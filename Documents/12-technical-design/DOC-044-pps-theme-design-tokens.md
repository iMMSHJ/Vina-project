# DOC-044 — `pps_theme` Design Tokens

**Status:** Draft — Pending Review
**Phase:** Phase 4 (Website Theme & Design System)
**Document Type:** Technical Design / Design System
**Traces to:** DOC-016, DOC-017, DOC-018 §21, DOC-036 §5

---

# 1. Objective

تعریف Design Tokenهای واقعی (نه فقط اصول) برای `pps_theme` — رنگ، تایپوگرافی، Spacing، Radius — که پایه‌ی همه صفحات اختصاصی (Wizard, Portal, Dashboard, Website) قرار می‌گیرد. طبق DOC-036 §5.3: مینیمال، مدرن، RTL Native.

---

# 2. Color Tokens

## 2.1 اصل انتخاب

یک رنگ اصلی (Brand) + طیف خاکستری خنثی + ۴ رنگ وضعیتی (Success/Warning/Danger/Info) — بدون رنگ‌های تزئینی اضافه، سازگار با «Flat & Minimal» (DOC-036 §5.3).

## 2.2 CSS Variables (پیشنهاد اولیه — قابل تنظیم با برندبوک شرکت)

```scss
:root {
  /* Brand — رنگ اصلی شرکت (نمونه: آبی صنعتی، قابل جایگزینی با رنگ برند واقعی) */
  --pps-brand-50:  #EFF6FF;
  --pps-brand-100: #DBEAFE;
  --pps-brand-400: #3B82F6;
  --pps-brand-600: #1D4ED8;
  --pps-brand-800: #1E3A8A;

  /* Neutral — پایه متن/پس‌زمینه */
  --pps-gray-0:   #FFFFFF;
  --pps-gray-50:  #F8F9FA;
  --pps-gray-100: #F1F3F5;
  --pps-gray-300: #CED4DA;
  --pps-gray-500: #868E96;
  --pps-gray-700: #495057;
  --pps-gray-900: #212529;

  /* Status */
  --pps-success: #2F9E44;
  --pps-warning: #F08C00;
  --pps-danger:  #E03131;
  --pps-info:    #1971C2;

  /* Semantic (مصرف واقعی در Component) */
  --pps-text-primary:   var(--pps-gray-900);
  --pps-text-secondary: var(--pps-gray-700);
  --pps-text-muted:     var(--pps-gray-500);
  --pps-surface:        var(--pps-gray-0);
  --pps-surface-alt:    var(--pps-gray-50);
  --pps-border:         var(--pps-gray-300);
}
```

> **یادداشت:** مقادیر Brand بالا Placeholder هستند — باید با برندبوک واقعی شرکت (لوگو، رنگ شرکتی موجود) جایگزین شوند. ساختار Token (نام متغیرها) تغییر نمی‌کند، فقط مقدار Hex.

---

# 3. Typography Tokens

## 3.1 فونت — RTL Native (طبق DOC-036 §5.3)

**تصمیم:** فونت **Vazirmatn** (فونت متن‌باز فارسی، پشتیبانی کامل RTL + اعداد فارسی/لاتین + سازگار با فونت‌های لاتین رایج برای بخش‌های انگلیسی).

```css
@font-face {
  font-family: 'Vazirmatn';
  src: url('/pps_theme/static/fonts/Vazirmatn-Variable.woff2') format('woff2-variations');
  font-weight: 100 900;
}

:root {
  --pps-font-family: 'Vazirmatn', -apple-system, sans-serif;
}
```

## 3.2 Scale (محدود، طبق اصل Minimal)

| Token | Size | استفاده |
|---|---|---|
| `--pps-text-xs` | 12px | برچسب، متادیتا |
| `--pps-text-sm` | 14px | متن فرعی |
| `--pps-text-base` | 16px | متن اصلی بدنه |
| `--pps-text-lg` | 18px | زیرعنوان |
| `--pps-text-xl` | 22px | عنوان صفحه |
| `--pps-text-2xl` | 28px | عنوان اصلی (کم‌مصرف) |

**وزن:** فقط دو وزن — `400` (عادی) و `500` (تأکید). بدون `700`/Bold سنگین، طبق فلسفه Minimal.

---

# 4. Spacing & Radius Tokens

```css
:root {
  --pps-space-xs: 4px;
  --pps-space-sm: 8px;
  --pps-space-md: 16px;
  --pps-space-lg: 24px;
  --pps-space-xl: 32px;
  --pps-space-2xl: 48px;

  --pps-radius-sm: 6px;
  --pps-radius-md: 10px;
  --pps-radius-lg: 16px;
  --pps-radius-pill: 999px;
}
```

---

