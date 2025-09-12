table 50101 "Car"
{
    DataClassification = CustomerContent;
    Caption = 'Car';
    DrillDownPageId = "Car List";
    LookupPageId = "Car Card";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; "Brand"; Text[50])
        {
            Caption = 'Brand';
        }
        field(3; "Model"; Text[50])
        {
            Caption = 'Model';
        }
        field(4; "Manufact. Name"; Text[50])
        {
            Caption = 'Manufacturer Name';
        }
        field(5; "Manufact. Place"; Text[50])
        {
            Caption = 'Manufacturer Place';
        }
        field(6; "Car Picture"; Blob)
        {
            Caption = 'Car Picture';
            Subtype = Bitmap;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; Brand, Model)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Brand, Model)
        {
        }
    }
}