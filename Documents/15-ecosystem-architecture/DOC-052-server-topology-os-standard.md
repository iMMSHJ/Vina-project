# DOC-052 — Server Topology and OS Standard

**Status:** `LOCKED` (sections 2–4); section 5.1 remains open  
**Phase:** Cross-Phase — Ecosystem Level  
**Path:** `docs/15-ecosystem-architecture/DOC-052-server-topology-os-standard.md`  
**References:** `DOC-050`, `DOC-051`

---

## 1. هدف

تعیین دو تصمیم کلیدی زیرساخت:

1. **توپولوژی سرور:** چگونه سرویس‌های اکوسیستم روی سرورها توزیع می‌شوند؟
2. **استاندارد سیستم‌عامل:** کدام OS برای همه سرورها؟

---

## 2. گزینه‌های توپولوژی

### گزینه الف: دو سرور ثابت (Standard Two-Server)

```text
Server 1: Frontend + HAProxy
Server 2: API (FastAPI) + Odoo + PostgreSQL
```

| سرور | سرویس‌ها | منابع پایه (DOC-051) |
|---|---|---|
| **Server 1 — Frontend** | HAProxy + Next.js | 2 vCPU / 2 GB RAM / 20 GB SSD |
| **Server 2 — Business** | FastAPI + Odoo + PostgreSQL + Redis | 8 vCPU / 16 GB RAM / 200 GB NVMe SSD |

**مزایا:**
- ساده
- هزینه قابل پیش‌بینی
- مدیریت آسان‌تر برای تیم کوچک

**محدودیت:**
- جداسازی بیشتر (مثلاً PostgreSQL مستقل) نیازمند Migration دستی

---

### گزینه ب: Cloud Node Architecture

هر سرویس روی Node جداگانه:
- Managed PostgreSQL
- Container per Service
- مقیاس‌پذیری مستقل هر سرویس

**مزایا:**
- مقیاس‌پذیری مستقل
- تخمین منابع دقیق از ابتدا لازم نیست

**محدودیت‌ها:**
- پیچیدگی عملیاتی بالاتر
- هزینه متغیر و غیرقابل پیش‌بینی
- نیاز به تخصص DevOps بیشتر

---

## 3. تصمیم نهایی توپولوژی (`LOCKED`)

**انتخاب: گزینه الف — دو سرور ثابت**

**دلیل:**
- سادگی معماری برای v1
- سرعت بالاتر در رسیدن به Production
- هم‌راستا با تصمیمات قبلی پروژه

Cloud Node فقط مسیر رشد آینده باقی می‌ماند؛ زمانی که نیاز به مقیاس‌پذیری اثبات شود.

---

### 3.1. نام‌گذاری نهایی سرورها

```text
┌─────────────────────────────────────────┐
│  i-srv-1 (Business Server)              │
│  ─────────────────────────────────────  │
│  • Odoo 18 Community                    │
│  • PostgreSQL 16                        │
│  • API Gateway (FastAPI)                │
│  • Redis (Session + Cache)              │
│  • Object Storage (Local/S3)            │
│                                         │
│  Baseline: 8 vCPU / 16 GB / 200 GB NVMe│
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│  i-srv-2 (Frontend Server)              │
│  ─────────────────────────────────────  │
│  • Next.js 15 (SSR/SSG)                 │
│  • HAProxy (Reverse Proxy + SSL)        │
│                                         │
│  Baseline: 2 vCPU / 2 GB / 20 GB SSD   │
└─────────────────────────────────────────┘
```

---

### 3.2. تصمیم درباره Redis و Object Storage

**Redis و Object Storage روی `i-srv-1` قرار می‌گیرند، نه Frontend.**

**دلایل:**

| دلیل | توضیح |
|---|---|
| مصرف‌کننده مستقیم | Odoo و API مستقیماً با Redis و Object Storage ارتباط دارند |
| کاهش Latency | نزدیکی به Odoo و API تأخیر شبکه‌ای را کاهش می‌دهد |
| ارتباط محدود با Frontend | Next.js مستقیماً با Redis یا Object Storage ارتباط ندارد |
| Redis برای Session | Session Odoo و Cache Internal API در Redis ذخیره می‌شود |
| Object Storage | فایل‌های پیوست Ticket و Service Report در Object Storage قرار دارد |

---

## 4. استاندارد سیستم‌عامل (`LOCKED`)

**تمام سرورهای اکوسیستم:**

```text
Ubuntu 26.04 LTS Minimal
```

این شامل:
- Frontend Server (`i-srv-2`)
- Business Server (`i-srv-1`)
- هر Node آینده

---

### 4.1. دلایل انتخاب

| دلیل | توضیح |
|---|---|
| **یکپارچگی** | همه سرورها نسخه یکسان؛ کاهش خطای "فقط روی سرور من کار می‌کند" |
| **سازگاری** | Staging پروژه (DOC-040 §8) از Ubuntu 26.04 LTS استفاده می‌کند |
| **Minimal** | بسته‌های پیش‌فرض کمتر → Attack Surface کمتر |
| **LTS** | پشتیبانی بلندمدت برای ثبات Production |

---

## 5. مورد باز: Multi-Tenant Resource Plan

### 5.1. تصمیم باز — برنامه منابع برای مشتری جدید

**سؤال تجاری حل‌نشده:**

1. سیستم تک‌مستأجر است یا چندمستأجر؟
   - **تک‌شرکت:** فقط همین پروژه
   - **SaaS:** چند شرکت مشتری

2. اگر چندمستأجر:
   - هر مشتری Database/Instance جداگانه Odoo؟
   - یا همه مشتریان در یک Instance با Multi-Company Data Isolation؟

**تأثیر:**
- مستقیماً بر Sizing در `DOC-051` اثر می‌گذارد
- پیش از قفل نهایی به جلسه تصمیم‌گیری جداگانه نیاز دارد

---

## نتیجه نهایی

**توپولوژی (`LOCKED`):**

```text
i-srv-1: Odoo + PostgreSQL + API + Redis + Object Storage
i-srv-2: Next.js + HAProxy
```

**OS استاندارد (`LOCKED`):**

```text
Ubuntu 26.04 LTS Minimal (همه سرورها)
```

**مورد باز:**
- Multi-Tenant Resource Plan (بخش 5.1)

---

سند بعدی: **`DOC-053 — Production Migration and Backup Plan`**