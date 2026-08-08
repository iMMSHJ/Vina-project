# DOC-007
# Service Report

**Status:** Approved

---

# Purpose

Service Report نتیجه هر تلاش برای ارائه سرویس است.

هر بار اقدام کارشناس، چه حضوری و چه غیرحضوری، یک Service Report مستقل ایجاد می‌کند.

Service Report سابقه کامل عملیات انجام‌شده روی Asset را ثبت می‌کند.

---

# Business Rules

## BR-001

هر تلاش برای ارائه سرویس یک Service Report ایجاد می‌کند.

نمونه:

- Remote Support
- Phone Support
- Online Session
- Onsite Visit
- Follow-up Visit

---

## BR-002

یک Ticket می‌تواند شامل چندین Service Report باشد.

نمونه:

Ticket

↓

Remote Support

↓

Onsite Visit

↓

Second Visit

↓

Resolved

---

## BR-003

Service Report توسط Technician ثبت می‌شود.

---

## BR-004

بستن Ticket فقط توسط Service Manager انجام می‌شود.

Technician فقط گزارش سرویس ثبت می‌کند.

---

## BR-005

تمام Time Sheet ها به Service Report متصل هستند.

در صورت تغییر Technician، تمام سوابق حفظ می‌شود.

---

## BR-006

هر Service Report فقط به یک Asset تعلق دارد.

---

## BR-007

هر Service Report متعلق به یک Ticket است.

---

# Required Fields

- Ticket
- Asset
- Technician
- Service Type
- Start Time
- End Time
- Working Duration
- Report Date

---

# Service Type

- Remote Support
- Phone Support
- Online Support
- Onsite Visit
- Workshop Repair
- Inspection
- Preventive Maintenance
- Installation
- Training
- Other

---

# Technical Report

Technician اطلاعات زیر را ثبت می‌کند.

- Problem Description
- Root Cause
- Diagnostic Process
- Actions Performed
- Recommendations
- Next Action (Optional)

---

# Parts

Service Report فقط قطعات استفاده‌شده یا درخواست‌شده را ثبت می‌کند.

کنترل موجودی، تحویل، بازگشت و وضعیت قطعات در DOC-008 تعریف می‌شود.

---

# Time Sheet

هر Service Report دارای Time Sheet مستقل است.

نمونه:

- Travel Time
- Waiting Time
- Working Time
- Remote Support Time

تمام زمان‌ها در Ticket تجمیع می‌شوند.

---

# Attachments

امکان ثبت موارد زیر وجود دارد.

- Images
- Videos
- Log Files
- Documents
- Configuration Files

---

# Customer Confirmation

در صورت نیاز:

- Customer Signature
- Customer Name
- Confirmation Date

ثبت می‌شود.

عدم تأیید مشتری مانع ثبت گزارش نخواهد بود.

---

# Reassignment

Technician می‌تواند درخواست Reassignment ثبت کند.

انتقال Technician فقط پس از تأیید Service Manager انجام می‌شود.

تمام Service Report ها و Time Sheet های قبلی حفظ خواهند شد.

---

# Ticket Result

نتیجه نهایی Ticket توسط Service Manager تعیین می‌شود.

Possible Results

- Success
- Failed
- Postponed
- Boycotted
- Canceled

---

# Ticket Status

نمونه Status های عملیاتی

- New
- Assigned
- In Progress
- Waiting Customer
- Waiting Parts
- On Hold
- Completed
- Closed

Status با Result متفاوت است.

---

# Odoo Mapping

| Business Entity | Odoo |
|-----------------|------|
| Ticket | helpdesk.ticket |
| Service Report | Custom Model |
| Technician | hr.employee |
| Timesheet | account.analytic.line |
| Attendance | hr.attendance |
| Attachments | ir.attachment |
| Activities | mail.activity |
| Chatter | mail.thread |

---

# Design Principles

- One Attempt = One Service Report
- One Ticket = Many Service Reports
- One Service Report = One Asset
- Technician Reports
- Service Manager Closes Ticket
- Time Sheet Never Lost
- Full History Preservation
- Odoo First
- OCA First
- Custom Last

---

# Notes

Service Report نمایانگر هر تلاش واقعی برای ارائه سرویس است.

موفق یا ناموفق بودن تلاش اهمیتی در ایجاد Report ندارد.

تمام عملیات، حتی تماس تلفنی یا Remote Support، باید دارای Service Report باشند تا تاریخچه کامل سرویس تجهیزات حفظ شود.

---

**Status:** Approved
