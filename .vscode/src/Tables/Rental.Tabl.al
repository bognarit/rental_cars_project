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
        field(3; "Rental Status"; Enum "Rental Status")
        {
            Caption = 'Rental Status';
        }
        field(4; Availability; Option)
        {
            Caption = 'Book Status';
            OptionCaption = 'Available,Booked';
            OptionMembers = Available,Booked;
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
                    Rec."Renter Type" := Renter."Renter Type";
                    Rec."Renter Name" := Renter."Renter Name";
                    Rec."Contact Person" := Renter."Contact Person";
                    Rec."VAT Registration No." := Renter."VAT Registration No.";
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
                if not BillRequired then begin
                    "Bill-to Same Data" := false;
                    ClearBillToFields();
                end else begin
                    "Bill-to Same Data" := true;
                end;
            end;
        }
        field(45; "Bill-to Same Data"; Boolean)
        {
            Caption = 'Bill to Same Data';
            trigger OnValidate()
            begin
                if Rec."Bill-to Same Data" then
                    ClearBillToFields();
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
            TableRelation = "Car Card Lines"."Registration No." where("No." = field("Car No."), "Car Status" = const("Car Status"::Available));
            trigger OnValidate()
            var
                CarCardLines: Record "Car Card Lines";
            begin
                if Rec."Registration No." <> '' then begin
                    CarCardLines.SetRange("No.", Rec."Car No.");
                    CarCardLines.SetRange("Registration No.", Rec."Registration No.");

                    if CarCardLines.FindFirst() then begin
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
            var
                RentalMgt: Codeunit "Rental Management";
            begin
                if (Rec."Renter No." = '') or (Rec."Car No." = '') then
                    Error(Text001Err);

                RentalMgt.ConfigureRentalDaysAndErrorWarning(Rec, Rec."From Date", Rec."To Date");

                if StrPos(Rec."No.", '-REV') = 0 then begin
                    RentalMgt.BookedCarAtTheAppointedTime(Rec, Rec."From Date", Rec."To Date");
                end;

                UpdateTotalCost();
            end;
        }
        field(100; "To Date"; Date)
        {
            Caption = 'To Date';
            trigger OnValidate()
            var
                DaysToShift: Integer;
                RentalMgt: Codeunit "Rental Management";
            begin
                if (Rec."Renter No." = '') or (Rec."Car No." = '') then
                    Error(Text001Err);

                if (xRec."To Date" <> 0D) and (Rec."To Date" <> 0D) then
                    DaysToShift := Rec."To Date" - xRec."To Date";

                RentalMgt.ConfigureRentalDaysAndErrorWarning(Rec, Rec."From Date", Rec."To Date");

                if StrPos(Rec."No.", '-REV') = 0 then begin
                    RentalMgt.BookedCarAtTheAppointedTime(Rec, Rec."From Date", Rec."To Date");

                end;

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
            var
                CostCalc: Codeunit "Insurance & Cost Calculator";
            begin
                if Rec."Ending Mileage" < 0 then
                    Error(Text002Err);

                if Rec."Ending Mileage" < Rec."Starting Mileage" then
                    Error(Text003Err);

                CostCalc.CalculateMileageAndRunCorrection(Rec, xRec);

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
                    Error(Text004Err)
                end else if Rec."Service Status" = Rec."Service Status"::Repaired then begin
                    Rec."New Damages" := true;
                    Error(Text005Err)
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
        field(182; "Service No."; Code[20])
        {
            Caption = 'Service No.';
        }
        field(185; "Service From Date"; Date)
        {
            Caption = 'Service From Date';

            trigger OnValidate()
            begin
                if Rec."Service From Date" = 0D then
                    exit;

                if Rec."Service From Date" < Today then
                    Error(Text006Err);

                if Rec."To Date" > Rec."Service From Date" then
                    Error(Text007Err, Rec."To Date", Rec."Service From Date");

                if (Date2DWY(Rec."Service From Date", 1) in [6, 7]) then
                    Error(Text008Err, Rec."Service From Date");
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
        field(205; "Renter Type"; Enum "Renter Type")
        {
            Caption = 'Renter Type';
        }
        field(210; "Contact Person"; Text[100])
        {
            Caption = 'Contact Person';
        }
        field(215; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';
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
        key(Key3; "Service No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Renter No.", "Renter Name")
        {
        }
    }

    local procedure ClearBillToFields()
    begin
        Rec."Bill-to Name" := '';
        Rec."Bill-to Address" := '';
        Rec."Bill-to City" := '';
        Rec."Bill-to Post Code" := '';
        Rec."Bill-to Country/Region Code" := '';
    end;

    local procedure UpdateTotalCost()
    begin
        Rec."Total Cost" := Rec."Rental Day(s) Cost" + Rec."Mileage Cost" + Rec."Car Insurance Cost" + Rec."Repair Costs";
    end;

    var
        Text001Err: Label 'Please choose a Renter, a Car No. und a Registration No. first!';
        Text002Err: Label 'The ending mileage cannot be negative.';
        Text003Err: Label 'The ending mileage must be greater than the starting mileage.';
        Text004Err: Label 'The car currently is being serviced.';
        Text005Err: Label 'The car has been repaired.';
        Text006Err: Label 'You cannot choose a past date. Please select a valid date.';
        Text007Err: Label 'The To Date %1 cannot be after Service From Date %2.';
        Text008Err: Label 'Service operations cannot be scheduled on weekends (%1 is a weekend day). Please select a weekday.';
}