# DOC-026 — Customer Service Management Experience

**Version:** 1.0
**Status:** Locked

---

# 1. Purpose

این سند تجربه کاربری مشتری برای مدیریت سرویس را مشخص می‌کند.

هدف:

* ایجاد یک محیط یکپارچه برای مشتری
* مشاهده وضعیت سرویس
* مدیریت درخواست‌ها
* مشاهده دارایی‌ها
* مدیریت دسترسی کاربران مشتری
* ارتباط کنترل‌شده با بخش‌های سرویس و مالی

---

# 2. Design Principle

Customer Service Management یک Portal ساده نیست.

این بخش یک لایه مدیریت سرویس مشتری است.

اصل:

```
Customer Visibility

+

Controlled Self Service

-

No Master Data Modification
```

---

# 3. Scope

Customer Service Management شامل موارد زیر است:

* Dashboard
* Assets
* Asset History
* Tickets
* Service Reports
* Contracts
* Digital Signature
* Customer User Management
* Finance Section

---

# 4. Dashboard

Dashboard صفحه اصلی مشتری است.

هدف:

نمایش خلاصه وضعیت سرویس بدون ایجاد پیچیدگی.

---

نمایش:

* Open Tickets
* Active Assets
* Active Contracts
* Pending Actions
* Pending Signatures
* Recent Services

---

نمونه:

```
Customer Service Dashboard

Open Tickets: 3

Assets: 125

Contracts: 8

Pending Actions: 2

Last Service: 2025/03/10
```

---

# 5. Asset Management

Customer می‌تواند دارایی‌های خود را مشاهده کند.

---

نمایش:

* Asset Name
* Model
* Serial Number
* Site
* Status
* Related Contract

---

# 6. Asset History

برای هر Asset تاریخچه سرویس نمایش داده می‌شود.

---

شامل:

* Service Date
* Service Type
* Service Report
* Replacement Parts
* Previous Activities

---

نمونه:

```
Asset ABC-123

2025/01/10
Maintenance

2025/02/20
Board Replacement

2025/03/05
Error Investigation
```

---

# 7. Asset Permission Rule

Asset Master Data متعلق به سیستم سرویس است.

Customer فقط امکان مشاهده دارد.

---

Customer:

✅ View Asset

✅ View History

❌ Edit Asset

❌ Delete Asset

❌ Change Serial Number

❌ Change Model

❌ Change Contract Relation

---

دلیل:

جلوگیری از تغییر اطلاعاتی که روی:

* SLA
* Contract
* Cost Calculation
* Service Responsibility

اثر می‌گذارد.

---

# 8. Asset Change Request

در صورت نیاز به تغییر اطلاعات Asset:

Customer باید Request ثبت کند.

---

Flow:

```
Customer Request

↓

Service Manager Review

↓

Asset Update
```

---

# 9. Ticket Management

## 9.1 Ticket Creation

ثبت Ticket از طریق:

Customer Ticket Wizard

---

Backend:

Odoo Helpdesk Ticket

---

اطلاعات:

* Asset
* Issue Description
* Attachment
* Contact Information

---

## 9.2 Ticket Tracking

Customer مشاهده می‌کند:

* Ticket Number
* Status
* SLA Expected Response
* Latest Update

---

Customer مشاهده نمی‌کند:

* Internal Notes
* Technician Hint
* Credit Status
* Internal Priority Logic

---

# 10. Service Report

Customer بعد از پایان سرویس می‌تواند گزارش سرویس را مشاهده کند.

---

نمایش:

* Service Date
* Technician
* Work Summary
* Resolution
* Used Parts
* Attachments
* Signature Status

---

# 11. Contract Management

Customer قراردادهای مرتبط را مشاهده می‌کند.

---

نمایش:

* Contract Name
* Start Date
* End Date
* SLA Level
* Covered Assets

---

اطلاعات مالی قرارداد:

فقط برای:

```
Accounting Contact
```

نمایش داده می‌شود.

---

# 12. Digital Signature Center

مرکز مدیریت امضاهای دیجیتال.

---

شامل:

* Service Report Approval
* Contract Approval
* Required Documents

---

بدون امضای معتبر:

مدارک اجرایی قابلیت اعتبار ندارند.

---

# 13. Customer User Management

Customer Admin امکان مدیریت کاربران شرکت خود را دارد.

---

Flow:

```
Customer Admin

↓

Create User

↓

Assign Allowed Customer Role

↓

Invitation

↓

Activation
```

---

# 14. Customer Roles

## Customer Admin

دسترسی:

* مدیریت کاربران مشتری
* مشاهده اطلاعات سرویس

---

## Technical Contact

دسترسی:

* Assets
* Tickets
* Service Reports

---

## Accounting Contact

دسترسی:

* Finance Section
* Invoice Information
* Payment Status

---

## Normal User

دسترسی:

* Create Ticket
* Track Ticket

---

# 15. Customer Admin Restrictions

Customer Admin:

می‌تواند:

✅ User ایجاد کند
✅ Roleهای مجاز مشتری بدهد

---

نمی‌تواند:

❌ Internal Role ایجاد کند
❌ Service Manager ایجاد کند
❌ Technician ایجاد کند
❌ Permission داخلی تغییر دهد

---

ایجاد Customer Admin جدید:

در صورت نیاز:

```
Request

↓

Internal Approval
```

---

# 16. Finance Section

اطلاعات مالی داخل همین Customer Service Management قرار دارد.

Portal مالی جدا ساخته نمی‌شود.

---

Finance Section فقط برای:

```
Accounting Contact
```

فعال است.

---

نمایش:

* Invoice
* Payment Status
* Financial Documents

---

# 17. Monitoring Integration

Monitoring یک Module مستقل است.

Customer Service Management مسئول ساخت Monitoring نیست.

---

Architecture:

```
Monitoring Module

↓

Customer Service Management Dashboard

↓

Customer View
```

---

# 18. Marketplace Separation

Marketplace کاملاً جدا از Customer Service Management است.

---

اصل:

```
Customer Service Management

≠

Marketplace
```

---

Marketplace در DOC-027 بررسی خواهد شد.

---

# 19. Final Architecture

```
Customer

↓

Customer Service Management

|

+ Dashboard

+ Assets

+ Asset History

+ Tickets

+ Service Reports

+ Contracts

+ Digital Signature

+ Customer User Management

+ Finance Section
```

---

# 20. Final Decisions

✅ Customer Portal به Customer Service Management تغییر نام یافت.
✅ هدف Portal فقط Service Experience است.
✅ Assetها توسط مشتری قابل ویرایش نیستند.
✅ تغییر Asset فقط با Request انجام می‌شود.
✅ Customer Admin می‌تواند User ایجاد کند.
✅ Roleهای مشتری محدود هستند.
✅ Finance داخل همین CSM قرار دارد و Portal جدا ندارد.
✅ Monitoring مستقل باقی می‌ماند.
✅ Marketplace کاملاً جدا طراحی خواهد شد.

---

# DOC-026 — LOCKED
