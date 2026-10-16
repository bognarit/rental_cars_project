report 50100 "Rental Invoice - Word"
{
    Caption = 'Rental Invoice';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = RentalInvoiceLayout;

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
            column(RenterName; "Renter Name")
            {
            }
            column(Address; Address)
            {
            }
            column(City; City)
            {
            }
            column(PostCode; "Post Code")
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

            trigger OnAfterGetRecord()
            var
                ClosedRental: Record "Closed Rental";
            begin
                Mileage := 0;

                if ClosedRental.Get("No.", "Renter No.") then
                    Mileage := ClosedRental."Ending Mileage" - ClosedRental."Starting Mileage";
            end;
        }
    }

    rendering
    {
        layout(RentalInvoiceLayout)
        {
            Type = Word;
            LayoutFile = './.vscode/src/Reports/RentalInvoiceLayout.docx';
            Caption = 'RentalInvoiceLayout';
            Summary = 'Word Layout of Rental Invoice.';
        }
    }

    var
        Mileage: Integer;
}