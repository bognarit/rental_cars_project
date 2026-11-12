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
                    Editable = false;
                }
                field("Renter Type"; Rec."Renter Type")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    trigger OnValidate()
                    begin
                        UpdateCompanyFieldsVisibility();
                    end;
                }
                group(PrivateDetailsGroup)
                {
                    ShowCaption = false;
                    Visible = isPrivate;

                    field(Gender; Rec.Gender)
                    {
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            UpdateCompanyFieldsVisibility();
                        end;
                    }
                }
                field("Renter Name"; Rec."Renter Name")
                {
                    ApplicationArea = All;
                }
                Group(CompanyDetailsGroup)
                {
                    ShowCaption = false;
                    Visible = IsCompany;

                    field("Contact Person"; Rec."Contact Person")
                    {
                        ApplicationArea = All;
                    }
                    field("VAT Registration No."; Rec."VAT Registration No.")
                    {
                        ApplicationArea = All;
                    }
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
                field(Email; Rec.Email)
                {
                    ApplicationArea = All;
                }
                field(Maplink; Maplink)
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                    Style = StandardAccent;

                    trigger OnDrillDown()
                    begin
                        if (Rec."Address" = '') and (Rec."City" = '') then
                            exit;
                        Hyperlink('https://www.google.com/maps/search/?api=1&query=' + Rec."Address" + ' ' + Rec."City" + ' ' + Rec."Post Code");
                    end;
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
    actions
    {
        area(Processing)
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

    trigger OnAfterGetRecord()
    begin
        UpdateCompanyFieldsVisibility();
    end;

    trigger OnModifyRecord(): Boolean
    begin
        Rec.TestField("Renter Type");
        exit(true);
    end;

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

        UpdateCompanyFieldsVisibility();
    end;

    local procedure UpdateCompanyFieldsVisibility()
    begin
        IsCompany := (Rec."Renter Type" = Rec."Renter Type"::Company);
        isPrivate := (Rec."Renter Type" = Rec."Renter Type"::Private);
    end;

    var
        isCompany: Boolean;
        isPrivate: Boolean;
        Maplink: Label 'Google Map';
}