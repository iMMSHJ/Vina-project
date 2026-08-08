# DOC-011 — System Architecture

**Version:** 2.0
**Status:** Approved – Revised
**Supersedes:** DOC-011 v1.0
**Aligned with:** DOC-036 (LOCKED), DOC-050 (LOCKED), DOC-052 (LOCKED), DOC-046

## 1. Scope

این سند معماری منطقی کلان پلتفرم را با سه افق زمانی ثبت می‌کند:
- **Current** — وضعیت اجراشده امروز
- **Transition** — مسیر فعلی که تا تکمیل معتبر است (QWeb/Odoo Website)
- **Target** — معماری هدف (Next.js + API Gateway)

نگاشت دقیق ماژول‌ها در DOC-012 است.

## 2. Architecture Principles
```text
Odoo Standard First
→ OCA فقط برای Data / Backend Logic (نه Presentation)
→ Custom برای تمام Presentation/UI کاربر نهایی
→ Business Logic فقط داخل Odoo
→ Loose Coupling از طریق Service Layer
→ High Maintainability / Upgrade Friendly
→ Mobile First / API Ready

اصل قدیمی «OCA First» با تصمیم قفل‌شده DOC-036 جایگزین شد؛ OCA دیگر اصل مطلق نیست.

## 3. Current / Transition Architecture

text
Internet
   │
Nginx (Reverse Proxy / SSL)
   │
Odoo Website + QWeb + pps_ticket_wizard
   │
Odoo Core (Business Layer)
   │
PostgreSQL + Filestore

این معماری امروز فعال است. `pps_ticket_wizard` از الگوی زیر پیروی می‌کند:

text
Controller → Service Layer → Odoo Models

Odoo Website/QWeb **حذف نمی‌شود** و تا تکمیل مهاجرت مسیر رسمی Customer UI باقی می‌ماند.

## 4. Target Architecture (Unified Single-Platform)

text
Users
(Customer / Employee / Admin)
│
One Domain
│
CDN (اختیاری – خارج از MVP)
│
HAProxy — i-srv-2
(Security / Rate Limiting / Load Balancing)
│
Nginx — i-srv-1
(Reverse Proxy / SSL / Static)
│
┌─────────────┴─────────────┐
│                           │
Next.js UI                   Odoo Web Client
   (Customer Portal, Ticket        (Employee / Admin
Wizard آینده, Dashboard,        Backoffice UI)
Marketplace, Responsive)
│                           │
└─────────────┬─────────────┘
│
API Gateway — i-srv-1
(Routing / Validation / Auth
Forwarding / Rate Limiting)
│
Odoo Business Core — i-srv-1
(Ticket, Contract, SLA, Asset, Package,
Inventory, Accounting, Service Report,
Security / ACL / Record Rules)
│
PostgreSQL + Redis + Object Storage/Filestore

مهاجرت به این معماری **مرحله‌ای** است. Next.js و API Gateway جایگزین فوری QWeb نیستند؛ Timeline در DOC-037/Roadmap مشخص می‌شود.

## 5. Component Responsibilities

| لایه | مسئولیت |
|---|---|
| Next.js | Customer Portal، Ticket Wizard آینده، Dashboard، Marketplace، Mobile-first UI، صفحات اختصاصی Employee/Admin در صورت نیاز |
| Odoo Web Client | UI استاندارد Backoffice برای Employee/Admin |
| API Gateway | Routing، Validation، Formatting، Auth Forwarding، Rate Limiting، Versioning احتمالی — بدون مالکیت Business Logic |
| HAProxy | Security Controls، Rate Limiting، Edge Entry، Load Balancing در صورت نیاز |
| Nginx | Reverse Proxy، SSL Termination، Static Files، Compression |
| Odoo | Business Logic، Data Model، System of Record، Security Enforcement |
| PostgreSQL | پایگاه داده اصلی |
| Redis | Cache / Session / Queue در صورت نیاز |
| Object Storage / Filestore | نگهداری Attachmentها و فایل‌های سرویس |
| CDN | اختیاری، خارج از MVP؛ هر ارائه‌دهنده قابل استفاده است |

## 6. Presentation Layer Ownership

مطابق DOC-036:

- Customer، Technician و Guest فقط UI کاملاً Custom می‌بینند (Next.js یا فعلاً QWeb اختصاصی).
- Odoo Backend UI استاندارد فقط برای Employee/Admin/Backoffice است.
- Website Builder، Snippets و OCA UI منبع صفحات کاربردی نیستند.
- OCA فقط در Data/Backend/Localization/Reporting مجاز است، هرگز در Presentation.

text
نیاز داده/منطق موجود است  → Odoo Standard
کمبود Data/Backend Logic  → OCA (پس از بررسی)
نیاز UI/Form/Page         → Custom Development

## 