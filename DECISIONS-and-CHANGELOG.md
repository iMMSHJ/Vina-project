# Data Model Revision — Decisions and Change Log

## Final Decisions

- Ticket Wizard: fully custom shared wizard.
- Ticket: `pps.ticket`.
- Contract: OCA `contract.contract` preferred, with custom coverage lines; compatible custom fallback permitted.
- Contract-to-Asset relation: independent `pps.service.contract.asset.line`.
- Service Level: one initial `pps.service.level` model; later decomposition is deferred.
- One Contract may cover Assets at multiple Sites.
- Each Asset displays its own active Site/address.
- Site: `pps.site` linked to `res.partner` address.
- Contact-to-Site: explicit access model with role and validity.
- Ownership and Site Assignment: independent history models.
- Archived technical history: Service Manager and higher roles only.
- Previous customer: own historical Tickets plus own financial records.
- Deletion: real deletion only for Super Admin; otherwise archive/state transition.
- Brand and Model: independent controlled entities.
- Serial Number: globally unique.
- Custom prefix: `pps.`.
- Scope: four rewritten documents plus this canonical model and this decision log.
- Delivery: ZIP archive.

## Changes Applied

- Removed Service Package from all domain relationships and mappings.
- Replaced conflicting Ticket mappings with `pps.ticket`.
- Replaced Child Address-only Site mapping with `pps.site` plus address partner.
- Unified SLA/Policy terminology under `pps.service.level`.
- Added ownership, site assignment, and contract asset line models.
- Documented period-based visibility and ownership-transfer termination.
- Documented financial-review tagging and Service Manager decision timing.
- Removed obsolete version metadata from the canonical business document; this package uses Git history for evolution.
