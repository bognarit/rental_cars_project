table 50105 "Car Card Lines"
{
    DataClassification = CustomerContent;
    Caption = 'Car Lines';

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = "Car"."No.";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Registration No."; Text[50])
        {
            Caption = 'Registration No.';
        }
        field(4; "Manufact. Year"; Integer)
        {
            Caption = 'Manufacturer Year';
        }
        field(5; Mileage; Integer)
        {
            Caption = 'Mileage(km)';
        }
        field(6; "Transmission Type"; Enum "Transmission Types")
        {
            Caption = 'Transmission Type';
        }
        field(7; Power; Integer)
        {
            Caption = 'Power(kw)';
        }
        field(8; "Fuel Type"; Enum "Fuel Types")
        {
            Caption = 'Fuel Type';
        }
        field(9; "Car Status"; Enum "Car Status")
        {
            Caption = 'Car Status';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "No.", "Registration No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Manufact. Year", "Fuel Type")
        {
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Line No.", "Registration No.", "Manufact. Year", "Fuel Type")
        {
        }
    }
}