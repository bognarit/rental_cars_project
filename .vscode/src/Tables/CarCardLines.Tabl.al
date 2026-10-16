table 50105 "Car Card Lines"
{
    DataClassification = CustomerContent;
    Caption = 'Car Lines';

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            Editable = false;
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
            FieldClass = FlowField;
            CalcFormula = max("Closed Rental"."Ending Mileage" where("Car No." = field("No."), "Registration No." = field("Registration No.")));
            Editable = false;
        }
        field(6; Transmission; Option)
        {
            Caption = 'Transmission';
            OptionMembers = ,Automatic,Manual;
            OptionCaption = ',Automatic,Manual';
        }
        field(7; Power; Integer)
        {
            Caption = 'Power(kw)';
        }
        field(8; Fuel; Option)
        {
            Caption = 'Fuel';
            OptionMembers = ,Electric,Petrol;
            OptionCaption = ',Electric,Petrol';
        }
    }

    keys
    {
        key(Key1; "No.", "Registration No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Manufact. Year", Fuel)
        {
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Line No.", "Registration No.", "Manufact. Year", Fuel)
        {
        }
    }
}