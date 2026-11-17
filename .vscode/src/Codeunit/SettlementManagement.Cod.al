codeunit 50105 "Settlement Management"
{
    procedure CalculateMonthlySettlement(var Settlement: Record "Monthly Settlement")
    var
        Service: Record Service;
        ServiceLines: Record "Service Card Lines";
        SettlementLines: Record "Monthly Settlement Line";
        Employee: Record Employee;
        ClosedRental: Record "Closed Rental";
        LineNo: Integer;
    begin
        if Settlement.Status = Settlement.Status::Closed then
            Error(Text001Err);

        Settlement.TestField("Starting Date");
        Settlement.TestField("Ending Date");

        // 1. Korábbi sorok törlése
        SettlementLines.SetRange("Settlement No.", Settlement."Settlement No.");
        SettlementLines.DeleteAll();

        // 2. Összes bérleti bevétel kiszámítása
        ClosedRental.SetRange("Rental Status", ClosedRental."Rental Status"::Returned);
        ClosedRental.SetRange("To Date", Settlement."Starting Date", Settlement."Ending Date");
        ClosedRental.SetRange(Canceled, false);
        ClosedRental.CalcSums("Total Cost");

        // 3. Összes szervizköltség kiszámítása (FlowField miatt ciklussal)
        TotalServiceCosts := 0;
        Service.SetRange(Status, Service.Status::Repaired);
        Service.SetRange("To Date", Settlement."Starting Date", Settlement."Ending Date");
        Service.SetRange(Canceled, false);
        if Service.FindSet() then
            repeat
                Service.CalcFields("Service Costs");
                TotalServiceCosts += Service."Service Costs";
            until Service.Next() = 0;

        // 4. Fejléc mentése
        Settlement."Total Rental Revenue" := ClosedRental."Total Cost";
        Settlement."Total Service Costs" := TotalServiceCosts;
        Settlement."Net Profit" := Settlement."Total Rental Revenue" - Settlement."Total Service Costs";
        Settlement.Modify(true);

        // 5. Munkatársak jutalékainak kiszámítása
        Employee.SetRange("Active in Rental", true);
        if Employee.FindSet() then
            repeat
                SettlementLines.Init();
                LineNo += 10000;
                SettlementLines."Settlement No." := Settlement."Settlement No.";
                SettlementLines."Line No." := LineNo;
                SettlementLines."Employee No." := Employee."No.";
                SettlementLines."Employee Name" := Employee.FullName();
                SettlementLines."Rent Role" := Employee."Rent Role";
                SettlementLines."Commission %" := Employee."Commission %";

                if Employee."Rent Role" = Employee."Rent Role"::Dispatcher then begin
                    ClosedRental.Reset();
                    ClosedRental.SetRange("Rental Status", ClosedRental."Rental Status"::Returned);
                    ClosedRental.SetRange("To Date", Settlement."Starting Date", Settlement."Ending Date");
                    ClosedRental.SetRange(Canceled, false);
                    ClosedRental.SetRange("Dispatcher No.", Employee."No.");
                    ClosedRental.CalcSums("Total Cost");

                    SettlementLines."Completed Count" := ClosedRental.Count();
                    SettlementLines."Generated Amount" := ClosedRental."Total Cost";

                end else if Employee."Rent Role" = Employee."Rent Role"::"Service Advisor" then begin
                    AdvisorAmount := 0;
                    Service.Reset();
                    Service.SetRange(Status, Service.Status::Repaired);
                    Service.SetRange("To Date", Settlement."Starting Date", Settlement."Ending Date");
                    Service.SetRange(Canceled, false);
                    Service.SetRange("Responsible Employee No.", Employee."No.");
                    if Service.FindSet() then
                        repeat
                            Service.CalcFields("Service Costs");
                            AdvisorAmount += Service."Service Costs";
                        until Service.Next() = 0;

                    SettlementLines."Completed Count" := Service.Count();
                    SettlementLines."Generated Amount" := AdvisorAmount;

                end else if Employee."Rent Role" = Employee."Rent Role"::Mechanic then begin
                    MechanicAmount := 0;
                    MechanicCount := 0;

                    ServiceLines.Reset();
                    ServiceLines.SetRange("Mechanic No.", Employee."No.");
                    if ServiceLines.FindSet() then
                        repeat
                            Service.Reset();
                            Service.SetRange("Service No.", ServiceLines."Service No.");
                            Service.SetRange(Status, Service.Status::Repaired);
                            Service.SetRange(Canceled, false);
                            Service.SetRange("To Date", Settlement."Starting Date", Settlement."Ending Date");
                            if Service.FindFirst() then begin
                                MechanicAmount += ServiceLines.Cost;
                                MechanicCount += 1;
                            end;
                        until ServiceLines.Next() = 0;

                    SettlementLines."Completed Count" := MechanicCount;
                    SettlementLines."Generated Amount" := MechanicAmount;
                end;

                SettlementLines."Commission Amount" := Round(SettlementLines."Generated Amount" * Employee."Commission %" / 100, 0.01);
                SettlementLines.Insert(true);
            until Employee.Next() = 0;
    end;

    procedure CloseMonthlySettlement(var Settlement: Record "Monthly Settlement")
    var
        MonthlySettlLines: Record "Monthly Settlement Line";
    begin
        if Settlement.Status = Settlement.Status::Closed then
            Error(Text001Err);

        Settlement.Status := Settlement.Status::Closed;
        Settlement.Modify(true);
    end;

    var
        AdvisorAmount: Decimal;
        MechanicAmount: Decimal;
        MechanicCount: Integer;
        TotalServiceCosts: Decimal;
        Text001Err: Label 'This monthly settlement is already closed and cannot be modified.';
}