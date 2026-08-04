# DOC-020 — Entity Mapping Design

**Status:** LOCKED  
**Phase:** Phase 3  
**Document Type:** Business Analysis & Data Model Design

---

# 1. Objective

هدف این داکیومنت مشخص کردن Entityهای اصلی سیستم و رابطه بین آن‌ها است.

اصول:

- استفاده از Entityهای استاندارد Odoo تا حد ممکن
- جلوگیری از ایجاد Entity اضافی
- Customization فقط در Business Gapها

---

# 2. Core Entity Model

Entityهای اصلی:

- Customer
- Contact
- Site
- Contract
- SLA
- Package
- Asset
- Ticket
- Task
- Service Report
- Expense

---

# 3. Customer

Customer مالک رابطه تجاری با سیستم است.

Customer می‌تواند:

- مشتری جدید باشد
- قرارداد نداشته باشد
- چند قرارداد داشته باشد
- چند Site داشته باشد
- چند Contact داشته باشد

---

ساختار:

```

Customer

|

Contacts

|

Sites

|

Contracts

```

---

# 4. Contact

Contact افراد مرتبط با Customer هستند.

مثال:

```

Customer ABC

├── مدیرعامل
├── مسئول IT
├── حسابدار
└── اپراتور

```

---

تصمیم:

مدیریت Contact بر اساس استاندارد Odoo انجام می‌شود.

---

# 5. Site

Site محل فیزیکی سرویس است.

مثال:

```

Customer ABC

├── Site Tehran
|
├── Site Shiraz
|
└── Site Tabriz

```

---

Site می‌تواند:

- آدرس
- اطلاعات تماس
- شرایط سرویس

داشته باشد.

---

# 6. Contract

Contract رابطه رسمی سرویس با مشتری است.

Contract شامل:

- تاریخ شروع
- تاریخ پایان
- شرایط قرارداد
- Package
- SLA

است.

---

رابطه:

```

Customer

↓

Contract

```

---

# 7. SLA

SLA تعهد زمانی پاسخگویی است.

تصمیم مهم:

SLA به معنی Response Commitment است.

مثال:

```

SLA 1

Response Time:
5 Days

SLA 2

Response Time:
48 Hours

```

---

SLA روی:

- Priority
- Notification
- Escalation

اثر دارد.

---

رابطه:

```

Contract

↓

SLA

```

---

# 8. Package

Package یک مفهوم قراردادی است.

Package شامل چند Asset است.

---

رابطه:

```

Contract

↓

Package

↓

Assets

```

---

Package:

- محصول نیست
- Inventory Item نیست
- فقط برای Contract Mapping است

---

# 9. Asset

Asset دستگاه یا تجهیز واقعی مشتری است.

مثال:

```

Plate Tester

Serial:
12532

```

---

Asset شامل:

- Serial Number
- Model
- Manufacturer
- Location
- Status

است.

---

رابطه:

```

Package

↓

Asset

```

---

# 10. Ticket

Ticket درخواست سرویس است.

می‌تواند توسط:

- Customer
- Guest
- Internal User

ایجاد شود.

---

Ticket شامل:

- Customer
- Site
- Asset
- Contract
- SLA
- Priority

است.

---

Flow:

```

Ticket

↓

Task

↓

Service Report

```

---

# 11. Task

Task فعالیت اجرایی کارشناس است.

تصمیم:

هر Ticket ارجاع شده حداقل یک Task دارد.

---

Task فقط توسط Technician انجام می‌شود.

شامل:

- Assigned Technician
- Time Sheet
- Report
- Attachment

---

رابطه:

```

Ticket

↓

Task

↓

Technician

```

---

# 12. Service Report

گزارش انجام سرویس است.

شامل:

- شرح کار
- زمان انجام
- نتیجه
- قطعات استفاده شده
- وضعیت نهایی

---

Service Report مالک تاریخچه فنی است.

---

# 13. Parts / Material

قطعات مصرفی یا امانی باید ثبت شوند.

اگر کارشناس:

- قطعه مصرف کند
- قطعه امانت بگیرد

باید وضعیت آن مشخص شود.

---

# 14. Expense

