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