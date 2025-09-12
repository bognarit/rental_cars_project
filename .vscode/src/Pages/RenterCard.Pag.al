page 50106 "Renter Card"
{
    ApplicationArea = All;
    Caption = 'Renter';
    PageType = Card;
    SourceTable = "Renter";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Renter No."; Rec."Renter No.")
                {
                    ApplicationArea = All;
                }
                field("Renter Name"; Rec."Renter Name")
                {
                    ApplicationArea = All;
                }
                field("Address"; Rec."Address")
                {
                    ApplicationArea = All;
                }
                field("City"; Rec."City")
                {
                    ApplicationArea = All;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = All;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = All;
                    TableRelation = "Country/Region";
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                }
            }
            part(RentalLinesInRenterCard; "Rental Lines In Renter Card")
            {
                Caption = 'Rental List';
                ApplicationArea = All;
                SubPageLink = "Renter No." = field("Renter No.");
            }
            part(ClosedRentalLinesInRenterCard; "Closed Rental In Renter Card")
            {
                Caption = 'Closed Rental List';
                ApplicationArea = All;
                SubPageLink = "Renter No." = field("Renter No.");
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        NoSeries: Codeunit "No. Series";
        RentSetup: Record "Rent Setup";
    begin
        RentSetup.Get();
        RentSetup.TestField("Renter Data No. Series");
        if Rec."Renter No." <> '' then begin
            NoSeries.TestManual(RentSetup."Renter Data No. Series")
        end else begin
            Rec."Renter No." := NoSeries.GetNextNo(RentSetup."Renter Data No. Series", WorkDate(), false);
        end;
    end;
}