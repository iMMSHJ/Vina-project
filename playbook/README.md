# README.md — راهنمای کامل ساخت Ansible Playbook برای Odoo 19 (پروژه Vina)

```markdown
# Odoo 19 Ansible Installer (Vina)

مهاجرت اینستالر Bash (`installer.zip`) به ساختار Ansible Playbook.
مرجع منطق: `install.sh` (ترتیب اجرای واقعی آرایه `MODULES`، نه ترتیب نام‌گذاری فایل‌ها).

---

## ۱. پیش‌نیازها

- Ansible >= 2.15
- کالکشن‌های مورد نیاز:
  ```bash
  ansible-galaxy collection install community.postgresql community.general ansible.posix
  ```
- دسترسی SSH با کاربر `mmshj` (sudo) به سرورهای `i-srv-1` و `i-srv-2`

---

## ۲. ساختار کامل دایرکتوری

```
/opt/playbook/
├── ansible.cfg
├── site.yml
├── requirements.yml
├── inventory/
│   ├── hosts
│   └── group_vars/
│       ├── all.yml
│       └── vault.yml          # رمزنگاری‌شده با ansible-vault
└── roles/
    ├── preflight/          # از 00-precheck.sh + 00-preflight.sh
    ├── bootstrap/          # از 01-bootstrap.sh
    ├── system_update/      # از 02-system-update.sh
    ├── odoo_user/          # از 03-users.sh
    ├── postgresql/         # از 04-postgresql.sh
    ├── redis/              # از 05-redis.sh
    ├── python/             # از 06-python.sh
    ├── odoo_source/        # از 07-odoo-source.sh
    ├── odoo_config/        # از 08-odoo-config.sh
    ├── odoo_db_init/       # از 08b-odoo-db-init.sh
    ├── odoo_systemd/       # از 09-odoo-systemd.sh
    ├── nginx/              # از 10-nginx.sh
    ├── local_ssl/          # از 11-local-ssl.sh
    ├── firewall/           # از 12-firewall.sh
    ├── backup/             # از 13-backup.sh
    ├── security/           # از 14-security.sh (fail2ban)
    ├── logrotate/          # از 15-logrotate.sh
    ├── oca_install/        # از 17-oca-install.sh
    ├── addon_path/         # از 18-addon-path.sh
    └── healthcheck/        # از 16-healthcheck.sh

هر نقش دارای زیرساختار استاندارد:

roles/<role_name>/
├── tasks/main.yml
├── handlers/main.yml
├── defaults/main.yml
├── vars/main.yml
├── templates/
└── files/

> نکته: فایل‌های `installer/modules/00-interactive.sh` و `19-database-init.sh` در آرایه `MODULES` داخل `install.sh` **حضور ندارند** و در نصب واقعی اجرا نمی‌شوند. بنابراین در مهاجرت به Ansible باید تصمیم گرفته شود که آیا معادل آن‌ها (مثلاً به‌عنوان یک نقش اختیاری `interactive_vars` یا `db_init_extra`) ساخته شود یا کاملاً نادیده گرفته شود.

---

## ۳. ترتیب اجرای نقش‌ها در `site.yml`

مطابق ترتیب واقعی آرایه `MODULES` در `install.sh:139-161`:

yaml
---
- name: Install and configure Odoo 19 (Vina)
  hosts: odoo_servers
  become: true

  roles:
    - preflight        # 00-precheck + 00-preflight (بخشی از preflight هم بعد از python اجرا می‌شود)
    - bootstrap         # 01
    - system_update      # 02
    - odoo_user           # 03
    - postgresql           # 04
    - redis                 # 05
    - python                 # 06
    # preflight (dependency validation) دوباره اینجا فراخوانی می‌شود
    - odoo_source           # 07
    - odoo_config             # 08
    - odoo_db_init             # 08b
    - odoo_systemd               # 09
    - nginx                        # 10
    - local_ssl                     # 11
    - firewall                        # 12
    - backup                            # 13
    - security                            # 14 (fail2ban)
    - logrotate                             # 15
    - oca_install                             # 17
    - addon_path                               # 18
    - healthcheck                                # 16

---

## ۴. متغیرهای سراسری (`inventory/group_vars/all/vars.yml`)

