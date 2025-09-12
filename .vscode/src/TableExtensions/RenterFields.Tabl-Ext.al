tableextension 50100 "Renter Fields Ext" extends "Renter"
{
    fields
    {
        field(50100; Gender; Enum "Gender Group")
        {
            Caption = 'Gender';
            DataClassification = CustomerContent;
        }
        field(50101; Email; Text[100])
        {
            Caption = 'Email';
            DataClassification = CustomerContent;
        }
    }
}