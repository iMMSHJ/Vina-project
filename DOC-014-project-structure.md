# DOC-014 — Project Structure

**Version:** 2.0
**Status:** Approved – Revised
**Supersedes:** DOC-014 v1.0
**Aligned with:** DOC-011 v2.0, DOC-015, DOC-036 (LOCKED), DOC-050 (LOCKED), DOC-052 (LOCKED)

## 1. Scope

این سند ساختار واحد Repository را برای کل پلتفرم تعریف می‌کند: Backend (Odoo)، Frontend (Next.js)، API Gateway و Deployment. یک Monorepo واحد حفظ می‌شود؛ تفکیک Repository جداگانه برای Frontend/Backend/Gateway انجام نمی‌شود.

## 2. Top-Level Structure
```text
prepress-service-platform/
├── backend/
│   ├── odoo/
│   ├── oca/
│   ├── addons/
│   ├── themes/
│   ├── config/
│   └── tests/
├── frontend/
│   └── nextjs/
├── gateway/
│   ├── src/
│   ├── routes/
│   ├── middleware/
│   ├── auth/
│   ├── clients/
│   ├── schemas/
│   └── tests/
├── deploy/
│   ├── native/
│   │   ├── systemd/
│   │   ├── nginx/
│   │   └── haproxy/
│   ├── cloud/
│   └── docker/
├── config/
├── docs/
├── scripts/
└── backups/

## 3. Directory Ownership

| مسیر | مالکیت | توضیح |
|---|---|---|
| `backend/` | Business Logic و Data Model | Odoo Core، OCA و Custom `pps_*` |
| `frontend/` | Presentation (Customer) | Next.js؛ هیچ Business Logic تکرار نمی‌شود |
| `gateway/` | Integration Layer | فقط Routing/Validation/Auth Forwarding |
| `deploy/` | Infrastructure as Code | Systemd Units، Nginx/HAProxy Configs، Docker اختیاری |
| `docs/` | مستندات پروژه | فقط در Repository؛ هرگز روی سرورها Deploy نمی‌شود |
| `scripts/` | ابزار عملیاتی | `install.sh`, `update.sh`, `backup.sh`, `restore.sh` |
| `backups/` | Placeholder | خروجی واقعی Backup در Git ذخیره نمی‌شود |

## 4. `backend/` — Detail

text
backend/
├── odoo/              # Odoo Core (Vendor, پین‌شده به نسخه مشخص)
├── oca/                # ماژول‌های OCA — فقط Data/Backend Logic (DOC-036)
├── addons/
│   └── pps_*/          # ماژول‌های سفارشی: asset, contract, sla, ticket_wizard,
│                        # portal, dashboard, notification, theme
├── themes/              # Website/Portal انتقالی (QWeb) — DOC-036 Transition
├── config/              # odoo.conf, per-environment overrides
└── tests/               # تست‌های سطح ماژول

قواعد:

- تنها `addons/pps_*` قابل تغییر مستقیم است؛ `odoo/` و `oca/` Vendor محسوب می‌شوند.
- `themes/` فقط برای مسیر Transition (QWeb/Odoo Website) نگه‌داری می‌شود و با تکمیل مهاجرت به Next.js، منقضی و حذف خواهد شد (بدون تاریخ قطعی؛ به Roadmap DOC-037 وابسته است).
- Business Logic منحصراً در `backend/` باقی می‌ماند؛ نه در `frontend/`، نه در `gateway/`.

## 5. `frontend/nextjs/` — Detail

text
frontend/nextjs/
├── app/                # Routes (App Router)
├── components/
├── lib/                # API Client, Auth Helpers
├── styles/             # Design Tokens مشترک با pps_theme
├── public/
└── tests/

قواعد:

- Next.js هرگز مستقیماً به PostgreSQL/Odoo ORM متصل نمی‌شود؛ فقط از طریق `gateway/` صحبت می‌کند.
- Design Tokens با `pps_theme` هماهنگ می‌مانند تا Consistency میان QWeb انتقالی و Next.js هدف حفظ شود (DOC-036).
- هیچ منطق محاسبه SLA، قیمت‌گذاری یا مجوزدهی در این لایه پیاده‌سازی نمی‌شود.

## 6. `gateway/` — Detail

text
gateway/
├── src/
├── routes/           # نگاشت Endpoint به سرویس Odoo
├── middleware/        # Rate Limiting, Logging
├── auth/               # Forward Authentication به Odoo Session/Token
├── clients/            # Odoo XML-RPC/JSON-RPC یا HTTP Client
├── schemas/            # Validation (Request/Response)
└── tests/

قواعد:

- Gateway مالک Business Logic یا Authorization نیست؛ فقط Integration/Validation/Formatting.
- هر منطق Ticket/SLA/Contract باید در Service Layer داخل `backend/addons/pps_*` باشد، نه در Gateway.

## 7. `deploy/` — Detail

text
deploy/
├── native/
│   ├── systemd/       # Unit files: odoo.service, gateway.service, nextjs.service
│   ├── nginx/          # Reverse Proxy configs — i-srv-1
│   └── haproxy/        # Edge configs — i-srv-2
├── cloud/              # Managed PostgreSQL, Cloud-specific configs (Future)
└── docker/             # اختیاری/آینده — الزام Phase One نیست

مدل Phase One طبق DOC-015/DOC-052:

- **Native Deployment** (`deploy/native/`) مدل اصلی است.
- Docker (`deploy/docker/`) اختیاری و برای فازهای بعدی نگه داشته می‌شود.
- توزیع فایل روی سرورها مطابق توپولوژی دو سرور (`i-srv-1` Business، `i-srv-2` Frontend) در DOC-052 است.

## 8. `docs/`, `config/`, `scripts/`, `backups/`

- `docs/`: تمام مستندات پروژه (`00-business-and-domain` تا `15-ecosystem-architecture`). این پوشه **هرگز** به هیچ سروری (`i-srv-1`/`i-srv-2`) Deploy نمی‌شود؛ فقط در Repository نگهداری می‌شود.
- `config/`: تنظیمات عمومی سطح پروژه (غیر Odoo/Gateway/Frontend اختصاصی).
- `scripts/`: `install.sh`, `update.sh`, `backup.sh`, `restore.sh` — سطح پروژه.
- `backups/`: صرفاً Placeholder/`.gitkeep`؛ Backupهای واقعی (Database Dumps، Filestore) هرگز Commit نمی‌شوند.

## 9. Repository & CI/CD Notes

- Monorepo واحد؛ بدون تفکیک Repository جداگانه.
- Pipelineهای CI/CD می‌توانند بر اساس مسیر تغییر (`backend/`, `frontend/`, `gateway/`) جدا اجرا شوند، بدون نیاز به تفکیک Repository.
- جزئیات کامل Branching، Commit Convention و Deployment-from-Git در سند جدید Version Control (بخش بعدی) مشخص می‌شود.

## 10. Migration Notes from v1.0

| مورد | قبل (v1.0) | بعد (v2.0) |
|---|---|---|
| Odoo | ریشه پروژه | `backend/odoo/` |
| OCA | ریشه پروژه | `backend/oca/` |
| Addons | ریشه پروژه | `backend/addons/` |
| Themes | ریشه پروژه | `backend/themes/` (Transitional) |
| Config | ریشه پروژه | `backend/config/` + `config/` سطح پروژه |
| Docker | پوشه اصلی Deployment | `deploy/docker/` (اختیاری) |
| — | — | `frontend/nextjs/` (جدید) |
| — | — | `gateway/` (جدید) |
| — | — | `deploy/native/` (جدید، مدل اصلی) |

`docs/`, `scripts/`, `backups/` بدون تغییر باقی می‌مانند.


---

آماده‌ام سند بعدی — **DOC-015 v2.0 (Deployment & Infrastructure)** — را ارائه دهم که توپولوژی دو سروره، Redis، Object Storage، Next.js و HAProxy را به Stack اضافه می‌کند. ادامه بدهم؟