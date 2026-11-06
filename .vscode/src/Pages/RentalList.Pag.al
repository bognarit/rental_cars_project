page 50102 "Rental List"
{
    ApplicationArea = All;
    Caption = 'Rental List';
    PageType = List;
    UsageCategory = Lists;
    CardPageId = "Rental Card";
    SourceTable = "Rental";

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
                field("Rental Status"; Rec."Rental Status")
                {
                    ApplicationArea = All;
                    StyleExpr = StatusStyle;
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

    trigger OnAfterGetRecord()
    begin
        if Rec."Rental Status" = Rec."Rental Status"::Released then
            StatusStyle := 'Unfavorable'
        else if Rec."Rental Status" = Rec."Rental Status"::Returned then
            StatusStyle := 'Favorable'
        else
            StatusStyle := 'Standard';
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        if (Rec."Rental Status" = Rec."Rental Status"::Released) or (Rec."Rental Status" = Rec."Rental Status"::Returned) then begin
            Message(Text001);
            exit(false);
        end;

        exit(true);
    end;

    var
        StatusStyle: Text;
        Text001: Label 'You can only delete a rental record if its status is Open!';
}