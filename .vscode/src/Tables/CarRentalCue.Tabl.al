table 50110 "Car Rental Cue"
{
    DataClassification = CustomerContent;
    Caption = 'Car Rental Cue';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = '', Locked = true;
        }
        field(2; "Open Rentals"; Integer)
        {
            Caption = 'Open Rentals';
            FieldClass = FlowField;
            CalcFormula = Count(Rental where("Rental Status" = const(Open)));
        }
        field(3; "Released Rentals"; Integer)
        {
            Caption = 'Released Rentals';
            FieldClass = FlowField;
            CalcFormula = Count(Rental where("Rental Status" = const(Released)));
        }
        field(4; "Available Cars"; Integer)
        {
            Caption = 'Available Cars';
            FieldClass = FlowField;
            CalcFormula = Count("Car Card Lines" where("Car Status" = const(Available)));
        }
        field(5; "Cars in Service"; Integer)
        {
            Caption = 'Cars in Service';
            FieldClass = FlowField;
            CalcFormula = Count(Rental where("Service Status" = const(Service)));
        }
        field(6; "Open Settlements"; Integer)
        {
            Caption = 'Open Settlements';
            FieldClass = FlowField;
            CalcFormula = Count("Monthly Settlement" where(Status = const(Open)));
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }
}