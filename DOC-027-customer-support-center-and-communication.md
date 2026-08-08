# DOC-027 — Customer Support Center & Communication

**Version:** 1.0
**Status:** Locked

---

# 1. Purpose

این سند ساختار ارتباط مشتری با سازمان، درخواست‌های غیرسرویسی، کانال‌های ارتباطی و نحوه Routing درخواست‌ها را مشخص می‌کند.

هدف:

* ایجاد یک نقطه ارتباطی یکپارچه برای مشتری
* جلوگیری از تبدیل همه درخواست‌ها به Ticket
* حفظ ارزش و مفهوم Service Ticket
* هدایت درخواست‌ها به واحد مسئول

---

# 2. Core Principle

اصل اصلی:

> همه ارتباطات مشتری Ticket نیستند.

---

تعریف:

```text
Service Ticket

=

Formal Service Operation
```

اما:

```text
Support Message

=

Customer Communication & Follow Up
```

---

# 3. Scope

Customer Support Center شامل:

* Chat Communication
* Support Message
* Customer Request History
* Request Routing
* Department Notification
* Follow Up Management

---

# 4. Relationship With Customer Service Management

Customer Support Center جایگزین Customer Service Management نیست.

ارتباط:

```text
Customer Support Center

        |

        +-- Service Ticket
        |
        +-- Support Message
        |
        +-- Chat
```

---

# 5. Service Ticket Boundary

Service Ticket فقط برای موارد زیر استفاده می‌شود:

* مشکل دستگاه
* Asset Related Issue
* Technical Support
* Field Service
* Contract Based Service

---

Service Ticket دارای:

* SLA
* Priority
* Service Manager
* Technician
* Work Order
* Timesheet
* KPI

است.

---

# 6. Support Message

Support Message برای درخواست‌هایی است که نیاز به فرآیند سرویس ندارند.

---

موارد استفاده:

## User Administration

مثال:

* ساخت User
* حذف User
* تغییر Role
* Reset Password
* Portal Access Request

---

## Finance Support

مثال:

* سوال درباره Invoice
* وضعیت پرداخت
* درخواست تماس مالی
* درخواست سند مالی

---

## General Inquiry

مثال:

* سوال عمومی
* درخواست راهنمایی
* درخواست تماس

---

# 7. Support Message Lifecycle

Flow:

```text
Customer

↓

Support Channel

↓

Category Selection

↓

Routing

↓

Responsible Department

↓

Follow Up

↓

Completed
```

---

# 8. Support Channels

## 8.1 Chat

Chat یک کانال ارتباطی است، نه فرآیند.

---

Flow:

```text
Customer

↓

Chat

↓

Agent Response
```

---

در صورت نیاز:

```text
Chat

↓

Create Service Ticket
```

یا:

```text
Chat

↓

Support Message
```

---

## 8.2 Offline Message

زمانی که Agent در دسترس نیست:

Customer پیام ثبت می‌کند.

---

Flow:

```text
Offline Message

↓

Support Message

↓

Department Notification
```

---

# 9. Request Classification

در زمان ثبت Support Message:

Customer Category انتخاب می‌کند.

---

Categories:

```text
1. User Administration

2. Finance

3. General Inquiry
```

---

نکته:

Technical Service در این بخش قرار نمی‌گیرد.

برای Technical:

```text
Service Ticket Wizard
```

استفاده می‌شود.

---

# 10. Department Ownership

## Technical Service

Owner:

```text
Service Manager
```

مسئول:

* Ticket
* Assignment
* Technician
* Work Order

---

## User Administration

Owner:

```text
Admin
```

مسئول:

* User Management
* Access Requests

---

## Finance

Owner:

```text
Accounting
```

مسئول:

* Financial Requests
* Invoice Questions

---

## General Inquiry

Owner:

```text
CRM
```

مسئول:

* Initial Contact
* Customer Follow Up

---

# 11. Internal Notification

Notification برای Support Message کوتاه است.

---

مثال:

## Admin Notification

```text
New Customer Request

Company:
Customer Name

Category:
User Administration

Action:
Please follow up
```

---

## Accounting Notification

```text
New Customer Request

Company:
Customer Name

Category:
Finance

Action:
Customer requested contact
```

---

# 12. Customer Request History

Customer می‌تواند درخواست‌های خود را مشاهده کند.

---

Section:

```text
My Requests
```

---

نمایش:

* Request Number
* Category
* Created Date
* Status
* Last Update
* Final Response

---

مثال:

```text
Request #REQ-1025

Category:
User Administration

Status:
In Progress

Last Update:
Your request is being reviewed.
```

---

# 13. Customer Visible Status

Statusها ساده هستند:

```text
Received

↓

In Progress

↓

Waiting for Customer

↓

Completed

↓

Cancelled
```

---

# 14. Customer Visibility Rules

Customer می‌تواند ببیند:

✅ Request Status
✅ Final Response
✅ Request History

---

Customer نمی‌بیند:

❌ Internal Notes
❌ Internal Discussion
❌ Approval Flow
❌ Internal Priority
❌ Internal Assignment Logic

---

# 15. Support Message Form

Support Message باید ساده باشد.

---

Fields:

## Required

* Category
* Subject
* Message

---

## Optional

* Attachment
* Preferred Contact Method

---

عدم استفاده:

❌ Asset Selection
❌ SLA
❌ Priority
❌ Work Order

---

# 16. Conversion Rule

در صورت تشخیص نیاز به سرویس:

Support Message می‌تواند تبدیل شود به Service Ticket.

---

Flow:

```text
Support Message

↓

Service Evaluation

↓

Create Service Ticket
```

---

اما:

Service Ticket تبدیل به Support Message نمی‌شود.

---

# 17. Permission Model

## Customer

می‌تواند:

* ایجاد Support Message
* شروع Chat
* مشاهده درخواست‌های خودش

---

## Customer Admin

علاوه بر موارد بالا:

* مشاهده درخواست‌های کل شرکت

---

## Internal Users

فقط درخواست‌های مربوط به Department خود را مشاهده می‌کنند.

---

مثال:

Accounting:

✅ Finance Requests

❌ Technical Tickets

---

Admin:

✅ User Requests

❌ Finance Requests

---

# 18. Design Decision

این تفکیک باعث می‌شود:

* Service Ticket ارزش خود را حفظ کند
* SLA فقط برای سرویس واقعی استفاده شود
* Service Manager درگیر درخواست‌های غیرسرویسی نشود
* KPI سرویس دقیق باقی بماند

---

# 19. Final Architecture

```text
Customer

↓

Customer Support Center

|

+ Chat

+ Support Message

+ Request History


Customer Service Management

|

+ Service Ticket

+ Work Order

+ Field Service
```

---

# Final Decisions

✅ همه ارتباطات مشتری Ticket نیستند.
✅ Service Ticket فقط برای سرویس فنی باقی می‌ماند.
✅ درخواست‌های مالی، ادمین و عمومی Support Message هستند.
✅ Chat فقط کانال ارتباطی است.
✅ درخواست‌های مشتری History دارند.
✅ مشتری وضعیت را می‌بیند ولی فرآیند داخلی را نمی‌بیند.
✅ Routing بر اساس Department انجام می‌شود.
✅ Marketplace خارج از این سند است و در DOC-028 بررسی می‌شود.

---

# DOC-027 — LOCKED ✅
