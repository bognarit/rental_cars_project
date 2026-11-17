table 50109 "Monthly Settlement Line"
{
    DataClassification = CustomerContent;
    Caption = 'Monthly Settlement Lines';

    fields
    {
        field(1; "Settlement No."; Code[20])
        {
            Caption = 'Settlement No.';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            TableRelation = Employee;
        }
        field(4; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
        }
        field(5; "Rent Role"; Enum "Rent Employee Role")
        {
            Caption = 'Rent Role';
        }
        field(6; "Commission %"; Decimal)
        {
            Caption = 'Commision %';
        }
        field(7; "Completed Count"; Integer)
        {
            Caption = 'Completed Count';
        }
        field(8; "Generated Amount"; Decimal)
        {
            Caption = 'Generated Amount';
        }
        field(9; "Commission Amount"; Decimal)
        {
            Caption = 'Commission Amount';
        }
    }

    keys
    {
        key(Key1; "Settlement No.", "Line No.")
        {
            Clustered = true;
        }
    }
}