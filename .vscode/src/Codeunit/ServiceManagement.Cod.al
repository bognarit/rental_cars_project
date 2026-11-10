codeunit 50103 "Service Management"
{
    procedure ProcessServiceClosure(var ServiceHeader: Record Service)
    var
        InsuranceCostCalc: Codeunit "Insurance & Cost Calculator";
        RentalList: Record Rental;
        ServiceCardLines: Record "Service Card Lines";
        CarCardLines: Record "Car Card Lines";
    begin
        ServiceCardLines.SetRange("Service No.", ServiceHeader."Service No.");
        if ServiceCardLines.FindSet() then begin
            repeat
                if (ServiceCardLines."Order Date" > ServiceHeader."To Date") and (ServiceCardLines."Delivery Date" > ServiceHeader."To Date") then
                    Error(Text003Err, ServiceCardLines."Delivery Date", ServiceHeader."To Date");
            until ServiceCardLines.Next() = 0;
        end;

        if (ServiceHeader."To Date" <> 0D) and (ServiceHeader."Service Costs" <> 0) and (ServiceHeader.Status = ServiceHeader.Status::Service) then begin
            ServiceHeader.Status := ServiceHeader.Status::Repaired;
            ServiceHeader.Modify();

            if ServiceCardLines.Findset() then begin
                repeat
                    ServiceCardLines.Status := ServiceCardLines.Status::Repaired;
                    ServiceCardLines.Modify();
                until ServiceCardLines.Next() = 0;
            end;

            if ServiceHeader."Rental No." <> '' then begin
                RentalList.SetRange("No.", ServiceHeader."Rental No.");
                if RentalList.FindFirst() then begin
                    RentalList."Service No." := ServiceHeader."Service No.";
                    RentalList."Service Status" := RentalList."Service Status"::Repaired;
                    RentalList."Service To Date" := ServiceHeader."To Date";
                    RentalList."Repair Costs" := ServiceHeader."Service Costs";
                    InsuranceCostCalc.CountTheRepairCosts(ServiceHeader, RentalList);
                    RentalList.Modify();
                end;
            end;

            CarCardLines.SetRange("No.", ServiceHeader."Car No.");
            CarCardLines.SetRange("Registration No.", ServiceHeader."Registration No.");
            if CarCardLines.FindFirst() then begin
                CarCardLines."Car Status" := CarCardLines."Car Status"::Available;
                CarCardLines.Modify(false);
            end;

            Message(Text001);

        end else if ServiceHeader.Status = ServiceHeader.Status::Repaired then
                Error(Text001Err)
        else if (ServiceHeader."To Date" = 0D) or (ServiceHeader."Service Costs" = 0) then begin
            Error(Text002Err);
        end;
    end;

    procedure PerformServiceCancelAndReopen(var SourceService: Record "Service") NewService: Record "Service"
    var
        CarCardLines: Record "Car Card Lines";
        SourceLines: Record "Service Card Lines";
        NewLines: Record "Service Card Lines";
        NewNo: Code[20];
        Rental: Record Rental;
    begin
        CarCardLines.SetRange("No.", SourceService."Car No.");
        CarCardLines.SetRange("Registration No.", SourceService."Registration No.");
        if CarCardLines.FindFirst() then begin
            if CarCardLines."Car Status" = CarCardLines."Car Status"::Rented then
                Error(Text007Err);
        end;

        SourceService.Canceled := true;
        SourceService.Modify();

        if SourceService."Rental No." <> '' then begin
            Rental.SetRange("No.", SourceService."Rental No.");
            if Rental.FindFirst() then begin
                Rental."Service To Date" := 0D;
                Rental."Service Status" := Rental."Service Status"::Service;
                Rental.Modify(true);
            end;
        end;

        NewNo := SourceService."Service No." + '-SER';

        NewService.Init();
        NewService.TransferFields(SourceService);
        NewService."Service No." := NewNo;
        NewService.Canceled := false;
        NewService.Status := NewService.Status::Service;
        NewService."To Date" := 0D;
        NewService.Insert(true);

        SourceLines.SetRange("Service No.", SourceService."Service No.");
        if SourceLines.FindSet() then begin
            repeat
                NewLines.Init();
                NewLines.TransferFields(SourceLines);
                NewLines."Service No." := NewNo;
                NewLines.Status := NewLines.Status::Service;
                NewLines.Insert(true);
            until SourceLines.Next() = 0;
        end;

        if CarCardLines.FindFirst() then begin
            CarCardLines."Car Status" := CarCardLines."Car Status"::Service;
            CarCardLines.Modify(false);
        end;

        exit(NewService);
    end;

    procedure SendTheCarToTheService(var Rental: Record "Rental")
    var
        ServiceList: Record "Service";
        RentSetup: Record "Rent Setup";
        NoSeries: Codeunit "No. Series";
    begin
        if (Rental."Service From Date" <> 0D) and (Rental."New Damage Details" <> '') and (Rental."Service Status" = Rental."Service Status"::" ") then begin
            Rental."Service Status" := Rental."Service Status"::Service;

            ServiceList.Init();

            RentSetup.Get();
            RentSetup.TestField("Service Data No. Series");

            ServiceList."Service No." := NoSeries.GetNextNo(RentSetup."Service Data No. Series", WorkDate(), false);

            ServiceList."Rental No." := Rental."No.";
            ServiceList."Car No." := Rental."Car No.";
            ServiceList."Car Brand" := Rental."Car Brand";
            ServiceList."Car Model" := Rental."Car Model";
            ServiceList."Registration No." := Rental."Registration No.";
            ServiceList."From Date" := Rental."Service From Date";
            ServiceList.Status := ServiceList.Status::Service;
            ServiceList.Details := Rental."New Damage Details";

            Rental."Service No." := ServiceList."Service No.";

            ServiceList.Insert(true);

            Message(Text002);

        end else if Rental."Service Status" = Rental."Service Status"::Service then
                Error(Text004Err)
        else if Rental."Service Status" = Rental."Service Status"::Repaired then
            Error(Text005Err)
        else
            Error(Text006Err);
    end;

    var
        Text001: Label 'The Service has been closed.';
        Text002: Label 'The car was sent to the service.';
        Text001Err: Label 'The Service is already closed.';
        Text002Err: Label 'Please fill ''To Date'' and ''Cost'' fields!';
        Text003Err: Label 'The Delivery Date %1 must not be behind To Date %2';
        Text004Err: Label 'The car currently is being serviced.';
        Text005Err: Label 'The car has been repaired.';
        Text006Err: Label 'Please fill in the Service ''New Damage Details'' and ''From Date'' fields!';
        Text007Err: Label 'The vehicle is currently rented out and cannot be sent back to service.';
}