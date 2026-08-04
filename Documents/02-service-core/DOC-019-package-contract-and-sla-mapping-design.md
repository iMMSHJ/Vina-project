# DOC-019 — Package, Contract & SLA Mapping Design

**Status:** LOCKED  
**Phase:** Phase 3  
**Document Type:** Business Analysis & Entity Relationship Design

---

# 1. Objective

هدف این داکیومنت تعریف مفهوم Package، ارتباط آن با Asset، Contract و SLA و مشخص کردن جایگاه آن در سیستم سرویس است.

اصل مهم:

> Package یک مفهوم قراردادی است، نه یک Entity عملیاتی عمومی در کل سیستم.

---

# 2. Package Definition

Package یعنی:

گروهی از تجهیزات یا دستگاه‌ها که برای ارائه سرویس، تحت یک قرارداد مشخص قرار می‌گیرند.

مثال:

```

Package A

├── Plate Tester
│      Serial: 12532
│
├── RIP
│      Serial: 546558
│
└── Processor
Serial: 655585

```

این سه دستگاه یک Package تشکیل می‌دهند.

---

مثال دوم:

```

Package B

├── Plotter
│      Serial: 5548855
│
└── RIP
Serial: 66559

```

---

# 3. Package Purpose

Package فقط برای:

- Contract Management
- SLA Definition
- Service Relationship

استفاده می‌شود.

---

Package در این موارد وارد نمی‌شود:

❌ Inventory Flow  
❌ Product Catalog  
❌ Marketplace  
❌ فروش عمومی  
❌ Ticket مستقل

---

# 4. Asset Relationship

مدل:

```

Asset

*

Asset

*

Asset

```
    |

    |

 Package

    |

    |

 Contract
```

```

---

یعنی:

چند Asset می‌توانند داخل یک Package قرار بگیرند.

---

# 5. Contract Relationship

تصمیم:

هر Package باید Contract مستقل داشته باشد.

دلیل:

چون هر Package ممکن است:

- SLA متفاوت
- شرایط سرویس متفاوت
- تاریخ شروع متفاوت
- شرایط مالی متفاوت

داشته باشد.

---

مدل:

```

Package A

```
    |
```

Contract A

```
    |
```

SLA A

```

---

```

Package B

```
    |
```

Contract B

```
    |
```

SLA B

```

---

# 6. SLA Relationship

SLA متعلق به Contract است.

نه:

- Asset
- Product
- Ticket

---

ساختار:

```

Customer

|

Contract

|

SLA

|

Package

|

Assets

```

---

# 7. Ticket Relationship

Ticket مستقیماً Package را مدیریت نمی‌کند.

Ticket از طریق Asset و Contract به Package مرتبط می‌شود.

---

Flow:

```

Customer

↓

Ticket

↓

Select Asset

↓

Find Related Package

↓

Find Contract

↓

Apply SLA

```

---

مثال:

Customer Ticket:

```

Problem:
Plate Tester Failure

Selected Asset:

Plate Tester SN12532

System:

Package A

Contract A

SLA A

```

---

# 8. Package Visibility

در Ticket:

کاربر فقط Assetهای قابل سرویس خود را می‌بیند.

مثلاً:

Customer دارای:

```

Package A

├── Plate Tester
├── RIP
└── Processor

Package B

├── Plotter
└── RIP

```

در Ticket:

Asset انتخاب می‌شود.

با انتخاب Asset:

Contract مربوطه مشخص می‌شود.

---

# 9. Package Lifecycle

Package از Contract جدا نیست.

Lifecycle:

```

Draft

↓

Active

↓

Expired

↓

Archived

```

---

# 10. Package Changes

اگر Asset جدید اضافه شود:

مثلاً:

```

Package A

Old:

Plate Tester
RIP

New:

Plate Tester
RIP
Processor

```

باید بررسی شود:

- آیا Contract تغییر می‌کند؟
- آیا SLA تغییر می‌کند؟
- آیا نیاز به Contract جدید است؟

---

این Rule در فاز طراحی Contract Management مشخص می‌شود.

---

# 11. Package vs Product

تصمیم:

Package محصول نیست.

Product:

برای:

- فروش
- Inventory
- Marketplace

است.

Package:

برای:

- سرویس
- قرارداد
- SLA

است.

---

مقایسه:

| مورد | Product | Package |
|-|-|-|
| فروش | ✅ | ❌ |
| Inventory | ✅ | ❌ |
| Contract | محدود | ✅ |
| SLA | ❌ | ✅ |
| Service | محدود | ✅ |

---

# 12. Package vs Inventory

تصمیم:

Inventory مالک Asset است.

Package فقط یک Grouping قراردادی است.

---

مدل:

```

Inventory

↓

Asset

↓

Package

↓

Contract

```

---

# 13. Contract Flexibility

