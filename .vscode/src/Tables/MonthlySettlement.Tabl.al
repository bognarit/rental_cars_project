table 50100 "Monthly Settlement"
{
    DataClassification = CustomerContent;
    Caption = 'Monthly Settlement';
    DrillDownPageId = "Monthly Settlements";
    LookupPageId = "Monthly Settlement Card";

    fields
    {
        field(1; "Settlement No."; Code[20])
        {
            Caption = 'Settlement No.';
            Editable = false;
        }
        field(2; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            trigger OnValidate()
            begin
                if Rec."Starting Date" <> 0D then begin
                    Rec."Starting Date" := CalcDate('<-CM>', Rec."Starting Date");
                    Rec."Ending Date" := CalcDate('<CM>', Rec."Starting Date");

                    if Rec."Settlement No." = '' then
                        Rec."Settlement No." := Format(Rec."Starting Date", 0, '<Year4>-<Month,2>');
                end else
                    Rec."Ending Date" := 0D;
            end;
        }
        field(3; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
            Editable = false;
        }
        field(4; "Total Rental Revenue"; Decimal)
        {
            Caption = 'Total Rental Revenue';
            Editable = false;
        }
        field(5; "Total Service Costs"; Decimal)
        {
            Caption = 'Total Service Costs';
            Editable = false;
        }
        field(6; "Net Profit"; Decimal)
        {
            Caption = 'Net Profit';
            Editable = false;
        }
        field(7; Status; Enum "Settlement Status")
        {
            Caption = 'Status';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Settlement No.")
        {
            Clustered = true;
        }
    }
}