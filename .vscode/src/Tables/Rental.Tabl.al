table 50102 "Rental"
{
    DataClassification = CustomerContent;
    Caption = 'Rental';
    DrillDownPageId = "Rental List";
    LookupPageId = "Rental Card";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(5; "Renter No."; Code[20])
        {
            Caption = 'Renter No.';
            TableRelation = "Renter"."Renter No.";
            ValidateTableRelation = false;
            trigger OnValidate()
            var
                Renter: Record "Renter";
            begin
                if Rec."Renter No." <> '' then begin
                    Renter.Get(Rec."Renter No.");
                    Rec."Renter Name" := Renter."Renter Name";
                    Rec.Address := Renter.Address;
                    Rec.City := Renter.City;
                    Rec."Post Code" := Renter."Post Code";
                    Rec."Country/Region Code" := Renter."Country/Region Code";
                    Rec."Phone No." := Renter."Phone No.";
                end;
            end;
        }
        field(10; "Renter Name"; Text[50])
        {
            Caption = 'Renter Name';
        }
        field(15; Address; Text[100])
        {
            Caption = 'Address';
        }
        field(20; City; Text[30])
        {
            Caption = 'City';
        }
        field(25; "Post Code"; Text[100])
        {
            Caption = 'Post Code';
        }
        field(30; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(35; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
        }
        field(40; "BillRequired"; Boolean)
        {
            Caption = 'Bill to Renter is required.';
            trigger OnValidate()
            begin
                if not Rec."BillRequired" then
                    Rec."Bill-to Same Data" := false;
            end;
        }
        field(45; "Bill-to Same Data"; Boolean)
        {
            Caption = 'Bill to Same Data';
            trigger OnValidate()
            begin
                if not Rec."BillRequired" then
                    Rec."Bill-to Same Data" := false
                else begin
                    Rec."Bill-to Name" := '';
                    Rec."Bill-to Address" := '';
                    Rec."Bill-to City" := '';
                    Rec."Bill-to Post Code" := '';
                    Rec."Bill-to Country/Region Code" := '';
                end;
            end;
        }
        field(50; "Bill-to Name"; Text[50])
        {
            Caption = 'Bill to Name';
        }

        field(55; "Bill-to Address"; Text[100])
        {
            Caption = 'Bill to Address';
        }
        field(60; "Bill-to City"; Text[30])
        {
            Caption = 'Bill to City';
        }
        field(65; "Bill-to Post Code"; Text[100])
        {
            Caption = 'Bill to Post Code';
        }
        field(70; "Bill-to Country/Region Code"; Code[10])
        {
            Caption = 'Bill to Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(75; "Car No."; Code[20])
        {
            Caption = 'Car No.';
            TableRelation = "Car"."No.";
            ValidateTableRelation = false;
            trigger OnValidate()
            var
                Car: Record "Car";
            begin
                if Rec."Car No." <> '' then begin
                    Car.Get(Rec."Car No.");
                    Rec."Car Brand" := Car."Brand";
                    Rec."Car Model" := Car."Model";
                    Rec."Registration No." := '';
                end;
            end;
        }
        field(80; "Car Brand"; Text[50])
        {
            Caption = 'Car Brand';
        }
        field(85; "Car Model"; Text[50])
        {
            Caption = 'Car Model';
        }
        field(90; "Registration No."; Text[50])
        {
            Caption = 'Registration Number';
            TableRelation = "Car Card Lines"."Registration No." where("No." = field("Car No."));
            trigger OnValidate()
            var
                CarCardLines: Record "Car Card Lines";
            begin
                if Rec."Registration No." <> '' then begin
                    CarCardLines.SetRange("No.", Rec."Car No.");
                    CarCardLines.SetRange("Registration No.", Rec."Registration No.");

                    if CarCardLines.FindFirst() then begin
                        CarCardLines.CalcFields("Mileage");
                        Rec."Starting Mileage" := CarCardLines."Mileage";
                    end;
                end else begin
                    Rec."Starting Mileage" := 0;
                end;
            end;
        }
        field(95; "From Date"; Date)
        {
            Caption = 'From Date';
            trigger OnValidate()
            begin
                if (Rec."Renter No." = '') or (Rec."Car No." = '') or (Rec."Registration No." = '') then
                    Error(Text003Err);

                ConfigureRentalDaysAndErrorWarning(Rec."From Date", Rec."To Date");
                BookedCarAtTheAppointedTime(Rec."From Date", Rec."To Date");
            end;
        }
        field(100; "To Date"; Date)
        {
            Caption = 'To Date';
            trigger OnValidate()
            begin
                if (Rec."Renter No." = '') or (Rec."Car No." = '') or (Rec."Registration No." = '') then
                    Error(Text003Err);

                ConfigureRentalDaysAndErrorWarning(Rec."From Date", Rec."To Date");
                BookedCarAtTheAppointedTime(Rec."From Date", Rec."To Date");

                UpdateTotalCost();
            end;
        }
        field(105; "Rental Day(s)"; Integer)
        {
            Caption = 'Rental Day(s)';
        }
        field(110; "Rental Day(s) Cost"; Decimal)
        {
            Caption = 'Rental Day(s) Cost(€)';
        }
        field(114; "Starting Mileage"; Integer)
        {
            Caption = 'Starting Mileage';
        }
        field(115; "Ending Mileage"; Integer)
        {
            Caption = 'Ending Mileage';
            trigger OnValidate()
            begin
                if Rec."Ending Mileage" < 0 then
                    Error(Text006Err);
                if (Rec."Ending Mileage" <> 0) and (Rec."Ending Mileage" < Rec."Starting Mileage") then
                    Error(Text011Err);

                Rec.CalculateMileageAndRunCorrection();

                UpdateTotalCost();
            end;
        }
        field(120; "Mileage Cost"; Decimal)
        {
            Caption = 'Mileage Cost(€)';
        }
        field(125; "Car Insurance Cost"; Decimal)
        {
            Caption = 'Car Insurance Cost(€)';
        }
        field(130; "Total Cost"; Decimal)
        {
            Caption = 'Total Cost(€)';
        }
        field(135; "Car Insurance"; Boolean)
        {
            Caption = 'Car Insurance';
            trigger OnValidate()
            begin
                if not Rec."Car Insurance" then begin
                    Rec."Car Insurance Types" := Rec."Car Insurance Types"::" ";
                    Rec."Car Insurance Cost" := 0;

                    UpdateTotalCost();
                end;
            end;
        }
        field(140; "Car Insurance Types"; Enum "Car Insurance Types")
        {
            Caption = 'Car insurance types';
            trigger OnValidate()
            begin
                case Rec."Car Insurance Types" of
                    Rec."Car Insurance Types"::" ":
                        Rec."Car Insurance Cost" := 0;
                    Rec."Car Insurance Types"::TwentyFivePercent:
                        Rec."Car Insurance Cost" := 25;
                    Rec."Car Insurance Types"::FiftyPercent:
                        Rec."Car Insurance Cost" := 50;
                    Rec."Car Insurance Types"::HundredPercent:
                        Rec."Car Insurance Cost" := 100;
                end;

                UpdateTotalCost();
            end;
        }
        field(145; "Previous Damages"; Boolean)
        {
            Caption = 'Previous Damage(s)';
            trigger OnValidate()
            begin
                if not Rec."Previous Damages" then begin
                    Rec."Prev Damage Details" := '';
                    Clear(Rec."Prev Damage Picture 1");
                    Clear(Rec."Prev Damage Picture 2");
                end;
            end;
        }
        field(150; "Prev Damage Details"; Text[250])
        {
            Caption = 'Previous Damage Details';
        }
        field(155; "Prev Damage Picture 1"; Blob)
        {
            Caption = 'Prev Damage Picture';
            Subtype = Bitmap;
        }
        field(160; "Prev Damage Picture 2"; Blob)
        {
            Caption = 'Prev Damage Picture';
            Subtype = Bitmap;
        }
        field(165; "New Damages"; Boolean)
        {
            Caption = 'New Damage(s)';
            trigger OnValidate()
            begin
                if Rec."Service Status" = Rec."Service Status"::Service then begin
                    Rec."New Damages" := true;
                    Error(Text007Err)
                end else if Rec."Service Status" = Rec."Service Status"::Repaired then begin
                    Rec."New Damages" := true;
                    Error(Text008Err)
                end else if not Rec."New Damages" then begin
                    Rec."New Damage Details" := '';
                    Clear(Rec."New Damage Picture 1");
                    Clear(Rec."New Damage Picture 2");
                    Rec."Service From Date" := 0D;
                end;

                UpdateTotalCost();
            end;
        }
        field(170; "New Damage Details"; Text[250])
        {
            Caption = 'New Damage Details';
        }
        field(175; "New Damage Picture 1"; Blob)
        {
            Caption = 'New Damage Picture';
            Subtype = Bitmap;
        }
        field(180; "New Damage Picture 2"; Blob)
        {
            Caption = 'New Damage Picture';
            Subtype = Bitmap;
        }
        field(185; "Service From Date"; Date)
        {
            Caption = 'Service From Date';

            trigger OnValidate()
            begin
                if Rec."Service From Date" < Today then
                    Error(Text004Err)
                else if Rec."To Date" >= Rec."Service From Date" then
                    Error(Text009Err, Rec."Service From Date", Rec."To Date")
                else if (Rec."From Date" = 0D) and (Rec."To Date" = 0D) then
                    Error(Text010Err);
            end;
        }
        field(190; "Service To Date"; Date)
        {
            Caption = 'Service To Date';
        }
        field(195; "Service Status"; Enum "Service Status")
        {
            Caption = 'Service Status';
        }
        field(200; "Repair Costs"; Decimal)
        {
            Caption = 'Repair Costs(€)';
        }
    }

    keys
    {
        key(Key1; "No.", "Renter No.")
        {
            Clustered = true;
        }
        key(Key2; "Renter Name")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Renter No.", "Renter Name")
        {
        }
    }

    procedure CountTheRepairCosts(var Service: Record "Service")
    begin
        if Rec."Service Status" = Rec."Service Status"::Repaired then begin
            Service.SetRange("Rental No.", Rec."No.");
            Service.FindFirst();

            case Rec."Car Insurance Types" of
                Rec."Car Insurance Types"::" ":
                    Rec."Repair Costs" := Service."Service Costs";
                Rec."Car Insurance Types"::TwentyFivePercent:
                    Rec."Repair Costs" := 0.75 * Service."Service Costs";
                Rec."Car Insurance Types"::FiftyPercent:
                    Rec."Repair Costs" := 0.5 * Service."Service Costs";
                Rec."Car Insurance Types"::HundredPercent:
                    Rec."Repair Costs" := 0;
            end;

            UpdateTotalCost();
        end;
    end;

    procedure ConfigureRentalDaysAndErrorWarning(var FromDate: Date; var ToDate: Date)
    begin
        if FromDate = 0D then
            FromDate := ToDate;
        if ToDate = 0D then
            ToDate := FromDate;

        if FromDate > ToDate then
            Error(Text001Err, FromDate, ToDate);
        if (FromDate < Today) or (ToDate < Today) then
            Error(Text004Err);

        if (FromDate <> 0D) and (ToDate <> 0D) then begin
            Rec."Rental Day(s)" := (ToDate + 1) - FromDate;
            case Rec."Rental Day(s)" of
                1:
                    Rec."Rental Day(s) Cost" := 70;
                2 .. 7:
                    Rec."Rental Day(s) Cost" := 60 * Rec."Rental Day(s)";
                8 .. 30:
                    Rec."Rental Day(s) Cost" := 50 * Rec."Rental Day(s)";
                else
                    Rec."Rental Day(s) Cost" := 40 * Rec."Rental Day(s)";
            end;
        end else begin
            Rec."Rental Day(s)" := 0;
            Rec."Rental Day(s) Cost" := 0;
        end;
    end;

    procedure BookedCarAtTheAppointedTime(FromDate: Date; ToDate: Date)
    var
        OldRental: Record "Rental";
        OldClosedRental: Record "Closed Rental";
        Service: Record "Service";
    begin
        if (FromDate = 0D) or (ToDate = 0D) then
            exit;

        OldRental.SetRange("Car No.", Rec."Car No.");
        OldRental.SetRange("Registration No.", Rec."Registration No.");

        if Rec."No." <> '' then
            OldRental.SetFilter("No.", '<>%1', Rec."No.");

        OldRental.SetFilter("From Date", '<=%1', ToDate);
        OldRental.SetFilter("To Date", '>=%1', FromDate);

        if not OldRental.IsEmpty then
            Error(Text002Err);

        OldClosedRental.SetRange("Car No.", Rec."Car No.");
        OldClosedRental.SetRange("Registration No.", Rec."Registration No.");
        OldClosedRental.SetFilter("From Date", '<=%1', ToDate);
        OldClosedRental.SetFilter("To Date", '>=%1', FromDate);

        if not OldClosedRental.IsEmpty then
            Error(Text002Err);

        Service.SetRange("Registration No.", Rec."Registration No.");
        Service.SetRange(Status, Service.Status::Service);
        Service.SetFilter("From Date", '<=%1', ToDate);
        Service.SetFilter("To Date", '>=%1|%2', FromDate, 0D);

        if not Service.IsEmpty then
            Error(Text005Err);
    end;

    procedure CalculateMileageAndRunCorrection()
    var
        CarCardLines: Record "Car Card Lines";
        Milage: Integer;
        MileageDifference: Integer;
    begin
        // 1. Ha 0 a záró km, nullázzuk a kilométer-költséget
        if Rec."Ending Mileage" = 0 then begin
            Rec."Mileage Cost" := 0;
            exit;
        end;

        // 2. Kiszámoljuk a megtett kilométert a helyi változóba
        Milage := Rec."Ending Mileage" - Rec."Starting Mileage";

        // 3. Sávos árazás meghatározása
        case Milage of
            1 .. 500:
                Rec."Mileage Cost" := 40;
            501 .. 1000:
                Rec."Mileage Cost" := 50;
            1001 .. 2000:
                Rec."Mileage Cost" := 60;
            2001 .. 5000:
                Rec."Mileage Cost" := 70;
            else
                Rec."Mileage Cost" := 80;
        end;

        // 4. NORMÁL ESET: Ha ez egy sima bérlet (nincs benne a '-REV')
        if StrPos(Rec."No.", '-REV') = 0 then begin
            // Beolvassuk a konkrét autót az adatbázisból a kulcsok alapján
            if CarCardLines.Get(Rec."Car No.", Rec."Registration No.") then begin
                // Az autó aktuális óraállását (Mileage) beállítjuk a bérlet záró óraállására
                CarCardLines."Mileage" := Rec."Ending Mileage";
                CarCardLines.Modify(true); // Elmentjük az SQL-be
            end;
        end;

        // 5. REVIZIÓS ESET: Ha ez egy újranyitott módosítás
        if StrPos(Rec."No.", '-REV') > 0 then begin
            // Kiszámoljuk a hiba mértékét: Új beírt záró km MINUSZ a módosítás előtti hibás záró km
            MileageDifference := Rec."Ending Mileage" - xRec."Ending Mileage";

            if MileageDifference <> 0 then begin
                // Meghívjuk a már korábban megírt UpdateSequenceMileages eljárásodat
                Rec.UpdateSequenceMileages(Rec."Car No.", Rec."Registration No.", xRec."Ending Mileage", MileageDifference);
            end;
        end;
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

    local procedure UpdateTotalCost()
    begin
        Rec."Total Cost" := Rec."Rental Day(s) Cost" + Rec."Mileage Cost" + Rec."Car Insurance Cost" + Rec."Repair Costs";
    end;

    var
        Text001Err: Label 'The From Date %1 must not be behind To Date %2.';
        Text002Err: Label 'The car is booked at a specified date. Please choose an other date or car!';
        Text003Err: Label 'Please choose a Renter, a Car No. und a Registration No. first!';
        Text004Err: Label 'You cannot choose an earlier date. Please choose another date!';
        Text005Err: Label 'The car currently is being serviced. Please choose an other car!';
        Text006Err: Label 'The ending mileage cannot be negative.';
        Text007Err: Label 'The car currently is being serviced.';
        Text008Err: Label 'The car has been repaired.';
        Text009Err: Label 'The To Date %1 must not be behind Service From Date %2';
        Text010Err: Label 'Please choose a From Date und a To Date first!';
        Text011Err: Label 'The ending mileage must be greater than the starting mileage.';
}