Expense از Odoo Expenses استفاده می‌کند.

Entity جدید ساخته نمی‌شود.

---

Customization فقط:

ارتباط با:

- Ticket
- Task

است.

---

Flow:

```

Technician

↓

Expense

↓

Approval

↓

Accounting

↓

Paid

```

---

# 15. Maintenance

Odoo Maintenance فعلاً در Core Model قرار نمی‌گیرد.

دلیل:

- تجهیزات داخلی شرکت موضوع اصلی نیست.
- PM به عنوان Ticket/Task سرویس دیده می‌شود.

---

Maintenance:

Future Module

---

# 16. Entity Relationship Final

## مسیر قراردادی

```

Customer

↓

Contract

↓

Package

↓

Asset

```

---

## مسیر سرویس

```

Customer

↓

Ticket

↓

Asset

↓

Contract / SLA Lookup

↓

Task

↓

Service Report

```

---

# 17. حذف و Archive

تصمیم:

Delete واقعی فقط برای:

Super Admin

---

سایر موارد:

Archive

---

# 18. Final Design Principle

اصل:

```

Standard Odoo Entity

*

OCA Extension

*

Custom Business Logic Only

```

---

# DOC-020 Final Status

LOCKED ✅
```

این نسخه با اصلاحی که آخر DOC-019 گفتیم هماهنگ است:
**مسیر قراردادی و مسیر سرویس جدا شده‌اند** تا مدل در Odoo طبیعی‌تر و قابل پیاده‌سازی‌تر باشد.
------------------------------------------------------
# DOC-020 — Contract, SLA & Commercial Rules

**Status: FINAL / LOCKED** 🔒
**Version:** 1.0

---

# 1. Purpose

این سند ساختار قرارداد، مالکیت حقوقی، ارتباط قرارداد با Asset، SLA و فرآیند سرویس را مشخص می‌کند.

هدف:

* مشخص شدن مالکیت قرارداد
* جلوگیری از اشتباه گرفتن SLA با زمان انجام سرویس
* تعیین نقش Finance / Accounting و Service Manager
* تعریف ارتباط Contract با Ticket

---

# 2. Contract Definition

## Contract چیست؟

قرارداد یک سند حقوقی رسمی بین Provider و Customer است.

Contract شامل:

* شرایط حقوقی
* تعهدات طرفین
* مدت اعتبار
* SLA
* شرایط فسخ
* هزینه‌ها
* محدوده سرویس

است.

---

# 3. Contract Template

قرارداد باید از قالب استاندارد استفاده کند.

ویژگی‌ها:

* دارای نسخه فارسی
* دارای نسخه انگلیسی
* دارای فرمت تایید شده سازمان

---

# 4. Digital Signature Rule

هیچ قرارداد یا سند اجرایی بدون امضای دیجیتال معتبر نیست.

افراد دارای امضای دیجیتال:

* CEO
* مدیران مجاز
* مجریان مرتبط
* مشتریان دارای دسترسی حقوقی

---

Rule:

```text
Unsigned Document

↓

Not Executable
```

---

# 5. Contract Ownership

مسئولیت حقوقی قرارداد:

## Finance / Accounting

بر عهده دارد.

وظایف:

* مدیریت قرارداد
* کنترل حقوقی
* نگهداری نسخه رسمی
* دسترسی حقوقی مشتری

---

Service Manager:

نقش اجرایی دارد.

وظایف:

* رابط مشتری
* اجرای تعهدات سرویس
* هماهنگی عملیات

---

مدل:

```text
Customer

↓

Finance / Accounting

↓

Contract

↓

Service Manager

↓

Service Execution
```

---

# 6. Contract Visibility

اطلاعات حقوقی قرارداد فقط برای افراد دارای دسترسی حقوقی نمایش داده می‌شود.

Customer:

اگر دسترسی حقوقی داشته باشد:

✅ مشاهده Contract Detail

اگر نداشته باشد:

❌ مشاهده نکردن اطلاعات حقوقی

---

Service Team:

اطلاعات لازم برای سرویس را می‌بیند.

اما:

❌ جزئیات حقوقی قرارداد
❌ شرایط مالی

نمایش داده نمی‌شود.

---

# 7. Contract Relationship Model

مدل ارتباط:

```text
Customer

