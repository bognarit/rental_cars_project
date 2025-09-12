report 50103 "Service Invoices - Word"
{
    Caption = 'Service Invoices';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = ServiceInvoiceLayout;

    dataset
    {
        dataitem(ServiceDataLines; "Service Card Lines")
        {
            column(ServiceNo; "Service No.")
            {
            }
            column(LineNo; "Line No.")
            {
            }
            column(Type; Type)
            {
            }
            column(CarPart; "Car Part")
            {
            }
            column(Manufacturer; Manufacturer)
            {
            }
            column(OrderNec; "Order Necessary")
            {
            }
            column(OrdeDate; "Order Date")
            {
            }
            column(DeliveryDate; "Delivery Date")
            {
            }
            column(Cost; Cost)
            {
            }
            column(FromDate; FromDate)
            {
            }
            column(ToDate; ToDate)
            {
            }
            column(Quantity; Quantity)
            {
            }
            column(UnitPrice; "Unit Price")
            {
            }
            column(TotalCost; TotalCost)
            {
            }

            trigger OnAfterGetRecord()
            var
                ServiceCardLines: Record "Service Card Lines";
                ServiceList: Record "Service";
            begin
                ServiceCardLines.SetRange("Service No.", "Service No.");
                ServiceCardLines.Calcsums(Cost);
                TotalCost := ServiceCardLines.Cost;

                ServiceList.SetRange("Service No.", "Service No.");
                ServiceList.FindFirst();
                FromDate := ServiceList."From Date";
                ToDate := ServiceList."To Date";
            end;
        }
    }

    rendering
    {
        layout(ServiceInvoiceLayout)
        {
            Type = Word;
            LayoutFile = './.vscode/src/Reports/ServiceInvoicesLayout.docx';
            Caption = 'ServiceInvoicesLayout';
            Summary = 'Word Layout of Service Invoices.';
        }
    }

    var
        TotalCost: Decimal;
        FromDate: Date;
        ToDate: Date;
}