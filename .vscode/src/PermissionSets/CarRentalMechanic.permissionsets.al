permissionset 50102 "Car Rental Mechanic"
{
    Assignable = true;
    Caption = 'Car Rental - Mechanic';
    Permissions =
        tabledata Employee = R,
        tabledata Car = R,
        tabledata "Car Card Lines" = R,
        tabledata "Car Rental Cue" = RIMD,
        tabledata "Rent Setup" = R,
        tabledata Rental = R,
        tabledata Service = RIMD,
        tabledata "Service Card Lines" = RIMD,
        table Car = X,
        table "Car Card Lines" = X,
        table "Car Rental Cue" = X,
        table "Rent Setup" = X,
        table Rental = X,
        table Service = X,
        table "Service Card Lines" = X,
        report "Service Invoices - Word" = X,
        codeunit "Service Management" = X,
        codeunit "Shared Functions" = X,
        page "Car Card" = X,
        page "Car Card Factbox" = X,
        page "Car Card Lines" = X,
        page "Car List" = X,
        page "Car Rental Activities" = X,
        page "Rental Card" = X,
        page "Rental List" = X,
        page "Role Center" = X,
        page "Service Card" = X,
        page "Service Card Lines" = X,
        page "Service Lists" = X;
}