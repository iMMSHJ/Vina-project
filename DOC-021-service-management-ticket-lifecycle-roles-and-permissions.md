# DOC-021 — Service Management, Ticket Lifecycle, Roles & Permissions

**Status:** LOCKED  
**Phase:** Phase 3  
**Document Type:** Business Process & Access Control Design

---

# 1. Objective

هدف این داکیومنت تعریف فرآیند کامل مدیریت سرویس شامل:

- Ticket Management
- Task Management
- Service Execution
- SLA
- Notification
- Expense
- Roles
- Permissions

است.

---

# 2. Service Management Philosophy

اصل اصلی:

هر درخواست سرویس باید قابل پیگیری، قابل گزارش و قابل اندازه‌گیری باشد.

Flow اصلی:

```

Customer

↓

Ticket

↓

Task

↓

Technician

↓

Service Report

↓

Closure

```

---

# 3. Ticket Creation

Ticket می‌تواند توسط:

- Guest
- Customer
- Internal User

ایجاد شود.

---

Ticket اولیه شامل:

- Customer
- Contact
- Site
- Asset (در صورت وجود)
- Description
- Priority
- SLA

است.

---

# 4. SLA Definition

SLA فقط به معنی:

## Response Commitment

است.

یعنی تعهد زمانی برای پاسخگویی.

---

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

SLA تاثیر مستقیم دارد روی:

- Priority
- Notification
- Escalation

---

# 5. Ticket Priority

Priority بر اساس SLA تعیین می‌شود.

اما Service Manager در شرایط خاص می‌تواند تصمیم عملیاتی بگیرد.

---

# 6. Ticket Assignment

وقتی Ticket Assigned می‌شود:

حداقل یک Task باید ایجاد شود.

---

Flow:

```

Service Manager

↓

Assign Technician

↓

Create Task

↓

Technician Notification

```

---

# 7. Task Management

Task فعالیت واقعی سرویس است.

---

تصمیم:

Task فقط توسط Technician انجام می‌شود.

---

Technician باید ثبت کند:

- Time Sheet
- Work Description
- Attachment
- Service Report

---

# 8. Technician Access

Technician فقط می‌بیند:

```

Assigned Tasks

```

نه:

- تمام Ticketهای تیم
- تمام مشتری‌ها
- تمام قراردادها

---

# 9. Service Report

هر Task باید گزارش انجام داشته باشد.

گزارش شامل:

- شرح فعالیت
- زمان انجام
- نتیجه
- قطعات مصرفی
- قطعات امانی
- وضعیت نهایی

---

# 10. Parts / Material Tracking

اگر Technician:

- قطعه مصرف کند
- قطعه امانت بگیرد

ثبت وضعیت اجباری است.

---

اطلاعات:

- قطعه
- تعداد
- وضعیت
- برگشت / مصرف

---

# 11. Ticket Closure

Ticket چند حالت پایان دارد:

---

## 1. Customer Signature

تایید مشتری

---

## 2. Success Done

مشکل حل شده است.

---

## 3. Failed

باید دلیل مشخص شود.

مثال:

- مشکل از مشتری
- مشکل از سرویس
- عدم امکان رفع

---

## 4. Postpone

تیکت موقتاً متوقف می‌شود.

نیازمند:

- تاریخ پیگیری
- تصمیم بعدی

---

## 5. Cancelled

اجباری:

- دلیل لغو
- مسئول تصمیم

---

# 12. Ticket Reopen

اگر مشکل تکرار شود:

تصمیم:

ابتدا با Service Manager بررسی می‌شود.

---

اگر مشکل تکراری باشد:

Priority سرویس باید افزایش پیدا کند.

---

تصمیم نهایی:

Service Manager اختیار دارد:

- Reopen Ticket
- ایجاد Ticket جدید زیر Ticket قبلی

را انتخاب کند.

---

# 13. Ticket Date Management

تاریخ‌ها جداگانه مدیریت می‌شوند.

---

## Created Date

زمان ثبت درخواست

---

## Assigned Date

زمان ارجاع به کارشناس

---

## Execution Date

زمان شروع/انجام عملیات

---

## Completion Date

زمان پایان سرویس

---

Execution ممکن است چند روز طول بکشد و نباید با Completion اشتباه شود.

---

# 14. Customer Confirmation

فاز 1:

تایید مشتری داخل Portal انجام می‌شود.

---

بعد از تایید:

کارشناس Notification دریافت می‌کند.

---

# 15. Notification System

Notification باید Role Based باشد.

---

## Customer

مثال:

- Ticket Update
- Invoice Due
- Pending Approval

---

## Service Manager

مثال:

- New Ticket
- SLA Warning
- Escalation

---

## Technician

مثال:

- New Task Assigned
- Task Approved
- Task Changed

---

## Accounting

مثال:

- Expense Waiting Approval

---

# 16. Notification Channel

فاز 1:

فقط:

- Portal Notification
- In-App Notification

---

Email / SMS در فاز بعد بررسی می‌شود.

---

# 17. Expense Management

Expense از Odoo Expenses استفاده می‌کند.

ماژول جدید ساخته نمی‌شود.

---

کارشناس می‌تواند ثبت کند:

- Taxi
- Food
- Fuel
- Accommodation
- Other

---

Flow:

```

Technician

↓

Expense Submit

↓

Manager Review

↓

Accounting

↓

Paid

```

---

Customization:

فقط:

- Link Ticket
- Link Task

---

# 18. History & Archive

اصل:

Archive به جای Delete

---

Delete واقعی فقط:

Super Admin

---

History برای:

- سرویس
- قرارداد
- Asset
- Ticket

حفظ می‌شود.

---

# 19. Role Hierarchy

ساختار سازمانی:

```

Super Admin

```
    |


   CEO


    |
```

+----------------------+----------------------+----------------+

|                      |                      |

Service Manager    CRM Manager          Accounting

|

Technician

CRM Manager

|

CRM User

```

---

# 20. Roles Definition

## Super Admin

مسئول:

- Configuration
- Security
- Technical Access
- Delete

---

## CEO

مسئول:

- Management View
- KPI
- Business Dashboard

---

CEO:

Override عملیاتی روزانه انجام نمی‌دهد.

---

## Service Manager

مالک فرآیند سرویس:

- Ticket
- SLA
- Assignment
- Technician
- Closure

---

## Technician

عملیات فنی:

- Assigned Task
- Time Sheet
- Report
- Expense

---

## CRM Manager

مالک:

- Customer Lifecycle
- Lead
- Opportunity
- Customer Data

---

## CRM User

فعالیت‌های CRM

---

## Accounting

مالک:

- Invoice
- Payment
- Expense

---

# 21. Permission Principle

اصل:

```

Hierarchy ≠ Permission

```

---

جایگاه سازمانی و دسترسی عملیاتی جدا هستند.

---

مثال:

CEO می‌تواند KPI سرویس را ببیند.

ولی:

نمی‌تواند جای Service Manager فرآیند سرویس را تغییر دهد.

---

# 22. Customer Access

Customer فقط اطلاعات خودش را می‌بیند.

شامل:

- Own Ticket
- Own Contract
- Own Asset
- Own Report
- Own Invoice

---

# 23. Final Architecture

```

Customer

↓

Ticket

↓

Task

↓

Service Report

↓

Closure

↓

History

```

---

# DOC-021 Final Status

LOCKED ✅
