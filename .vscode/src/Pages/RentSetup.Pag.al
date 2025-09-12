page 50107 "Rent Setup"
{
    ApplicationArea = All;
    Caption = 'Rent Setup';
    PageType = Card;
    UsageCategory = Administration;
    SourceTable = "Rent Setup";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Rental List No. Series"; Rec."Rental List No. Series")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Renter Data No. Series"; Rec."Renter Data No. Series")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Service Data No. Series"; Rec."Service Data No. Series")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
            }
        }
    }
}