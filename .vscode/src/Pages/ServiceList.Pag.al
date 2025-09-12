page 50112 "Service Lists"
{
    ApplicationArea = All;
    Caption = 'Service List';
    PageType = List;
    UsageCategory = Lists;
    CardPageId = "Service Card";
    SourceTable = "Service";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Service No."; Rec."Service No.")
                {
                    ApplicationArea = All;
                }
                field("Rental No."; Rec."Rental No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Car No."; Rec."Car No.")
                {
                    ApplicationArea = All;
                }
                field(Brand; Rec."Car Brand")
                {
                    ApplicationArea = All;
                }
                field(Model; Rec."Car Model")
                {
                    ApplicationArea = All;
                }
                field("Registration No."; Rec."Registration No.")
                {
                    ApplicationArea = All;
                }
                field("From Date"; Rec."From Date")
                {
                    ApplicationArea = All;
                }
                field("To Date"; Rec."To Date")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Service Costs"; Rec."Service Costs")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        NoSeries: Codeunit "No. Series";
        RentSetup: Record "Rent Setup";
    begin
        RentSetup.Get();
        RentSetup.TestField("Service Data No. Series");
        if Rec."Service No." <> '' then begin
            NoSeries.TestManual(RentSetup."Service Data No. Series")
        end else begin
            Rec."Service No." := NoSeries.GetNextNo(RentSetup."Service Data No. Series", WorkDate(), false);
        end;
    end;
}
