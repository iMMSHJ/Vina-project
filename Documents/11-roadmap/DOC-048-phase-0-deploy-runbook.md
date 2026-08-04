# DOC-048 — Phase 0 Deploy Runbook

**Status:** LOCKED
**Phase:** Phase 0 (اجرای مستقیم)
**Document Type:** Runbook
**Traces to:** DOC-014, DOC-015, DOC-037, DOC-040, DOC-041, DOC-047

---

# 1. Objective

دستورالعمل قدم‌به‌قدم اجرای فاز ۰ روی محیط Staging موجود (Odoo 19 Community، طبق DOC-040 §8). این سند تنها Runbook اجرایی این نشست است — بقیه مستندات معماری/طراحی‌اند، این یکی عملیاتی است.

---

# 2. پیش‌نیاز

- دسترسی SSH/Admin به سرور Staging
- دسترسی Settings > Apps در Odoo (طبق اسکرین‌شات قبلی)
- اتصال اینترنت سرور برای Clone کردن Repositoryهای OCA

---

# 3. مرحله ۱ — پاکسازی

```bash
# اتصال به سرور Staging
ssh <staging-server>

# غیرفعال‌سازی و حذف ماژول تست
# از UI: Settings > Apps > جستجوی "vina_base" > Uninstall
# یا از خط فرمان:
odoo-bin -d <db_name> -u vina_base --stop-after-init  # اگر نیاز به Uninstall via shell بود، از UI انجام شود (امن‌تر)
```

**تأیید:** بعد از Uninstall، مطمئن شوید `vina_base` دیگر در لیست Apps دیده نمی‌شود.

---

# 4. مرحله ۲ — نصب ماژول اثبات‌شده (`contract`)

```bash
cd /path/to/custom-addons
git clone -b 19.0 https://github.com/OCA/contract.git oca-contract
```

سپس از UI: Apps > Update Apps List > جستجوی «Contract» > Install (فقط ماژول پایه `contract`، بدون زیرماژول‌های اضافه مثل `contract_sale` مگر نیاز اثبات شود — طبق اصل Watchlist DOC-040).

**تأیید:** ساخت یک `contract.contract` تستی از UI و بررسی صحت نصب.

---

# 5. مرحله ۳ — بررسی دو Open Item (طبق DOC-047 §3)

## 5.1 بررسی `hr_attendance`

```
Settings > Apps > جستجوی "Attendances"
```

- اگر نصب است: ✅ ثبت شود در این سند (بخش ۷).
- اگر نصب نیست: تصمیم — طبق اصل سادگی v1، اگر نیاز فوری Technician Dashboard (DOC-045 §6.2) نیست، نصب را به فاز ۶ موکول کنید؛ در غیر این صورت همین‌جا نصب شود (رایگان، بدون وابستگی OCA).

## 5.2 بررسی `sign_oca` روی Branch 19.0

```bash
cd /path/to/custom-addons
git clone -b 19.0 https://github.com/OCA/... sign_oca   # آدرس دقیق را از Apps Store OCA تأیید کنید
```

- اگر Clone و Install موفق بود: ✅ ثبت در بخش ۷، استفاده در `pps_portal` (DOC-042 §7).
- اگر Branch 19.0 موجود/پایدار نبود: **Fallback فعال می‌شود** — تأیید سرویس با Checkbox + Timestamp + IP Log (از قبل در DOC-042 §10.1 به‌عنوان جایگزین تعریف شده، بدون نیاز به تصمیم جدید).

---

# 6. مرحله ۴ — تأیید نهایی محیط پایه

چک‌لیست قبل از شروع کدنویسی ماژول‌های `pps_*`:

- [x] `vina_base` حذف شد
- [x] `contract` (OCA) نصب و تست شد
- [x] وضعیت `hr_attendance` مشخص و ثبت شد — نصب شد
- [x] وضعیت `sign_oca` مشخص و ثبت شد
- [x] بومی‌سازی ایران (`l10n_ir_account`, `l10n_ir_states`) نصب و تست شد (خارج از چک‌لیست اولیه، اما در همین فاز تکمیل شد)
- [x] فونت PDF فارسی (`l10n_ir_fonts`) و `wkhtmltopdf` نصب و تست شد
- [ ] لیست نهایی ماژول‌های نصب‌شده Export و در کنار DOC-040 آرشیو شود (توصیه می‌شود، غیر-بلاکر)

## 6.1 وضعیت: فاز ۰ عملاً تکمیل شد ✅

تمام موارد بلاکر برای شروع فاز ۲ (کدنویسی `pps_asset` و بقیه ماژول‌ها) برطرف شدند.

---

# 7. ثبت نتیجه (تکمیل توسط تیم اجرا)

> این بخش بعد از اجرای واقعی مراحل بالا تکمیل می‌شود — جای خالی عمدی است، نه نقص سند.

| آیتم | نتیجه | تاریخ |
|---|---|---|
| `vina_base` حذف شد | ✅ (به‌همراه چند ماژول Vina دیگر که روی دیسک بودن) | ۲۵ تیر ۱۴۰۵ |
| `contract` نصب شد | ✅ — تأیید از لاگ (`Module contract loaded in 3.15s`) و اجرای موفق Cron Job | ۲۵ تیر ۱۴۰۵ |
| زبان فارسی UI | ✅ فعال — تست RTL/اعداد فارسی سالم؛ یافته تکمیلی: نمایش نام ماه فارسی ≠ تقویم جلالی واقعی (جزئیات DOC-049 §3.1) | ۲۵ تیر ۱۴۰۵ |
| `l10n_ir_fonts` | ✅ نصب و تست شد (فونت PDF سالم) | ۲۵ تیر ۱۴۰۵ |
| `wkhtmltopdf` | ✅ نصب نسخه Patched + اصلاح `PATH` در `odoo.service` (جزئیات DOC-049 §9) | ۲۵ تیر ۱۴۰۵ |
| `hr_attendance` | ✅ نصب شد | ۲۵ تیر ۱۴۰۵ |
| `sign_oca` | ✅ بررسی/اقدام انجام شد (Clone یا Fallback طبق DOC-042 §10.1) | ۲۵ تیر ۱۴۰۵ |
| زبان پیش‌فرض | ✅ برگردانده شد به English (US) | ۲۵ تیر ۱۴۰۵ |
| `l10n_ir_states` | ✅ نصب و فعال شد | ۲۵ تیر ۱۴۰۵ |
| `l10n_ir_account` | ✅ نصب شد؛ `Fiscal Localization Package` روی «ایران IR» تنظیم شد، مالیات ۱۵٪ پیش‌فرض فعال | ۲۵ تیر ۱۴۰۵ |
| **یافته اضافه:** `persian_calendar` (third-party) با Odoo 19 ناسازگار بود و Uninstall شد | ✅ حل شد | ۲۵ تیر ۱۴۰۵ |
| **یافته اضافه:** رندر Bidi/RTL در PDF (خروجی `wkhtmltopdf`) با پیش‌نمایش HTML متفاوت است — محدودیت شناخته‌شده، راه‌حل در DOC-049 §7.1 | ✅ مستند شد | ۲۵ تیر ۱۴۰۵ |

---

# 8. قدم بعدی

با تکمیل چک‌لیست بخش ۶، محیط پایه آماده شروع توسعه ماژول‌های `pps_*` طبق ترتیب Roadmap (DOC-037 فاز ۲: `pps_asset` → `pps_package` → `pps_contract` → `pps_sla`) است.

---

**Status:** LOCKED
