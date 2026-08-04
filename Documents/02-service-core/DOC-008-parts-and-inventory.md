# DOC-008
# Parts & Inventory

**Status:** Approved

---

# Purpose

مدیریت چرخه عمر قطعات مورد استفاده در سرویس.

سیستم Inventory بر پایه ماژول Stock اودو پیاده‌سازی می‌شود و از قابلیت‌های استاندارد Odoo استفاده خواهد کرد.

هیچ تغییر اساسی در منطق Inventory اودو انجام نمی‌شود.

---

# Business Rules

## BR-001

تمام قطعات و مواد مصرفی در Inventory اودو مدیریت می‌شوند.

---

## BR-002

هر قطعه دارای Product مشخص در Odoo است.

---

## BR-003

در صورت نیاز، قطعه می‌تواند دارای Lot یا Serial Number باشد.

---

## BR-004

قطعات قبل از مصرف باید به Technician تحویل شوند.

تحویل از طریق انتقال داخلی (Internal Transfer) انجام می‌شود.

---

## BR-005

پس از تحویل، مسئولیت نگهداری قطعه تا زمان مصرف یا بازگشت با Technician است.

مالک قطعه همچنان شرکت خواهد بود.

---

## BR-006

پس از پایان سرویس، Technician وضعیت هر قطعه را مشخص می‌کند.

- Used
- Returned

---

## BR-007

قطعات مصرف‌شده به Service Report متصل می‌شوند.

---

## BR-008

قطعات استفاده‌نشده به انبار بازگردانده می‌شوند.

---

## BR-009

قطعات برگشتی قبل از ورود مجدد به موجودی توسط مسئول انبار بررسی می‌شوند.

---

## BR-010

در صورت نیاز، وضعیت قطعه پس از بررسی تغییر می‌کند.

نمونه

- New
- Open Box
- Used
- Refurbished
- Damaged
- Scrap

---

## BR-011

مدیریت موجودی، انتقال، برگشت، Scrap و Lot/Serial توسط هسته استاندارد Odoo انجام می‌شود.

---

# Parts Lifecycle

Warehouse

↓

Internal Transfer

↓

Technician

↓

Used

یا

↓

Returned

↓

Inspection

↓

Warehouse

---

# Parts in Service Report

Service Report فقط قطعات استفاده‌شده یا برگشتی را ثبت می‌کند.

مدیریت موجودی توسط Inventory انجام می‌شود.

---

# Warehouse Operations

عملیات اصلی

- Receive
- Internal Transfer
- Return
- Consume
- Scrap
- Inventory Adjustment

تمام عملیات توسط Odoo Stock مدیریت می‌شود.

---

# Required Information

برای هر قطعه

- Product
- Quantity
- Unit of Measure
- Lot / Serial (در صورت وجود)
- Source Location
- Destination Location

---

# Odoo Mapping

| Business Entity | Odoo |
|-----------------|------|
| Product | product.product |
| Inventory | stock.quant |
| Warehouse | stock.warehouse |
| Stock Location | stock.location |
| Internal Transfer | stock.picking |
| Stock Move | stock.move |
| Lot / Serial | stock.lot |
| Scrap | stock.scrap |

---

# Design Principles

- Odoo Stock is the Single Source of Truth.
- No Custom Inventory Logic.
- Odoo First.
- OCA First.
- Custom Last.

---

# Notes

این پروژه از تمام قابلیت‌های استاندارد Inventory اودو استفاده می‌کند.

تمام قوانین مربوط به موجودی، انتقال کالا، Lot، Serial Number، Scrap و انبار بر عهده هسته Odoo خواهد بود.

ما فقط فرآیند سرویس را به Inventory متصل می‌کنیم و منطق انبار را بازنویسی نخواهیم کرد.

---

**Status:** Approved
