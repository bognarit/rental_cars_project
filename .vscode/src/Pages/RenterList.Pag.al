page 50104 "Renter List"
{
    ApplicationArea = All;
    Caption = 'Renter List';
    PageType = List;
    UsageCategory = Lists;
    CardPageId = "Renter Card";
    SourceTable = "Renter";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                Caption = 'General';

                field("Renter No."; Rec."Renter No.")
                {
                    ApplicationArea = All;
                    TableRelation = "Renter";
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
            }
        }
    }
}