page 50113 "Closed Rental List"
{
    ApplicationArea = All;
    Caption = 'Closed Rental List';
    PageType = List;
    UsageCategory = Lists;
    CardPageId = "Closed Rental Card";
    SourceTable = "Closed Rental";
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Renter No."; Rec."Renter No.")
                {
                    ApplicationArea = All;
                }
                field("Renter Name"; Rec."Renter Name")
                {
                    ApplicationArea = All;
                }
                field("Car Brand"; Rec."Car Brand")
                {
                    ApplicationArea = All;
                }
                field("Car Model"; Rec."Car Model")
                {
                    ApplicationArea = All;
                }
                field("Registration No."; Rec."Registration No.")
                {
                    ApplicationArea = All;
                }
                field("From Date"; Rec."From Date")
                {
                    ApplicationArea = All;
                }
                field("To Date"; Rec."To Date")
                {
                    ApplicationArea = All;
                }
                field("Rental Day(s)"; Rec."Rental Day(s)")
                {
                    ApplicationArea = All;
                }
                field("Rental Day(s) Cost"; Rec."Rental Day(s) Cost")
                {
                    ApplicationArea = All;
                }
                field("Starting Mileage"; Rec."Starting Mileage")
                {
                    ApplicationArea = All;
                }
                field("Ending Mileage"; Rec."Ending Mileage")
                {
                    ApplicationArea = All;
                }
                field("Mileage Cost"; Rec."Mileage Cost")
                {
                    ApplicationArea = All;
                }
                field("Car Insurance"; Rec."Car Insurance")
                {
                    ApplicationArea = All;
                }
                field("Car Insurance Cost"; Rec."Car Insurance Cost")
                {
                    ApplicationArea = All;
                }
                field("New Damages"; Rec."New Damages")
                {
                    ApplicationArea = All;
                }
                field("Repair Costs"; Rec."Repair Costs")
                {
                    ApplicationArea = All;
                }
                field("Total Cost"; Rec."Total Cost")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}