page 50110 "Closed Rental In Renter Card"
{
    ApplicationArea = All;
    Caption = 'Closed Rental Lines';
    PageType = ListPart;
    CardPageId = "Closed Rental Card";
    SourceTable = "Closed Rental";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Brand; Rec."Car Brand")
                {
                    ApplicationArea = All;
                }
                field(Model; Rec."Car Model")
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
                field(Fuel; Rec."Rental Day(s)")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Print)
            {
                ApplicationArea = All;
                Caption = 'Print';
                Image = Print;

                trigger OnAction()
                var
                    ClosedRentalList: Record "Closed Rental";
                    ClosedRentalInvoicesLayout: Report "Closed Rental Invoices - Word";
                begin
                    ClosedRentalList.SetRange("Renter No.", Rec."Renter No.");

                    ClosedRentalInvoicesLayout.SetTableView(ClosedRentalList);
                    ClosedRentalInvoicesLayout.Run();
                end;
            }
        }
    }
}