page 50114 "Closed Rental Card"
{
    ApplicationArea = All;
    Caption = 'Closed Rental';
    PageType = Card;
    SourceTable = "Closed Rental";
    Editable = false;

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
                    StyleExpr = PageStyle;
                }
                field(Canceled; Rec.Canceled)
                {
                    ApplicationArea = All;
                    Style = Unfavorable;
                }
                field("Renter No."; Rec."Renter No.")
                {
                    ApplicationArea = All;
                }
                field("Renter Name"; Rec."Renter Name")
                {
                    ApplicationArea = All;
                }
                field("Address"; Rec."Address")
                {
                    ApplicationArea = All;
                }
                field("City"; Rec."City")
                {
                    ApplicationArea = All;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = All;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = All;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                }
            }
            group(InvoiceDetails)
            {
                Caption = 'Invoice Details';

                field(BillRequired; Rec."BillRequired")
                {
                    ApplicationArea = All;
                }
                field("Bill-to Data"; Rec."Bill-to Same Data")
                {
                    ApplicationArea = All;
                }
                field("Bill-to Name"; Rec."Bill-to Name")
                {
                    ApplicationArea = All;
                }
                field("Bill-to Address"; Rec."Bill-to Address")
                {
                    ApplicationArea = All;
                }
                field("Bill-to City"; Rec."Bill-to City")
                {
                    ApplicationArea = All;
                }
                field("Bill-to Post Code"; Rec."Bill-to Post Code")
                {
                    ApplicationArea = All;
                }
                field("Bill-to Country/Region Code"; Rec."Bill-to Country/Region Code")
                {
                    ApplicationArea = All;
                }
            }
            group(CarRental)
            {
                Caption = 'Car Rental';

                field("Car No."; Rec."Car No.")
                {
                    ApplicationArea = All;
                }
                field("Car Brand"; Rec."Car Brand")
                {
                    ApplicationArea = All;
                }
                field("Car Model"; Rec."Car Model")
                {
                    ApplicationArea = All;
                }
                field("Registration No."; Rec."Registration No.")
                {
                    ApplicationArea = All;
                }
                field("From Date"; Rec."From Date")
                {
                    ApplicationArea = All;
                }
                field("To Date"; Rec."To Date")
                {
                    ApplicationArea = All;
                }
                field("Rental Day(s)"; Rec."Rental Day(s)")
                {
                    ApplicationArea = All;
                }
                field("Car Insurance"; Rec."Car Insurance")
                {
                    ApplicationArea = All;
                }
                field("Car Insurance Types"; Rec."Car Insurance Types")
                {
                    ApplicationArea = All;
                }
                field("Car Insurance Cost"; Rec."Car Insurance Cost")
                {
                    ApplicationArea = All;
                    Style = Strong;
                }
                field("Rental Day(s) Cost"; Rec."Rental Day(s) Cost")
                {
                    ApplicationArea = All;
                    Style = Strong;
                }
                field("Starting Km"; Rec."Starting Mileage")
                {
                    ApplicationArea = All;
                }
                field("Ending Km"; Rec."Ending Mileage")
                {
                    ApplicationArea = All;
                }
                field("Mileage Cost"; Rec."Mileage Cost")
                {
                    ApplicationArea = All;
                    Style = Strong;
                }
                field("Total Cost"; Rec."Total Cost")
                {
                    ApplicationArea = All;
                    Style = StrongAccent;
                }
            }
            group(CarDamage)
            {
                Caption = 'Car Damages';

                group(PreviousDamages)
                {
                    Caption = 'Previous Damages';

                    field("Previous Damages"; Rec."Previous Damages")
                    {
                        ApplicationArea = All;
                    }
                    field("Prev Damage Details"; Rec."Prev Damage Details")
                    {
                        ApplicationArea = All;
                    }
                    field("Prev Damage Picture 1"; Rec."Prev Damage Picture 1")
                    {
                        ApplicationArea = All;
                    }
                    field("Prev Damage Picture 2"; Rec."Prev Damage Picture 2")
                    {
                        ApplicationArea = All;
                    }
                }
                group(NewDamages)
                {
                    Caption = 'New Damages';

                    field("New Damages"; Rec."New Damages")
                    {
                        ApplicationArea = All;
                    }
                    field("New Damage Details"; Rec."New Damage Details")
                    {
                        ApplicationArea = All;
                    }
                    field("New Damage Picture 1"; Rec."New Damage Picture 1")
                    {
                        ApplicationArea = All;
                    }
                    field("New Damage Picture 2"; Rec."New Damage Picture 2")
                    {
                        ApplicationArea = All;
                    }
                }
            }
            group(Service)
            {
                Caption = 'Service';

                field("Service From Date"; Rec."Service From Date")
                {
                    ApplicationArea = All;
                }
                field("Service To Date"; Rec."Service To Date")
                {
                    ApplicationArea = All;
                }
                field("Service Status"; Rec."Service Status")
                {
                    ApplicationArea = All;
                }
                field("Repair Costs"; Rec."Repair Costs")
                {
                    ApplicationArea = All;
                    Style = Strong;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(BillToRenterWord)
            {
                Caption = 'Rental Invoice';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Download;

                trigger OnAction()
                var
                    ClosedRental: Record "Closed Rental";
                    RentalInvoiceLayout: Report "Rental Invoice - Word";
                    RentalInvoiceOtherDataLayout: Report "Rental Invoice Other Data-Word";
                begin
                    ClosedRental.SetRange("No.", Rec."No.");
                    ClosedRental.SetRange("Renter No.", Rec."Renter No.");

                    if Rec."BillRequired" and not Rec."Bill-to Same Data" then begin
                        RentalInvoiceOtherDataLayout.SetTableView(ClosedRental);
                        RentalInvoiceOtherDataLayout.Run()
                    end else begin
                        RentalInvoiceLayout.SetTableView(ClosedRental);
                        RentalInvoiceLayout.Run();
                    end;
                end;
            }

            action(CancelAndReopen)
            {
                Caption = 'Cancel and Reopen';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Undo;
                Enabled = not Rec.Canceled; // Csak akkor futhat, ha nincs még sztornózva

                trigger OnAction()
                var
                    NewActiveRental: Record "Rental";
                begin
                    if StrPos(Rec."No.", '-REV') > 0 then
                        Error(Text001Err, Rec."No.");

                    if Rec.Canceled then
                        Error(Text002Err);

                    if Confirm('Are you sure you want to cancel this closed rental and create a correctable draft?', true) then begin
                        NewActiveRental := Rec.PerformRentalCancelAndReopen(Rec);

                        Commit(); // Kényszerítjük az SQL mentést a háttérben

                        // Felugró ablak nélkül megnyitjuk az új, szerkeszthető aktív kártyát
                        Page.Run(Page::"Rental Card", NewActiveRental);
                        CurrPage.Update(false);
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if Rec.Canceled then
            PageStyle := 'Subordinate'
        else
            PageStyle := 'Standard';
    end;

    var
        PageStyle: Text;
        Text001Err: Label 'This contract (%1) is already a corrected version. You cannot modify a corrected contract again!';
        Text002Err: Label 'This rental has already been canceled!';
}