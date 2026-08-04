# DOC-003
# Contract & Service Policy
Version: 1.0
Status: Approved

---

# هدف

Contract مشخص می‌کند شرکت با چه شرایطی متعهد به ارائه سرویس برای یک Service Package است.

Contract مسئول تعریف SLA، مدت قرارداد و شرایط تجاری است.

---

# Architecture

Customer
    │
    ├── Site
    │
    └── Service Package
            │
            ├── Devices (Assets)
            │
            └── Contract
                    │
                    ├── Service Policy (SLA)
                    ├── Contract Type
                    └── Commercial Terms

---

# Business Rules

## BR-001

هر Customer می‌تواند چند Contract فعال داشته باشد.

---

## BR-002

هر Contract فقط برای یک Service Package تعریف می‌شود.

---

## BR-003

هر Package می‌تواند شامل یک یا چند Asset باشد.

---

## BR-004

هر Contract فقط یک Service Policy دارد.

---

## BR-005

یک Customer می‌تواند همزمان چند Contract با Service Policy متفاوت داشته باشد.

مثال:

Package A → Gold

Package B → Silver

---

## BR-006

Site در قرارداد اهمیت دارد.

زیرا بر موارد زیر اثر می‌گذارد:

- هزینه اعزام
- زمان اعزام
- برنامه سرویس
- هزینه خدمات

---

## BR-007

جابجایی Asset بین Customerها باعث انتقال Contract نمی‌شود.

مالک جدید باید Contract جدید داشته باشد.

تاریخچه سرویس دستگاه حفظ می‌شود.

---

# Service Policy

Service Policy مجموعه قوانین ارائه سرویس است.

نمونه اطلاعات:

- Response Time
- Working Hours (8×5 / 24×7)
- Remote Support
- Onsite Response
- Spare Parts Commitment
- Loan Device
- Preventive Maintenance

Service Policy یک Template استاندارد است.

مانند:

- Bronze
- Silver
- Gold
- Platinum

(نام سطح قابل تغییر است.)

---

# Contract Type

نوع قرارداد مستقل از Service Policy است.

نمونه‌ها:

- One Time Service
- Monthly
- Annual
- Warranty
- Sales Warranty

---

# Commercial Terms

موارد مالی و تجاری در Contract نگهداری می‌شوند.

نمونه:

- Contract Price
- Currency
- Payment Terms
- Travel Cost
- Zone

Pricing بخشی از Service Policy نیست.

---

# Ticket Priority

اولویت تیکت مستقیماً از نام سطح سرویس محاسبه نمی‌شود.

سیستم هنگام ایجاد Ticket اطلاعات زیر را بررسی می‌کند:

- Contract
- Service Policy
- Customer Credit Status
- Manager Decision

Service Policy تعهد شرکت است.

Operational Priority اولویت عملیاتی سیستم است.

این دو مفهوم مستقل هستند.

---

# Capacity

در فاز اول Capacity Planning پیاده‌سازی نمی‌شود.

تنها هشدار مدیریتی برای تعداد قراردادهای سطح سرویس نمایش داده خواهد شد.

هدف جلوگیری از فروش بیش از ظرفیت واقعی شرکت است.

---

# Odoo Mapping

| Business | Odoo |
|----------|------|
| Customer | res.partner |
| Contact | res.partner |
| Site | res.partner (Child Address) |
| Contract | OCA Contract |
| Assets | maintenance.equipment |
| Ticket | helpdesk.ticket |
| Inventory | stock |
| Accounting | account |

Custom Models

- Service Package
- Service Policy

تمام Workflow روی ماژول‌های استاندارد Odoo پیاده‌سازی خواهد شد.

---

# Design Principles

- Odoo First
- OCA First
- Custom Last
- Minimum Custom Models
- No Custom Workflow unless necessary
- Modern UI (Outside Odoo Backend)
- Standard Odoo Backend for Internal Users
- Persian Calendar (OCA)
- Persian Documents
- Bilingual (FA / EN)

---

# Phase

✅ DOC-002 Approved
