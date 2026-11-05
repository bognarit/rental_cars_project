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

        if FromDate > ToDate then
            Error(Text003Err, FromDate, ToDate);

        if StrPos(Rental."No.", '-REV') = 0 then begin
            if (FromDate < Today) or (ToDate < Today) then
                Error(Text004Err);
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
        OldRental: Record "Rental";
        OldClosedRental: Record "Closed Rental";
        Service: Record "Service";
    begin
        if (FromDate = 0D) or (ToDate = 0D) then
            exit;

        OldRental.SetRange("Car No.", Rental."Car No.");
        OldRental.SetRange("Registration No.", Rental."Registration No.");

        if Rental."No." <> '' then
            OldRental.SetFilter("No.", '<>%1', Rental."No.");

        OldRental.SetFilter("From Date", '<=%1', ToDate);
        OldRental.SetFilter("To Date", '>=%1', FromDate);

        if not OldRental.IsEmpty then
            Error(Text005Err);

        OldClosedRental.SetRange("Car No.", Rental."Car No.");
        OldClosedRental.SetRange("Registration No.", Rental."Registration No.");
        OldClosedRental.SetFilter("From Date", '<=%1', ToDate);
        OldClosedRental.SetFilter("To Date", '>=%1', FromDate);

        if not OldClosedRental.IsEmpty then
            Error(Text005Err);

        Service.SetRange("Registration No.", Rental."Registration No.");
        Service.SetRange(Status, Service.Status::Service);
        Service.SetFilter("From Date", '<=%1', ToDate);
        Service.SetFilter("To Date", '>=%1|%2', FromDate, 0D);

        if not Service.IsEmpty then
            Error(Text006Err);
    end;

    procedure UpdateSequenceMileages(CarNo: Code[20]; RegNo: Text[50]; OldEndingMileage: Integer; Diff: Integer)
    var
        CarCardLines: Record "Car Card Lines";
        ClosedRental: Record "Closed Rental";
        Rental: Record "Rental";
    begin
        // A) Autó frissítése
        if CarCardLines.Get(CarNo, RegNo) then begin
            CarCardLines."Mileage" += Diff;
            CarCardLines.Modify(true);
        end;

        // B) Későbbi lezárt bérlések eltolása
        ClosedRental.SetRange("Car No.", CarNo);
        ClosedRental.SetRange("Registration No.", RegNo);
        ClosedRental.SetFilter("Starting Mileage", '>=%1', OldEndingMileage);
        ClosedRental.SetRange(Canceled, false);
        if ClosedRental.FindSet() then
            repeat
                ClosedRental."Starting Mileage" += Diff;
                ClosedRental."Ending Mileage" += Diff;
                ClosedRental.Modify(false); // Átüti a ModifyAllowed = false-t
            until ClosedRental.Next() = 0;

        // C) Jövőbeli aktív foglalások eltolása
        Rental.SetRange("Car No.", CarNo);
        Rental.SetRange("Registration No.", RegNo);
        Rental.SetFilter("Starting Mileage", '>=%1', OldEndingMileage);
        if Rental.FindSet() then
            repeat
                Rental."Starting Mileage" += Diff;
                Rental."Ending Mileage" += Diff;
                Rental.Modify(true);
            until Rental.Next() = 0;
    end;

    var
        Text001: Label 'Are you sure to close the %1 rental?';
        Text002: Label 'The rental contract %1 has been successfully closed and archived.';
        Text001Err: Label 'The car wasn''t sent to the service.';
        Text002Err: Label 'The car currently is being serviced.';
        Text003Err: Label 'The From Date %1 must not be behind To Date %2.';
        Text004Err: Label 'You cannot choose an earlier date. Please choose another date!';
        Text005Err: Label 'The car is booked at a specified date. Please choose an other date or car!';
        Text006Err: Label 'The car currently is being serviced. Please choose an other car!';
}