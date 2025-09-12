table 50108 "Service Card Lines"
{
    DataClassification = CustomerContent;
    Caption = 'Service Lines';

    fields
    {
        field(1; "Service No."; Code[20])
        {
            Caption = 'Service No.';
        }
        field(2; Status; Enum "Service Status")
        {
            Caption = 'Status';
        }
        field(5; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(10; Type; Option)
        {
            Caption = 'Type';
            OptionMembers = ,CarPart,Wage;
            OptionCaption = ',Car Part,Wage';
            trigger OnValidate()
            begin
                if Rec.Type = Rec.Type::Wage then begin
                    Rec."Car Part" := '';
                    Rec.Manufacturer := '';
                    Rec."Order Necessary" := Rec."Order Necessary"::No;
                    Rec."Order Date" := 0D;
                    Rec."Delivery Date" := 0D;
                    Rec.Cost := 0;
                end;
            end;
        }
        field(15; "Car Part"; Text[100])
        {
            Caption = 'Car Part';
        }
        field(20; Manufacturer; Text[100])
        {
            Caption = 'Manufacturer';
        }
        field(25; "Order Necessary"; Option)
        {
            Caption = 'Order Necessary';
            OptionMembers = ,Yes,No;
            OptionCaption = ',Yes,No';
            trigger OnValidate()
            var
                ServiceList: Record "Service";
            begin
                if Rec."Order Necessary" = Rec."Order Necessary"::No then begin
                    Rec."Order Date" := 0D;
                    Rec."Delivery Date" := 0D;
                    Rec.Cost := 0;
                end;
            end;
        }
        field(30; "Order Date"; Date)
        {
            Caption = 'Order Date';
            trigger OnValidate()
            begin
                ConfigureOrderDateAndErrorWarning(Rec."Order Date", Rec."Delivery Date");
            end;
        }
        field(35; "Delivery Date"; Date)
        {
            Caption = 'Delivery Date';
            trigger OnValidate()
            begin
                ConfigureOrderDateAndErrorWarning(Rec."Order Date", Rec."Delivery Date");
            end;
        }
        field(40; Quantity; Integer)
        {
            Caption = 'Quantity';
            MinValue = 0;
        }
        field(45; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
        }
        field(50; Cost; Decimal)
        {
            Caption = 'Cost';
            MinValue = 0;
        }
    }
    keys
    {
        key(PK; "Service No.", "Line No.")
        {
            Clustered = true;
        }
    }

    procedure ConfigureOrderDateAndErrorWarning(OrderDate: Date; DeliveryDate: Date)
    var
        Service: Record "Service";
    begin
        if OrderDate = 0D then
            OrderDate := DeliveryDate;
        if DeliveryDate = 0D then
            DeliveryDate := OrderDate;
        if OrderDate > DeliveryDate then
            Error(Text001Err, OrderDate, DeliveryDate);
        if (OrderDate < Today) or (DeliveryDate < Today) then
            Error(Text002Err);

        Service.SetRange("Service No.", Rec."Service No.");
        if Service.FindSet() then
            repeat
                if (OrderDate < Service."From Date") then
                    Error(Text003Err, OrderDate, Service."From Date");
                if (DeliveryDate < Service."To Date") then
                    Error(Text004Err, DeliveryDate, Service."From Date");
            until Service.Next() = 0;
    end;

    var
        Text001Err: Label 'The Order Date %1 must not be behind Delivery Date %2.';
        Text002Err: Label 'You cannot choose an earlier date. Please choose another date!';
        Text003Err: Label 'The Order Date %1 must not be behind From Date %2.';
        Text004Err: Label 'The Delivery Date %1 must not be behind To Date %2.';
}