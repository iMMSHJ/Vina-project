# DOC-005
# Service Package

**Status:** Approved

---

# Purpose

Service Package مجموعه‌ای از Assetها است که به عنوان یک واحد سرویس و قرارداد تعریف می‌شود.

Package مشخص می‌کند کدام تجهیزات تحت یک قرارداد و یک Service Policy (SLA) پوشش داده می‌شوند.

Package یک مفهوم تجاری (Business Concept) است و مبنای قراردادهای سرویس می‌باشد.

---

# Business Rules

## BR-001

هر Package متعلق به یک Customer است.

---

## BR-002

هر Package فقط به یک Site تعلق دارد.

---

## BR-003

هر Package شامل یک یا چند Asset است.

---

## BR-004

هر Package فقط یک Contract فعال دارد.

---

## BR-005

هر Package فقط یک Service Policy (SLA) دارد.

---

## BR-006

هر Asset در هر لحظه فقط عضو یک Package است.

---

## BR-007

پس از فعال شدن Contract، ساختار Package ثابت (Immutable) است.

افزودن، حذف یا جایگزینی Asset باعث ایجاد Package جدید خواهد شد.

در صورت نیاز، Contract جدید یا الحاقیه قرارداد ایجاد می‌شود.

---

# Package Structure

نمونه

Commercial Prepress

- CTP
- Processor
- RIP

یا

Digital Printing

- Digital Press
- DFE
- RIP
- Finishing

Package صرفاً مجموعه تجهیزات تحت پوشش یک قرارداد است.

---

# Required Fields

- Package Name
- Customer
- Site
- Contract
- Service Policy (SLA)
- Status

---

# Package Status

- Draft
- Active
- Suspended
- Expired
- Archived

---

# Package Members

Package می‌تواند شامل هر نوع تجهیز قابل سرویس باشد.

نمونه

- CTP
- Processor
- RIP
- Plate Punch
- Plate Stacker
- Digital Press
- Color Server
- سایر تجهیزات

نوع تجهیزات محدودیتی ندارد.

---

# Asset Selection

هنگام ثبت Ticket مشتری Package را انتخاب نمی‌کند.

مشتری فقط Asset مورد نظر را انتخاب می‌کند.

سیستم به صورت خودکار اطلاعات زیر را استخراج می‌کند.

- Package
- Contract
- Service Policy (SLA)
- Site
- Customer

---

# Package Lifecycle

Customer

↓

Site

↓

Assets

↓

Package

↓

Contract

↓

Service Policy (SLA)

↓

Service Requests

---

# Package Revision

اگر ترکیب تجهیزات تغییر کند:

- Package جدید ایجاد می‌شود.
- Contract جدید یا الحاقیه قرارداد ثبت می‌شود.
- سوابق Package قبلی حفظ می‌شود.
- تاریخچه سرویس تجهیزات حذف نخواهد شد.

---

# Odoo Mapping

| Business Entity | Odoo |
|-----------------|------|
| Package | Custom Model |
| Customer | res.partner |
| Site | res.partner (Child Address) |
| Asset | maintenance.equipment |
| Contract | OCA Contract |
| Service Policy | Custom Model |

---

# Design Principles

- One Package = One Contract
- One Package = One Service Policy
- One Package = Many Assets
- One Asset = One Package
- Customer selects Asset, not Package
- Package is a Business Concept
- Package structure is fixed after Contract activation
- Odoo First
- OCA First
- Custom Last

---

# Notes

Package یک اصطلاح قراردادی است.

هدف Package تعریف مجموعه تجهیزاتی است که تحت یک قرارداد و یک سطح سرویس مشخص پوشش داده می‌شوند.

هرگونه تغییر در ترکیب تجهیزات، باعث ایجاد Package جدید خواهد شد تا یکپارچگی قراردادها و سوابق سرویس حفظ شود.

---

**Status:** Approved
