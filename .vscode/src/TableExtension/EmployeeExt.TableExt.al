tableextension 50100 "Employee Ext" extends Employee
{
    fields
    {
        field(50100; "Rent Role"; Enum "Rent Employee Role")
        {
            Caption = 'Rent Role';
        }
        field(50101; "Commission %"; Decimal)
        {
            Caption = 'Commission %';
            MinValue = 0;
            MaxValue = 100;
        }
        field(50102; "Active in Rental"; Boolean)
        {
            Caption = 'Active in Rental';
        }
    }
}