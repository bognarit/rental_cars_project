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
                    Visible = false;
                }
                field("Registration No."; Rec."Registration No.")
                {
                    ApplicationArea = All;
                    Editable = IsLineEditable;
                }
                field("Car Status"; Rec."Car Status")
                {
                    ApplicationArea = All;
                }
                field("Manufact. Year"; Rec."Manufact. Year")
                {
                    ApplicationArea = All;
                    Editable = IsLineEditable;
                }
                field(Mileage; Rec.Mileage)
                {
                    ApplicationArea = All;
                    Editable = IsLineEditable;
                }
                field("Transmission Type"; Rec."Transmission Type")
                {
                    ApplicationArea = All;
                    Editable = IsLineEditable;
                }
                field(Power; Rec.Power)
                {
                    ApplicationArea = All;
                    Editable = IsLineEditable;
                }
                field("Fuel Type"; Rec."Fuel Type")
                {
                    ApplicationArea = All;
                    Editable = IsLineEditable;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        IsLineEditable := true;
    end;

    trigger OnAfterGetRecord()
    begin
        if (Rec."Line No." = 0) or (Rec."Registration No." = '') then
            IsLineEditable := true
        else
            IsLineEditable := false

    end;

    var
        IsLineEditable: Boolean;
}