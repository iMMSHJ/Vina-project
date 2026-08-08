# DOC-046 — Unified Security Model (Groups & Record Rules)

**Status:** LOCKED
**Phase:** Phase 7 (Hardening) — تلفیق‌شده زودتر برای تصویر کامل
**Document Type:** Technical Design / Security Specification
**Traces to / Reconciles:** DOC-009, DOC-025 §7, DOC-026 §14-15, DOC-042 §5, DOC-045 §3

---

# 1. Objective

جمع‌بندی یکجای همه‌ی Groupهایی که در اسناد مختلف (Portal در DOC-042، Dashboard در DOC-045) به‌طور پراکنده تعریف شدند + تطبیق با فهرست اصلی نقش‌ها در DOC-009 — یک منبع واحد ACL/Record Rule.

---

# 2. اصلاحیه — تطبیق نام‌گذاری Customer Roles

DOC-009 (سند اولیه) و DOC-026 (سند بعدی، Locked) دو نام‌گذاری متفاوت برای نقش‌های مشتری دارند. چون DOC-026 جزئیات دقیق‌تر و جدیدتری دارد، **DOC-026 مرجع نهایی** است:

| نام در DOC-009 (اولیه) | نام نهایی — DOC-026 (مرجع) |
|---|---|
| Customer Manager | Customer Admin |
| Service (NAT) | Technical Contact |
| Operator | Normal User |
| Accountant (مشتری) | Accounting Contact |

> این جدول فقط برای شفافیت تاریخچه تصمیم است؛ در پیاده‌سازی فقط از ستون دوم (DOC-026) استفاده می‌شود.

---

# 3. فهرست کامل Groupها

## 3.1 نقش‌های داخلی (Internal)

| گروه Odoo | نقش کسب‌وکار | Dashboard اختصاصی؟ | منبع |
|---|---|---|---|
| `pps_dashboard.group_pps_admin` | Admin | ✅ (DOC-030) | DOC-045 §3 |
| `pps_dashboard.group_pps_service_manager` | Service Manager | ✅ (DOC-031) | DOC-045 §3 |
| `pps_dashboard.group_pps_technician` | Technician | ✅ (DOC-032) | DOC-045 §3 |
| — (گروه استاندارد `sales_team.group_sale_salesman`) | Sales | ❌ — از Backend استاندارد Odoo استفاده می‌کند | DOC-009 |
| — (گروه استاندارد `stock.group_stock_manager` / `group_stock_user`) | Warehouse Manager / User | ❌ | DOC-009 |
| — (گروه استاندارد `account.group_account_user`) | Accountant (داخلی) | ❌ | DOC-009 |
| — (بدون گروه اختصاصی — دسترسی فنی مستقیم) | System Analyst | ❌ | DOC-009 |
| — (`base.group_system` استاندارد) | Super Admin | ❌ — Odoo Backend کامل | DOC-009, DOC-030 §2 |

**تصمیم صریح:** فقط سه نقش (Admin, Service Manager, Technician) Dashboard اختصاصی می‌گیرند (طبق DOC-045). بقیه نقش‌های داخلی (Sales, Warehouse, Accountant, System Analyst) از Backend استاندارد Odoo با گروه‌های بومی همان اپ استفاده می‌کنند — بدون UI اضافه در v1 (سازگار با اصل سادگی).

## 3.2 نقش‌های مشتری (Portal — DOC-026 / DOC-042)

| گروه Odoo | نقش کسب‌وکار |
|---|---|
| `pps_portal.group_portal_admin` | Customer Admin |
| `pps_portal.group_portal_technical` | Technical Contact |
| `pps_portal.group_portal_accounting` | Accounting Contact |
| `pps_portal.group_portal_basic` | Normal User |

## 3.3 Guest (بدون حساب کاربری)

بدون گروه — دسترسی فقط از طریق Controller عمومی `pps_ticket_wizard` با `sudo()` محدود (DOC-038 §5)، طبق DOC-009 §Guest User.

---

# 4. ماتریس Record Rules (تجمیع نهایی)

| مدل | نقش | Domain |
|---|---|---|
| `helpdesk.ticket` | Technician | `[('technician_id', '=', user.id)]` — فقط Ticketهای اختصاصی خودش (DOC-009 BR-006) |
| `helpdesk.ticket` | Service Manager | `[('team_id', 'in', user.team_ids.ids)]` — همه Ticketهای واحد سرویس |
| `helpdesk.ticket` / `pps.asset` / `contract.contract` | Portal (هر ۴ نقش) | `[('partner_id', 'child_of', user.partner_id.commercial_partner_id.id)]` (DOC-042 §5.1) |
| همه مدل‌ها | Super Admin / Admin | بدون Domain (دسترسی کامل، طبق DOC-030 §2 و DOC-009) |
| `res.partner` (Master Data) | Admin | Read/Write مطابق DOC-030 §7؛ Portal فقط Read روی رکورد خودش |
| `pps.asset` (فیلدهای Serial/Model/Contract) | Portal (همه نقش‌ها) | `write` **غیرفعال** در سطح ACL (نه فقط UI) — طبق DOC-026 §7 |
| `pps.asset.brand` / `pps.asset.model` | Internal فقط | `create`/`write` فقط گروه‌های داخلی (DOC-002 BR-004) |

---

# 5. اصل Least Privilege (DOC-009 §Security Principles) — Checklist پیاده‌سازی

- [ ] هیچ Permission مستقیم به User داده نمی‌شود — همه از طریق Group (BR-003)
- [ ] هر مدل جدید (`pps.*`) پیش‌فرض بسته است؛ فقط گروه‌های صراحتاً تعریف‌شده در بخش ۳ دسترسی می‌گیرند
- [ ] Record Rule برای هر مدل حساس (Ticket, Asset, Contract, Service Report) طبق بخش ۴ الزامی است — نه اختیاری
- [ ] Customer Admin نمی‌تواند نقش داخلی بسازد (DOC-026 §15) — از طریق محدود کردن گروه‌های قابل‌تخصیص در فرم Customer User Management (`selection_groups` محدود به بخش ۳.۲)

---

# 6. Resolved

آیا در فاز اول به Roleهای فرعی (مثل «Service Manager Trainee» طبق نمونه DOC-009 BR-005) نیاز واقعی وجود دارد؟ **تصمیم:** خیر — فقط سه سطح ساده (بخش ۳.۱) برای v1، سازگار با اصل سادگی. در صورت نیاز واقعی در آینده، گروه‌های فرعی جدید بدون تغییر ساختار پایه اضافه می‌شوند.

---

# DOC-046 — LOCKED ✅