Contract باید امکان ثبت شرایط خاص داشته باشد.

یعنی:

اگر شرایط قرارداد خارج از Fieldهای استاندارد بود:

امکان:

- Note
- Custom Terms
- Manual Conditions

وجود داشته باشد.

---

# 14. Customer Contract Scenario

سناریو:

مشتری جدید ثبت می‌شود.

در ابتدا:

```

Customer

No Contract

```

---

بعد از تایید:

```

Customer

↓

Contract

↓

Package

↓

SLA

```

---

# 15. Multiple Contracts

یک Customer می‌تواند داشته باشد:

```

Customer A

├── Contract 1
│       |
│       Package A
│
└── Contract 2
|
Package B

```

---

هر Contract:

- SLA مستقل
- شرایط مستقل
- تاریخ مستقل

دارد.

---

# 16. Reporting

گزارش‌ها می‌توانند بر اساس:

- Package
- Contract
- Asset
- SLA

ساخته شوند.

---

مثال:

```

Most Failed Package

Highest Service Cost Package

SLA Performance By Package

```

---

# 17. Design Decision

تصمیم نهایی:

Package:

- یک مفهوم قراردادی است.
- فقط برای Contract Mapping استفاده می‌شود.
- وارد تمام Flowهای سیستم نمی‌شود.
- جایگزین Asset نیست.
- جایگزین Product نیست.

---

# Final Entity Relationship

```

Customer

|

Contract

|

Package

|

Assets

|

Ticket

|

Task

|

Service Report

```

---

# DOC-019 Final Status

## LOCKED ✅
```
----------------------------------------------
# DOC-019 — Package Concept & Contract Relationship

**Status: FINAL / REVIEWED**
**Version:** 1.0

---

# 1. Purpose

این سند مفهوم **Package** و ارتباط آن با قرارداد، تجهیزات، Asset و سرویس را مشخص می‌کند.

هدف اصلی جلوگیری از اشتباه گرفتن Package به عنوان یک Entity عملیاتی در سیستم است.

---

# 2. Package Definition

## Package چیست؟

Package یک **اصطلاح قراردادی / محاوره‌ای** برای اشاره به مجموعه‌ای از تجهیزات یا سرویس‌های ارائه شده در یک قرارداد است.

مثال:

```
Package 1
Package 2
Package 3
```

---

## نکته مهم

Package یک Object مستقل در سیستم نیست.

یعنی:

* ❌ در CRM به عنوان Entity مستقل ثبت نمی‌شود.
* ❌ در Ticket به آن ارجاع داده نمی‌شود.
* ❌ در Workflow سرویس استفاده نمی‌شود.
* ❌ دارای SLA مستقل نیست.

---

# 3. Package Structure

یک Package شامل مجموعه‌ای از تجهیزات است که جزئیات آن در قرارداد مشخص می‌شود.

مثال:

```
Contract A

Package 1

    Asset 1
    Asset 2
    Asset 3
```

اطلاعات واقعی تجهیزات در:

```
Asset
```

نگهداری می‌شود.

---

# 4. Relationship Model

مدل ارتباط:

```
Customer

    |
    |
Contract

    |
    |
Package (Conceptual Group)

    |
    |
Assets
```

---

# 5. Package vs Contract

## Contract

یک Entity واقعی و حقوقی است.

دارای:

* شماره قرارداد
* تاریخ شروع
* تاریخ پایان
* شرایط حقوقی
* SLA
* امضا
* مسئولیت‌ها

---

## Package

فقط نشان‌دهنده گروه تجهیزات داخل قرارداد است.

مثلاً:

قرارداد:

```
ABC Service Contract
```

شامل:

```
Package 1
    Printer A
    Printer B

Package 2
    RIP Server
    Scanner
```

---

# 6. Contract Per Package Rule

هر Package قراردادی دارای قرارداد مستقل است.

یعنی:

اگر مشتری دو Package داشته باشد:

```
Package 1
Contract A

Package 2
Contract B
```

حتی اگر شرایط مشابه باشند:

* قراردادها جدا هستند.
* تاریخچه جدا دارند.
* SLA جدا دارند.
* وضعیت حقوقی جدا دارند.

---

# 7. SLA Relationship

SLA متعلق به Contract است، نه Package.

Flow:

```
Asset

↓

Active Contract

↓

SLA Rule

↓

Expected Response Time
```

---

# 8. Ticket Relationship

Ticket هیچ ارجاع مستقیمی به Package ندارد.

Flow:

```
Customer

↓

Asset Selection

↓

Contract Detection

↓

SLA Calculation

↓

Ticket Creation
```

---

# 9. Site Relationship

Package معیار Site نیست.

Site فقط محل استقرار Asset است.

مدل:

```
Customer

 |
Sites

 |
Assets

 |
Contracts
