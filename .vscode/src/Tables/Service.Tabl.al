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
                ConfigureServiceDaysAndErrorWarning();
            end;
        }
        field(35; "To Date"; Date)
        {
            Caption = 'To Date';
            trigger OnValidate()
            var
                ServiceDataLines: Record "Service Card Lines";
            begin
                ConfigureServiceDaysAndErrorWarning();

                ServiceDataLines.SetRange("Service No.", Rec."Service No.");
                if ServiceDataLines.FindSet() then
                    repeat
                        if (ServiceDataLines."Order Necessary" = ServiceDataLines."Order Necessary"::Yes) and ((ServiceDataLines."Order Date" = 0D) or (ServiceDataLines."Delivery Date" = 0D)) then
                            Error(Text001Err);
                        if ServiceDataLines."Delivery Date" > Rec."To Date" then
                            Error(Text002Err, ServiceDataLines."Delivery Date", Rec."To Date");
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
        field(55; Canceled; Boolean)
        {
            Caption = 'Canceled';
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Service No.", "Rental No.")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    var
        ServiceLines: Record "Service Card Lines";
    begin
        ServiceLines.SetRange("Service No.", Rec."Service No.");

        if not ServiceLines.IsEmpty() then
            ServiceLines.DeleteAll(true);
    end;

    procedure ConfigureServiceDaysAndErrorWarning()
    begin
        if Rec."From Date" = 0D then
            Rec."From Date" := Rec."To Date";
        if Rec."To Date" = 0D then
            Rec."To Date" := Rec."From Date";

        if (Rec."From Date" = 0D) or (Rec."To Date" = 0D) then
            exit;

        if Rec."From Date" > Rec."To Date" then
            Error(Text003Err, Rec."From Date", Rec."To Date");

        if StrPos(Rec."Service No.", '-SER') = 0 then begin
            if (Rec."From Date" < Today) or (Rec."To Date" < Today) then
                Error(Text004Err);
        end;
    end;

    var
        Text001Err: Label 'Please choose ''Order Date'' and ''Delivery Date'' in the Service Data Lines first!';
        Text002Err: Label 'The Delivery Date %1 must not be behind To Date %2.';
        Text003Err: Label 'The From Date %1 must not be behind To Date %2.';
        Text004Err: Label 'You cannot choose an earlier date. Please choose another date!';
}