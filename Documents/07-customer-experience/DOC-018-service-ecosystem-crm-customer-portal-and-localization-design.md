# DOC-018 — Service Ecosystem, CRM, Customer Portal & Localization Design

**Status:** LOCKED  
**Phase:** Phase 3  
**Document Type:** Business Analysis & Architecture Decision

---

# 1. Objective

هدف این داکیومنت تعریف ساختار کلی سیستم سرویس، ارتباط CRM، Customer Portal، Helpdesk، Field Service و Localization است.

اصول اصلی:

- استفاده حداکثری از استانداردهای Odoo
- استفاده از OCA در موارد مورد نیاز
- جلوگیری از Customization غیرضروری
- طراحی On-Premise و Self Hosted
- قابل ارائه به چند شرکت مختلف
- تمرکز بر Single Company Operation در هر Deployment

---

# 2. Deployment Principles

تصمیمات زیر قطعی هستند:

- سیستم Self Hosted است.
- Deployment روی Ubuntu Server انجام می‌شود.
- استفاده از Docker / Containerization مورد نیاز نیست.
- سرویس‌ها ترجیحاً Open Source باشند.
- HA در صورت نیاز به صورت Virtual طراحی خواهد شد.
- سیستم برای یک شرکت طراحی می‌شود ولی قابلیت ارائه به شرکت‌های دیگر را دارد.

---

# 3. Platform Direction

پایه سیستم:

## Odoo Platform

با استفاده از:

- Odoo Standard Modules
- OCA Community Modules
- Custom Development فقط در موارد ضروری

---

# 4. Website & Portal Concept

ساختار کلی:

```

Home

|
|-- Login / Register
|
|-- About
|
|-- Contact
|
|-- Service Portal
|
|-- Customer Portal
|
|-- Marketplace

```

---

# 5. Home Page Philosophy

تصمیم:

Home یک صفحه مشترک برای همه کاربران است.

کاربر بعد از Login از Home خارج نمی‌شود.

سیستم با توجه به Role کاربر، محتوا و دسترسی‌ها را نمایش می‌دهد.

---

مثال:

Guest:

- معرفی سرویس
- اطلاعات عمومی
- ثبت Ticket

Customer:

- Dashboard
- Ticket
- Contract
- Service Information

Admin / Manager:

- Management Dashboard
- Administrative Sections

---

# 6. Login & Register

تصمیم:

Login و Register در یک Flow قرار می‌گیرند.

بعد از Login:

Role کاربر تعیین می‌کند چه Dashboard یا Portalای نمایش داده شود.

---

# 7. Role Based UI

UI باید بر اساس Role تغییر کند.

مثلاً:

- تغییر Minimal در Navbar
- نمایش Notification مرتبط
- نمایش Dashboard مناسب

هدف:

User بدون شلوغی متوجه شود Login موفق بوده و در چه Contextی قرار دارد.

---

# 8. Design Philosophy

Design:

- Minimal
- Flat
- Modern
- Mobile First
- Accessible
- Consistent
- Large Click Areas
- Wizard Based Forms

---

# 9. Theme & Color System

تصمیم:

یک Design Palette تعریف شود.

هدف:

- تغییر Theme با هزینه کم
- امکان استفاده مجدد در پروژه‌های مختلف

---

# 10. Mobile Strategy

تصمیم:

در این فاز:

- Native Mobile App ساخته نمی‌شود.

راهکار:

## PWA

برای:

- Technical Pages
- Service Portal
- Customer Portal

استفاده می‌شود.

---

# 11. Portal Structure

## Service Portal

شامل:

```

Service Portal

|
|-- Guest Ticket

|
|-- Service Information

|
|-- Technical Pages

|
|-- PWA Accessible Content

```

---

## Customer Portal

شامل:

```

Customer Portal

|
|-- Dashboard

|
|-- Ticket

|
|-- Analysis Page

|
|-- Contracts

|
|-- Service Reports

|
|-- Notifications

```

---

# 12. Marketplace

ساختار اولیه:

```

Marketplace

|
|-- Products

|
|-- Services

|
|-- Information

```

دسترسی:

Guest:

- مشاهده اطلاعات عمومی

Customer:

- طبق Permission

---

# 13. Customer Lifecycle

مشتری جدید:

ابتدا بدون قرارداد است.

Flow:

```

Register

↓

New Customer

↓

Verification

↓

Customer Level Assignment

↓

Contract (Optional)

```

---

# 14. Customer Level

تصمیم:

Customer Lifecycle Level وجود دارد.

مثال:

```

New Customer

↓

Verified Customer

↓

Contract Customer

```

---

# 15. CRM

CRM ضروری است.

دلایل:

- مشتری جدید همیشه وجود دارد.
- Customer Lifecycle نیازمند مدیریت است.
- Lead و Opportunity نیاز است.

---

CRM مسئول:

- Customer Creation
- Customer Information
- Lead
- Opportunity

---

# 16. CRM Role Separation

CRM از Service جدا است.

ساختار:

```

CRM Manager

|

CRM User

```

Service Manager مسئول CRM نیست.

---

# 17. Customer Data

استاندارد Odoo حفظ می‌شود.

پشتیبانی:

- Company
- Multiple Contacts
- Multiple Addresses
- Multiple Sites

---

# 18. Helpdesk

تصمیم:

Helpdesk از OCA بررسی و استفاده می‌شود.

هدف:

- Community Supported
- قابل توسعه
- هماهنگ با Odoo

---

# 19. Field Service

Field Service مورد نیاز است.

ارتباط:

```

Ticket

↓

Task

↓

Technician

↓

Service Report

```

---

# 20. Maintenance

تصمیم:

Odoo Maintenance فعلاً وارد Core System نمی‌شود.

دلایل:

- شرکت فعلاً تجهیزات داخلی زیادی ندارد.
- Assetها در Inventory قابل مدیریت هستند.
- PM به عنوان Service Task/Ticket دیده می‌شود.

---

Maintenance:

## Future Module

برای آینده حفظ می‌شود.

---

# 21. Localization

نیازمندی:

پشتیبانی:

- فارسی
- انگلیسی
- تقویم شمسی
- تقویم میلادی

---

Localization باید:

- استاندارد باشد.
- ترجیحاً از OCA استفاده شود.

---

# 22. Customer Notification

Notification باید Role Based باشد.

مثال:

Customer:

- Ticket Update
- Invoice Due
- Approval Request

Service Manager:

- New Ticket
- SLA Warning

---

# 23. Notification Principle

Notification:

```

Event

*

Permission

*

Recipient

*

Channel

```

---

# 24. Phase 1 Notification Channel

تصمیم:

فقط:

- Portal Notification
- In-App Notification

Email / SMS در فازهای بعدی بررسی می‌شود.

---

# 25. Final Architecture Principle

اصل نهایی:

```

Use Standard Odoo

*

Use OCA Where Needed

*

Customize Only Business Gaps

```

---

# DOC-018 Final Status

## LOCKED ✅
