report 50105 "Monthly Settlement Report"
{
    Caption = 'Monthly Settlement Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = MonthlySettlementInvoiceLayout;

    dataset
    {
        dataitem(Settlement; "Monthly Settlement")
        {
            RequestFilterFields = "Settlement No.", "Starting Date";

            column(SettlementNo; "Settlement No.") { }
            column(StartingDate; "Starting Date") { }
            column(EndingDate; "Ending Date") { }
            column(TotalRentalRevenue; "Total Rental Revenue") { }
            column(TotalServiceCosts; "Total Service Costs") { }
            column(NetProfit; "Net Profit") { }

            dataitem(SettlementLine; "Monthly Settlement Line")
            {
                DataItemLink = "Settlement No." = field("Settlement No.");

                column(EmployeeNo; "Employee No.") { }
                column(EmployeeName; "Employee Name") { }
                column(RentRole; "Rent Role") { }
                column(CommissionPct; "Commission %") { }
                column(CompletedCount; "Completed Count") { }
                column(GeneratedAmount; "Generated Amount") { }
                column(CommissionAmount; "Commission Amount") { }
            }
        }
    }
    rendering
    {
        layout(MonthlySettlementInvoiceLayout)
        {
            Type = Word;
            LayoutFile = './.vscode/src/Reports/MonthlySettlementInvoicesLayout.docx';
            Caption = 'SettlementInvoicesLayout';
            Summary = 'Word Layout of Monthly Settlement Invoices.';
        }
    }
}