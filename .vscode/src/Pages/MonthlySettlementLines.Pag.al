page 50119 "Monthly Settlement Lines"
{
    PageType = ListPart;
    Caption = 'Monthly Settlement Lines';
    ApplicationArea = All;
    SourceTable = "Monthly Settlement Line";
    AutoSplitKey = true;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Settlement No."; Rec."Settlement No.")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = all;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = all;
                }
                field("Rent Role"; Rec."Rent Role")
                {
                    ApplicationArea = all;
                }
                field("Commission %"; Rec."Commission %")
                {
                    ApplicationArea = all;
                }
                field("Completed Count"; Rec."Completed Count")
                {
                    ApplicationArea = all;
                }
                field("Generated Amount"; Rec."Generated Amount")
                {
                    ApplicationArea = all;
                }
                field("Commission Amount"; Rec."Commission Amount")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}