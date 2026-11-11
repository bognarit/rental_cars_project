codeunit 50102 "Rental Management"
{
    procedure ProcessRentalClosure(var Rental: Record "Rental")
    var
        ClosedRental: Record "Closed Rental";
    begin
        if Rental."New Damages" and (Rental."Service Status" = Rental."Service Status"::" ") then
            Error(Text001Err)
        else if Rental."New Damages" and (Rental."Service Status" = Rental."Service Status"::Service) then
            Error(Text002Err)
        else if Confirm(StrSubstNo(Text001, Rental."No.")) then begin
            ClosedRental.Init();
            ClosedRental.TransferFields(Rental);

            ClosedRental.Canceled := false;
            ClosedRental.Insert(true);
            Rental.Delete();

            Message(Text002, Rental."No.");
        end;
    end;

    procedure ConfigureRentalDaysAndErrorWarning(var Rental: Record Rental; var FromDate: Date; var ToDate: Date)
    begin
        if FromDate = 0D then
            FromDate := ToDate;
        if ToDate = 0D then
            ToDate := FromDate;

        if StrPos(Rental."No.", '-REV') = 0 then begin
            if ((FromDate <> 0D) and (FromDate < Today)) or ((ToDate <> 0D) and (ToDate < Today)) then
                Error(Text003Err);
        end;

        if (FromDate <> 0D) and (ToDate <> 0D) then begin
            Rental."Rental Day(s)" := (ToDate + 1) - FromDate;
            case Rental."Rental Day(s)" of
                1:
                    Rental."Rental Day(s) Cost" := 70;
                2 .. 7:
                    Rental."Rental Day(s) Cost" := 60 * Rental."Rental Day(s)";
                8 .. 30:
                    Rental."Rental Day(s) Cost" := 50 * Rental."Rental Day(s)";
                else
                    Rental."Rental Day(s) Cost" := 40 * Rental."Rental Day(s)";
            end;
        end else begin
            Rental."Rental Day(s)" := 0;
            Rental."Rental Day(s) Cost" := 0;
        end;
    end;

    procedure BookedCarAtTheAppointedTime(var Rental: Record Rental; FromDate: Date; ToDate: Date)
    var
        ActiveRentalsCount: Integer;
        ActiveServicesCount: Integer;
        TotalCarsInFlotta: Integer;
        AvailableCars: Integer;
        CarCardLines: Record "Car Card Lines";
        OldRental: Record Rental;
        Service: Record Service;
        RenterRentalCheck: Record Rental;
    begin
        if (FromDate = 0D) or (ToDate = 0D) then
            exit;

        if Rental."No." <> '' then begin
            OldRental.SetFilter("No.", '<>%1', Rental."No.");
            RenterRentalCheck.SetFilter("No.", '<>%1', Rental."No.");
        end;

        RenterRentalCheck.SetRange("Renter No.", Rental."Renter No.");
        RenterRentalCheck.SetFilter("From Date", '<=%1', ToDate);
        RenterRentalCheck.SetFilter("To Date", '>=%1', FromDate);
        RenterRentalCheck.SetFilter("Rental Status", '<>%1', Rental."Rental Status"::Returned);

        if not RenterRentalCheck.IsEmpty then
            Error(Text003, Rental."Renter Name");

        CarCardLines.SetRange("No.", Rental."Car No.");
        CarCardLines.SetFilter("Car Status", '<>%1', CarCardLines."Car Status"::Blocked);
        TotalCarsInFlotta := CarCardLines.Count();

        OldRental.SetRange("Car No.", Rental."Car No.");
        OldRental.SetFilter("From Date", '<=%1', ToDate);
        OldRental.SetFilter("To Date", '>=%1', FromDate);
        OldRental.SetFilter("Rental Status", '<>%1', Rental."Rental Status"::Returned);

        ActiveRentalsCount := OldRental.Count();

        Service.SetRange("Car No.", Rental."Car No.");
        Service.SetRange(Status, Service.Status::Service);
        Service.SetFilter("From Date", '<=%1', ToDate);
        Service.SetFilter("To Date", '>=%1|%2', FromDate, 0D);
        ActiveServicesCount := Service.Count();

        AvailableCars := TotalCarsInFlotta - ActiveRentalsCount - ActiveServicesCount;

        if AvailableCars <= 0 then
            Error(Text004Err);
    end;

    procedure UpdateSequenceMileages(CarNo: Code[20]; RegNo: Text[50]; OldEndingMileage: Integer; Diff: Integer)
    var
        CarCardLines: Record "Car Card Lines";
        ClosedRental: Record "Closed Rental";
        Rental: Record "Rental";
    begin
        CarCardLines.SetRange("No.", CarNo);
        CarCardLines.SetRange("Registration No.", RegNo);
        // CarCardLines.SetLoadFields("Mileage");
        if CarCardLines.FindFirst() then begin
            CarCardLines."Mileage" += Diff;
            CarCardLines.Modify(true);
        end;

        ClosedRental.SetRange("Car No.", CarNo);
        ClosedRental.SetRange("Registration No.", RegNo);
        ClosedRental.SetFilter("Starting Mileage", '>=%1', OldEndingMileage);
        ClosedRental.SetRange(Canceled, false);
        // ClosedRental.SetLoadFields("Starting Mileage", "Ending Mileage");
        if ClosedRental.FindSet() then
            repeat
                ClosedRental."Starting Mileage" += Diff;
                ClosedRental."Ending Mileage" += Diff;
                ClosedRental.Modify(false); // Átüti a ModifyAllowed = false-t
            until ClosedRental.Next() = 0;

        Rental.SetRange("Car No.", CarNo);
        Rental.SetRange("Registration No.", RegNo);
        Rental.SetFilter("Starting Mileage", '>=%1', OldEndingMileage);
        // Rental.SetLoadFields("Starting Mileage", "Ending Mileage");
        if Rental.FindSet() then
            repeat
                Rental."Starting Mileage" += Diff;
                Rental."Ending Mileage" += Diff;
                Rental.Modify(true);
            until Rental.Next() = 0;
    end;

    procedure UpdateCarStatus(Rental: Record Rental)
    var
        CarCardLines: Record "Car Card Lines";
    begin
        CarCardLines.SetRange("No.", Rental."Car No.");
        CarCardLines.SetRange("Registration No.", Rental."Registration No.");
        // CarCardLines.SetLoadFields("Car Status", Mileage);
        if CarCardLines.FindFirst() then begin
            if Rental."Service Status" = Rental."Service Status"::Service then begin
                CarCardLines."Car Status" := CarCardLines."Car Status"::Service;
            end else if Rental."Rental Status" = Rental."Rental Status"::Returned then begin
                CarCardLines.Mileage := Rental."Ending Mileage";
                if (Rental."Previous Damages" = true) or (Rental."New Damages" = true) then
                    CarCardLines."Car Status" := CarCardLines."Car Status"::Blocked
                else begin
                    CarCardLines."Car Status" := CarCardLines."Car Status"::Available;
                end
            end else if Rental."Rental Status" = Rental."Rental Status"::Released then begin
                CarCardLines."Car Status" := CarCardLines."Car Status"::Rented;
            end;

            CarCardLines.Modify(false);
        end;
    end;

    var
        Text001: Label 'Are you sure to close the %1 rental?';
        Text002: Label 'The rental contract %1 has been successfully closed and archived.';
        Text003: Label 'The renter, %1 already has an active car rental during the selected period!';
        Text001Err: Label 'The car wasn''t sent to the service.';
        Text002Err: Label 'The car currently is being serviced.';
        Text003Err: Label 'You cannot choose an earlier date. Please choose another date!';
        Text004Err: Label 'The selected car is not available for this period. Please choose another vehicle or date!';
}