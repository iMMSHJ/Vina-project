# DOC-001
# Business Domain & Core Rules

**Status:** Approved

---

# Purpose

تعریف ساختار اصلی کسب‌وکار و قوانین پایه سیستم قبل از طراحی دیتابیس و توسعه.

این سند مرجع اصلی تمام مستندات بعدی است.

---

# Business Domain

```text
Customer
│
├── Head Office (Optional)
│
├── Sites (0..N)
│
│      ├── Contacts
│      └── Assets
│
└── Contracts
       └── Contract Lines
              └── Assets
```

---

# Customer Types

سیستم از دو نوع مشتری پشتیبانی می‌کند.

- Company (حقوقی)
- Individual (حقیقی)

---

# Customer Structure

هر Customer می‌تواند:

- چند Site داشته باشد.
- چند Contact داشته باشد.
- چند Contract داشته باشد.
- چند Asset داشته باشد.

> Service Package از مدل دامنه حذف شد و در این نسخه وجود ندارد.

---

# Site

Site محل ارائه سرویس است.

نمونه:

- کارخانه
- دفتر
- شعبه
- انبار
- منزل مشتری

Site فقط یک آدرس نیست.

بر موارد زیر اثر دارد:

- هزینه اعزام
- زمان اعزام
- برنامه سرویس
- SLA عملیاتی

Site در Odoo به صورت `res.partner` از نوع آدرس فرزند مدل می‌شود، اما در دامنه یک موجودیت عملیاتی مستقل است.

---

# Contacts

هر Contact می‌تواند به چند Site متصل باشد.

هر Contact می‌تواند چند Role مشتری داشته باشد.

نقش Contact نسبت به هر Site می‌تواند متفاوت باشد و باید به صورت رابطه‌ای با بازه اعتبار و محدوده دسترسی ذخیره شود.

---

# Customer Roles

Roleهای مشتری محدود و ثابت هستند.

- Manager
- Service (Technical Contact)
- Operator
- Accountant

هر Contact می‌تواند بیش از یک Role داشته باشد.

مثال:

Manager + Accountant

یا

Operator + Service

---

# Internal Roles

Roleهای کاربران داخلی کاملاً مستقل از مشتری هستند.

نمونه:

- Super Admin
- Service Manager / Supervisor
- Technician
- Warehouse
- Accountant
- Sales

---

# Security Rules

Customer هیچ‌وقت Role داخلی دریافت نمی‌کند.

Internal User هیچ‌وقت Role مشتری دریافت نمی‌کند.

هر User می‌تواند چند Role داخلی داشته باشد.

هر Contact مشتری نیز می‌تواند چند Role مشتری داشته باشد.

---

# Asset Ownership

مالک دستگاه Customer است.

Contact مالک دستگاه نیست.

---

# Asset History

جابجایی دستگاه بین مشتریان مجاز است.

مالکیت تغییر می‌کند.

تاریخچه سرویس حذف نمی‌شود.

Customer قبلی فقط به سوابق مالی مربوط به دوره مالکیت خود دسترسی دارد.

تاریخچه دستگاه برای مشتری قبلی آرشیو می‌شود و برای Service Manager قابل مشاهده باقی می‌ماند.

Customer جدید سوابق جدید مربوط به دوره مالکیت خود را مدیریت می‌کند و به آرشیو دوره‌های قبلی دسترسی پیش‌فرض ندارد.

کاربران داخلی به تاریخچه کامل دسترسی دارند.

---

# Contracts

هر Customer می‌تواند چند Contract داشته باشد.

هر Device فقط یک Contract فعال و یک سطح خدمت فعال دارد.

هر Contract می‌تواند یک یا چند Asset را پوشش دهد، مشروط بر اینکه همه آن‌ها در همان Contract یک سطح خدمت مشترک داشته باشند.

اگر برای یک Asset سطح خدمت متفاوت لازم باشد، باید Contract جداگانه تعریف شود.

