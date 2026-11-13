pageextension 50100 "Employee Card Ext" extends "Employee Card"
{
    layout
    {
        addlast(General)
        {
            Group(CarRentalInfo)
            {
                Caption = 'Car Rental Information';

                field("Rent Role"; Rec."Rent Role")
                {
                    ApplicationArea = All;
                }
                field("Commission %"; Rec."Commission %")
                {
                    ApplicationArea = All;
                }
                field("Active in Rental"; Rec."Active in Rental")
                {
                    ApplicationArea = All;
                }

            }
        }
    }
}