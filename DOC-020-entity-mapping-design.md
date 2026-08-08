# DOC-020 — Entity Mapping Design

**Status:** Approved  
**Canonical Reference:** DOC-001 and DOC-054-CANONICAL  
**Scope:** Logical domain model and lifecycle rules

## 1. Objective

Define the canonical logical model for the after-sales service system on Odoo Community 19, with an independent Next.js frontend and API Gateway.

## 2. Core Model

```text
Customer
├── Contacts ── Contact-Site Access ── Sites
└── Assets
    ├── Ownership History
    ├── Site Assignment History
    └── Contract Asset Lines
                              └── Service Level

Ticket ── Asset (optional) ── applicable ownership/coverage period
       └── Service Reports ── Parts / Timesheets / Expenses
```

## 3. Customer, Contact, and Site

Customer and Contact use `res.partner`. One Contact may be associated with multiple Sites through `pps.contact.site.access`; each association carries role, permissions, validity dates, and active state. A Site is an operational domain entity (`pps.site`) linked to an address partner. A Customer may have multiple Sites, and a Site may have multiple Contacts.

A Head Office is an administrative/legal address and is not automatically a service Site.

## 4. Asset and History

`pps.asset` stores identity only. Ownership and placement are period-based records. A transfer closes the old ownership period and ends active contract coverage. Technical history is retained and period-labeled. The previous customer can view its own financial records and its own historical Tickets; the new customer manages only records in its period. Service Manager and higher roles can view complete archived technical history.

## 5. Contract and Coverage

A Contract belongs to a Customer and contains one or more `pps.service.contract.asset.line` records. A line identifies an Asset, its Site, validity period, and Service Level. One Contract may cover Assets at multiple Sites. Each Asset may have only one active line at a time. Coverage periods must not overlap. Ownership transfer terminates the prior active line and contract coverage for that Asset.

The preferred implementation is OCA `contract.contract` with a custom coverage-line extension. A compatible custom contract model is an implementation fallback.

## 6. Service Level

The canonical model is `pps.service.level`. It initially contains response time, remote support eligibility, on-site eligibility, priority behavior, and lower-service behavior. SLA and policy decomposition is intentionally deferred but the model and APIs must allow later extension.

## 7. Ticket

The canonical model is `pps.ticket`, created through the fully custom shared Ticket Wizard. A Ticket may be created by a portal customer or Guest flow. Wizard details and Guest account behavior are specified in DOC-010 and are only referenced here.

At intake, the system resolves the available asset, site, ownership period, coverage, and service level. An uncovered or financially restricted request is still registered, receives the lower service level, receives a financial-review tag, and stores the relevant customer financial rating. Service Manager makes the initial service decision and decides when Finance is involved.

## 8. Service Execution

Tasks, service reports, parts, inventory movements, timesheets, expenses, and accounting records are linked to the Ticket using native Odoo models where possible and custom service records where required. Technical and financial visibility is enforced independently.

## 9. Lifecycle and Deletion

Core states must be explicit and auditable. At minimum:

- Contract: Draft, Active, Suspended, Terminated, Archived
- Coverage Line: Planned, Active, Ended, Archived
- Ticket: New, Manager Review, Approved, In Service, Waiting, Resolved, Closed, Cancelled
- Asset: Active, Suspended, Retired, Archived

Real deletion is restricted to Super Admin. All normal user actions use archive or state transitions. Audit fields and chatter are mandatory for ownership transfer, coverage changes, service decisions, financial decisions, and access changes.

## 10. Access Control

Portal access is scoped by customer, ownership period, Contact-Site Access, and record type. Previous customers can access their own period's financial documents and Tickets, but not the new customer's records. Archived technical history is available only to Service Manager and higher internal roles. Attachments inherit the visibility of their parent record and must not be exposed through direct public URLs.

## 11. Design Principle

Odoo First, OCA First, Custom Last. The API Gateway is the only frontend integration boundary. No Package, `pps.service.package`, `pps.sla`, or `pps.service.policy` is part of the canonical model.
