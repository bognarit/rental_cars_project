table 50107 "Closed Rental"
{
    DataClassification = CustomerContent;
    Caption = 'Closed Rental';
    DrillDownPageId = "Closed Rental List";
    LookupPageId = "Closed Rental Card";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(5; "Renter No."; Code[20])
        {
            Caption = 'Renter No.';
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
        }
        field(35; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
        }
        field(40; "BillRequired"; Boolean)
        {
            Caption = 'Bill to Renter is required.';
        }
        field(45; "Bill-to Same Data"; Boolean)
        {
            Caption = 'Bill to Same Data';
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
        }
        field(75; "Car No."; Code[20])
        {
            Caption = 'Car No.';
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
            Caption = 'Registration No.';
        }
        field(95; "From Date"; Date)
        {
            Caption = 'From Date';
        }
        field(100; "To Date"; Date)
        {
            Caption = 'To Date';
        }
        field(105; "Rental Day(s)"; Integer)
        {
            Caption = 'Rental Day(s)';
        }
        field(110; "Rental Day(s) Cost"; Decimal)
        {
            Caption = 'Rental Day(s) Cost';
        }
        field(115; "Mileage"; Integer)
        {
            Caption = 'Mileage(Km)';
        }
        field(120; "Mileage Cost"; Decimal)
        {
            Caption = 'Mileage Cost';
        }
        field(125; "Car Insurance Cost"; Decimal)
        {
            Caption = 'Car Insurance Cost';
        }
        field(130; "Total Cost"; Decimal)
        {
            Caption = 'Total Cost';
        }
        field(135; "Car Insurance"; Boolean)
        {
            Caption = 'Car Insurance';
        }
        field(140; "Car Insurance Types"; Enum "Car Insurance Types")
        {
            Caption = 'Car insurance types';
        }
        field(145; "Previous Damages"; Boolean)
        {
            Caption = 'Previous Damage(s)';
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
}