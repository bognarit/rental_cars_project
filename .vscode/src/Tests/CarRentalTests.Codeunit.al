codeunit 50106 "Car Rental Tests"
{
    Subtype = Test;

    [Test]
    procedure TestTieredRentalPricing()
    var
        Rental: Record Rental;
    begin
        // Given: 3 napos bérlés előkészítése
        Rental.Init();
        Rental."From Date" := WorkDate();
        Rental.Validate("To Date", CalcDate('<+2D>', WorkDate()));

        // Then: 3 napra (2..7 sáv = 60 EUR/nap) 180 EUR-nak kell lennie
        if Rental."Rental Day(s) Cost" <> 180 then
            Error('Expected 180 EUR for 3 days, but got %1.', Rental."Rental Day(s) Cost");
    end;

    [Test]
    procedure TestCannotRecalculateClosedSettlement()
    var
        Settlement: Record "Monthly Settlement";
        SettlementMgt: Codeunit "Settlement Management";
    begin
        // Given: Már lezárt havi elszámolás előkészítése
        Settlement.Init();
        Settlement."Settlement No." := 'TEST-2026-11';
        Settlement."Starting Date" := 20261101D;
        Settlement."Ending Date" := 20261130D;
        Settlement.Status := Settlement.Status::Closed;

        // When: Újraszámítás megkísérlése lezárt állapotban
        asserterror SettlementMgt.CalculateMonthlySettlement(Settlement);

        // Then: Ellenőrizzük, hogy valóban a lezárás miatti hibaüzenet jött-e
        if StrPos(LowerCase(GetLastErrorText()), 'closed') = 0 then
            Error('Expected closed error, but got: %1', GetLastErrorText());
    end;
}