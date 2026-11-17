page 50100 "Monthly Settlements"
{
    PageType = List;
    Caption = 'Monthly Settlement List';
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "Monthly Settlement Card";
    SourceTable = "Monthly Settlement";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Settlement No."; Rec."Settlement No.")
                {
                    ApplicationArea = All;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = All;
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = All;
                }
                field("Total Rental Revenue"; Rec."Total Rental Revenue")
                {
                    ApplicationArea = All;
                }
                field("Total Service Costs"; Rec."Total Service Costs")
                {
                    ApplicationArea = All;
                }
                field("Net Profit"; Rec."Net Profit")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec."Status")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    begin
        Message(Text001);
        exit(false);
    end;

    var
        Text001: Label 'Deleting monthly settlement is strictly prohibited in this system for security reasons!';
}