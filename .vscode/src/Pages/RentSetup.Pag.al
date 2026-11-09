page 50107 "Rent Setup"
{
    ApplicationArea = All;
    Caption = 'Rent Setup';
    PageType = Card;
    UsageCategory = Administration;
    SourceTable = "Rent Setup";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = IsAdminEditable;

                field("Car List No. Series"; Rec."Car List No. Series")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Rental List No. Series"; Rec."Rental List No. Series")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Renter Data No. Series"; Rec."Renter Data No. Series")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Service Data No. Series"; Rec."Service Data No. Series")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        UserPermissions: Codeunit "User Permissions";
    begin
        if UserPermissions.IsSuper(UserSecurityId()) then begin
            IsAdminEditable := true;
        end else begin
            IsAdminEditable := false;
        end;
    end;

    var
        IsAdminEditable: Boolean;
}