برگرفته از `installer/config/installer.conf` (استخراج شده):

yaml
# Odoo
odoo_version: "19.0"
odoo_edition: community
odoo_core_modules:
  - base
  - mail
  - contacts
  - calendar
  - project
  - maintenance
  - hr
  - hr_timesheet
  - sale_management

# Paths
odoo_home: /opt/odoo
odoo_source: /opt/odoo/src/odoo
odoo_venv: /opt/odoo/venv
odoo_custom_addons: /opt/odoo/custom_addons
oca_dir: /opt/odoo/oca

# Linux User
odoo_user: odoo
odoo_group: odoo

# PostgreSQL
postgres_version: "16"
postgres_user: odoo
odoo_db_name: odoo        # توجه: در فایل اصلی دو بار override شده (vina -> odoo)، مقدار نهایی odoo است

# Redis
redis_version: "7"

# Node / Python
node_version: "22"
python_version: "3"

# Reports
report_engine: chromium

# Mode
odoo_dev_mode: false

# Backup
backup_enable: true
backup_cron_schedule: "0 2 * * *"

# Initial DB
odoo_install_modules:
  - base

# Network
odoo_port: 8069
longpolling_port: 8072
odoo_domain: odoo.local

# Nginx / SSL / Security
nginx_enable: true
ssl_enable: true
ssl_country: IR
firewall_enable: true
fail2ban_enable: true
fail2ban_bantime: 3600
fail2ban_findtime: 600
fail2ban_maxretry: 5
fail2ban_ignoreip: "127.0.0.1/8"

# Odoo Source Repo
odoo_repo: "https://github.com/odoo/odoo.git"
odoo_branch: "19.0"

# Timezone
timezone: Asia/Tehran

# Firewall Ports
firewall_allowed_ports:
  - 22
  - 80
  - 443
  - 8069

> **نکته مهم:** در فایل اصلی `installer.conf`، متغیرهای `ODOO_DB_NAME`، `SSL_COUNTRY` و سه متغیر Fail2ban هرکدام دو بار تعریف شده‌اند. در Bash آخرین مقدار برنده است (`ODOO_DB_NAME=odoo`). در نسخه Ansible این تکرارها حذف و فقط یک مقدار نهایی ثبت شده است.

---

## ۵. رمزهای عبور (`inventory/group_vars/all/vault.yml`)

> **توجه مهم:** این فایل باید حتماً داخل یک دایرکتوری به نام یکی از گروه‌های
> inventory (اینجا `all`) قرار بگیرد، نه به‌صورت یک فایل هم‌سطح `all.yml`.
> Ansible متغیرهای گروه را فقط از `group_vars/<group_name>.yml` یا از تمام
> فایل‌های داخل دایرکتوری `group_vars/<group_name>/` می‌خواند؛ فایلی به نام
> `group_vars/vault.yml` (بدون گروهی به نام «vault») هرگز لود نمی‌شود و باعث
> خطای `'vault_odoo_master_password' is undefined` می‌شود.

bash
ansible-vault create /opt/playbook/inventory/group_vars/all/vault.yml

محتوای پیشنهادی (رمزنگاری‌شده):
yaml
vault_odoo_db_password: "********"
vault_odoo_admin_password: "********"

---

## ۵.۱ پارامترهای گرفته‌شده در ابتدای نصب

هنگام اجرای `ansible-playbook site.yml`، به همین ترتیب از کاربر پرسیده می‌شود:

1. **sudo password** — خودکار توسط `become_ask_pass = True` در `ansible.cfg` قبل از شروع play پرسیده می‌شود (نیازی به `vars_prompt` ندارد).
2. **local IP address** — `backend_ip_input` در `vars_prompt` فایل `site.yml`.
3. **local domain / hostname** — `backend_hostname_input` در `vars_prompt` فایل `site.yml`.
4. **DB name** — `db_name_input` در `vars_prompt` فایل `site.yml` (پیش‌فرض `odoo`، فقط حروف/عدد/زیرخط مجاز است).
5. **DB password** — `db_password_input` در `vars_prompt` فایل `site.yml` (مخفی و با تأیید مجدد گرفته می‌شود).

