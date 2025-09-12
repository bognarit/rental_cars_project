page 50111 "Car Card Factbox"
{
    ApplicationArea = All;
    Caption = 'Car Picture';
    PageType = CardPart;
    SourceTable = "Car";

    layout
    {
        area(Content)
        {
            field("Car Picture"; Rec."Car Picture")
            {
                ApplicationArea = All;
                ShowCaption = false;
            }
        }
    }
}
