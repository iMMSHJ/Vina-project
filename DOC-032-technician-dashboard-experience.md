# DOC-032 — Technician Dashboard Experience

**Version:** 1.0  
**Status:** 🔒 LOCKED


# 1. Purpose

طراحی داشبورد اختصاصی Technician با رویکرد:

**Mobile First Field Operation Dashboard**

هدف:

Technician بتواند تمام فعالیت‌های روزانه خود را سریع، ساده و دقیق مدیریت کند.

Dashboard باید:

- عملیاتی باشد
- کمترین کلیک را داشته باشد
- مناسب استفاده در موبایل باشد
- اطلاعات مورد نیاز اجرای سرویس را ارائه دهد


---

# 2. Role Definition

Technician مسئول:

- اجرای سرویس
- ثبت Activity
- ثبت وضعیت Task
- ثبت گزارش سرویس
- ثبت درخواست قطعه
- ثبت هزینه داخلی
- تکمیل مدارک سرویس


Technician مسئول نیست:

- مدیریت Ticket
- Approval
- Accounting
- Inventory Management
- مدیریت مالی مشتری


---

# 3. Mobile First Principle

Dashboard باید برای استفاده در محیط Field طراحی شود.

اولویت:

- سرعت
- دسترسی سریع
- دکمه‌های عملیاتی
- حداقل اطلاعات غیرضروری


---

# 4. Dashboard Structure

```

Technician Mobile Dashboard

├── My Tasks

├── Work Order Execution

├── Activity & Time

├── Attendance

├── Expense Requests

├── My Parts

├── Service Report

├── Asset History

└── My Alerts

```


---

# 5. My Tasks

## User Story

به عنوان Technician می‌خواهم تمام Taskهای اختصاص داده شده به خودم را ببینم تا بدانم چه کارهایی باید انجام دهم.


نمایش:

- Today's Tasks
- Upcoming Tasks
- Overdue Tasks
- Priority
- Customer
- Asset
- Location


---

# 6. Work Order Execution

## User Story

به عنوان Technician می‌خواهم جزئیات Work Order را ببینم تا سرویس را درست انجام دهم.


نمایش:

- Ticket Information
- Customer
- Asset
- Service History
- Previous Notes
- Required Parts


---

# 7. Technician Assignment Type

Technician Role تغییر نمی‌کند.

Leader و Support فقط در سطح Task تعریف می‌شوند.


ساختار:

```

Work Order

├── Leader Technician

└── Supporting Technician

```


## Leader Technician

مسئول:

- هدایت اجرای فنی سرویس
- درخواست قطعه
- ثبت Service Report
- اعلام پایان سرویس


## Supporting Technician

مسئول:

- ثبت Activity خود
- ثبت Notes
- اعلام مشکل
- ثبت زمان فعالیت خود


---

# 8. Activity & Time Registration

## User Story

به عنوان Technician می‌خواهم زمان فعالیت خودم را ثبت کنم.


قابلیت:

- Start Activity
- End Activity
- Description
- Time Spent


Rule:

Time Sheet Technician ≠ Service Duration


---

# 9. Attendance Management

## User Story

به عنوان Technician می‌خواهم حضور کاری خودم را ثبت و مشاهده کنم.


قابلیت:

- Check In
- Check Out
- Attendance History


---

# 10. Expense Management

## User Story

به عنوان Technician می‌خواهم هزینه‌های مرتبط با کار خودم را ثبت کنم.


شامل:

- Expense Type
- Amount
- Receipt
- Related Task


Flow:

```

Technician

↓

Service Manager Review

↓

Accounting

↓

Payment

```


---

# 11. Financial Boundary

Technician فقط هزینه‌های ثبت شده توسط خودش را می‌بیند.


می‌تواند ببیند:

- Submitted Expense
- Approval Status
- Payment Status


نمی‌تواند ببیند:

- Customer Invoice
- Customer Payment
- Contract Value
- Customer Credit
- Service Profitability


---

# 12. My Parts Management

## User Story

به عنوان Technician می‌خواهم قطعاتی که مسئولیت آن با من است را ببینم.


نمایش:

- Assigned Parts
- Loan Parts
- Exchange Parts
- Return Required


اطلاعات:

- Part
- Serial
- Ticket
- Customer
- Issue Date
- Return Date


---

# 13. Part Request

## User Story

به عنوان Technician می‌خواهم درخواست قطعه ثبت کنم.


اطلاعات:

- Part Name
- Quantity
- Reason
- Related Task


Status:

- Requested
- Approved
- Rejected
- Delivered


---

# 14. Service Report

## User Story

به عنوان Technician می‌خواهم گزارش سرویس را ثبت کنم.


شامل:

- Work Description
- Problem Found
- Solution
- Photos
- Consumed Parts
- Recommendation


---

# 15. Customer Signature

## User Story

به عنوان Technician می‌خواهم پایان سرویس را ثبت کنم و تایید مشتری را دریافت کنم.


حالت‌ها:

- Digital Signature
- Printed Form
- No Signature Reason


---

# 16. Asset History

## User Story

به عنوان Technician می‌خواهم سابقه دستگاه را ببینم تا سرویس بهتر انجام شود.


دسترسی:

Read Only


نمایش:

- Previous Service
- Repairs
- Parts History
- Technical Notes


---

# 17. Knowledge Access (Future)

## User Story

به عنوان Technician می‌خواهم دانش فنی مرتبط با دستگاه را مشاهده کنم.


شامل:

- Manuals
- Troubleshooting
- Previous Solutions
- Technical Documents


Phase 1:

Out of Scope


---

# 18. My Alerts

بخش محدود Notification در Dashboard.


نمایش:

- New Task Assigned
- Part Ready
- Approval Result
- Schedule Change


Notification Center کامل در DOC مستقل بررسی خواهد شد.


---

# 19. Out of Scope

❌ Customer Financial Information

❌ Customer Invoice

❌ Ticket Management

❌ Approval Management

❌ Inventory Management

❌ Technician Hierarchy


---

# Final Decision

✅ Mobile First Technician Dashboard

✅ Simple Operational Experience

✅ Leader / Support Assignment Defined

✅ Expense Workflow Defined

✅ Attendance Included

✅ Parts Responsibility Included

✅ Asset History Read Only

✅ Knowledge Future Capability


---

# Status

🔒 DOC-032 LOCKED
