# DOC-013
# Data Model (Entity Mapping)

**Status:** Approved

> **⚠️ اصلاحیه (DOC-041 §2):** سه ردیف جدول Entity Mapping زیر اصلاح شدند: **Asset** (→ `pps.asset` کاملاً اختصاصی، نه `maintenance.equipment`)، **SLA** (→ `pps.sla` کاملاً اختصاصی، نه `helpdesk.sla` که Enterprise-only است)، **Contract** (→ `contract.contract` از OCA، نه `sale.subscription` که Enterprise-only است). جزئیات و دلایل کامل در DOC-041.

---

# Purpose

تعریف موجودیت‌های اصلی سیستم و ارتباط آن‌ها با مدل‌های استاندارد Odoo.

هدف این سند جلوگیری از ایجاد Modelهای غیرضروری و استفاده حداکثری از ساختار استاندارد Odoo است.

---

# Design Principle

> If Odoo already provides the model, extend it instead of creating a new one.

---

# Entity Mapping

| Business Object | Odoo Model | Strategy |
|-----------------|------------|----------|
| Customer | res.partner | Extension |
| Site | res.partner (Child Partner) | Extension |
| Asset | ~~maintenance.equipment~~ → **pps.asset** | ~~Extension~~ → **New (Custom, طبق DOC-041)** |
| Package | Custom Model | New |
| Contract | ~~sale.subscription / sale.order~~ → **contract.contract (OCA)** | Extension (طبق DOC-041) |
| SLA | ~~helpdesk.sla~~ → **pps.sla** | ~~Extension~~ → **New (Custom, طبق DOC-041)** |
| Service Request (Ticket) | helpdesk.ticket | Extension |
| Service Report | Custom Model | New |
| Parts | product.product | Native |
| Inventory | stock.* | Native |
| Users | res.users | Native |
| Roles | res.groups | Native |
| Permissions | ACL + Record Rules | Native |
| Timesheet | account.analytic.line | Native |
| Attachments | ir.attachment | Native |

---

# Entity Relationship

```text
Customer
    │
    ├── Site
    │
    ├── Asset
    │      │
    │      ├── Package
    │      │      │
    │      │      ├── Contract
    │      │      │      │
    │      │      │      └── SLA
    │      │
    │      └── Service Request
    │              │
    │              ├── Service Reports
    │              └── Parts Used
```

---

# Native Odoo Models

بدون تغییر ساختاری استفاده می‌شوند.

- res.users
- res.groups
- stock.*
- product.product
- account.*
- account.analytic.line
- ir.attachment
- mail.thread
- mail.activity

---

# Extended Models

مدل‌های استاندارد Odoo که فقط فیلدها و منطق موردنیاز پروژه به آن‌ها اضافه می‌شود.

- res.partner
- ~~maintenance.equipment~~ (حذف شد — به‌جای آن `pps.asset` کاملاً اختصاصی)
- helpdesk.ticket
- ~~helpdesk.sla~~ (حذف شد — به‌جای آن `pps.sla` کاملاً اختصاصی)
- contract.contract (OCA — طبق DOC-041)

---

# Custom Models

مدل‌هایی که در Odoo معادل مستقیمی ندارند.

## Service Package

تعریف مجموعه تجهیزات تحت یک قرارداد سرویس.

---

## Service Report

گزارش هر اقدام انجام‌شده توسط کارشناس.

هر Ticket می‌تواند شامل چندین Service Report باشد.

---

# Design Rules

- تا حد امکان از مدل‌های استاندارد Odoo استفاده می‌شود.
- ایجاد Model جدید فقط در صورت نبود معادل مناسب در Odoo انجام خواهد شد.
- هیچ تغییری در Core Odoo انجام نمی‌شود.
- ارتباط موجودیت‌ها با استفاده از Relationهای استاندارد Odoo پیاده‌سازی خواهد شد.

---

# Future Extensions

در نسخه‌های آینده در صورت نیاز می‌توان مدل‌های زیر را اضافه کرد.

- Warranty
- Preventive Maintenance Plan
- Customer Rating
- Device Health
- Marketplace Integration
- IoT Integration

---

# Notes

این سند فقط ساختار موجودیت‌ها را مشخص می‌کند.

تعریف فیلدها، Relationها و Business Logic هر Model در زمان توسعه هر ماژول انجام خواهد شد.

---

**Status:** Approved
