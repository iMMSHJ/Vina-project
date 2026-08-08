# DOC-025 — Odoo Standard Alignment & Customization Boundary

**Version:** 1.0  
**Status:** Locked

---

# 1. Purpose

این سند مرز بین قابلیت‌های استاندارد Odoo و بخش‌های سفارشی پروژه را مشخص می‌کند.

اهداف:

- جلوگیری از توسعه غیرضروری
- حفظ قابلیت Upgrade Odoo
- استفاده حداکثری از Core استاندارد
- ایجاد تجربه کاربری متناسب با نیاز Business

---

# 2. Core Principle

اصل معماری:

```

Odoo Core Process = Standard

Business Experience = Custom

```

---

یعنی:

- فرآیندهای اصلی در Odoo حفظ می‌شوند.
- فقط نقاطی که تجربه کاربر نیاز به ساده‌سازی یا تغییر دارد Custom می‌شوند.

---

# 3. Odoo Standard First Approach

سیستم نباید قابلیت‌هایی که Odoo به صورت استاندارد ارائه می‌دهد را دوباره پیاده‌سازی کند.

---

استفاده از استاندارد Odoo برای:

- Helpdesk
- Field Service
- Project Task
- Timesheet
- Inventory
- Accounting
- CRM
- Contacts
- Portal

---

# 4. Customization Boundary

## 4.1 Custom Components

سه بخش اصلی Custom ساخته می‌شود.

---

# A. Customer Ticket Wizard

هدف:

ایجاد تجربه ساده برای ثبت Ticket.

---

جایگزین:

Odoo Standard Ticket Form

---

Backend:

Odoo Helpdesk Ticket

---

قابلیت‌ها:

- Guest Customer Submission
- Registered Customer Submission
- Contact Information
- Asset Selection
- Issue Description
- Attachment Upload
- SLA Calculation
- Ticket Creation

---

Flow:

```

Customer

↓

Custom Wizard

↓

Odoo Ticket Creation

```

---

# B. Technician Dashboard

هدف:

عدم استفاده مستقیم Technician از Backend پیچیده Odoo.

---

Backend:

Odoo Field Service / Project Task

---

Dashboard شامل:

- Assigned Work Orders
- Today Tasks
- Pending Activities
- Waiting Parts
- Completed Tasks
- Personal KPI View

---

Technician فقط اطلاعات مورد نیاز خود را مشاهده می‌کند.

---

# C. Customer Portal Experience

هدف:

ایجاد تجربه مشتری ساده و حرفه‌ای.

---

Backend:

Odoo Portal

---

Customer View:

- Assets
- Tickets
- Contracts
- Service History
- Documents
- Invoice Information (طبق Permission)

---

# 5. Non-Customized Core Modules

موارد زیر Custom نمی‌شوند.

---

## Helpdesk

استفاده از:

- Ticket
- SLA
- Stage
- Assignment
- Priority

---

## Field Service / Task

استفاده از:

- Task
- Assignment
- Worksheet
- Activity

---

## Timesheet

استفاده از:

- Employee Timesheet
- Cost Tracking
- Analytic Accounting

---

## Inventory

استفاده از:

- Stock
- Warehouse
- Part Movement
- Delivery

---

## Accounting

استفاده از:

- Invoice
- Payment
- Financial Reporting

---

## CRM

استفاده از:

- Customer Management
- Lead
- Opportunity

---

# 6. User Management Strategy

Version 1 از IAM مستقل استفاده نمی‌کند.

---

اصل:

```

Odoo User Management = Source of Access Control

```

---

مدیریت دسترسی با:

- Odoo Users
- Odoo Groups
- Access Rights
- Record Rules

انجام می‌شود.

---

IAM در آینده به عنوان Layer خارجی قابل اضافه شدن است.

---

# 7. Role & Permission Strategy

Roleها با Odoo Groups مدیریت می‌شوند.

---

مدل:

```

User

↓

Odoo Groups

↓

Access Rights

↓

Record Rules

```

---

یک User می‌تواند چند Role داشته باشد.

---

مثال:

```

User:

Ali Ahmadi

Groups:

Service Manager

*

CRM Manager

```

---

# 8. Business Roles

## 8.1 Super Admin

مسئول:

- Technical Configuration
- Security Settings
- System Administration

---

## 8.2 CEO

بالاترین سطح Business.

دسترسی:

- Business Visibility
- Approval
- Exception Handling

---

## 8.3 Service Manager

مالک فرآیند سرویس.

مسئول:

- Ticket Management
- Work Order Assignment
- Technician Management
- Service KPI

---

## 8.4 CRM

سطوح:

### CRM User

- Customer Management
- Communication

### CRM Manager

- Team Management
- Reporting

---

## 8.5 Accounting / Finance

سطوح:

### Accounting User

- Financial Operations

### Accounting Manager

- Financial Control

---

## 8.6 Inventory

سطوح:

### Inventory User

- Stock Operations

### Inventory Manager

- Warehouse Management

---

## 8.7 Technician

دسترسی محدود:

- Assigned Tasks Only
- Own Activities
- Own Timesheet
- Service Reports

---

# 9. Permission Philosophy

اصل:

```

Higher Management inherits visibility,
not operational ownership.

```

---

مثال:

CEO:

✅ مشاهده اطلاعات

اما:

❌ مسئول اجرای روزانه سرویس نیست.

---

Service Manager:

مالک عملیات سرویس است.

---

# 10. Future IAM Integration

IAM بخشی از Version 1 نیست.

---

در آینده امکان اضافه شدن:

- SSO
- MFA
- External Identity Provider
- Advanced Access Governance

وجود دارد.

---

بدون تغییر در:

- Business Object
- Workflow
- Core Process

---

# 11. Architecture Model

```

Custom User Experience Layer

↓

Odoo Standard Modules

↓

Odoo Database

```

---

# 12. Final Decisions

✅ Odoo Core حفظ می‌شود.  
✅ Customization فقط در Experience Layer انجام می‌شود.  
✅ Ticket Engine سفارشی ساخته نمی‌شود.  
✅ Task Engine سفارشی ساخته نمی‌شود.  
✅ Timesheet Engine سفارشی ساخته نمی‌شود.  
✅ Inventory و Accounting استاندارد باقی می‌مانند.  
✅ User Management با Odoo انجام می‌شود.  
✅ IAM برای Future Enhancement نگه داشته می‌شود.  
✅ سه بخش اصلی Custom:

1. Customer Ticket Wizard  
2. Technician Dashboard  
3. Customer Portal Experience  

---

# DOC-025 — LOCKED
