# Car Rental & Fleet Management System (RentCar GmbH)

A comprehensive ERP extension for Microsoft Dynamics 365 Business Central (AL), covering the entire business lifecycle of a car rental company—from fleet and customer management to integrated workshop repairs, automated monthly commission settlements, role-based dashboards, and REST API integration.

## Key Features

- **Fleet & Rental Management:** Vehicle master data and individual car tracking, tiered daily pricing based on rental duration, customer type validation (private vs. corporate rental limits), automatic booking conflict detection, archiving of closed rentals, and full reversal/cancellation handling (`-REV`).
- **Workshop & Service Module:** Dedicated service orders tracking spare parts and mechanic labor, automatic transfer of repair costs to the corresponding rental contract, and unified company invoicing.
- **Monthly Settlement & Commission Calculation:** Automated monthly calculation of total rental revenue, service costs, and net profit; role-based commission calculation (`Dispatcher`, `Service Advisor`, `Mechanic`) with period closing (`Open` -> `Closed`) and deletion protection.
- **Reporting, Dashboard & Security:** Custom Microsoft Word layouts (`.docx`) for rental invoices, service invoices, and monthly settlement reports; custom `Role Center` with live `FlowField` Cue tiles and quick creation actions; granular role-based `PermissionSets` (`Admin`, `Dispatcher`, `Mechanic`); and a `REST API v2.0` endpoint for querying available vehicles.

## Technologies & Architecture

- **Platform:** Microsoft Dynamics 365 Business Central
- **Language:** AL Language
- **Key Concepts:** Custom Tables & Pages, Table/Page Extensions, FlowFields & CalcFields, Codeunits & Business Logic, Word Report Layouts, Role Center & Cues, Permission Sets, REST API (`PageType = API`), Multi-language Support via XLIFF (`EN` / `DE`).

---

\_Related Project: [Desk Reservation System (IHK Umschulung Project)](https://github.com/bognarit/desk_reservation_project)
