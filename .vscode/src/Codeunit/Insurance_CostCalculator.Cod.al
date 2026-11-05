codeunit 50104 "Insurance & Cost Calculator"
{
    procedure CountTheRepairCosts(ServiceHeader: Record "Service"; var Rental: Record Rental)
    begin
        if Rental."Service Status" = Rental."Service Status"::Repaired then begin
            ServiceHeader.SetRange("Rental No.", Rental."No.");
            ServiceHeader.CalcFields("Service Costs");

            case Rental."Car Insurance Types" of
                Rental."Car Insurance Types"::" ":
                    Rental."Repair Costs" := ServiceHeader."Service Costs";
                Rental."Car Insurance Types"::TwentyFivePercent:
                    Rental."Repair Costs" := (ServiceHeader."Service Costs" * 75) / 100;
                Rental."Car Insurance Types"::FiftyPercent:
                    Rental."Repair Costs" := (ServiceHeader."Service Costs" * 50) / 100;
                Rental."Car Insurance Types"::HundredPercent:
                    Rental."Repair Costs" := 0;
            end;

            Rental."Total Cost" := Rental."Rental Day(s) Cost" + Rental."Mileage Cost" + Rental."Car Insurance Cost" + Rental."Repair Costs";
        end;
    end;

    procedure CalculateMileageAndRunCorrection(var Rental: Record "Rental"; xRental: Record "Rental")
    var
        CarCardLines: Record "Car Card Lines";
        Milage: Integer;
        MileageDifference: Integer;
        RentalMgt: Codeunit "Rental Management";
    begin
        // 1. Ha 0 a záró km, nullázzuk a kilométer-költséget
        if Rental."Ending Mileage" = 0 then begin
            Rental."Mileage Cost" := 0;
            exit;
        end;

        // 2. Kiszámoljuk a megtett kilométert a helyi változóba
        Milage := Rental."Ending Mileage" - Rental."Starting Mileage";

        // 3. Sávos árazás meghatározása
        case Milage of
            1 .. 500:
                Rental."Mileage Cost" := 40;
            501 .. 1000:
                Rental."Mileage Cost" := 50;
            1001 .. 2000:
                Rental."Mileage Cost" := 60;
            2001 .. 5000:
                Rental."Mileage Cost" := 70;
            else
                Rental."Mileage Cost" := 80;
        end;

        // 4. NORMÁL ESET: Ha ez egy sima bérlet (nincs benne a '-REV')
        if StrPos(Rental."No.", '-REV') = 0 then begin
            if CarCardLines.Get(Rental."Car No.", Rental."Registration No.") then begin
                CarCardLines."Mileage" := Rental."Ending Mileage";
                CarCardLines.Modify(true);
            end;
        end;

        // 5. REVIZIÓS ESET: Ha ez egy újranyitott módosítás
        if StrPos(Rental."No.", '-REV') > 0 then begin
            // Az xRec helyett az átadott xRental változót használjuk a múltbéli értékhez!
            MileageDifference := Rental."Ending Mileage" - xRental."Ending Mileage";

            if MileageDifference <> 0 then begin
                // Meghívjuk a meglévő UpdateSequenceMileages eljárásodat (mivel az a Rental táblában van, Rental.-al hívjuk)
                RentalMgt.UpdateSequenceMileages(Rental."Car No.", Rental."Registration No.", xRental."Ending Mileage", MileageDifference);
            end;
        end;
    end;
}