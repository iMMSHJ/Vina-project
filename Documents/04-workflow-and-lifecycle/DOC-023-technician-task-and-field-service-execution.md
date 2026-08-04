# DOC-023 — Technician Task & Field Service Execution

**Version:** 1.1
**Status:** Locked

---

# 1. Purpose

این سند فرآیند اجرای خدمات میدانی، مدیریت Task، فعالیت کارشناسان، ثبت زمان، قطعات و تکمیل سرویس را تعریف می‌کند.

هدف:

* اجرای استاندارد Service Operation
* ثبت کامل History
* محاسبه KPI
* اتصال Service به Inventory و Accounting

---

# 2. Service Structure

مدل اصلی:

```text
Ticket

↓

Work Order / Task

↓

Activities

↓

Service Report

↓

Ticket Closure
```

---

# 3. Work Order Assignment

پس از بررسی Ticket توسط Service Manager:

یک Work Order ایجاد می‌شود.

ساختار تیم:

```text
Work Order

|

+ Lead Technician (Required)

+ Supporting Technicians (Optional)
```

---

## Responsibility

Lead Technician:

* مسئول اصلی اجرا
* ثبت نتیجه
* درخواست قطعه
* تکمیل گزارش

Supporting Technician:

* ثبت فعالیت خودش
* ثبت زمان خودش
* کمک در اجرا

---

# 4. Technician Dashboard

کارشناس در Dashboard:

مشاهده می‌کند:

* Assigned Tasks
* Due Date
* Priority
* Customer
* Asset
* SLA Status

---

# 5. Technician Task View

اطلاعات ثابت:

* Customer Name
* Asset
* Model
* Serial Number
* Site Address
* Contract Information (Limited)
* Reported Issue
* Error Code
* Attachments
* Service Manager Hint

---

کارشناس:

❌ Contract Details کامل
❌ Customer Credit Status

را مشاهده نمی‌کند.

---

# 6. Activity Management

هر Technician فعالیت خودش را ثبت می‌کند.

مثال:

```text
Ticket 1001

Work Order 1

|

+ Masoud Activity
  5 Hours

+ Ali Activity
  4 Hours
```

اما:

این به معنی 9 ساعت سرویس نیست.

چون:

در یک Work Order و زمان مشترک انجام شده است.

---

# 7. Time Sheet

Time Sheet مستقل از Service Duration است.

هر کارشناس:

* Time Sheet خودش را دارد.

---

Time Sheet:

برای:

* Payroll
* Internal Cost
* KPI

است.

---

Service Duration:

برای:

* Customer Service Calculation
* SLA
* Performance

است.

---

# 8. Part Request Management

## Permission

فقط:

### Lead Technician

می‌تواند Part Request ایجاد کند.

---

Technician همراه:

❌ ایجاد درخواست قطعه ندارد.

---

# 9. Part Request Timing

درخواست قطعه ممکن است:

## Before Visit

بر اساس تجربه و Diagnosis اولیه

یا:

## During Service

بعد از بررسی دستگاه

ایجاد شود.

---

# 10. Part Request Structure

Dynamic:

```text
Part Request

|

+ Part Line 1

+ Add Part

+ Part Line 2

+ Add Part

+ Part Line 3
```

---

هر Part Line:

* Part
* Quantity
* Reason
* Source
* Usage Type
* Serial/Lot
* Required Date
* Status

---

# 11. Part Source

## Customer Owned

قطعه متعلق به مشتری است.

نتیجه:

* وارد Inventory شرکت نمی‌شود
* فقط در History ثبت می‌شود

---

## Marketplace / Purchase

قطعه از مسیر خرید تجاری تامین می‌شود.

---

## Company Stock

قطعه متعلق به شرکت است.

کاربرد:

* Loan
* Test
* Replacement Stock

---

# 12. Part Usage Type

## Replacement

قطعه جدید جایگزین قطعه خراب می‌شود.

---

## Exchange

قطعه جدید تحویل می‌شود و قطعه قبلی باید برگشت داده شود.

---

## Loan

قطعه امانی نزد مشتری قرار می‌گیرد.

---

## Test

قطعه تستی برای Diagnosis استفاده می‌شود.

---

# 13. Part Approval Flow

```text
Lead Technician

↓

Part Request

↓

Service Manager Review

↓

Approval / Reject

↓

Warehouse

↓

Issue
```

---

# 14. Responsibility Matrix (RACI)

## Part Request Creation

| Role            | Responsibility |
| --------------- | -------------- |
| Lead Technician | Responsible    |
| Service Manager | Accountable    |
| Warehouse       | Consulted      |
| Accounting      | Informed       |

---

## Warehouse Issue

| Role            | Responsibility |
| --------------- | -------------- |
| Warehouse       | Responsible    |
| Service Manager | Accountable    |
| Technician      | Informed       |
| Accounting      | Informed       |

---

## Loan Return

| Role            | Responsibility |
| --------------- | -------------- |
| Warehouse       | Responsible    |
| Service Manager | Accountable    |
| Customer        | Consulted      |
| Accounting      | Informed       |

---

# 15. Loan/Test Tracking

برای Company Stock که خارج می‌شود:

ثبت می‌شود:

* Part
* Serial Number
* Customer
* Asset
* Ticket
* Technician
* Issue Date
* Expected Return Date
* Actual Return Date

---

Status:

```text
Issued

↓

Installed

↓

Waiting Return

↓

Returned

↓

Inspection
```

---

# 16. Warehouse Notification

برای قطعات امانی و تست:

قبل از موعد:

Reminder

بعد از موعد:

Overdue Notification

گیرنده:

* Warehouse
* Service Manager

---

# 17. Service Report

پس از پایان کار:

ثبت:

* Problem Found
* Action Taken
* Parts Used
* Parts Requested
* Loan Status
* Attachments
* Customer Confirmation

---

# 18. Completion Rules

Task زمانی Complete می‌شود که:

* Activityها ثبت شده باشند
* نتیجه سرویس ثبت شده باشد
* وضعیت قطعات مشخص باشد

---

Loan لازم نیست حتماً برگشته باشد، ولی باید Tracking فعال داشته باشد.

---

# 19. KPI

محاسبه:

* Task Completion Time
* Report Delay
* Technician Performance
* Part Request Cycle Time
* Loan Return Delay
* Test Part Cycle Time

---

# 20. Integration

ارتباط:

```text
Field Service

↓

Inventory

↓

Accounting

↓

Customer Service Management
```

---

# Final Decision

✅ استاندارد Odoo حفظ می‌شود.
✅ Workflow اختصاصی فقط در UX و Dashboard ایجاد می‌شود.
✅ RACI از طریق Permission و Approval پیاده می‌شود.
✅ Part Lifecycle کامل شد.
✅ DOC-023 آماده اجرا است.

---

🔒 **DOC-023 — LOCKED**
