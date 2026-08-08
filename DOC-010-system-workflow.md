# DOC-010
# System Workflow

**Status:** Approved

---

# Purpose

تعریف گردش کار اصلی سیستم از زمان ایجاد درخواست سرویس تا پایان فرآیند.

این سند ارتباط تمام موجودیت‌های سیستم را مشخص می‌کند و به عنوان نقشه اصلی پروژه استفاده می‌شود.

---

# Workflow Overview

Guest / Customer

↓

Service Request (Ticket)

↓

Service Manager Review

↓

Contract & SLA Validation

↓

Technician Assignment

↓

Service Execution

↓

Service Report

↓

Customer Feedback

↓

Service Manager Review

↓

Ticket Closed

---

# Workflow Details

## Step 1 — Service Request

درخواست سرویس توسط یکی از موارد زیر ثبت می‌شود.

- Guest
- Customer

اطلاعات اولیه دریافت می‌شود.

- Device
- Description
- Contact Information
- (در صورت وجود) Asset
- (در صورت وجود) Contract

---

## Step 2 — Service Manager Review

مدیر سرویس درخواست را بررسی می‌کند.

موارد بررسی

- اطلاعات دستگاه
- قرارداد
- SLA
- اولویت
- نیاز به بازدید
- نیاز به قطعات

---

## Step 3 — Contract Validation

در صورت وجود قرارداد

سیستم بررسی می‌کند

- Package
- Contract Status
- SLA
- Coverage

در صورت نبود قرارداد

Ticket همچنان قابل ادامه است.

---

## Step 4 — Technician Assignment

مدیر سرویس Technician مناسب را انتخاب می‌کند.

معیارها

- تخصص
- موقعیت
- برنامه کاری
- SLA

---

## Step 5 — Service Execution

Technician عملیات سرویس را انجام می‌دهد.

نمونه

- Remote Support
- Phone Support
- Onsite Visit
- Workshop Repair
- Preventive Maintenance

---

## Step 6 — Service Report

Technician گزارش عملیات را ثبت می‌کند.

شامل

- Technical Report
- Time Sheet
- Parts Used
- Attachments

هر مراجعه یا تلاش برای ارائه سرویس دارای یک Service Report مستقل است.

یک Ticket می‌تواند شامل چندین Service Report باشد.

---

## Step 7 — Customer Feedback

پس از ثبت گزارش سرویس

Customer می‌تواند

- Digital Signature
- Comment

ثبت کند.

ثبت نظر مشتری مانع ادامه Workflow نخواهد شد.

---

## Step 8 — Service Manager Review

مدیر سرویس گزارش را بررسی می‌کند.

در صورت نیاز

- ارجاع مجدد
- درخواست مراجعه مجدد
- تغییر Technician
- ادامه فرآیند

---

## Step 9 — Close Ticket

پس از تأیید مدیر سرویس

Ticket بسته می‌شود.

Possible Results

- Success
- Failed
- Postponed
- Boycotted
- Canceled

---

# Side Processes

در طول Workflow ممکن است فرآیندهای زیر اجرا شوند.

## Contract

بررسی اعتبار قرارداد

---

## SLA

محاسبه اولویت و زمان پاسخگویی

---

## Package

تشخیص تجهیزات تحت پوشش

---

## Asset

مشاهده تاریخچه دستگاه

---

## Inventory

- Issue Parts
- Return Parts
- Consume Parts

---

## Accounting

در صورت نیاز

- Invoice
- Service Cost

---

## Timesheet

ثبت زمان انجام سرویس

---

## Customer Portal

نمایش

- Ticket Status
- Service Reports
- Attachments
- Comments

---

# Printable Documents

سیستم باید امکان تولید PDF برای موارد زیر را داشته باشد.

- Service Report
- Ticket Summary
- Customer Signature

---

# Workflow Principles

- Every Request Creates One Ticket.
- One Ticket Can Have Multiple Service Reports.
- Every Service Report Represents One Service Attempt.
- Service Manager Controls The Workflow.
- Customer Provides Feedback.
- Inventory Uses Native Odoo Stock.
- Security Uses Native Odoo ACL.
- Odoo First.
- OCA First.
- Custom Last.

---

# Odoo Mapping

| Business Process | Odoo |
|------------------|------|
| Ticket | helpdesk.ticket |
| Customer Portal | portal |
| Website | website |
| Asset | maintenance.equipment (Customized) |
| Contract | sale.subscription / custom |
| SLA | helpdesk_sla (OCA) |
| Inventory | stock |
| Service Report | Custom Module |
| Timesheet | account.analytic.line |
| Attendance | hr.attendance |
| Accounting | account.move |
| Attachments | ir.attachment |
| Activities | mail.activity |

---

# Notes

Workflow بر پایه قابلیت‌های استاندارد Odoo طراحی شده است.

تمام توسعه‌های سفارشی باید حداقل ممکن باشند و فقط در بخش‌هایی انجام شوند که توسط Odoo یا OCA پوشش داده نمی‌شوند.

هدف پروژه ایجاد یک اکوسیستم ماژولار، ساده، قابل توسعه و قابل نگهداری است.

---

**Status:** Approved
