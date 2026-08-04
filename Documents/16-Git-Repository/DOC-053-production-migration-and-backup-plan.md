# DOC-053 — Production Migration and Backup Plan

**Status:** `LOCKED`  
**Type:** Runbook  
**Path:** `docs/11-roadmap/DOC-053-production-migration-and-backup-plan.md`  
**References:** `DOC-014`, `DOC-040`, `DOC-048`, `DOC-050`, `DOC-052`  
**Repository Commit:** `26b0a56`

> این سند فقط راهنمای اجراست؛ اجرای واقعی دستورات توسط تیم روی سرور و GitHub انجام می‌شود.

---

## 1. هدف

سه اقدام مستقل پیش از انتقال به Production:

1. انتقال کامل ماژول‌های اختصاصی `pps_*` به GitHub
2. تهیه Backup کامل دیتابیس خام و خارج‌کردن آن از Staging
3. تهیه Backup از Configها و ذخیره‌سازی خارج از سرور

---

## 2. انتقال ماژول‌های اختصاصی به GitHub

**Repository:** `IMMSHJ/my-odoo` (یا Repository خالی جدید)

**ماژول‌های اختصاصی برای Commit:**
- `pps_asset`
- `pps_contract`
- `pps_sla`
- `pps_ticket_wizard`

```bash
cd /opt/odoo/custom_addons
# git init / remote add / .gitignore
# add → commit → rename branch to main → push origin
```

**`.gitignore`:**
```text
__pycache__/
*.pyc
*.pyo
```

**نکات امنیتی:**
- بررسی نبود Password/API Key در کد پیش از Push
- ماژول‌های OCA هرگز Commit نمی‌شوند؛ فقط Version/Branch/Commit مستند می‌شود

---

## 3. Backup دیتابیس خام

### تهیه Backup

```bash
mkdir -p ~/backups
sudo -u postgres pg_dump -Fc vina-odoo \
  > ~/backups/vina-odoo-$(date +%Y%m%d-%H%M).dump
ls -lh ~/backups/
```

فرمت `-Fc` انتخاب شده چون: فشرده‌تر است + امکان Restore انتخابی جدول‌به‌جدول دارد.

### انتقال خارج از Staging

```bash
scp mmshj@<آی‌پی-سرور>:~/backups/vina-odoo-*.dump ./
```

(در صورت VM محلی: از طریق Shared Folder یا کپی به Host)

### تست صحت Backup

```bash
sudo -u postgres createdb vina-odoo-test-restore
sudo -u postgres pg_restore -d vina-odoo-test-restore ~/backups/vina-odoo-*.dump
sudo -u postgres dropdb vina-odoo-test-restore
```

Restore آزمایشی باید پیش از اعتماد به Backup موفق باشد.

---

## 4. Backup تنظیمات و اطلاعات محیط

### فایل‌های اصلی

```bash
mkdir -p ~/backups/configs
sudo cp /etc/odoo/odoo.conf ~/backups/configs/
sudo cp /etc/systemd/system/odoo.service ~/backups/configs/
```

### ثبت نسخه ماژول‌های OCA

```bash
for dir in /opt/odoo/oca/*/; do
    name=$(basename "$dir")
    commit=$(cd "$dir" && git rev-parse HEAD 2>/dev/null)
    branch=$(cd "$dir" && git rev-parse --abbrev-ref HEAD 2>/dev/null)
    echo "$name | branch=$branch | commit=$commit" \
      >> ~/backups/configs/oca-modules-versions.txt
done
```

### ثبت ماژول‌های نصب‌شده (Odoo Shell)

```python
mods = env['ir.module.module'].search([('state', '=', 'installed')])
with open('/tmp/installed_modules.txt', 'w') as f:
    for m in mods:
        f.write(f"{m.name} | {m.latest_version}\n")
```

→ خروجی در `~/backups/configs/installed_modules.txt`

### فشرده‌سازی

```bash
tar -czf ~/backups/configs-full-$(date +%Y%m%d).tar.gz ~/backups/configs/
```

---

## 5. چک‌لیست پیش از Production

- [ ] کد `pps_*` روی GitHub Push شده
- [ ] Backup کامل دیتابیس گرفته و خارج از سرور ذخیره شده
- [ ] صحت Backup با Restore آزمایشی تأیید شده
- [ ] `odoo.conf` و `odoo.service` خارج از سرور ذخیره شده‌اند
- [ ] Version/Branch/Commit ماژول‌های OCA ثبت شده
- [ ] فهرست کامل ماژول‌های نصب‌شده ثبت شده

---

## 6. ساختار نهایی Repository

بر اساس **تفکیک سرور**، نه Component:

```text
my-odoo/
├── Project Docs/
├── i-srv-1/                    ← Business Server
│   ├── opt/odoo/
│   │   ├── custom_addons/
│   │   ├── oca/VERSIONS.md
│   │   ├── src/VERSIONS.md
│   │   └── third_party/iran/
│   ├── etc/
│   │   ├── odoo/odoo.conf.template
│   │   ├── systemd/odoo.service
│   │   ├── postgresql/
│   │   └── redis/
│   ├── api/
│   └── var/
└── i-srv-2/                    ← Frontend/HAProxy (آینده)
```

**قواعد:**
- `custom_addons/` = کد کامل ماژول‌های اختصاصی
- `oca/VERSIONS.md` = فقط Repository/Branch/Commit، نه کد کامل
- `src/VERSIONS.md` = مشخصات نسخه سورس Odoo
- `third_party/iran/` = کد کامل نگه داشته می‌شود (Repository مستقل ندارد)
- `odoo.conf.template` نباید `admin_passwd` واقعی داشته باشد

---

## 7. روش Mirror، نه Live Directory

Repository مستقیماً از `/opt/odoo/` Push نمی‌شود (خطر اختلال در Odoo زنده، به‌ویژه `addons_path`).

```text
~/git-manage/my-odoo/  ← پوشه Mirror مستقل
```

**قاعده:**
```text
پیش از هر Commit:
sync.sh → کپی آخرین تغییرات از سرور واقعی به Mirror → سپس Commit
```

Sync فقط **Copy** است، نه Move؛ سرور زنده دست‌نخورده می‌ماند.

---

## 8. امنیت Token

⚠️ یک GitHub Token قبلاً بدون Mask در چت ارسال شد و بلافاصله باطل و جایگزین شد.

**قاعده دائمی:**
- Token هرگز کامل در پیام نوشته نمی‌شود
- Token مستقیماً در Terminal استفاده می‌شود
- گزارش نتیجه بدون نمایش خود Token

---

## نتیجه نهایی

```text
Status: LOCKED
Repository Commit: 26b0a56
```

ساختار Repository اجرا و روی GitHub تأیید شده است.

---

این آخرین سند در فهرست فایل‌های شماره‌دار موجود بود. اگر سند بعدی (مثلاً شماره بالاتر) دارید یا می‌خواهید فایل‌های دیگری از فهرست ۲۵ مورد باقی‌مانده بررسی شود، بگویید.