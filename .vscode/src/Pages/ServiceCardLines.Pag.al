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
                    Editable = (Rec.Status = Rec.Status::Repaired = false);
                }
                field("Type"; Rec."Type")
                {
                    ApplicationArea = All;
                    Editable = (Rec.Status = Rec.Status::Repaired = false);
                }
                field("Car Part"; Rec."Car Part")
                {
                    ApplicationArea = All;
                    Editable = (Rec.Type = Rec.Type::Wage = false) and (Rec.Status = Rec.Status::Repaired = false);
                }
                field(Manufacturer; Rec.Manufacturer)
                {
                    ApplicationArea = All;
                    Editable = (Rec.Type = Rec.Type::Wage = false) and (Rec.Status = Rec.Status::Repaired = false);
                }
                field("Order Necessary"; Rec."Order Necessary")
                {
                    ApplicationArea = All;
                    Editable = (Rec.Type = Rec.Type::Wage = false) and (Rec.Status = Rec.Status::Repaired = false);
                }
                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = All;
                    Editable = (Rec.Type = Rec.Type::Wage = false) and (Rec.Status = Rec.Status::Repaired = false) and (Rec."Order Necessary" = Rec."Order Necessary"::No = false);
                }
                field("Delivery Date"; Rec."Delivery Date")
                {
                    ApplicationArea = All;
                    Editable = (Rec.Type = Rec.Type::Wage = false) and (Rec.Status = Rec.Status::Repaired = false) and (Rec."Order Necessary" = Rec."Order Necessary"::No = false);
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Editable = (Rec.Status = Rec.Status::Repaired = false);
                    trigger OnValidate()
                    begin
                        Rec.Cost := Rec.Quantity * Rec."Unit Price";
                    end;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    Editable = (Rec.Status = Rec.Status::Repaired = false);
                    trigger OnValidate()
                    begin
                        Rec.Cost := Rec.Quantity * Rec."Unit Price";
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
                    ServiceList: Record "Service Card Lines";
                    ServiceInvoicesLayout: Report "Service Invoices - Word";
                begin
                    ServiceList.SetRange("Service No.", Rec."Service No.");

                    ServiceInvoicesLayout.SetTableView(ServiceList);
                    ServiceInvoicesLayout.Run();
                end;
            }
        }
    }

    var
        ServiceList: Record "Service";
}