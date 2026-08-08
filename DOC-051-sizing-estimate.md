# DOC-051 — Ecosystem Sizing Estimate (Phase 1)

**Status:** LOCKED
**Phase:** Cross-Phase (سطح اکوسیستم/هلدینگ — خارج از Backend این پروژه، طبق DOC-050 §5)
**Document Type:** Capacity Planning
**Traces to:** DOC-050

---

# 1. Objective

ثبت تخمین منابع (Sizing Estimate) برای کل اکوسیستم (Frontend + API Gateway + Odoo + Database) طبق سناریوی فرضی مرحله ۱.

> **یادداشت مهم:** این مقادیر **تخمینی** هستند و بر اساس حدود ۱۰۰ مشتری ثبت‌شده، ۲۰ کارمند، حدود ۲۵ کاربر همزمان و ۲۰–۵۰ درخواست در ثانیه محاسبه شده‌اند. اندازه‌گیری واقعی پس از استقرار و مانیتورینگ انجام خواهد شد و مبنای تصمیم برای ارتقای منابع یا جداسازی سرویس‌ها خواهد بود. **هیچ‌کس نمی‌تواند عدد دقیق قطعی بدهد** — این یک Baseline استاندارد برای Capacity Planning است، نه تعهد فنی.

---

# 2. سناریوی مبنا

- ۱۰۰ مشتری ثبت‌شده، ۲۰ کارمند
- همزمانی: ~۱۵ مشتری آنلاین + ~۱۰ کارمند آنلاین
- ۲۰ تا ۵۰ RPS در ساعات اوج
- Next.js با SSR محدود، بیشتر صفحات Static
- Odoo 19، PostgreSQL 17/18، FastAPI (پیشنهادی برای API Gateway)، Redis فقط Cache/Session، Object Storage برای پیوست

---

# 3. جدول منابع per سرویس

| Service | CPU | RAM | Disk | Network | توضیح |
|---|---|---|---|---|---|
| HAProxy | 0.2–0.5 Core | 150–300 MB | <1 GB | کم | ۵–۱۰٪ یک هسته |
| Next.js Frontend | 1–2 Core | 1–2 GB | 5–10 GB | متوسط | صفحات سایت + Portal |
| FastAPI Gateway | 1–2 Core | 1–2 GB | 2 GB | متوسط | ~۲۰–۵۰ RPS |
| Odoo | 4 Core | 6–8 GB | 20 GB | متوسط | ~۱۰ کارمند فعال + API |
| PostgreSQL | 2–4 Core | 6–8 GB | 50–100 GB SSD/NVMe | کم | ~۱۰۰ مشتری، ایندکس، کش |
| Redis | 0.5 Core | 512 MB–1 GB | <1 GB | کم | Session + Cache |
| Object Storage | 0.5 Core | 512 MB | ≥100 GB | متوسط | پیوست تیکت، تصاویر، PDF |

**جمع روی یک ماشین (فرضی):** ۱۰–۱۴ vCPU، ۱۶–۲۲ GB RAM، ۱۸۰–۲۵۰ GB Storage — به همین دلیل جداسازی Frontend از Business Server توصیه می‌شود.

---

# 4. سناریوی رشد — اگر ۱۰۰۰ مشتری

| Service | تغییر |
|---|---|
| Frontend | تقریباً بدون تغییر |
| HAProxy | تقریباً بدون تغییر |
| FastAPI | افزایش جزئی |
| Redis | افزایش جزئی |
| Odoo | افزایش محسوس |
| PostgreSQL | افزایش زیاد |
| Object Storage | افزایش زیاد |

**نتیجه:** رشد اصلی روی PostgreSQL، Odoo، و Object Storage است — نه Frontend.

---

# 5. جدول اولویت جداسازی (Baseline + زمان جداسازی)

| سرویس | وظیفه | CPU | RAM | Disk I/O | منابع پیشنهادی (Baseline) | زمان جداسازی |
|---|---|:-:|:-:|:-:|---|---|
| Frontend (Next.js) | Website, Customer Portal | 🟡 | 🟡 | 🟢 | 2 vCPU / 2 GB / 20 GB SSD | از روز اول جدا |
| HAProxy | Reverse Proxy, SSL, LB | 🟢 | 🟢 | 🟢 | 0.5 vCPU / 256 MB / 2 GB SSD | کنار Frontend |
| API Gateway (FastAPI) | Auth, Authorization, API | 🟡 | 🟡 | 🟢 | 2 vCPU / 2 GB / 10 GB SSD | ابتدا کنار Odoo |
| Odoo | ERP, Workflow, Business Logic | 🔴 | 🔴 | 🟡 | 8 vCPU / 16 GB / 50 GB SSD | هسته سیستم |
| PostgreSQL | Database | 🟡 | 🔴 | 🔴 | 4 vCPU / 16 GB / 100 GB NVMe | ابتدا کنار Odoo |
| Redis (اختیاری) | Cache, Session, Queue | 🟢 | 🟡 | 🟢 | 1 vCPU / 1 GB / 5 GB SSD | در صورت نیاز |
| Object Storage (اختیاری) | فایل‌ها و پیوست‌ها | 🟢 | 🟢 | 🟡 | 2 vCPU / 2 GB / بر اساس رشد | در صورت رشد |

---

**Status:** LOCKED — این سند فقط سطح اکوسیستم را پوشش می‌دهد؛ منابع مصرفی واقعی Backend این پروژه در DOC-052 (توپولوژی) دقیق‌تر می‌شود.
