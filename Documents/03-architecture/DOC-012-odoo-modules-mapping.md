# DOC-012
# Odoo Modules Mapping

**Status:** Approved

---

# Purpose

تعریف ماژول‌های مورد استفاده در پروژه و تعیین اینکه هر بخش توسط Odoo، OCA یا توسعه سفارشی پیاده‌سازی خواهد شد.

اصل طراحی:

> Odoo First → OCA First → Custom Last

---

# Core Modules

| Domain | Odoo | OCA | Custom | Decision |
|----------|-------|------|----------|-----------|
| Website | Website | — | Theme + UI | Extended |
| Customer Portal | Portal | — | Dashboard + UI | Extended |
| Contacts | Contacts | — | Customer Extensions | Extended |
| Helpdesk | Helpdesk | Helpdesk SLA | Ticket Wizard | Extended |
| Asset Registry | Maintenance | — | Asset Extension | Extended |
| Contracts | Subscription / Sales | TBD | Contract Extension | Extended |
| Inventory | Stock | — | — | Native |
| Accounting | Accounting | — | — | Native |
| Timesheet | Timesheet | — | — | Native |
| Calendar | Calendar | TBD | — | Native |
| Documents | Documents | — | Optional | Optional |
| Digital Sign | Sign | — | Integration | Optional |
| Notifications | Discuss / Mail | — | Notification Rules | Extended |

---

# Website

Website Engine از Odoo استفاده خواهد شد.

Website Builder فقط برای صفحات عمومی استفاده می‌شود.

فرم‌ها و رابط کاربری مشتری کاملاً اختصاصی خواهند بود.

---

## Included

- Landing Pages
- About
- Contact
- Login
- Register

---

## Custom

- Theme
- Customer Dashboard
- Ticket Wizard
- Service Request Forms
- Portal UX

---

# Customer Portal

Portal بر پایه Odoo توسعه داده می‌شود.

ظاهر و تجربه کاربری کاملاً اختصاصی خواهد بود.

Portal شامل موارد زیر است.

- Dashboard
- Assets
- Packages
- Contracts
- Tickets
- Service Reports
- Attachments
- Invoices

---

# Helpdesk

Helpdesk هسته مدیریت Ticket خواهد بود.

---

## Native

- Ticket
- Communication
- Activities
- Mail Thread

---

## Custom

- Ticket Wizard
- Business Logic
- Package Selection
- Contract Validation
- SLA Integration

---

# Asset Registry

از ماژول Maintenance فقط به عنوان Registry تجهیزات استفاده خواهد شد.

قابلیت‌های تعمیرات Maintenance در MVP استفاده نمی‌شوند.

---

# Inventory

Inventory به صورت کامل از Stock استاندارد Odoo استفاده خواهد کرد.

هیچ توسعه سفارشی روی موتور انبار انجام نخواهد شد.

---

# Accounting

Accounting به صورت Native استفاده می‌شود.

Technician هیچ دسترسی به قیمت‌گذاری، صدور فاکتور یا عملیات مالی نخواهد داشت.

تمام عملیات مالی توسط Service Manager و Accounting انجام می‌شود.

---

# Timesheet

ثبت زمان انجام سرویس توسط Timesheet استاندارد انجام خواهد شد.

---

# Documents

در فاز اول اختیاری است.

در صورت نیاز برای نگهداری فایل‌ها استفاده خواهد شد.

---

# Digital Signature

در صورت استفاده، از ماژول استاندارد Odoo Sign استفاده می‌شود.

امضا بخشی از فرآیند Customer Feedback خواهد بود.

---

# Excluded From MVP

ماژول‌های زیر در فاز اول استفاده نخواهند شد.

- Field Service
- Planning
- Map / GIS
- Appointment
- Reservation
- Predictive Maintenance

---

# Custom Development

توسعه سفارشی فقط در بخش‌های زیر انجام خواهد شد.

- Customer Theme
- Customer Portal UI
- Ticket Wizard
- Service Report
- Package Logic
- Contract Logic
- Asset Extensions
- Customer Dashboard

---

# Localization

بومی‌سازی فارسی در سند جداگانه بررسی خواهد شد.

موارد بررسی

- RTL
- Persian Language
- Jalali Calendar
- Persian Reports
- Persian Fonts
- OCA Localization Modules

---

# Architecture Principles

- Reuse Native Odoo Modules
- Reuse OCA Modules
- Keep Business Logic Modular
- Avoid Core Modifications
- Upgrade Friendly
- Mobile First
- API Ready

---

# Notes

تمام توسعه‌های سفارشی باید به گونه‌ای طراحی شوند که کمترین وابستگی به هسته Odoo را داشته باشند.

هر قابلیت جدید ابتدا باید در Odoo و سپس در OCA بررسی شود و تنها در صورت نبود راهکار مناسب، توسعه سفارشی انجام گردد.

---

**Status:** Approved
