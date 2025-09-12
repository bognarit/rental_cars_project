page 50105 "Role Center"
{
    ApplicationArea = All;
    Caption = 'Role Center';
    PageType = RoleCenter;
    RefreshOnActivate = true;

    actions
    {
        area(Sections)
        {
            group(RentalCars)
            {
                Caption = 'Rental Cars';

                action(RentalList)
                {
                    Caption = 'Rental List';
                    Image = Database;
                    RunObject = page "Rental List";
                }
                action(ClosedRentalList)
                {
                    Caption = 'Closed Rental List';
                    Image = Database;
                    RunObject = page "Closed Rental List";
                }
                action(CarList)
                {
                    Caption = 'Car List';
                    Image = Database;
                    RunObject = page "Car List";
                }
                action(RenterData)
                {
                    Caption = 'Renter List';
                    Image = Database;
                    RunObject = page "Renter List";
                }
                action(ServiceList)
                {
                    Caption = 'Service List';
                    Image = Database;
                    RunObject = page "Service Lists";
                }
            }
            group(IT)
            {
                Caption = 'IT', Locked = true;

                action(Language)
                {
                    Caption = 'Language';
                    Image = Language;
                    RunObject = codeunit "Shared Functions";
                }
                action(RentSetup)
                {
                    Caption = 'Rent Setup';
                    Image = Database;
                    RunObject = Page "Rent Setup";
                }
            }
        }
    }
}