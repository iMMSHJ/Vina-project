# DOC-009
# Roles & Permissions

**Status:** Approved

---

# Purpose

مدیریت نقش‌ها و سطح دسترسی کاربران سیستم.

این پروژه از سیستم امنیتی استاندارد Odoo استفاده می‌کند و هیچ سیستم Permission سفارشی در فاز اول توسعه نخواهد شد.

---

# Design Principles

- Odoo First
- OCA First
- Custom Last

---

# Security Model

سیستم امنیتی بر پایه قابلیت‌های استاندارد Odoo پیاده‌سازی می‌شود.

- User
- Groups
- Access Control Lists (ACL)
- Record Rules

---

# Business Rules

## BR-001

هر User می‌تواند عضو یک یا چند Role باشد.

---

## BR-002

سطح دسترسی هر User حاصل مجموع Role های اختصاص داده شده به او است.

---

## BR-003

Permission مستقیماً به User اختصاص داده نمی‌شود.

تمام دسترسی‌ها از طریق Role (Odoo Groups) مدیریت می‌شوند.

---

## BR-004

در فاز اول پروژه هیچ سیستم IAM یا User Permission اختصاصی پیاده‌سازی نخواهد شد.

---

## BR-005

در صورت نیاز به سطوح دسترسی متفاوت، Roleهای مجزا تعریف خواهند شد.

نمونه:

- Service Manager Trainee
- Service Manager
- Senior Service Manager

---

## BR-006

دسترسی به اطلاعات علاوه بر Role توسط Record Rules نیز کنترل می‌شود.

نمونه:

- Customer فقط اطلاعات خود را مشاهده می‌کند.
- Technician فقط Ticketهای اختصاص یافته به خود را مشاهده می‌کند.
- Service Manager تمامی Ticketهای واحد سرویس را مشاهده می‌کند.
- Super Admin به تمام اطلاعات سیستم دسترسی دارد.

---

# Internal Roles

نمونه Roleهای داخلی

- Super Admin
- Service Manager
- Technician
- Sales
- Warehouse Manager
- Warehouse User
- Accountant
- System Analyst

---

# Customer Roles

نمونه Roleهای مشتری

- Customer Manager
- Service (NAT)
- Operator
- Accountant

کاربران مشتری فقط در محدوده سازمان خود دسترسی خواهند داشت.

---

# Guest User

کاربر مهمان می‌تواند بدون ایجاد حساب کاربری درخواست سرویس ثبت کند.

دسترسی Guest فقط محدود به ثبت Ticket خواهد بود.

---

# Super Admin

Super Admin دارای دسترسی کامل به تمام بخش‌های سیستم است.

این Role فقط برای مدیریت داخلی سیستم استفاده می‌شود.

---

# Odoo Mapping

| Business Concept | Odoo |
|------------------|------|
| User | res.users |
| Role | res.groups |
| Permission | ir.model.access |
| Record Rules | ir.rule |

---

# Security Principles

- Least Privilege
- Role Based Access
- Record Level Security
- No Direct User Permissions
- Odoo Native Security

---

# Future Scope

در صورت نیاز در نسخه‌های آینده می‌توان یک لایه IAM مستقل روی Odoo طراحی کرد.

این قابلیت خارج از محدوده MVP است.

---

# Notes

هدف پروژه استفاده حداکثری از زیرساخت امنیتی Odoo است.

تمام توسعه‌های امنیتی باید تا حد امکان بر پایه Groups، ACL و Record Rules انجام شوند و از بازنویسی سیستم امنیتی Odoo اجتناب گردد.

---

**Status:** Approved
