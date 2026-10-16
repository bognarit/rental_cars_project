report 50102 "Closed Rental Invoices - Word"
{
    Caption = 'Closed Rental Invoices';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = RentalInvoiceLayout;

    dataset
    {
        dataitem(RentalListClosed; "Closed Rental")
        {
            RequestFilterFields = "Renter No.";
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
            column(StartingMileage; "Starting Mileage")
            {
            }
            column(EndingMileage; "Ending Mileage")
            {
            }
            column(MileageCost; "Mileage Cost")
            {
            }
            column(TotalCost; "Total Cost")
            {
            }
            column(FirstFromDate; FirstFromDate)
            {
            }
            column(LastToDate; LastToDate)
            {
            }
            column(TotalRentalDayCost; TotalRentalDayCost)
            {
            }
            column(TotalMileageCost; TotalMileageCost)
            {
            }
            column(TotalCarInsuranceCost; TotalCarInsuranceCost)
            {
            }
            column(TotalRentalCosts; TotalRentalCosts)
            {
            }

            trigger OnAfterGetRecord()
            var
                ClosedRental: Record "Closed Rental";
            begin
                ClosedRental.SetRange("Renter No.", "Renter No.");
                ClosedRental.Calcsums("Rental Day(s) Cost", "Mileage Cost", "Car Insurance Cost", "Total Cost");
                TotalRentalDayCost := ClosedRental."Rental Day(s) Cost";
                TotalMileageCost := ClosedRental."Mileage Cost";
                TotalCarInsuranceCost := ClosedRental."Car Insurance Cost";
                TotalRentalCosts := ClosedRental."Total Cost";

                if ClosedRental.FindSet() then begin
                    repeat
                        if "From Date" >= ClosedRental."From Date" then
                            FirstFromDate := ClosedRental."From Date";
                        if "To Date" <= ClosedRental."To Date" then
                            LastToDate := ClosedRental."To Date";
                    until ClosedRental.Next() = 0;
                end;
            end;
        }
    }

    rendering
    {
        layout(RentalInvoiceLayout)
        {
            Type = Word;
            LayoutFile = './.vscode/src/Reports/ClosedRentalInvoicesLayout.docx';
            Caption = 'ClosedRentalInvoicesLayout';
            Summary = 'Word Layout of Closed Rental Invoices.';
        }
    }

    var
        TotalRentalDayCost: Decimal;
        TotalMileageCost: Decimal;
        TotalCarInsuranceCost: Decimal;
        TotalRentalCosts: Decimal;
        FirstFromDate: Date;
        LastToDate: Date;
}