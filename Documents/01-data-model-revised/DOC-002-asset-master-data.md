# DOC-002 — Asset Master Data

**Status:** Approved  
**Canonical Reference:** DOC-001  
**Scope:** Asset identity and master data

## Purpose

An Asset is a customer-owned or customer-associated device that can receive service requests. Asset master data identifies the device; contractual coverage, ownership, site placement, service history, and financial records are maintained by related entities.

## Canonical Odoo Model

```text
pps.asset
```

The model is custom because the domain requires ownership history, site assignment history, contract coverage rules, and period-based access control. It must not inherit the meaning of `maintenance.equipment` unless a later technical decision explicitly requires it.

## Required Fields

| Field | Type | Rule |
|---|---|---|
| `name` | Char | Human-readable asset name |
| `serial_number` | Char | Required and unique system-wide |
| `brand_id` | Many2one | Required; internal-managed catalog |
| `model_id` | Many2one | Required; must belong to selected brand |
| `manufacture_date` | Date | Required |
| `current_customer_id` | Many2one | Derived from the current ownership period |
| `current_site_id` | Many2one | Derived from the current site assignment |
| `active` | Boolean | Archive flag; default true |

## Related Records

- `pps.asset.ownership.history` records ownership periods.
- `pps.asset.site.assignment` records installation or placement periods.
- `pps.service.contract.asset.line` records contractual coverage periods and service level.
- `pps.ticket` and service reports reference the asset and the applicable business period.

## Business Rules

1. Serial Number is unique across all active and archived assets.
2. Brand and Model are controlled internal catalogs. A Model must belong to its Brand.
3. Every Asset may receive a Ticket, whether covered or uncovered.
4. An Asset has at most one active ownership period, one active site assignment, one active contract coverage line, and one active service level.
5. Ownership transfer closes the current ownership period and terminates the active contract coverage for that period.
6. Historical technical records remain retained. They are visible to Service Manager and higher internal roles; portal customers see only records belonging to their ownership period.
7. Archiving does not remove legal, financial, service, or audit history.

## Access Summary

Customers can select and view only assets associated with their current or permitted historical ownership scope. Internal service users receive access according to role and site/team rules. Service Manager and higher roles can inspect complete technical history.

## Odoo Mapping

- Asset: `pps.asset`
- Brand: `pps.asset.brand`
- Model: `pps.asset.model`
- Customer and address data: `res.partner`
- Attachments and chatter: `ir.attachment`, `mail.thread`, and `mail.activity` where appropriate

## Out of Scope

Detailed technical specifications, warranty policy, preventive maintenance, IoT telemetry, and inventory valuation are separate concerns.
