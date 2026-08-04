# DOC-033 — Technician Expense & Cost Management

**Version:** 1.0  
**Status:** 🔒 LOCKED


# 1. Purpose

تعریف فرآیند مدیریت هزینه‌های Technician مرتبط با عملیات سرویس.

هدف:

- ثبت شفاف هزینه‌ها
- جلوگیری از هزینه بدون تایید
- کنترل هزینه‌های سرویس
- ایجاد فرآیند مشخص برای بازپرداخت Technician


---

# 2. Scope

## Phase 1 Included

✅ Technician Expense Registration

✅ Receipt / Evidence Attachment

✅ Service Manager Approval

✅ Accounting Payment

✅ Technician Settlement Tracking


## Phase 1 Out of Scope

❌ Company Advance

❌ Petty Cash Management

❌ Advance Balance Tracking

❌ Advance Settlement


Future Capability:

Company Advance / Petty Cash Management


---

# 3. Role Responsibility


## Technician

Responsible for:

- ثبت هزینه
- ارائه مدرک
- توضیح دلیل هزینه
- پیگیری وضعیت تسویه


عدم دسترسی:

- تایید هزینه
- پرداخت هزینه
- مشاهده مالی مشتری


---

## Service Manager

Responsible for:

- بررسی ارتباط هزینه با سرویس
- بررسی ضرورت هزینه
- تایید یا رد Expense


Actions:

- Approve
- Reject
- Request Information


---

## Accounting

Responsible for:

- پرداخت هزینه تایید شده
- ثبت عملیات مالی داخلی


Accounting بررسی فنی انجام نمی‌دهد.


---

# 4. Expense Flow

Phase 1 Flow:


```

Technician

↓

Create Expense Request

↓

Service Manager Approval

↓

Accounting Payment

↓

Technician Confirmation

↓

Done

```


---

# 5. Expense Creation


## User Story

به عنوان Technician می‌خواهم هزینه انجام شده برای سرویس را ثبت کنم.


Information:

- Expense Type
- Amount
- Date
- Description
- Receipt
- Related Ticket
- Related Task


Rule:

هر Expense باید به Service Operation مرتبط باشد.


---

# 6. Expense Type

Phase 1:

## Personal Payment

Technician هزینه را شخصاً پرداخت کرده و درخواست بازپرداخت می‌دهد.


Flow:


```

Expense Submitted

↓

Service Manager Approval

↓

Accounting Payment

↓

Technician Settlement

↓

Done

```


---

# 7. Technician Dashboard Integration


بخش:

```

My Expense Requests

```


نمایش:

- Draft
- Submitted
- Pending Approval
- Approved
- Paid
- Done


Technician می‌تواند:

- Expense جدید ثبت کند
- مدارک اضافه کند
- وضعیت را مشاهده کند


---

# 8. Service Manager Dashboard Integration


بخش:

```

Technician Requests

├── Expense Requests
├── Part Requests
└── Service Updates

```


نمایش:

- Technician
- Ticket
- Task
- Amount
- Reason
- Attachment


Actions:

- Approve
- Reject
- Request Information


---

# 9. Expense Status


```

Draft

↓

Submitted

↓

Service Manager Approved

↓

Accounting Paid

↓

Technician Confirmed

↓

Done

```


---

# 10. Cost Traceability


هر هزینه باید قابل ردیابی باشد:


```

Expense

↓

Technician

↓

Task

↓

Ticket

↓

Customer

↓

Asset

```


---

# 11. Financial Boundary


Technician می‌تواند ببیند:

✅ Expense خودش

✅ Approval Status

✅ Payment Status


Technician نمی‌تواند ببیند:

❌ Customer Invoice

❌ Customer Payment

❌ Contract Value

❌ Customer Credit

❌ Service Profitability


---

# 12. Future Capability


## Company Advance / Petty Cash


در آینده:


```

Company Advance

↓

Expense Usage

↓

Balance Tracking

↓

Settlement

```


---

# Final Decision


✅ Expense Management مستقل

✅ Integrated with Technician Dashboard

✅ Integrated with Service Manager Approval Queue

✅ Accounting Execution After Approval

✅ No Customer Financial Access

✅ No Petty Cash in Phase 1


---

# Status

🔒 DOC-033 LOCKED
