page 50116 "Rental Lines In Renter Card"
{
    ApplicationArea = All;
    Caption = 'Rental Lines';
    PageType = ListPart;
    CardPageId = "Rental Card";
    SourceTable = "Rental";
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
}