page 50115 "Service Card"
{
    ApplicationArea = All;
    Caption = 'Service';
    PageType = Card;
    SourceTable = "Service";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Service No."; Rec."Service No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Canceled; Rec.Canceled)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Rental No."; Rec."Rental No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Car No."; Rec."Car No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Car Brand"; Rec."Car Brand")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Car Model"; Rec."Car Model")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Registration No."; Rec."Registration No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("From Date"; Rec."From Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("To Date"; Rec."To Date")
                {
                    ApplicationArea = All;
                    Editable = (Rec.Status = Rec.Status::Repaired = false);
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Details; Rec.Details)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Service Costs"; Rec."Service Costs")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            part(SeviceCardLines; "Service Card Lines")
            {
                Caption = 'Service Lines';
                ApplicationArea = All;
                SubPageLink = "Service No." = field("Service No.");
                Editable = IsLinesEditable;
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(CloseService)
            {
                ApplicationArea = All;
                Caption = 'Close Service';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Close;
                Enabled = (Rec.Status = Rec.Status::Service);

                trigger OnAction()
                var
                    ServiceMgt: Codeunit "Service Management";
                begin
                    ServiceMgt.ProcessServiceClosure(Rec);

                    IsLinesEditable := false;
                    CurrPage.Update(false);
                end;

            }
            action(CancelAndReopen)
            {
                Caption = 'Cancel and Reopen';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Undo;
                Enabled = (Rec.Status = Rec.Status::Repaired);

                trigger OnAction()
                var
                    ServiceMgt: Codeunit "Service Management";
                    NewActiveService: Record "Service";
                begin
                    if Rec.Canceled then
                        Error(Text002Err);

                    if StrPos(Rec."Service No.", '-SER') > 0 then
                        Error(Text001Err, Rec."Service No.");

                    if Confirm(Text001, true) then begin
                        NewActiveService := ServiceMgt.PerformServiceCancelAndReopen(Rec);

                        Commit();

                        Page.Run(Page::"Service Card", NewActiveService);
                        CurrPage.Close();
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        IsLinesEditable := (Rec.Status <> Rec.Status::Repaired)
    end;

    var
        IsLinesEditable: Boolean;
        Text001: Label 'Are you sure you want to cancel this closed service and create a correctable draft?';
        Text001Err: Label 'This service contract (%1) is already a corrected version. You cannot modify a corrected contract again!';
        Text002Err: Label 'This rental has already been canceled!';
}