---

# Contract Rules

هر Contract باید برای هر Asset، سطح خدمت مؤثر را مشخص کند.

سطح خدمت در این سند در سطح Contract و برای هر Asset معرفی‌شده در قرارداد تعیین می‌شود.

اولویت تصمیم‌گیری خدمت:

1. Contract Asset Level
2. Contract Default (اگر تعریف شده باشد)
3. Global Default

در نسخه اول، هم‌پوشانی چند Contract فعال برای یک Asset مجاز نیست.

---

# Ticket Philosophy

ثبت درخواست سرویس همیشه مجاز است.

وجود یا عدم وجود Contract مانع ثبت Ticket نیست.

Contract فقط روی نحوه ارائه سرویس اثر می‌گذارد.

محدودیت مالی و پیش‌پرداخت ممکن است اجرای سرویس را محدود کند، اما مانع ثبت اولیه Ticket نمی‌شود.

---

# Ticket Intake

فرم ویزارد تیکت در این سند فقط در سطح کلی ذکر می‌شود.

جزئیات کامل فرم، مراحل، و فیلدها در سند اختصاصی Ticket Wizard تعریف می‌شود.

---

# Ticket Types

## Guest

بدون ورود به سیستم.

ثبت درخواست تماس یا درخواست اولیه.

برای پیگیری، کاربر باید یک حساب با سطح دسترسی پایین ایجاد کند.

---

## Authenticated Customer

پس از ورود.

انتخاب دقیق Site، Device و سایر اطلاعات عملیاتی طبق ویزارد اختصاصی تیکت انجام می‌شود.

سطح ثبت و انتخاب‌ها در این سند فقط به صورت کلی اشاره می‌شود.

---

# Financial Policy

سیاست مالی از سیاست سرویس جداست.

اگر مشتری در سطح پایین مالی قرار گیرد:

- سرویس با سطح پایین‌تر دریافت می‌کند.
- هزینه‌های لازم باید پیش‌پرداخت شوند.
- تصمیم مالی مانع ثبت اولیه Ticket نمی‌شود، اما می‌تواند ارائه سرویس را شرطی کند.

---

# Decision Authority

تصمیم اولیه، ارجاع فنی، و مسیر کلی سرویس توسط نقش `Service Manager / Supervisor` انجام می‌شود.

---

# Design Principles

- Odoo First
- OCA First
- Custom Last

---

تا حد امکان از مدل‌های استاندارد Odoo استفاده می‌شود.

در صورت نیاز فقط Modelهای کوچک و مستقل ایجاد خواهند شد.

---

# UI / UX

رابط کاربری مشتری و کارشناس به صورت اختصاصی طراحی می‌شود.

Backend کاربران داخلی تا حد امکان از رابط استاندارد Odoo استفاده خواهد کرد.

---

# Localization

- Persian Calendar (OCA)
- Persian Documents
- Persian Date
- English Language
- Bilingual (FA / EN)

---

# Project Principles

- Business First
- Domain Driven Design
- Modular Architecture
- Small Documents
- Fast Development
- Easy Maintenance
- Upgrade Friendly

---

# Odoo Mapping

| Business Entity | Odoo Model |
|-----------------|------------|
| Customer | res.partner |
| Contact | res.partner |
| Internal User | res.users |
| Site | res.partner (Child Address) |
| Asset | maintenance.equipment |
| Ticket | helpdesk.ticket |
| Warehouse | stock |
| Accounting | account |

---

# Document Roadmap

- DOC-001 Business Domain & Core Rules
- DOC-002 Asset Master Data
- DOC-003 Contract
- DOC-004 Service Policy (SLA)
- DOC-005 Service Request
- DOC-006 Service Report
- DOC-007 Parts & Inventory
- DOC-008 Roles & Permissions
- DOC-009 Workflow
- DOC-010 Ticket Wizard

---

**Status:** Approved
