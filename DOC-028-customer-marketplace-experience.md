# DOC-028 — Customer Marketplace Experience

**Version:** 1.0
**Status:** Locked

---

# 1. Purpose

این سند تجربه مشتری در Marketplace را مشخص می‌کند.

هدف:

* ایجاد یک فضای تجاری برای مشتری
* نمایش محصولات و خدمات قابل ارائه
* دریافت درخواست خرید
* اتصال فرآیند تجاری به Sales، Inventory و Accounting

---

# 2. Core Principle

Marketplace یک فروشگاه عمومی ساده نیست.

Marketplace یک Channel تجاری B2B است.

اصل:

```text
Marketplace

≠

Customer Service Management
```

---

Marketplace مسئول:

* معرفی محصول
* دریافت درخواست خرید
* ارتباط اولیه فروش

است.

---

Marketplace مسئول نیست:

* ایجاد Asset
* اجرای سرویس
* مدیریت قرارداد سرویس
* مدیریت Ticket

---

# 3. Architecture Relationship

```text
Customer

        |

Marketplace

        |

Sales

        |

CRM

        |

Inventory

        |

Accounting

        |

Customer Service Management
```

---

# 4. Marketplace Entry

Marketplace یک صفحه اصلی دارد.

---

ساختار:

```text
Marketplace

|

+ Product Categories

+ Products

+ Services

+ Spare Parts

+ My Requests

+ My Orders
```

---

# 5. Guest Access

مهمان می‌تواند وارد Marketplace شود.

اما دسترسی محدود دارد.

---

## Guest User

می‌تواند:

✅ مشاهده Marketplace
✅ مشاهده دسته‌بندی‌ها
✅ مشاهده اطلاعات عمومی محصول

---

نمی‌تواند:

❌ مشاهده قیمت
❌ ثبت سفارش
❌ Request Quote رسمی

---

Flow:

```text
Guest

↓

Browse Products

↓

Interested

↓

Register / Contact Sales
```

---

# 6. Customer Access

Customer ثبت‌شده:

می‌تواند:

✅ مشاهده محصولات
✅ مشاهده قیمت رسمی
✅ Request Quote
✅ Request Discount
✅ مشاهده سفارش‌های خودش

---

# 7. Product Visibility

هر محصول Inventory الزاماً Marketplace نیست.

---

مدل:

```text
Inventory Product

        |

        + Internal Only

        + Marketplace Available
```

---

فقط محصولات Publish شده در Marketplace نمایش داده می‌شوند.

---

# 8. Product Categories

دسته‌بندی پیشنهادی:

```text
1. Equipment

2. Spare Parts

3. Accessories

4. Services

5. Support Packages
```

---

# 9. Product Information

اطلاعات محصول باید ساده و کاربردی باشد.

---

## Customer View

نمایش:

* Product Name
* Image
* Short Description
* Main Features
* Compatibility
* Availability Status
* Price (Customer Only)

---

## Technical Information

در صورت نیاز:

* Datasheet
* Specification File
* Manual

---

# 10. Pricing Model

## Single Price Model

برای هر محصول فقط یک قیمت رسمی وجود دارد.

---

مدل:

```text
Product

↓

Official Price
```

---

Marketplace موتور قیمت‌گذاری پیچیده ندارد.

---

# 11. Discount Request

مشتری اگر درخواست تخفیف داشته باشد:

از مسیر Request Quote اقدام می‌کند.

---

Flow:

```text
Customer

↓

Request Quote / Discount Request

↓

Sales Review

↓

Approval (if required)

↓

Final Quotation
```

---

تخفیف خارج از Marketplace تصمیم‌گیری می‌شود.

---

# 12. Price Ownership

مالک قیمت:

```text
Sales Manager
```

---

با همکاری:

## Inventory

برای:

* Availability
* Stock Information

---

## Accounting

برای:

* Financial Control
* Margin Rules

---

---

# 13. Price Change Permission

تغییر قیمت:

```text
Update Price

↓

Approval

↓

Publish Marketplace
```

---

کاربر عادی فروش:

❌ تغییر قیمت ندارد

---

# 14. Product Publish Process

قبل از نمایش محصول:

```text
Product Created

↓

Technical Information Complete

↓

Inventory Validation

↓

Price Defined

↓

Sales Manager Approval

↓

Publish Marketplace
```

---

# 15. Purchase Flow

Marketplace سفارش مستقیم را مدیریت نمی‌کند.

Flow:

```text
Customer

↓

Product Selection

↓

Request Quote

↓

CRM / Sales

↓

Quotation

↓

Approval

↓

Sales Order

↓

Delivery

↓

Invoice
```

---

# 16. Spare Parts Marketplace

قطعات یدکی می‌توانند در Marketplace ارائه شوند.

---

اما دو مسیر کاملاً جدا داریم:

---

## A. Direct Spare Part Purchase

برای:

* قطعات عمومی
* Accessories
* Consumables

Flow:

```text
Marketplace

↓

Order

↓

Inventory

↓

Delivery

↓

Invoice
```

---

## B. Service Replacement Part

برای تعمیر:

```text
Service Ticket

↓

Diagnosis

↓

Part Request

↓

Approval

↓

Inventory Issue

↓

Service Report
```

---

این دو فرآیند با هم ترکیب نمی‌شوند.

---

# 17. Asset Creation Relation

Marketplace هیچ Asset ایجاد نمی‌کند.

---

اگر محصول خریداری‌شده Asset باشد:

Flow:

```text
Sales Order

↓

Delivery

↓

Asset Creation

↓

Customer Service Management
```

---

# 18. Customer Specific Control

مشتری نمی‌تواند:

❌ قیمت تغییر دهد
❌ محصول تغییر دهد
❌ موجودی تغییر دهد
❌ Asset ایجاد یا ویرایش کند

---

# 19. Permission Model

## Guest

* Browse Products

---

## Customer User

* View Products
* View Price
* Request Quote
* Request Discount
* View Orders

---

## Sales User

* Manage Quotes
* Follow Sales Process

---

## Sales Manager

* Product Publish
* Price Management
* Discount Approval

---

## Accounting

* Financial Validation

---

## Inventory

* Stock Validation

---

# 20. Final Architecture

```text
Customer Marketplace

|

+ Product Catalog

+ Pricing

+ Request Quote

+ Discount Request

+ Spare Parts

+ Orders


Backend:

Sales

CRM

Inventory

Accounting

Customer Service Management
```

---

# Final Decisions

✅ Marketplace از Customer Service Management جدا است.
✅ Marketplace از Customer Support Center جدا است.
✅ Guest قیمت مشاهده نمی‌کند.
✅ Guest سفارش ثبت نمی‌کند.
✅ Customer قیمت رسمی را مشاهده می‌کند.
✅ فقط یک قیمت رسمی برای محصول وجود دارد.
✅ تخفیف از طریق Request Quote بررسی می‌شود.
✅ Sales Manager مالک Publish و Pricing است.
✅ Spare Parts در Marketplace قابل ارائه هستند.
✅ قطعه فروشگاهی با قطعه سرویس جدا است.
✅ Marketplace Asset ایجاد نمی‌کند.

---

# DOC-028 — LOCKED ✅
