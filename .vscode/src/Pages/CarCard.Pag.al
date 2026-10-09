page 50108 "Car Card"
{
    ApplicationArea = All;
    Caption = 'Car';
    PageType = Card;
    SourceTable = "Car";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Brand; Rec.Brand)
                {
                    ApplicationArea = All;
                }
                field(Model; Rec.Model)
                {
                    ApplicationArea = All;
                }
                field("Manufact. Name"; Rec."Manufact. Name")
                {
                    ApplicationArea = All;
                }
                field("Manufact. Place"; Rec."Manufact. Place")
                {
                    ApplicationArea = All;
                }
            }
            part(CarCardLines; "Car Card Lines")
            {
                Caption = 'Car Lines';
                ApplicationArea = All;
                SubPageLink = "No." = field("No.");
            }
        }
        area(FactBoxes)
        {
            part(CarCardFactbox; "Car Card Factbox")
            {
                Caption = 'Car Picture';
                ApplicationArea = All;
                SubPageLink = "No." = field("No.");
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(UploadPicture)
            {
                Caption = 'Upload Picture';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Add;

                trigger OnAction()
                var
                    InS: InStream;
                    OutS: OutStream;
                    FileName: Text;
                    TempBlob: Codeunit "Temp Blob";
                begin
                    if UploadIntoStream('Select file', '', '', FileName, InS) then begin
                        TempBlob.CreateOutStream(OutS);
                        CopyStream(OutS, InS);
                        Rec.CalcFields("Car Picture");
                        Rec."Car Picture".CreateOutStream(OutS);
                        TempBlob.CreateInStream(InS);
                        CopyStream(OutS, InS);
                    end;
                end;
            }
            action(DeletePicture)
            {
                Caption = 'Delete Picture';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Delete;

                trigger OnAction()
                begin
                    if not Rec."Car Picture".HasValue then
                        Message('There is not uploaded picture.')
                    else
                        if Confirm('Would you like to delete the picture?') then begin
                            Clear(Rec."Car Picture");
                            Rec.Modify(true);
                        end;
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        NoSeries: Codeunit "No. Series";
        RentSetup: Record "Rent Setup";
    begin
        RentSetup.Get();
        RentSetup.TestField("Car List No. Series");
        if Rec."No." <> '' then begin
            NoSeries.TestManual(RentSetup."Car List No. Series")
        end else begin
            Rec."No." := NoSeries.GetNextNo(RentSetup."Car List No. Series", WorkDate(), false);
        end;
    end;
}