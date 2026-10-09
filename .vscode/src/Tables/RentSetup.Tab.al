table 50104 "Rent Setup"
{
    DataClassification = CustomerContent;
    Caption = 'Rent Setup';
    DrillDownPageId = "Rent Setup";
    LookupPageId = "Rent Setup";

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key', Locked = true;
        }
        field(2; "Car List No. Series"; Code[20])
        {
            Caption = 'Car List No. Series';
            TableRelation = "No. Series";
        }
        field(3; "Rental List No. Series"; Code[20])
        {
            Caption = 'Rental List No. Series';
            TableRelation = "No. Series";
        }
        field(4; "Renter Data No. Series"; Code[20])
        {
            Caption = 'Renter Data No. Series';
            TableRelation = "No. Series";
        }
        field(5; "Service Data No. Series"; Code[20])
        {
            Caption = 'Service Data No. Series';
            TableRelation = "No. Series";
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