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
                    RentalList: Record "Rental";
                    ServiceCardLines: Record "Service Card Lines";
                    ServiceLines: Page "Service Card Lines";
                // Email: Codeunit Email;
                // EmailMessage: Codeunit "Email Message";
                begin
                    ServiceCardLines.SetRange("Service No.", Rec."Service No.");
                    if ServiceCardLines.FindSet() then begin
                        repeat
                            if (ServiceCardLines."Order Date" > Rec."To Date") and (ServiceCardLines."Delivery Date" > Rec."To Date") then
                                Error(Text003Err, ServiceCardLines."Delivery Date", Rec."To Date");
                        until ServiceCardLines.Next() = 0;
                    end;

                    if (Rec."To Date" <> 0D) and (Rec."Service Costs" <> 0) and (Rec.Status = Rec.Status::Service) then begin
                        Rec.Canceled := false;
                        Rec.Status := Rec.Status::Repaired;
                        Rec.Modify();

                        // No Editable Fields of Service Card Lines
                        if ServiceCardLines.Findset() then begin
                            repeat
                                ServiceCardLines.Status := ServiceCardLines.Status::Repaired;
                                ServiceCardLines.Modify();
                            until ServiceCardLines.Next() = 0;
                        end;

                        // Update Rental List
                        if Rec."Rental No." <> '' then begin
                            RentalList.SetRange("No.", Rec."Rental No.");
                            if RentalList.FindFirst() then begin
                                RentalList."Service Status" := RentalList."Service Status"::Repaired;
                                RentalList."Service To Date" := Rec."To Date";
                                RentalList."Repair Costs" := Rec."Service Costs";
                                RentalList.CountTheRepairCosts(Rec);
                                RentalList.Modify();
                            end;
                        end;

                        Message(Text001);
                        IsLinesEditable := false;
                        CurrPage.Update(false);
                        // Automatic email sending
                        // EmailMessage.Create('akos.bognar@hejnav.com', 'Repair', 'Dear Sir or Madam, Your car has been repaired. You can collect it at our Service Center. Kind regards, Service Company');
                        // Email.Send(EmailMessage, "Email Scenario"::Notification)
                    end else if Rec.Status = Rec.Status::Repaired then
                            Error(Text001Err)
                    else if (Rec."To Date" = 0D) or (Rec."Service Costs" = 0) then begin
                        Error(Text002Err);
                    end;
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
                    NewActiveService: Record "Service";
                begin
                    if StrPos(Rec."Service No.", '-SER') > 0 then
                        Error(Text001Err, Rec."Service No.");

                    if Rec.Canceled then
                        Error(Text005Err);

                    if Confirm('Are you sure you want to cancel this closed service and create a correctable draft?', true) then begin
                        NewActiveService := Rec.PerformCancelAndReopen(Rec);

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
        Text001: Label 'The Service has been closed.';
        Text001Err: Label 'The Service is already closed.';
        Text002Err: Label 'Please fill ''To Date'' and ''Cost'' fields!';
        Text003Err: Label 'The Delivery Date %1 must not be behind To Date %2';
        Text004Err: Label 'This contract (%1) is already a corrected version. You cannot modify a corrected contract again!';
        Text005Err: Label 'This rental has already been canceled!';
}