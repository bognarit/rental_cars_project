table 50103 "Renter"
{
    DataClassification = CustomerContent;
    Caption = 'Renter';

    fields
    {
        field(1; "Renter No."; Code[20])
        {
            Caption = 'Renter No.';
        }
        field(2; "Renter Type"; Enum "Renter Type")
        {
            Caption = 'Renter Type';
        }
        field(3; Gender; Enum "Gender Group")
        {
            Caption = 'Gender';
            DataClassification = CustomerContent;
        }
        field(4; "Renter Name"; Text[50])
        {
            Caption = 'Renter Name';
        }
        field(7; Address; Text[100])
        {
            Caption = 'Address';
        }
        field(9; City; Text[30])
        {
            Caption = 'City';
        }
        field(11; "Post Code"; Text[100])
        {
            Caption = 'Post Code';
        }
        field(12; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
        }
        field(13; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
        }
        field(14; Email; Text[100])
        {
            Caption = 'Email';
            DataClassification = CustomerContent;
        }
        field(15; "Contact Person"; Text[100])
        {
            Caption = 'Contact Person';
        }
        field(16; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';
        }

    }

    keys
    {
        key(Key1; "Renter No.")
        {
            Clustered = true;
        }
        key(Key2; "Renter Name")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Renter No.", "Renter Name")
        {
        }
    }
}