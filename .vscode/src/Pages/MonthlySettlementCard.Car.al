page 50118 "Monthly Settlement Card"
{
    PageType = Card;
    Caption = 'Monthly Settlement Card';
    ApplicationArea = All;
    SourceTable = "Monthly Settlement";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Settlement No."; Rec."Settlement No.")
                {
                    ApplicationArea = All;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = All;
                    Editable = (Rec.Status = Rec.Status::Open);
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = All;
                }
                field("Total Rental Revenue"; Rec."Total Rental Revenue")
                {
                    ApplicationArea = All;
                }
                field("Total Service Costs"; Rec."Total Service Costs")
                {
                    ApplicationArea = All;
                }
                field("Net Profit"; Rec."Net Profit")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec."Status")
                {
                    ApplicationArea = All;
                }
            }
            part(MonthlySettlementLines; "Monthly Settlement Lines")
            {
                Caption = 'Monthly Settlement Lines';
                ApplicationArea = All;
                SubPageLink = "Settlement No." = field("Settlement No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CalculateSettlement)
            {
                Caption = 'Calculate Settlement';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Calculate;
                Enabled = (Rec.Status = Rec.Status::Open);
                trigger OnAction()
                var
                    SettlementMgt: Codeunit "Settlement Management";
                begin
                    CurrPage.SaveRecord();
                    SettlementMgt.CalculateMonthlySettlement(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(CloseSettlement)
            {
                Caption = 'Close Settlement';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Approve;
                trigger OnAction()
                var
                    SettlementMgt: Codeunit "Settlement Management";
                begin
                    if Rec."Ending Date" >= Today then
                        Error(Text001Err);

                    if Confirm(Text001, true) then
                        SettlementMgt.CloseMonthlySettlement(Rec);
                end;
            }
        }
    }
    var
        Text001: Label 'Are you sure you want to close this monthly settlement? Once closed, it cannot be modified.';
        Text001Err: Label 'You can only close months that have already ended.';
}