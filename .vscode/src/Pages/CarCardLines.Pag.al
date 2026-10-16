page 50109 "Car Card Lines"
{
    ApplicationArea = All;
    Caption = 'Car Lines';
    PageType = ListPart;
    SourceTable = "Car Card Lines";
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field("Registration No."; Rec."Registration No.")
                {
                    ApplicationArea = All;
                }
                field("Manufact. Year"; Rec."Manufact. Year")
                {
                    ApplicationArea = All;
                }
                field(Mileage; Rec.Mileage)
                {
                    ApplicationArea = All;
                }
                field(Transmission; Rec.Transmission)
                {
                    ApplicationArea = All;
                }
                field(Power; Rec.Power)
                {
                    ApplicationArea = All;
                }
                field(Fuel; Rec.Fuel)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}