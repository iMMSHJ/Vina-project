# DOC-015 — Deployment and Infrastructure

**Version:** 2.0
**Status:** Approved – Revised
**Supersedes:** DOC-015 v1.0
**Aligned with:** DOC-011 v2.0, DOC-014 v2.0, DOC-050 (LOCKED), DOC-052 (LOCKED)

## 1. Deployment Philosophy (Unchanged)

- محصول **Self-Hosted** و **Infrastructure Independent** است.
- هر مشتری نسخه اختصاصی خود را روی زیرساخت خودش نصب و نگهداری می‌کند.
- زیرساخت‌های Physical Server، Virtual Machine، Private Cloud و Customer Datacenter پشتیبانی می‌شوند.
- محصول به Virtualization، Storage یا تجهیزات شبکه خاص وابسته نیست.

## 2. Server Topology (New — from DOC-052)

Phase One بر مبنای مدل **دو سرور ثابت** است:
```text
i-srv-1 (Business):
  Odoo
  PostgreSQL
  API Gateway
  Redis
  Object Storage

i-srv-2 (Frontend):
  Next.js
  HAProxy

### 2.1 Resource Baseline

| سرور | سرویس‌ها | منابع پیشنهادی |
|---|---|---|
| `i-srv-1` Business | Odoo, PostgreSQL, API Gateway, Redis, Object Storage | 8 vCPU / 16 GB RAM / 200 GB NVMe SSD |
| `i-srv-2` Frontend | Next.js, HAProxy | 2 vCPU / 2 GB RAM / 20 GB SSD |

### 2.2 دلایل انتخاب مدل دو سرور

- سادگی عملیاتی
- هزینه قابل پیش‌بینی
- مدیریت آسان برای تیم کوچک
- سرعت رسیدن به v1

### 2.3 محدودیت‌ها

- جداسازی آتی PostgreSQL یا سایر سرویس‌ها به Migration دستی نیاز دارد.
- Cloud Node مسیر رشد آینده است، **نه** انتخاب Phase One.
- تصمیم Single-Tenant/Multi-Tenant و مدل Database مستقل/Multi-Company هنوز قطعی نشده است (Deferred).

### 2.4 Operating System Standard

تمام سرورها بدون استثنا:

text
Ubuntu 26.04 LTS Minimal

دلایل: یکپارچگی محیط‌ها، کاهش خطای تفاوت Serverها، سازگاری با Staging موجود، Attack Surface کمتر، مصرف منابع پایه کمتر، پشتیبانی بلندمدت LTS.

## 3. End-to-End Request Flow (New — from DOC-050)

### 3.1 Customer World

text
Customer
  → Cloudflare
  → HAProxy        (i-srv-2)
  → Next.js         (i-srv-2)
  → API Gateway     (i-srv-1)
  → Odoo             (i-srv-1)
  → PostgreSQL       (i-srv-1)

### 3.2 Employee World

text
Employee
  → Odoo Web Client
  → Odoo             (i-srv-1)

### 3.3 Odoo/API Internal Dependencies

text
Odoo / API Gateway
  → Redis            (i-srv-1)
  → Object Storage   (i-srv-1)

## 4. Technology Stack

### 4.1 Base Stack (Unchanged — `i-srv-1`)

text
Ubuntu Server
  → Python
  → PostgreSQL
  → Odoo
  → Nginx
  → SSL

### 4.2 Extended Stack (New)

| لایه | سرویس | سرور |
|---|---|---|
| Edge/Reverse Proxy مشتری | HAProxy | `i-srv-2` |
| Presentation | Next.js | `i-srv-2` |
| Integration | API Gateway | `i-srv-1` |
| Cache/Session | Redis | `i-srv-1` |
| File Storage | Object Storage | `i-srv-1` |
| Business/Data | Odoo + PostgreSQL | `i-srv-1` |
| Internal Reverse Proxy | Nginx | `i-srv-1` |

## 5. Container & Runtime Policy (Unchanged)

- Docker و سایر Container Runtimeها در Phase One استفاده نمی‌شوند.
- استقرار **Native Linux** است.
- سرویس‌ها با **Systemd** مدیریت می‌شوند؛ شامل واحدهای جدید:

text
odoo.service
postgresql.service (managed by OS package)
nginx.service
api-gateway.service    (new — i-srv-1)
nextjs.service          (new — i-srv-2)
haproxy.service         (new — i-srv-2)
redis.service            (new — i-srv-1)

- `deploy/docker/` در Repository به‌عنوان مسیر **اختیاری/آینده** نگه داشته می‌شود؛ الزام Phase One نیست (DOC-014).

## 6. Reverse Proxy Layers

### 6.1 Nginx (`i-srv-1` — Unchanged Role)

- SSL Termination برای ترافیک داخلی/Employee World
- Reverse Proxy به Odoo
- Static Files
- Compression

### 6.2 HAProxy (`i-srv-2` — New)

- Edge Termination برای ترافیک Customer World (پس از Cloudflare)
- Routing به Next.js
- Load balancing (در صورت مقیاس‌پذیری آینده Next.js instance)

## 7. Data Layer

PostgreSQL تنها Database Engine پشتیبانی‌شده در MVP است؛ روی `i-srv-1` مستقر می‌شود.

داده‌ها در بخش‌های زیر نگهداری می‌شوند:

- PostgreSQL Database
- Odoo Filestore
- Configuration Files
- **Object Storage** (جدید) — فایل‌های Ticket و Service Report
- **Redis** (جدید) — Session/Cache، عمدتاً State غیر بحرانی/بازسازی‌پذیر

## 8. Ticket Transition Path (New — from DOC-050)

`pps_ticket_wizard` فعلاً با Controller + QWeb و مسیر `/support/new` ادامه می‌یابد. منطق ساخت Ticket و محاسبه SLA باید از Controller جدا و در **Service Layer** مستقل قرار گیرد:

text
HTTP Controller
  → Shared Ticket Service
  → Odoo Models
  → QWeb Response

مسیر آینده (بدون تغییر Business Logic):

text
JSON/API Controller
  → همان Shared Ticket Service
  → Odoo Models
  → JSON Response

ماژول‌های دارای Controller مشمول این Refactor:

| ماژول | Controller | Service Layer |
|---|---:|---:|
| `pps_asset` | خیر | نیاز ندارد |
| `pps_contract` | خیر | نیاز ندارد |
| `pps_sla` | خیر | نیاز ندارد |
| `pps_ticket_wizard` | بله | الزامی |
| `pps_portal` (آینده) | بله | از ابتدا الزامی |
| `pps_dashboard` (آینده) | بله | از ابتدا الزامی |

## 9. Deployment Automation

اسکریپت‌های استاندارد (سطح پروژه، طبق DOC-014 در `scripts/`):

text
install.sh
update.sh
backup.sh
restore.sh

این اسکریپت‌ها باید Phase One را با توپولوژی دو سروره هماهنگ کنند:

- `install.sh`: تشخیص نقش سرور (`i-srv-1`/`i-srv-2`) و نصب سرویس‌های متناظر.
- `update.sh`: بروزرسانی مستقل هر سرور بدون Downtime کامل.

## 10. Backup & Restore Matrix (Revised)

| مورد | سرور | وضعیت |
|---|---|---|
| PostgreSQL Database | `i-srv-1` | الزامی (Unchanged) |
| Odoo Filestore | `i-srv-1` | الزامی (Unchanged) |
| Configuration Files (Odoo/Nginx) | `i-srv-1` | الزامی (Unchanged) |
| Object Storage (Ticket/Report Attachments) | `i-srv-1` | الزامی (New) |
| API Gateway Configuration | `i-srv-1` | الزامی (New) |
| HAProxy Configuration | `i-srv-2` | الزامی (New) |
| Next.js Build/Environment Configuration | `i-srv-2` | الزامی (New) |
| Redis Data | `i-srv-1` | مشروط — فقط اگر State غیر قابل‌بازسازی نگه‌داری شود (New) |

Backup باید:

- به‌صورت خودکار قابل اجرا باشد.
- Restore مستقل هر جزء (نه فقط کل سرور) را پشتیبانی کند.
- برای هر سرور (`i-srv-1`, `i-srv-2`) جدا مدیریت شود، اما در یک Runbook واحد مستند شود (رجوع به DOC-053).

## 11. Logging & Monitoring (Mostly Unchanged)

- HTTPS و SSL اجباری هستند (هم در Nginx `i-srv-1` و هم HAProxy `i-srv-2`).
- Logging فاز اول بر مبنای Logging استاندارد هر سرویس (Odoo, Next.js, API Gateway, HAProxy) است.
- اتصال به سامانه مرکزی Log برای آینده پیش‌بینی شده؛ Out of Scope برای Phase One.

Business Monitoring (Unchanged):

- Open Tickets
- SLA Status
- Delayed Services
- Technician Workload
- Customer Satisfaction
- Parts Consumption
- Service Statistics

Infrastructure Monitoring در فاز اول خارج از محدوده است (Unchanged).

## 12. High Availability

- HA بر عهده زیرساخت مشتری است؛ نرم‌افزار باید بدون تغییر در محیط‌های HA اجرا شود (Unchanged).
- مدل دو سرور Phase One به‌خودی‌خود HA فراهم نمی‌کند؛ افزایش تعداد Node یا Load Balancing پیشرفته، خارج از محدوده Phase One است.

## 13. Out of Scope for MVP (Revised)

- Docker / Kubernetes (به‌عنوان الزام؛ در Repository به‌صورت اختیاری نگه داشته می‌شود)
- Multi-Node Deployment مستقل از مدل دو سروره ثابت
- Distributed Database
- Infrastructure Monitoring
- Cloud-Native Deployment
- تصمیم نهایی Single-Tenant/Multi-Tenant
- جداسازی PostgreSQL/Redis/Object Storage به سرورهای مستقل

## 14. Migration Notes from v1.0

| مورد | قبل (v1.0) | بعد (v2.0) |
|---|---|---|
| توپولوژی سرور | تک‌سرور ضمنی | دو سرور ثابت (`i-srv-1`, `i-srv-2`) طبق DOC-052 |
| Frontend | Odoo Website/QWeb | Next.js (`i-srv-2`) — QWeb همچنان Transitional |
| Reverse Proxy مشتری | Nginx تنها | HAProxy (`i-srv-2`) + Nginx (`i-srv-1`) |
| Cache/Session | تعریف نشده | Redis (`i-srv-1`) |
| File Storage | Odoo Filestore تنها | + Object Storage (`i-srv-1`) |
| Integration Layer | تعریف نشده | API Gateway (`i-srv-1`) |
| Backup Matrix | 3 مورد | 8 مورد (شامل اجزای جدید) |
| سیستم‌عامل | مشخص نشده | Ubuntu 26.04 LTS Minimal (تمام سرورها) |

بخش‌های بدون تغییر: Self-Hosted Philosophy، Systemd Model، PostgreSQL به‌عنوان تنها Engine، Automated Scripts، HA بر عهده مشتری.


---

آماده‌ام سند بعدی — **DOC-036 v2.0 (OCA Minimization & Presentation Layer Strategy)** — را با ارجاع متقابل به DOC-011 v2.0 و DOC-050 ارائه دهم. ادامه می‌دهم.