# 5. Jalali Calendar — Utility (طبق DOC-040 §3.2)

پیاده‌سازی سمت Frontend، **نه وابستگی OCA** (طبق تصمیم قبلی):

```js
// pps_theme/static/src/js/utils/jalali.js
import jalaali from 'jalaali-js';   // کتابخانه استاندارد JS، بدون وابستگی به Odoo/OCA

export function toJalali(gregorianDate) {
  const { jy, jm, jd } = jalaali.toJalaali(gregorianDate);
  return `${jy}/${String(jm).padStart(2, '0')}/${String(jd).padStart(2, '0')}`;
}
```

این Utility در همه Componentهای Custom (Wizard, Portal, Dashboard) بازاستفاده می‌شود — یک منبع واحد تبدیل تاریخ.

---

# 6. Component Primitives (سطح پایه، طبق DOC-036 §6 — `pps_theme`)

فقط اجزای پایه‌ای که در همه صفحات تکرار می‌شوند — نه یک Component Library کامل (برای جلوگیری از پیچیدگی زودهنگام v1):

| Component | استفاده |
|---|---|
| Button (Primary / Secondary / Ghost) | همه CTAها |
| Card | Dashboard Widgets، Asset Cards |
| Badge (Status) | وضعیت Ticket، SLA |
| Stepper | Ticket Wizard (DOC-038) |
| Input / Select / Textarea | تمام فرم‌ها |

## 6.1 نمونه Button (Flat, Minimal)

```css
.pps-btn {
  font-family: var(--pps-font-family);
  font-size: var(--pps-text-base);
  font-weight: 500;
  padding: var(--pps-space-sm) var(--pps-space-lg);
  border-radius: var(--pps-radius-md);
  border: none;
  cursor: pointer;
  transition: background-color 0.15s ease;
}
.pps-btn--primary {
  background: var(--pps-brand-600);
  color: var(--pps-gray-0);
}
.pps-btn--primary:hover { background: var(--pps-brand-800); }
.pps-btn--secondary {
  background: var(--pps-surface-alt);
  color: var(--pps-text-primary);
  border: 1px solid var(--pps-border);
}
```

## 6.2 نمونه Badge وضعیت (نگاشت به SLA/Ticket Status)

```css
.pps-badge--success { background: color-mix(in srgb, var(--pps-success) 12%, white); color: var(--pps-success); }
.pps-badge--warning { background: color-mix(in srgb, var(--pps-warning) 12%, white); color: var(--pps-warning); }
.pps-badge--danger  { background: color-mix(in srgb, var(--pps-danger) 12%, white);  color: var(--pps-danger); }
```

---

# 7. RTL Layout Rules

- `direction: rtl` روی سطح صفحه (نه Patch موضعی) — طبق DOC-036 §5.3.
- استفاده از `margin-inline-start/end` و `padding-inline-start/end` به‌جای `left/right` مستقیم — برای سازگاری خودکار RTL/LTR (بخش انگلیسی احتمالی آینده).
- آیکون‌های جهت‌دار (فلش بعدی/قبلی در Wizard) باید بر اساس `direction` صفحه Mirror شوند.

---

# 8. Dark Mode — آماده برای آینده، نه v1

طبق DOC-036 §5.3، ساختار Token از همین الان برای Dark Mode آماده است (چون همه‌چیز از طریق CSS Variable تعریف شده)، اما پیاده‌سازی واقعی Dark Mode **در v1 نیست** — فقط ساختار مانع نمی‌شود.

---

# 9. Module Structure

```
pps_theme/
├── static/src/
│   ├── scss/
│   │   ├── tokens.scss        # بخش ۲-۴ همین سند
│   │   ├── components/        # Button, Card, Badge, Stepper
│   │   └── rtl.scss           # بخش ۷
│   ├── fonts/
│   │   └── Vazirmatn-Variable.woff2
│   └── js/
│       └── utils/jalali.js    # بخش ۵
└── __manifest__.py
```

**وابستگی:** `web` (استاندارد Odoo، فقط برای Asset Bundling) — بدون وابستگی به OCA/Enterprise Theme (طبق DOC-036 §3.2).

---

# 10. Resolved

رنگ‌های Brand در بخش ۲.۲ فعلاً **Placeholder قابل‌استفاده** باقی می‌مانند (آبی صنعتی خنثی) — چون منتظر ماندن برای برندبوک نباید فاز ۰/۱ را متوقف کند. ساختار Token (نام متغیرها) نهایی و قفل است؛ فقط مقدار Hex در `tokens.scss` در هر زمان (حتی بعد از شروع پیاده‌سازی) با یک تغییر تک‌فایلی قابل جایگزینی است — بدون نیاز به تغییر در هیچ Componentی.

---

# DOC-044 — LOCKED ✅
