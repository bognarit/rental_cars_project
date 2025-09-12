pageextension 50100 "Renter Fields Ext" extends "Renter Card"
{
    layout
    {
        addbefore("Renter Name")
        {
            field(Gender; Rec.Gender)
            {
                ApplicationArea = All;
            }
        }
        addlast(General)
        {
            field(Email; Rec.Email)
            {
                ApplicationArea = All;
            }
            field(Maplink; Maplink)
            {
                ApplicationArea = All;
                ShowCaption = false;

                trigger OnDrillDown()
                begin
                    Hyperlink('https://www.google.com/maps/search/?api=1&query=' + Rec."Address" + ' ' + Rec."City" + ' ' + Rec."Post Code");
                end;
            }
        }
    }

    actions
    {
        addfirst(Processing)
        {
            action(SendEmail)
            {
                Caption = 'Send Email';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = SendMail;

                trigger OnAction()
                var
                    Email: Codeunit Email;
                    EmailMessage: Codeunit "Email Message";
                begin
                    EmailMessage.Create(Rec.Email, '', '');
                    Email.OpenInEditorModally(EmailMessage, Enum::"Email Scenario"::Default);
                    // Automatic email sending
                    // EmailMessage.Create(Rec.Email, 'Info', 'This is the Info');
                    // Email.Send(EmailMessage, "Email Scenario"::Notification)
                end;
            }
        }
    }
    var
        Maplink: Label 'Google Map';
}