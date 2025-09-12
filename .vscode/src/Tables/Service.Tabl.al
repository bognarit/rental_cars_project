table 50106 "Service"
{
    DataClassification = CustomerContent;
    Caption = 'Service';

    fields
    {
        field(1; "Service No."; Code[20])
        {
            Caption = 'Service No.';
        }
        field(5; "Rental No."; Code[20])
        {
            Caption = 'Rental No.';
            TableRelation = "Rental"."No.";
        }
        field(10; "Car No."; Code[20])
        {
            Caption = 'Car No.';
            TableRelation = "Car"."No.";
            ValidateTableRelation = false;
            trigger OnValidate()
            var
                CarList: Record "Car";
            begin
                if Rec."Car No." <> '' then begin
                    CarList.Get(Rec."Car No.");
                    Rec."Car Brand" := CarList."Brand";
                    Rec."Car Model" := CarList."Model";
                    Rec."Registration No." := '';
                end;
            end;
        }
        field(15; "Car Brand"; Text[50])
        {
            Caption = 'Car Brand';
        }
        field(20; "Car Model"; Text[50])
        {
            Caption = 'Car Model';
        }
        field(25; "Registration No."; Text[50])
        {
            Caption = 'Registration No.';
            TableRelation = "Car Card Lines"."Registration No." where("No." = field("Car No."));
        }
        field(30; "From Date"; Date)
        {
            Caption = 'From Date';
            trigger OnValidate()
            begin
                ConfigureRentalDaysAndErrorWarning(Rec."From Date", Rec."To Date");
            end;
        }
        field(35; "To Date"; Date)
        {
            Caption = 'To Date';
            trigger OnValidate()
            var
                ServiceDataLines: Record "Service Card Lines";
            begin
                ConfigureRentalDaysAndErrorWarning(Rec."From Date", Rec."To Date");

                ServiceDataLines.SetRange("Service No.", Rec."Service No.");
                if ServiceDataLines.FindSet() then
                    repeat
                        if (ServiceDataLines."Order Necessary" = ServiceDataLines."Order Necessary"::Yes) and ((ServiceDataLines."Order Date" = 0D) or (ServiceDataLines."Delivery Date" = 0D)) then
                            Error(Text003Err);
                        if ServiceDataLines."Delivery Date" > Rec."To Date" then
                            Error(Text004Err, ServiceDataLines."Delivery Date", Rec."To Date");
                    until ServiceDataLines.Next() = 0;
            end;
        }
        field(40; Status; Enum "Service Status")
        {
            Caption = 'Status';
        }
        field(45; Details; Text[50])
        {
            Caption = 'Details';
        }
        field(50; "Service Costs"; Decimal)
        {
            Caption = 'Service Costs';
            CalcFormula = Sum("Service Card Lines".Cost where("Service No." = field("Service No.")));
            FieldClass = FlowField;
        }
    }
    keys
    {
        key(PK; "Service No.", "Rental No.")
        {
            Clustered = true;
        }
    }

    procedure ConfigureRentalDaysAndErrorWarning(FromDate: Date; ToDate: Date)
    var
        ServiceDataLines: Record "Service Card Lines";
    begin
        if FromDate = 0D then
            FromDate := ToDate;
        if ToDate = 0D then
            ToDate := FromDate;
        if FromDate > ToDate then
            Error(Text001Err, FromDate, ToDate);
        if (FromDate < Today) or (ToDate < Today) then
            Error(Text002Err);
    end;

    var
        Text001Err: Label 'The From Date %1 must not be behind To Date %2.';
        Text002Err: Label 'You cannot choose an earlier date. Please choose another date!';
        Text003Err: Label 'Please choose ''Order Date'' and ''Delivery Date'' in the Service Data Lines first!';
        Text004Err: Label 'The Delivery Date %1 must not be behind To Date %2.';
}