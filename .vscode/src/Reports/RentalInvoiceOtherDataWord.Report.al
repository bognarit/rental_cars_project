report 50101 "Rental Invoice Other Data-Word"
{
    Caption = 'Rental Invoice Other Data';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = RentalInvoiceOtherDataLayout;

    dataset
    {
        dataitem(RentalListClosed; "Closed Rental")
        {
            RequestFilterFields = "No.", "Renter No.";
            column(No; "No.")
            {
            }
            column(RenterNo; "Renter No.")
            {
            }
            column(BillToName; "Bill-to Name")
            {
            }
            column(BillToAddress; "Bill-to Address")
            {
            }
            column(BillToCity; "Bill-to City")
            {
            }
            column(BillToPostCode; "Bill-to Post Code")
            {
            }
            column(CarBrand; "Car Brand")
            {
            }
            column(CarModel; "Car Model")
            {
            }
            column(RegistrationNo; "Registration No.")
            {
            }
            column(FromDate; "From Date")
            {
            }
            column(ToDate; "To Date")
            {
            }
            column(RentalDay; "Rental Day(s)")
            {
            }
            column(RentalDayCost; "Rental Day(s) Cost")
            {
            }
            column(Mileage; Mileage)
            {
            }
            column(MileageCost; "Mileage Cost")
            {
            }
            column(CarInsuranceCost; "Car Insurance Cost")
            {
            }
            column(TotalCost; "Total Cost")
            {
            }
        }
    }

    rendering
    {
        layout(RentalInvoiceOtherDataLayout)
        {
            Type = Word;
            LayoutFile = './.vscode/src/Reports/RentalInvoiceOtherDataLayout.docx';
            Caption = 'RentalInvoiceOtherDataLayout';
            Summary = 'Word Layout of Rental Invoice Other Data.';
        }
    }
}