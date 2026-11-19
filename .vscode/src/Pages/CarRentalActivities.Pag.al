page 50120 "Car Rental Activities"
{
    ApplicationArea = All;
    Caption = 'Car Rental Activities';
    PageType = CardPart;
    SourceTable = "Car Rental Cue";

    layout
    {
        area(Content)
        {
            cuegroup(General)
            {
                field("Open Rentals"; Rec."Open Rentals")
                {
                    ApplicationArea = All;
                    DrillDownPageId = "Rental List";
                }
                field("Released Rentals"; Rec."Released Rentals")
                {
                    ApplicationArea = All;
                    DrillDownPageId = "Rental List";
                }
                field("Available Cars"; Rec."Available Cars")
                {
                    ApplicationArea = All;
                    DrillDownPageId = "Car List";
                }
                field("Cars in Service"; Rec."Cars in Service")
                {
                    ApplicationArea = All;
                    DrillDownPageId = "Service List";
                }
                field("Open Settlements"; Rec."Open Settlements")
                {
                    ApplicationArea = All;
                    DrillDownPageId = "Monthly Settlements";
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}