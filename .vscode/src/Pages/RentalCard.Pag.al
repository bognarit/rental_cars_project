page 50103 "Rental Card"
{
    ApplicationArea = All;
    Caption = 'Rental';
    PageType = Card;
    SourceTable = "Rental";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Editable = false;
                }
                field("Rental Status"; Rec."Rental Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Renter No."; Rec."Renter No.")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Editable = (Rec."Rental Status" = Rec."Rental Status"::Open);
                }
                field("Renter Name"; Rec."Renter Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Address"; Rec."Address")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("City"; Rec."City")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            group(InvoiceDetails)
            {
                Caption = 'Invoice Details';

                field(BillRequired; Rec."BillRequired")
                {
                    ApplicationArea = All;
                    Editable = (Rec."Rental Status" = Rec."Rental Status"::Open) or (Rec."Rental Status" = Rec."Rental Status"::Released);
                }
                field("Bill-to Data"; Rec."Bill-to Same Data")
                {
                    ApplicationArea = All;
                    Editable = Rec.BillRequired;
                }
                field("Bill-to Name"; Rec."Bill-to Name")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    Editable = Rec.BillRequired and Rec."Bill-to Same Data" = false;
                }
                field("Bill-to Address"; Rec."Bill-to Address")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    Editable = Rec.BillRequired and Rec."Bill-to Same Data" = false;
                }
                field("Bill-to City"; Rec."Bill-to City")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    Editable = Rec.BillRequired and Rec."Bill-to Same Data" = false;
                }
                field("Bill-to Post Code"; Rec."Bill-to Post Code")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    Editable = Rec.BillRequired and Rec."Bill-to Same Data" = false;
                }
                field("Bill-to Country/Region Code"; Rec."Bill-to Country/Region Code")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    Editable = Rec.BillRequired and Rec."Bill-to Same Data" = false;
                }
            }
            group(CarRental)
            {
                Caption = 'Car Rental';

                field("Car No."; Rec."Car No.")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Editable = (Rec."Rental Status" = Rec."Rental Status"::Open);
                }
                field("Car Brand"; Rec."Car Brand")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Car Model"; Rec."Car Model")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Registration No."; Rec."Registration No.")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Editable = (Rec."Rental Status" = Rec."Rental Status"::Open);
                }
                field("From Date"; Rec."From Date")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Editable = (Rec."Rental Status" = Rec."Rental Status"::Open);
                }
                field("To Date"; Rec."To Date")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Editable = (Rec."Rental Status" = Rec."Rental Status"::Open) or (Rec."Rental Status" = Rec."Rental Status"::Released);
                }
                field("Rental Day(s)"; Rec."Rental Day(s)")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Editable = false;
                }
                field("Car Insurance"; Rec."Car Insurance")
                {
                    ApplicationArea = All;
                    Editable = (Rec."Rental Status" = Rec."Rental Status"::Open);
                }
                field("Car Insurance Types"; Rec."Car Insurance Types")
                {
                    ApplicationArea = All;
                    Editable = (Rec."Rental Status" = Rec."Rental Status"::Open);
                }
                field("Car Insurance Cost"; Rec."Car Insurance Cost")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Style = Strong;
                }
                field("Rental Day(s) Cost"; Rec."Rental Day(s) Cost")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Style = Strong;
                }
                field("Starting Km"; Rec."Starting Mileage")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Ending Km"; Rec."Ending Mileage")
                {
                    ApplicationArea = All;
                    Editable = (Rec."Rental Status" = Rec."Rental Status"::Open) or (Rec."Rental Status" = Rec."Rental Status"::Released);
                    ShowMandatory = true;
                }
                field("Mileage Cost"; Rec."Mileage Cost")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Style = Strong;
                }
                field("Total Cost"; Rec."Total Cost")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Style = StrongAccent;
                }
            }
            group(CarDamage)
            {
                Caption = 'Car Damages';

                group(PreviousDamages)
                {
                    Caption = 'Previous Damages';
                    Editable = (Rec."Rental Status" = Rec."Rental Status"::Open);

                    field("Previous Damages"; Rec."Previous Damages")
                    {
                        ApplicationArea = All;
                    }
                    field("Prev Damage Details"; Rec."Prev Damage Details")
                    {
                        ApplicationArea = All;
                        Editable = Rec."Previous Damages";
                    }
                    field("Prev Damage Picture 1"; Rec."Prev Damage Picture 1")
                    {
                        ApplicationArea = All;
                        Editable = Rec."Previous Damages";
                    }
                    field("Prev Damage Picture 2"; Rec."Prev Damage Picture 2")
                    {
                        ApplicationArea = All;
                        Editable = Rec."Previous Damages";
                    }
                }
                group(NewDamages)
                {
                    Caption = 'New Damages';
                    Editable = (Rec."Rental Status" = Rec."Rental Status"::Open) or (Rec."Rental Status" = Rec."Rental Status"::Released);

                    field("New Damages"; Rec."New Damages")
                    {
                        ApplicationArea = All;
                    }
                    field("New Damage Details"; Rec."New Damage Details")
                    {
                        ApplicationArea = All;
                        Editable = Rec."New Damages";
                    }
                    field("New Damage Picture 1"; Rec."New Damage Picture 1")
                    {
                        ApplicationArea = All;
                        Editable = Rec."New Damages";
                    }
                    field("New Damage Picture 2"; Rec."New Damage Picture 2")
                    {
                        ApplicationArea = All;
                        Editable = Rec."New Damages";
                    }
                }
            }
            group(Service)
            {
                Caption = 'Service';

                field("Service From Date"; Rec."Service From Date")
                {
                    ApplicationArea = All;
                    Editable = Rec."New Damages" and (Rec."Rental Status" = Rec."Rental Status"::Returned);
                }
                field("Service To Date"; Rec."Service To Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Service Status"; Rec."Service Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Repair Costs"; Rec."Repair Costs")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Style = Strong;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(CloseRental)
            {
                Caption = 'Close Rental';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Close;
                Enabled = (Rec."Rental Status" = Rec."Rental Status"::Returned);

                trigger OnAction()
                begin
                    ProcessRentalClosure();
                end;
            }
            action(ReleaseRental)
            {
                Caption = 'Release Car';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = ReleaseDoc;
                Enabled = (Rec."Rental Status" = Rec."Rental Status"::Open);

                trigger OnAction()
                begin
                    if Confirm('Are you sure you want to release the car? This will lock the renter details and departure date.', true) then begin
                        Rec."Rental Status" := Rec."Rental Status"::Released;
                        Rec.Modify(true);
                        CurrPage.Update(false);
                    end;
                end;
            }
            action(ReturnRental)
            {
                Caption = 'Return Car';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = ReturnOrder;
                Enabled = (Rec."Rental Status" = Rec."Rental Status"::Released);

                trigger OnAction()
                begin
                    CurrPage.SaveRecord();

                    if Rec."Ending Mileage" = 0 then
                        Error(Text005Err);

                    if Confirm('Are you sure the car has been returned? This will lock the return date.', true) then begin
                        Rec."Rental Status" := Rec."Rental Status"::Returned;
                        Rec.Modify(true);
                        CurrPage.Update(false);
                    end;
                end;
            }
            action(SendToService)
            {
                Caption = 'Send to Service';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = ServiceSetup;
                Enabled = (Rec."Rental Status" = Rec."Rental Status"::Returned) and Rec."New Damages";

                trigger OnAction()
                begin
                    SendTheCarToTheService()
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        NoSeries: Codeunit "No. Series";
        RentSetup: Record "Rent Setup";
    begin
        RentSetup.Get();
        RentSetup.TestField("Rental List No. Series");
        if Rec."No." <> '' then begin
            NoSeries.TestManual(RentSetup."Rental List No. Series")
        end else begin
            Rec."No." := NoSeries.GetNextNo(RentSetup."Rental List No. Series", WorkDate(), false);
        end;
    end;

    local procedure ProcessRentalClosure()
    var
        ClosedRental: Record "Closed Rental";
    begin
        if Rec."New Damages" and (Rec."Service Status" = Rec."Service Status"::" ") then
            Error(Text004Err)
        else if Rec."New Damages" and (Rec."Service Status" = Rec."Service Status"::Service) then
            Error(Text001Err)
        else if Confirm(StrSubstNo(Text001, Rec."No.")) then begin
            ClosedRental.Init();
            ClosedRental.TransferFields(Rec);
            ClosedRental.Insert();
            Rec.Delete();
        end;
    end;

    local procedure SendTheCarToTheService()
    var
        ServiceList: Record "Service";
        RentSetup: Record "Rent Setup";
        NoSeries: Codeunit "No. Series";
    begin
        if (Rec."Service From Date" <> 0D) and (Rec."New Damage Details" <> '') and (Rec."Service Status" = Rec."Service Status"::" ") then begin
            Rec."Service Status" := Rec."Service Status"::Service;
            ServiceList.Init();

            // Get New Service No.
            RentSetup.Get();
            RentSetup.TestField("Service Data No. Series");
            if ServiceList."Service No." <> '' then begin
                NoSeries.TestManual(RentSetup."Service Data No. Series")
            end else begin
                ServiceList."Service No." := NoSeries.GetNextNo(RentSetup."Service Data No. Series", WorkDate(), false);
            end;

            // Add Necessary Data
            ServiceList."Rental No." := Rec."No.";
            ServiceList."Car No." := Rec."Car No.";
            ServiceList."Car Brand" := Rec."Car Brand";
            ServiceList."Car Model" := Rec."Car Model";
            ServiceList."Registration No." := Rec."Registration No.";
            ServiceList."From Date" := Rec."Service From Date";
            ServiceList.Status := ServiceList.Status::Service;
            ServiceList.Details := Rec."New Damage Details";
            ServiceList.Insert();
            Message(Text004);
        end else if Rec."Service Status" = Rec."Service Status"::Service then
                Error(Text001Err)
        else if Rec."Service Status" = Rec."Service Status"::Repaired then
            Error(Text002Err)
        else
            Error(Text003Err);
    end;

    var
        Text001: Label 'Are you sure to close the %1 rental?';
        Text002: Label 'Dear %1, %2 %3 was successfully booked you from %4 to %5. Kind Regards RentCar GmbH';
        Text003: Label 'Rental notification was sent the renter by email.';
        Text004: Label 'The car was sent to the service.';
        Text001Err: Label 'The car currently is being serviced.';
        Text002Err: Label 'The car has been repaired.';
        Text003Err: Label 'Please fill in the Service ''New Damage Details'' and ''From Date'' fields!';
        Text004Err: Label 'The car wasn''t sent to the service.';
        Text005Err: Label 'The Ending Mileage cannot be 0 when returning the car. Please enter the current mileage!';
}