مقادیر ۴ و ۵ در `pre_tasks` روی `odoo_db_name` و `odoo_db_password` ست می‌شوند و در کل play (نقش `postgresql`، `database_init`، `odoo_config`) استفاده می‌شوند.

نقش `database_init` **فقط** یک role پستگرس برای Odoo (با پسورد داده‌شده و privilege `CREATEDB`) می‌سازد؛ خود دیتابیس Odoo عمداً از طریق Ansible ساخته/مقداردهی نمی‌شود. `odoo.conf` هم با `list_db = True` و بدون `db_name`/`dbfilter` ثابت تنظیم شده — بنابراین همان بار اول که آدرس سرور در مرورگر باز شود، ویزارد استاندارد **Create Database** خود Odoo (Master Password / DB Name / Email / Password / Language / Country / Demo data) نمایش داده می‌شود، نه یک صفحهٔ لاگین با یوزر از پیش ساخته‌شده. Master Password همان `odoo_master_password` (از `vault_odoo_master_password`) است که باید در آن فرم وارد شود.

---

## ۶. اجرای Playbook

bash
cd /opt/playbook

# بررسی Syntax
ansible-playbook site.yml --syntax-check

# اجرای Dry-run
ansible-playbook -i inventory/hosts site.yml --check --ask-vault-pass

# اجرای واقعی
ansible-playbook -i inventory/hosts site.yml --ask-vault-pass

# اجرای فقط یک نقش خاص (تگ‌گذاری‌شده)
ansible-playbook -i inventory/hosts site.yml --tags "postgresql" --ask-vault-pass

---

## ۷. وضعیت پیاده‌سازی نقش‌ها

| نقش | ماژول مبدأ | وضعیت |
|---|---|---|
| preflight | 00-precheck.sh, 00-preflight.sh | ✅ تکمیل |
| bootstrap | 01-bootstrap.sh | ⏳ در انتظار |
| system_update | 02-system-update.sh | ✅ تکمیل |
| odoo_user | 03-users.sh | ✅ تکمیل |
| postgresql | 04-postgresql.sh | ✅ تکمیل |
| redis | 05-redis.sh | ⏳ در انتظار |
| python | 06-python.sh | ⏳ در انتظار |
| odoo_source | 07-odoo-source.sh | ⏳ در انتظار |
| odoo_config | 08-odoo-config.sh | ⏳ در انتظار |
| odoo_db_init | 08b-odoo-db-init.sh | ⏳ در انتظار |
| odoo_systemd | 09-odoo-systemd.sh | ⏳ در انتظار |
| nginx | 10-nginx.sh | ⏳ در انتظار |
| local_ssl | 11-local-ssl.sh | ⏳ در انتظار |
| firewall | 12-firewall.sh | ⏳ در انتظار |
| backup | 13-backup.sh | ⏳ در انتظار |
| security | 14-security.sh | ⏳ در انتظار |
| logrotate | 15-logrotate.sh | ⏳ در انتظار |
| oca_install | 17-oca-install.sh | ⏳ در انتظار |
| addon_path | 18-addon-path.sh | ⏳ در انتظار |
| healthcheck | 16-healthcheck.sh | ⏳ در انتظار |

ماژول‌های `00-interactive.sh` و `19-database-init.sh` جزو گردش‌کار پیش‌فرض `install.sh` نیستند و در Ansible هم به‌صورت پیش‌فرض معادل‌سازی نمی‌شوند مگر تصمیم دیگری گرفته شود.

---

## ۸. منابع

- `installer/install.sh` — ترتیب اجرای ماژول‌ها، مدیریت state و lock
- `installer/config/installer.conf` — تمام متغیرهای پیکربندی
- `installer/lib/functions.sh` — توابع کمکی (info/success/warning/error/command_exists)


---

این README کل نقشهٔ راه (ساختار پوشه‌ها، فایل‌ها، ترتیب نقش‌ها، متغیرها، و وضعیت پیشرفت) را پوشش می‌دهد. اگر بخواهی، در پیام بعدی می‌توانم محتوای دقیق `tasks/main.yml` برای نقش‌های باقی‌مانده (مثلاً `bootstrap`, `redis`, `python`) را هم بر اساس محتوای واقعی اسکریپت‌های مربوطه استخراج و آماده کنم.
