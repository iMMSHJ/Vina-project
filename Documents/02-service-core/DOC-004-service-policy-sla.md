# DOC-004
# Service Policy (SLA)

**Status:** Approved

---

# Purpose

Service Policy مجموعه تعهدات شرکت در قبال یک Service Package است.

این Policy مشخص می‌کند خدمات با چه کیفیت، سرعت و شرایطی ارائه خواهد شد.

---

# Scope

هر Contract فقط یک Service Policy دارد.

هر Service Package فقط یک Service Policy دارد.

در صورت نیاز به SLA متفاوت، Package جدید تعریف می‌شود.

---

# Business Rules

## BR-001

هر Service Package دقیقاً یک Service Policy دارد.

---

## BR-002

تمام Deviceهای داخل یک Package از همان Service Policy پیروی می‌کنند.

---

## BR-003

Service Policy یک Template استاندارد است.

نمونه:

- Bronze
- Silver
- Gold
- Platinum

نام Policy توسط مدیر سیستم قابل تعریف است.

---

## BR-004

نام Service Policy فقط یک عنوان تجاری است.

رفتار سیستم بر اساس مقادیر Policy انجام می‌شود، نه نام آن.

---

# SLA Items

هر Service Policy می‌تواند شامل موارد زیر باشد.

---

## Response

### Remote Response Time

نمونه:

- 2 Hours
- 4 Hours
- 1 Business Day
- 2 Business Days
- 5 Business Days

---

### Working Calendar

نمونه:

- 8×5
- 24×7

---

### Remote Support

- Included
- Optional
- Not Included

---

## Onsite Service

### Onsite Response Time

زمان اعزام کارشناس حضوری.

---

## Spare Parts

تعهد تأمین قطعات یدکی

نمونه:

- Included
- Chargeable
- Best Effort

---

## Loan Device

تعهد تأمین قطعه یا دستگاه جایگزین

نمونه:

- Included
- Optional
- Not Included

---

## Preventive Maintenance

سرویس دوره‌ای

نمونه:

- None
- Monthly
- Quarterly
- Semi Annual
- Annual
- Custom

---

# Exclusions

Service Policy شامل موارد زیر نیست.

- قیمت قرارداد
- مبلغ سرویس
- شرایط پرداخت
- مدت قرارداد
- نوع قرارداد

این موارد در Contract مدیریت می‌شوند.

---

# Ticket Processing

هنگام ثبت Ticket سیستم Service Policy را بررسی می‌کند.

اطلاعات مورد استفاده:

- Response Time
- Working Calendar
- Remote Support
- Onsite Response
- PM Rules

---

# Operational Priority

Service Policy تنها عامل تعیین اولویت نیست.

عوامل مؤثر:

- SLA
- Customer Credit Status
- Manager Decision
- شرایط عملیاتی

---

# Customer Credit

اگر وضعیت اعتباری مشتری مناسب نباشد،

سیستم هشدار لازم را به مدیر سرویس نمایش می‌دهد.

مدیر درباره ادامه فرآیند تصمیم نهایی را می‌گیرد.

SLA تغییر نمی‌کند.

---

# Capacity

در فاز اول کنترل ظرفیت خودکار انجام نمی‌شود.

فقط هشدار مدیریتی ارائه خواهد شد.

هدف جلوگیری از فروش بیش از ظرفیت واقعی سرویس است.

---

# Odoo Mapping

| Business Entity | Odoo |
|-----------------|------|
| Service Policy | Custom Model |
| Contract | OCA Contract |
| Helpdesk | helpdesk.ticket |
| Calendar | resource.calendar |
| Working Hours | resource.calendar |

---

# Design Principles

- One Package = One Service Policy
- One Contract = One Service Policy
- SLA غیرقابل تغییر در زمان اجرای سرویس است.
- تصمیم نهایی همیشه با Service Manager است.
- سیستم فقط پیشنهاد و هشدار ارائه می‌دهد.
- تا حد امکان از قابلیت‌های استاندارد Odoo استفاده می‌شود.

---

# Future Scope

در فازهای بعد می‌توان موارد زیر را اضافه کرد.

- Capacity Planning
- SLA KPI Dashboard
- SLA Violation Report
- Automatic Escalation
- Notification Rules

---

**Status:** Approved
