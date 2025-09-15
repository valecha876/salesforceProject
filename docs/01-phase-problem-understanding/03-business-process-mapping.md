# Phase 1: Business Process Mapping

## Current State (As-Is Process)

**Process:** Manual Carbon Accounting and Reporting
**Goal:** To produce an annual sustainability report.

1.  **Data Collection (Fragmented):**
    *   Email requests sent to various department heads (Facilities, Travel, HR).
    *   Data arrives in inconsistent formats: PDF bills, Excel spreadsheets, handwritten logs.
2.  **Data Consolidation:**
    *   Sustainability team spends weeks aggregating data into a single, massive master spreadsheet.
    *   High risk of version control issues and human error during data entry.
3.  **Manual Calculation:**
    *   Team applies emission factors from external sources to the activity data using complex spreadsheet formulas.
    *   Process is fragile; a single formula error can invalidate entire datasets.
    *   Audit trail is nearly impossible to maintain.
4.  **Report Generation:**
    *   Charts and graphs are manually created from spreadsheet results.
    *   Report is compiled in a PowerPoint or Word document.
5.  **Distribution:**
    *   Final report is siloed in email inboxes and shared drives, completely disconnected from the customer and operational data in Salesforce.

**Pain Points:** Extremely time-consuming, prone to errors, not scalable, difficult to audit, data is stale and not actionable.

## Future State (To-Be Process)

**Process:** Automated Carbon Tracking in Salesforce
**Goal:** To provide real-time, actionable emissions insights.

1.  **Data Ingestion (Integrated):**
    *   **Manual Entry:** Users enter data directly into a custom Salesforce object through a tailored UI.
    *   **Bulk Import:** Data is imported into Salesforce using standard Data Loader tools.
    *   **API Integration (Future):** Systems automatically push data to Salesforce via APIs.
2.  **Automated Calculation:**
    *   Upon record save, an Apex Trigger (or Flow) automatically fetches the correct emission factor and calculates the CO2e.
    *   Results are stored in a related `Emission Result` object, creating a clean audit trail.
3.  **Centralized Data Storage:**
    *   All source data, factors, and results are stored as records within Salesforce.
    *   Emissions are linked to relevant Accounts, Facilities, or Projects, providing a 360-degree view.
4.  **Real-Time Reporting:**
    *   Pre-built, real-time dashboards and reports provide instant visibility into emissions performance.
    *   Reports can be filtered by scope, time period, and business unit with a single click.
5.  **Action and Integration:**
    *   Emissions data is available within the core CRM workflow.
    *   Sales can reference a client's sustainability partnership, leadership can monitor progress on goals, and investors can receive automated reports.

**Benefits:** Automated, accurate, auditable, scalable, integrated, and drives actionable business decisions.