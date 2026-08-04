# DOC-054-CANONICAL — Canonical Data Model

**Status:** Approved  
**Canonical Reference:** DOC-001  
**Purpose:** Single source of truth for data-model decisions

## Canonical Entities

| Entity | Canonical model | Key responsibility |
|---|---|---|
| Customer / Contact | `res.partner` | Party and identity |
| Site | `pps.site` | Operational service location linked to address partner |
| Contact-Site Access | `pps.contact.site.access` | Role, scope, and validity |
| Asset | `pps.asset` | Device identity |
| Ownership History | `pps.asset.ownership.history` | Customer ownership periods |
| Site Assignment | `pps.asset.site.assignment` | Installation periods |
| Contract | OCA `contract.contract` + extension | Commercial agreement |
| Contract Asset Line | `pps.service.contract.asset.line` | Asset coverage and service level |
| Service Level | `pps.service.level` | Initial service commitment |
| Ticket | `pps.ticket` | Service request and workflow anchor |
| Service Report | `pps.service.report` | Execution outcome |

## Prohibited Canonical Entities

`Service Package`, `pps.service.package`, `pps.sla`, and `pps.service.policy` are not part of this model. They must not appear in migrations, API resources, workflows, or foreign keys.

## Invariants

1. Serial Number is globally unique.
2. An Asset has no more than one active ownership period.
3. An Asset has no more than one active site assignment.
4. An Asset has no more than one active contract asset line.
5. An Asset has no more than one active Service Level.
6. Active coverage periods cannot overlap.
7. Ownership transfer terminates prior coverage.
8. A Ticket may exist without coverage.
9. Restricted financial status results in lower service handling, a financial-review tag, and Service Manager decision.
10. Site address and Asset address are resolved from the Asset's active Site assignment; a Contract may cover multiple Sites.

## Access Matrix Summary

| Actor | Current records | Previous-period records | Archived technical history |
|---|---|---|---|
| Current customer/contact | Own permitted Site/Asset scope | No | No |
| Previous customer/contact | Own ownership-period Tickets and financial records | Yes, own period only | No |
| Service team | Assigned operational scope | Per internal rules | No |
| Service Manager | Full operational scope | Yes | Yes |
| Higher internal roles | According to elevated policy | Yes | Yes |

## Financial Decision

Ticket intake does not block registration. The Ticket receives the lower service level and a financial-review tag when required. Service Manager decides whether Finance is involved before service or after service. The final decision, actor, timestamp, and reason are audited.

## Naming and Implementation

Custom models use the `pps.` prefix. OCA Contract is preferred where compatible with Odoo Community 19; the custom fallback must preserve the same domain relationships and API contract. Brand and Model are independent controlled entities, with Model constrained to its Brand.

## Required Follow-Up Documents

- DOC-010 Ticket Wizard
- Field-level schema and constraints
- ERD
- Record Rules and ACL matrix
- API contract
- Ownership transfer and migration procedure