↓

Contract

↓

Assets

↓

Service
```

---

هر Contract مربوط به محدوده مشخصی از تجهیزات است.

---

# 8. Package Relationship

Package یک Entity مستقل نیست.

اما در قرارداد ممکن است مجموعه‌ای از تجهیزات را نشان دهد.

مدل:

```text
Contract

↓

Package (Conceptual)

↓

Assets
```

---

قوانین:

* هر Package قراردادی قرارداد مستقل دارد.
* دو Package با شرایط مشابه، دو Contract جدا هستند.
* SLA مربوط به Contract است.

---

# 9. Contract Duration

حالت پیش‌فرض:

Contract تا پایان تاریخ اعتبار ادامه دارد.

مثلاً:

```text
Start Date:
01/01/2026

End Date:
31/12/2026
```

---

اما برای جلوگیری از ضرر طرفین:

شرایط فسخ باید داخل قرارداد تعریف شود.

---

# 10. Contract Change Rules

تغییرات قرارداد:

نیازمند فرآیند رسمی است.

مثال:

* تغییر مشتری
* تغییر شرایط سرویس
* تغییر تجهیزات تحت پوشش

---

# 11. Customer Change Scenario

اگر مشتری تغییر کند:

Contract قبلی:

```text
Cancelled / Archived
```

---

Customer جدید:

Contract جدید دریافت می‌کند.

---

History:

* تاریخچه مشتری قبلی حفظ می‌شود.
* تاریخچه مشتری جدید مستقل نمایش داده می‌شود.

---

# 12. SLA Definition

## تعریف SLA

SLA فقط به معنی:

**تعهد زمانی برای پاسخ اولیه به مشتری**

است.

---

SLA شامل:

* زمان پاسخگویی
* محاسبه Expected Response Time

است.

---

مثال:

## SLA Level 1

```text
First Response:
5 Days
```

---

## SLA Level 2

```text
First Response:
48 Hours
```

---

# 13. SLA Does Not Mean

SLA شامل موارد زیر نیست:

❌ زمان تعمیر
❌ زمان حضور تکنسین
❌ زمان Resolution
❌ مدت انجام کار

این موارد در Task و Execution مدیریت می‌شوند.

---

# 14. SLA Flow

```text
Asset

↓

Active Contract

↓

SLA Rule

↓

Expected Response Time

↓

Ticket Priority / Notification
```

---

# 15. SLA Impact

SLA تاثیر مستقیم دارد بر:

## Ticket Priority

و

## Notification

---

مثال:

```text
SLA:
48 Hours

↓

Higher Priority
```

---

# 16. Guest SLA

Guest Customer نیز SLA دارد.

اما:

* معمولاً پایین‌ترین سطح SLA
* سرویس‌ها Prepaid هستند

---

مثال:

```text
Guest

↓

Default SLA

↓

Prepayment Required
```

---

# 17. Credit Dependency

اعتبار مشتری روی امکان سرویس تاثیر دارد.

Rule:

* سیستم اعتبار را بررسی می‌کند.
* در صورت نزدیک شدن به صفر هشدار ایجاد می‌شود.
* Service Manager می‌تواند مشتری را Block کند.

---

Credit Status در Ticket به صورت Visual Indicator نمایش داده می‌شود.

---

# 18. Contract & Site Relationship

Site معیار قرارداد نیست.

مدل:

```text
Customer

↓

Sites

↓

Assets

↓

Contract Coverage
```

---

Site فقط محل استقرار تجهیزات است.

---

# 19. Contract Decision Rules

* Contract متعلق به Customer است.
* Asset تحت پوشش Contract قرار می‌گیرد.
* SLA از Contract استخراج می‌شود.
* Ticket از Asset شروع می‌شود.
* Package فقط مفهوم قراردادی است.

---

# Final Architecture

```text
Customer

    |
    |
Contract
    |
    |
    +---- SLA
    |
    |
    +---- Assets
              |
              |
            Ticket
              |
              |
            Task
              |
              |
          Service Execution
