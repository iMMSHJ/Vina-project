# DOC-013 — Data Model Entity Mapping

**Status:** Approved  
**Canonical Reference:** DOC-001 and DOC-054-CANONICAL  
**Scope:** Business-to-Odoo mapping

## Canonical Decisions Applied

- Service Package is removed completely.
- Ticket is the custom model `pps.ticket`.
- Asset is `pps.asset`.
- Site is the domain model `pps.site`, linked to an Odoo address partner.
- Contract coverage is represented by an independent asset-line model.
- Service Level is the single current service-level concept.
- Each Asset has at most one active Contract and one active Service Level.
- Ownership transfer terminates active coverage for the previous period.

## Entity Mapping

| Business Object | Odoo Model | Strategy |
|---|---|---|
| Customer | `res.partner` | Extension |
| Contact | `res.partner` | Native extension |
| Contact-Site Access | `pps.contact.site.access` | Custom |
| Site | `pps.site` | Custom, linked to `res.partner` address |
| Asset | `pps.asset` | Custom |
| Ownership History | `pps.asset.ownership.history` | Custom |
| Site Assignment History | `pps.asset.site.assignment` | Custom |
| Contract | `contract.contract` (OCA, if compatible) | Extension/adaptor |
| Contract Asset Line | `pps.service.contract.asset.line` | Custom |
| Service Level | `pps.service.level` | Custom |
| Ticket | `pps.ticket` | Custom |
| Service Report | `pps.service.report` | Custom |
| Parts and stock | `product.product`, `stock.*` | Native |
| Accounting | `account.*` | Native |
| Users and groups | `res.users`, `res.groups` | Native |
| Attachments | `ir.attachment` | Native with record rules |

If the selected OCA Contract module cannot satisfy Odoo 19 compatibility or required lifecycle rules, `pps.service.contract` becomes the implementation fallback without changing the domain contract interface.

## Canonical Relationships

```text
Customer (res.partner)
├── Contact (res.partner)
├── Site (pps.site -> address res.partner)
└── Asset (pps.asset)
    ├── Ownership History
    ├── Site Assignment History
    ├── Contract Asset Line
    └── Ticket / Service History

Contract
└── Contract Asset Lines
    ├── Asset
    ├── Site
    └── Service Level
```

## Design Rules

- No Package entity or Package foreign key exists.
- Contract Asset Line stores validity, asset, site, and service level reference.
- Database constraints and server-side checks prevent overlapping active coverage periods.
- Ticket creation is allowed without coverage. The wizard applies the lower service level, adds the financial-review tag, and records the customer's financial rating.
- The first operational decision belongs to Service Manager. Finance may be engaged before or after service according to that decision.
- Real deletion is restricted to Super Admin. Operational records are archived.
- Portal access is period-scoped and must not be inferred from `current_customer_id` alone.

## Odoo First Rules

Use native Odoo models for partners, users, groups, accounting, products, inventory, attachments, activities, and messaging. Use OCA modules where compatible and proven. Add custom models only for domain rules that cannot be represented safely by standard models.

## API Boundary

The independent Next.js frontend communicates through the API Gateway. It does not access Odoo models directly. The Gateway resolves customer/site/asset scope, applies record rules and business validation, and exposes versioned resources for tickets, assets, contracts, service levels, and reports.
