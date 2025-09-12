page 50101 "Car List"
{
    ApplicationArea = All;
    Caption = 'Car List';
    PageType = List;
    UsageCategory = Lists;
    CardPageId = "Car Card";
    SourceTable = "Car";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
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
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(UploadData)
            {
                Caption = 'Upload Data';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Add;

                trigger OnAction()
                var
                    Buffer: Record "Excel Buffer" temporary;
                    Data: Record "Car";
                    InS: InStream;
                    Filename: Text;
                    Row: Integer;
                    LastRow: Integer;
                begin
                    if UploadIntoStream('Gimmi the Excel', '', '', Filename, InS) then begin
                        Buffer.OpenBookStream(InS, 'Tabelle1');
                        Buffer.ReadSheet();
                        Buffer.SetRange("Column No.", 5);
                        Buffer.FindLast();
                        LastRow := Buffer."Row No.";
                        Buffer.Reset();

                        for row := 2 to LastRow do begin
                            Data.Init();
                            Data."No." := ExcelTools.GetText(Buffer, 'A', row);
                            Data.Brand := ExcelTools.GetText(Buffer, 'B', row);
                            Data.Model := ExcelTools.GetText(Buffer, 'C', row);
                            Data."Manufact. Name" := ExcelTools.GetText(Buffer, 'D', row);
                            Data."Manufact. Place" := ExcelTools.GetText(Buffer, 'E', row);
                            Data.Insert();
                        end;
                    end;
                end;
            }
            action(DownloadData)
            {
                Caption = 'Download Data';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Download;

                trigger OnAction()
                begin
                    Message('Download Data');
                end;
            }
        }
    }

    var
        ExcelTools: Codeunit "Excel Tools";
}