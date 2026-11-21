page 50121 "Available Cars API"
{
    PageType = API;
    Caption = 'Available Cars API';
    APIPublisher = 'rentcar';
    APIGroup = 'fleet';
    APIVersion = 'v2.0';
    EntityName = 'availableCar';
    EntitySetName = 'availableCars';
    ODataKeyFields = SystemId;
    SourceTable = "Car Card Lines";
    SourceTableView = where("Car Status" = const(Available));
    Editable = false;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(id; Rec.SystemId)
                {
                    Caption = 'System Id';
                    Editable = false;
                }
                field(brand; CarHeader.Brand)
                {
                    Caption = 'Brand';
                    Editable = false;
                }
                field(model; CarHeader.Model)
                {
                    Caption = 'Type';
                    Editable = false;
                }
                field(registrationNo; Rec."Registration No.")
                {
                    Caption = 'Registration No.';
                }
                field(manufactYear; Rec."Manufact. Year")
                {
                    Caption = 'Manufact. Year';
                }
                field(mileage; Rec.Mileage)
                {
                    Caption = 'Mileage';
                }
                field(transmissionType; Rec."Transmission Type")
                {
                    Caption = 'Transmission Type';
                }
                field(power; Rec.Power)
                {
                    Caption = 'Power';
                }
                field(fuelType; Rec."Fuel Type")
                {
                    Caption = 'Fuel Type';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if not CarHeader.Get(Rec."No.") then
            CarHeader.Init();
    end;

    var
        CarHeader: Record Car;
}