page 50117 "Service Card Lines"
{
    ApplicationArea = All;
    Caption = 'Service Lines';
    PageType = ListPart;
    SourceTable = "Service Card Lines";
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Service No."; Rec."Service No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field("Type"; Rec."Type")
                {
                    ApplicationArea = All;
                }
                field("Car Part"; Rec."Car Part")
                {
                    ApplicationArea = All;
                    Editable = (Rec.Type = Rec.Type::Wage = false);
                }
                field(Manufacturer; Rec.Manufacturer)
                {
                    ApplicationArea = All;
                    Editable = (Rec.Type = Rec.Type::Wage = false);
                }
                field("Order Necessary"; Rec."Order Necessary")
                {
                    ApplicationArea = All;
                }
                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = All;
                    Editable = (Rec.Type = Rec.Type::Wage = false) and (Rec."Order Necessary" = Rec."Order Necessary"::No = false);
                }
                field("Delivery Date"; Rec."Delivery Date")
                {
                    ApplicationArea = All;
                    Editable = (Rec.Type = Rec.Type::Wage = false) and (Rec."Order Necessary" = Rec."Order Necessary"::No = false);
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.Cost := Rec.Quantity * Rec."Unit Price";
                        CurrPage.Update(true);
                    end;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.Cost := Rec.Quantity * Rec."Unit Price";
                        CurrPage.Update(true);
                    end;
                }
                field(Cost; Rec.Cost)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Print)
            {
                ApplicationArea = All;
                Caption = 'Print';
                Image = Print;

                trigger OnAction()
                var
                    ServiceHeader: Record "Service";
                    ServiceList: Record "Service Card Lines";
                    ServiceInvoicesLayout: Report "Service Invoices - Word";
                begin
                    ServiceHeader.SetRange("Service No.", Rec."Service No.");

                    if ServiceHeader.FindFirst() then begin
                        if ServiceHeader.Status = ServiceHeader.Status::Service then
                            Error(Text001Err);
                    end;

                    ServiceList.SetRange("Service No.", Rec."Service No.");

                    ServiceInvoicesLayout.SetTableView(ServiceList);
                    ServiceInvoicesLayout.Run();
                end;
            }
        }
    }

    var
        Text001Err: Label 'The car has not yet been repaired!';
}