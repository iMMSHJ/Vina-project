# DOC-024 — Service Completion & Ticket Closure

**Version:** 1.0  
**Status:** Locked

---

# 1. Purpose

این سند فرآیند پایان عملیات سرویس، تایید مشتری، بسته شدن Work Order و Ticket و محاسبه KPI را مشخص می‌کند.

هدف:

- اطمینان از ثبت کامل سرویس
- حفظ تایید مشتری
- محاسبه صحیح KPI
- آماده‌سازی اطلاعات برای Accounting

---

# 2. Completion Responsibility

Technician مسئول انجام سرویس و ثبت گزارش است.

اما:

Technician مسئول بستن Ticket نیست.

---

Flow:

```

Technician

↓

Complete Work Order Report

↓

Customer Confirmation

↓

Service Manager Review

↓

Ticket Closure

```

---

# 3. Technician Completion Deadline

بعد از انجام سرویس:

Technician موظف است تا پایان همان روز:

- Activityها را ثبت کند.
- Timesheet را ثبت کند.
- گزارش کار را تکمیل کند.
- وضعیت قطعات را مشخص کند.
- Completion را اعلام کند.

---

اگر Technician:

- گزارش را ثبت نکند.
- با تاخیر ثبت کند.

سیستم:

- KPI منفی برای Technician ثبت می‌کند.
- Delay در Performance History ذخیره می‌شود.

---

# 4. Technician Final Report

Technician در پایان Work Order اطلاعات زیر را ثبت می‌کند:

## Service Result

- مشکل مشاهده شده
- علت مشکل
- اقدامات انجام شده
- نتیجه نهایی

---

## Documentation

- عکس
- فایل
- گزارش سرویس

---

## Parts

- Requested Parts
- Used Parts
- Returned Parts
- Loan Equipment Status

---

# 5. Customer Confirmation Process

بعد از تکمیل گزارش:

سه حالت وجود دارد.

---

# 5.1 Digital Signature

Customer از Portal تایید دیجیتال انجام می‌دهد.

Flow:

```

Technician Complete

↓

Customer Notification

↓

Digital Signature

↓

Service Manager Review

↓

Close Ticket

```

---

# 5.2 Physical Signature

Technician:

- فرم سرویس را چاپ می‌کند.
- امضای مشتری را دریافت می‌کند.
- تصویر سند را در سیستم ثبت می‌کند.

---

سپس:

Service Manager بررسی کرده و Ticket را می‌بندد.

---

# 5.3 Customer Does Not Accept / Receive

ممکن است مشتری:

- حضور نداشته باشد.
- تحویل را تایید نکند.
- امضا ارائه ندهد.

---

در این حالت:

Technician ثبت می‌کند:

```

Customer Unavailable

```

یا:

```

Customer Refused Signature

```

---

شامل:

- دلیل
- توضیح
- مستندات

---

Service Manager تصمیم نهایی را می‌گیرد.

---

# 6. Ticket Closure Permission

سطح دسترسی:

## Technician

❌ Close Ticket ندارد.

---

## Service Manager

✅ Review Completion  
✅ Confirm Result  
✅ Close Ticket

---

## Higher Management

طبق Permission Hierarchy امکان Override دارد.

---

# 7. Cancelled Ticket Process

اگر Ticket قبل از Completion لغو شود:

---

## Case 1 — No Work Order Created

```

Ticket

↓

Cancelled

```

---

## Case 2 — Work Order Exists

```

Ticket

↓

Work Order

↓

Activities Recorded

↓

Cancel Reason

↓

Service Manager Close Ticket

```

---

Activityهای انجام شده حذف نمی‌شوند.

---

# 8. Ticket Final Status

Statusهای اصلی:

```

Completed

Failed

Cancelled

Postponed

```

---

# 9. Completed Status

زمانی استفاده می‌شود که:

- سرویس انجام شده.
- نتیجه مشخص است.
- گزارش ثبت شده.
- تایید مشتری دریافت شده یا طبق Rule تایید شده است.

---

# 10. Failed Status

زمانی استفاده می‌شود که سرویس موفق نبوده است.

دلایل باید مشخص شود.

مثال:

```

Technical Issue

Customer Limitation

Missing Information

External Dependency

```

---

# 11. Cancelled Status

برای توقف کامل درخواست.

اجباری:

- Cancel Reason
- Responsible Party

---

مثال:

```

Customer Requested Cancellation

Wrong Request

No Access To Site

```

---

# 12. Postponed Status

برای مواردی که سرویس فعلاً متوقف شده است.

---

اجباری:

- Postpone Reason
- Expected Review Date

---

بعد از تاریخ تعیین شده:

تصمیم جدید گرفته می‌شود.

---

# 13. KPI Calculation

در زمان بستن Ticket:

Service Manager KPI سرویس را نهایی می‌کند.

---

موارد KPI:

## SLA Performance

- Response Time
- SLA Compliance

---

## Service Performance

- Resolution Time
- Number Of Visits
- Number Of Work Orders

---

## Technician Performance

- Report Delay
- Completion Quality
- Activity Accuracy

---

# 14. Service Duration vs Timesheet

این دو مفهوم متفاوت هستند.

---

## Service Duration

برای:

- Customer KPI
- SLA Analysis
- Service Performance

---

## Technician Timesheet

برای:

- Employee Cost
- Resource Analysis

---

Rule:

```

Service Duration ≠ Technician Timesheet

```

---

Example:

```

Service Visit:

10:00 - 15:00

Duration:
5 Hours

Timesheet:

Masoud:
5 Hours

Ali:
4 Hours

```

---

نتیجه:

Service Duration:

5 Hours

Timesheet Total:

9 Hours

---

# 15. Final Service Data

قبل از Close شدن Ticket:

اطلاعات زیر باید تکمیل شده باشد:

---

## Technical

- Final Result
- Resolution
- Attachments

---

## Time

- Service Duration
- Technician Timesheet

---

## Material

- Used Parts
- Part Cost

---

## Customer

- Signature Status
- Confirmation Result

---

# 16. Accounting Notification

بعد از بسته شدن Ticket:

Accounting Notification ارسال می‌شود.

---

اطلاعات اولیه:

```

Service Completed

Ticket Number

Customer

Asset

Final Status

Parts Used

Ready For Financial Review

```

---

جزئیات مالی در فرآیند Accounting بررسی خواهد شد.

---

# 17. Final Process Flow

```

Work Order Completed

↓

Technician Report

↓

Customer Confirmation

```
    |
    |
    +-- Digital Signature
    |
    +-- Physical Signature
    |
    +-- Customer Unavailable
```

↓

Service Manager Review

↓

KPI Calculation

↓

Parts / Service Data Finalize

↓

Close Ticket

↓

Accounting Notification

```

---

# Final Decisions

✅ Technician انجام سرویس را ثبت می‌کند.  
✅ Technician Ticket را نمی‌بندد.  
✅ Customer Confirmation بخشی از Completion Process است.  
✅ Service Manager مسئول Closure است.  
✅ Cancel شدن Ticket نیاز به ثبت دلیل دارد.  
✅ Postpone نیاز به تاریخ بازبینی دارد.  
✅ Failed نیاز به علت دارد.  
✅ Service Duration با Timesheet متفاوت است.  
✅ بعد از Closure اطلاعات برای Accounting ارسال می‌شود.  

---

**DOC-024 — LOCKED**
