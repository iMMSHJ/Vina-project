# Prepress Service Platform
## Odoo Community 19 Service Management Blueprint

این مخزن شامل مستندات تحلیل، طراحی، معماری و نقشه راه پیاده‌سازی سامانه **مدیریت تیکت و خدمات پس از فروش** بر پایه **Odoo Community 19** است.

هدف پروژه، طراحی یک هسته استاندارد و قابل توسعه برای مدیریت خدمات، قراردادها، SLA، دارایی/دستگاه، عملیات تکنسین، پورتال مشتری و یک لایه فرانت‌اند مستقل است؛ به‌گونه‌ای که:
- تا حد ممکن از مدل استاندارد Odoo استفاده شود
- سفارشی‌سازی‌ها محدود، کنترل‌شده و مستند باشند
- فرانت‌اند از بک‌اند جدا باشد
- API Gateway به عنوان لایه یکپارچه‌سازی بین Odoo و Frontend عمل کند

---

## هدف پروژه

این سامانه برای مدیریت چرخه کامل خدمات پس از فروش طراحی شده است؛ از ثبت درخواست مشتری تا ارجاع، بررسی کارشناسی، اجرای سرویس، گزارش خدمت، بستن تیکت و رهگیری تجربه مشتری.

### اصول کلیدی دامنه
- مشتری یا مهمان می‌تواند درخواست خدمت ثبت کند.
- ثبت درخواست از طریق یک **ویزارد مشترک** برای مهمان و مشتری انجام می‌شود.
- اطلاعات شخص، دستگاه و شرح مشکل می‌تواند به‌صورت دستی ثبت شود.
- دسته‌بندی اولیه درخواست فقط برای **هدایت و ارجاع** است، نه تصمیم نهایی فنی.
- تصمیم‌گیری اصلی فنی و عملیاتی با **Service Manager / Supervisor فنی** است.
- اعتبار مشتری و وضعیت مالی باید در تصمیم ارجاع/اجرا اثرگذار باشد، اما مدل مالی از هسته عملیات سرویس جدا بماند.
- سطح خدمت از طریق **قرارداد** به **دستگاه** اعمال می‌شود.
- یک قرارداد می‌تواند چند دستگاه را پوشش دهد و هر دستگاه می‌تواند سطح خدمت متفاوتی داشته باشد.

---

## چشم‌انداز معماری

معماری هدف پروژه شامل این اجزاست:

- **Backend Core:** Odoo Community 19
- **Frontend:** برنامه مستقل مبتنی بر Next.js
- **Integration Layer:** API Gateway
- **Portal / UX Layer:** تجربه کاربری جدا از رابط داخلی Odoo در صورت نیاز
- **Customization Strategy:** حفظ هسته استاندارد Odoo و توسعه ماژول‌های اختصاصی فقط در نقاط ضروری

### تصمیمات معماری مهم
- Odoo نقش **سیستم رکورد (System of Record)** را دارد.
- منطق اصلی سرویس، قرارداد، دارایی و گردش‌کار در Odoo نگهداری می‌شود.
- فرانت‌اند مستقل برای پورتال، داشبوردها و تجربه کاربری بهتر توسعه می‌یابد.
- وابستگی به OCA باید حداقلی، کنترل‌شده و قابل نگهداری باشد.
- مرز بین **استاندارد Odoo** و **سفارشی‌سازی اختصاصی** باید روشن و مستند بماند.

---

## ساختار مستندات

مستندات پروژه در پوشه `docs/` سازمان‌دهی شده‌اند و کل چرخه تحلیل تا طراحی فنی را پوشش می‌دهند.

## فهرست بخش‌ها

### 00 — Business & Domain
پایه و قوانین اصلی کسب‌وکار که مبنای تمام تصمیمات طراحی بعدی است.
- [DOC-001 — Business Domain and Core Rules](docs/00-business-and-domain/DOC-001-business-domain-and-core-rules.md)

### 01 — Data Model
مدل داده اصلی، موجودیت‌ها و نگاشت بین مدل مفهومی و پیاده‌سازی.
- [DOC-002 — Asset Master Data](docs/01-data-model/DOC-002-asset-master-data.md)
- [DOC-013 — Data Model / Entity Mapping](docs/01-data-model/DOC-013-data-model-entity-mapping.md)
- [DOC-020 — Entity Mapping Design](docs/01-data-model/DOC-020-entity-mapping-design.md)

> نسخه بازنگری‌شده مدل داده:
- [DECISIONS and CHANGELOG](docs/01-data-model-revised/DECISIONS-and-CHANGELOG.md)
- [DOC-002 — Asset Master Data (Revised)](docs/01-data-model-revised/DOC-002-asset-master-data.md)
- [DOC-013 — Data Model / Entity Mapping (Revised)](docs/01-data-model-revised/DOC-013-data-model-entity-mapping.md)
- [DOC-020 — Entity Mapping Design (Revised)](docs/01-data-model-revised/DOC-020-entity-mapping-design.md)
- [DOC-054 — Canonical Data Model](docs/01-data-model-revised/DOC-054-CANONICAL-data-model.md)

### 02 — Service Core
هسته دامنه سرویس: قرارداد، SLA، پکیج، تیکت، گزارش خدمات و قطعات.
- [DOC-003 — Contract and Service Policy](docs/02-service-core/DOC-003-contract-and-service-policy.md)
- [DOC-004 — Service Policy / SLA](docs/02-service-core/DOC-004-service-policy-sla.md)
- [DOC-005 — Service Package](docs/02-service-core/DOC-005-service-package.md)
- [DOC-006 — Service Request / Ticket Wizard](docs/02-service-core/DOC-006-service-request-ticket-wizard.md)
- [DOC-007 — Service Report](docs/02-service-core/DOC-007-service-report.md)
- [DOC-008 — Parts and Inventory](docs/02-service-core/DOC-008-parts-and-inventory.md)
- [DOC-019 — Package / Contract / SLA Mapping Design](docs/02-service-core/DOC-019-package-contract-and-sla-mapping-design.md)
- [DOC-022 — Contract Management Detail](docs/02-service-core/DOC-022-contract-management-detail.md)

### 03 — Architecture
معماری سیستم، ساختار پروژه، استقرار و مرز استاندارد/سفارشی‌سازی.
- [DOC-011 — System Architecture](docs/03-architecture/DOC-011-system-architecture.md)
- [DOC-012 — Odoo Modules Mapping](docs/03-architecture/DOC-012-odoo-modules-mapping.md)
- [DOC-014 — Project Structure](docs/03-architecture/DOC-014-project-structure.md)
- [DOC-015 — Deployment and Infrastructure](docs/03-architecture/DOC-015-deployment-and-infrastructure.md)
- [DOC-025 — Odoo Standard Alignment and Customization Boundary](docs/03-architecture/DOC-025-odoo-standard-alignment-and-customization-boundary.md)
- [DOC-036 — OCA Minimization and Presentation Layer Strategy](docs/03-architecture/DOC-036-oca-minimization-and-presentation-layer-strategy.md)

### 04 — Workflow & Lifecycle
گردش‌کار سیستم و چرخه عمر تیکت و اجرای خدمت.
- [DOC-010 — System Workflow](docs/04-workflow-and-lifecycle/DOC-010-system-workflow.md)
- [DOC-021 — Ticket Lifecycle, Roles and Permissions](docs/04-workflow-and-lifecycle/DOC-021-service-management-ticket-lifecycle-roles-and-permissions.md)
- [DOC-023 — Technician Task and Field Service Execution](docs/04-workflow-and-lifecycle/DOC-023-technician-task-and-field-service-execution.md)
- [DOC-024 — Service Completion and Ticket Closure](docs/04-workflow-and-lifecycle/DOC-024-service-completion-and-ticket-closure.md)

### 05 — UX / UI
معماری تجربه کاربری، سفر کاربر و ناوبری.
- [DOC-016 — UI/UX Architecture](docs/05-ux-ui/DOC-016-ui-ux-architecture.md)
- [DOC-017 — User Journey and Navigation Architecture](docs/05-ux-ui/DOC-017-user-journey-and-navigation-architecture.md)

### 06 — Roles & Access
نقش‌ها، دسترسی‌ها و تفکیک مسئولیت‌ها.
- [DOC-009 — Roles and Permissions](docs/06-roles-and-access/DOC-009-roles-and-permissions.md)

### 07 — Customer Experience
تجربه مشتری، پورتال، CRM، پشتیبانی و تعاملات خدماتی.
- [DOC-018 — Service Ecosystem: CRM, Customer Portal and Localization Design](docs/07-customer-experience/DOC-018-service-ecosystem-crm-customer-portal-and-localization-design.md)
- [DOC-026 — Customer Service Management Experience](docs/07-customer-experience/DOC-026-customer-service-management-experience.md)
- [DOC-027 — Customer Support Center and Communication](docs/07-customer-experience/DOC-027-customer-support-center-and-communication.md)
- [DOC-028 — Customer Marketplace Experience](docs/07-customer-experience/DOC-028-customer-marketplace-experience.md)

### 08 — Dashboards
داشبوردهای نقش‌محور برای مدیر، تکنسین و ادمین.
- [DOC-029 — Role-Based Dashboard Experience](docs/08-dashboards/DOC-029-role-based-dashboard-experience.md)
- [DOC-030 — Admin Dashboard Experience](docs/08-dashboards/DOC-030-admin-dashboard-experience.md)
- [DOC-031 — Service Manager Dashboard Experience](docs/08-dashboards/DOC-031-service-manager-dashboard-experience.md)
- [DOC-032 — Technician Dashboard Experience](docs/08-dashboards/DOC-032-technician-dashboard-experience.md)

### 09 — Technician Operations
هزینه‌ها، دانش فنی و یادگیری تکنسین‌ها.
- [DOC-033 — Technician Expense and Cost Management](docs/09-technician-operations/DOC-033-technician-expense-and-cost-management.md)
- [DOC-035 — Knowledge Management and Technician Learning](docs/09-technician-operations/DOC-035-knowledge-management-and-technician-learning.md)

### 10 — Notifications
مدیریت اعلان‌ها و مرکز اطلاع‌رسانی.
- [DOC-034 — Notification Center and Notification Management](docs/10-notifications/DOC-034-notification-center-and-notification-management.md)

### 11 — Roadmap
نقشه راه اجرا، فازبندی و آمادگی استقرار.
- [DOC-037 — Implementation Roadmap](docs/11-roadmap/DOC-037-implementation-roadmap.md)
- [DOC-047 — v1 Blueprint Completion Summary](docs/11-roadmap/DOC-047-v1-blueprint-completion-summary.md)
- [DOC-048 — Phase 0 Deploy Runbook](docs/11-roadmap/DOC-048-phase-0-deploy-runbook.md)
- [DOC-053 — Production Migration and Backup Plan](docs/11-roadmap/DOC-053-production-migration-and-backup-plan.md)

### 12 — Technical Design
طراحی فنی ماژول‌ها و اجزای اختصاصی.
- [DOC-038 — pps_ticket_wizard Technical Design](docs/12-technical-design/DOC-038-pps-ticket-wizard-technical-design.md)
- [DOC-041 — Asset / Package / Contract / SLA Technical Design](docs/12-technical-design/DOC-041-asset-package-contract-sla-technical-design.md)
- [DOC-042 — pps_portal Technical Design](docs/12-technical-design/DOC-042-pps-portal-technical-design.md)
- [DOC-043 — pps_service_report Technical Design](docs/12-technical-design/DOC-043-pps-service-report-technical-design.md)
- [DOC-044 — pps_theme Design Tokens](docs/12-technical-design/DOC-044-pps-theme-design-tokens.md)
- [DOC-045 — pps_dashboard Technical Design](docs/12-technical-design/DOC-045-pps-dashboard-technical-design.md)
- [DOC-046 — Unified Security Model](docs/12-technical-design/DOC-046-unified-security-model.md)
- [DOC-049 — Persian Localization Plan](docs/12-technical-design/DOC-049-persian-localization-plan.md)

### 13 — Business Lines & Integration
مدل کسب‌وکار چندخطی و ارتباط فروش و سرویس.
- [DOC-039 — Multi-Line Business Model & Sales-Service Integration](docs/13-business-lines/DOC-039-multi-line-business-model-and-sales-service-integration.md)

### 14 — Prerequisites
پیش‌نیازهای فنی و بررسی OCA.
- [DOC-040 — OCA and Prerequisites Plan](docs/14-prerequisites/DOC-040-oca-and-prerequisites-plan.md)

### 15 — Ecosystem Architecture
معماری اکوسیستم، API Gateway، سایزینگ و توپولوژی سرور.
- [DOC-050 — Ecosystem Frontend and API Gateway Architecture](docs/15-ecosystem-architecture/DOC-050-ecosystem-frontend-api-gateway-architecture.md)
- [DOC-051 — Sizing Estimate](docs/15-ecosystem-architecture/DOC-051-sizing-estimate.md)
- [DOC-052 — Server Topology and OS Standard](docs/15-ecosystem-architecture/DOC-052-server-topology-os-standard.md)

### 16 — Git Repository
بک آپ و انتقال به ریپازیتوری 
- [DOC-053 — Production — Migration — and — Backup — Plan](DOC-053-production-migration-and-backup-plan.md)

---

## مسیر پیشنهادی مطالعه

اگر اولین بار است که وارد این پروژه می‌شوید، این ترتیب مطالعه توصیه می‌شود:

1. [DOC-001 — Business Domain and Core Rules](docs/00-business-and-domain/DOC-001-business-domain-and-core-rules.md)
2. [DOC-010 — System Workflow](docs/04-workflow-and-lifecycle/DOC-010-system-workflow.md)
3. [DOC-002 — Asset Master Data](docs/01-data-model-revised/DOC-002-asset-master-data.md)
4. [DOC-054 — Canonical Data Model](docs/01-data-model-revised/DOC-054-CANONICAL-data-model.md)
5. [DOC-003 — Contract and Service Policy](docs/02-service-core/DOC-003-contract-and-service-policy.md)
6. [DOC-004 — Service Policy / SLA](docs/02-service-core/DOC-004-service-policy-sla.md)
7. [DOC-006 — Service Request / Ticket Wizard](docs/02-service-core/DOC-006-service-request-ticket-wizard.md)
8. [DOC-011 — System Architecture](docs/03-architecture/DOC-011-system-architecture.md)
9. [DOC-025 — Odoo Standard Alignment and Customization Boundary](docs/03-architecture/DOC-025-odoo-standard-alignment-and-customization-boundary.md)
10. [DOC-050 — Ecosystem Frontend and API Gateway Architecture](docs/15-ecosystem-architecture/DOC-050-ecosystem-frontend-api-gateway-architecture.md)

---

## وضعیت فعلی مخزن

این مخزن در درجه اول یک **Blueprint / Analysis & Design Repository** است و نه لزوماً یک مخزن کد عملیاتی کامل.

بنابراین تمرکز اصلی آن روی این موارد است:
- تحلیل دامنه کسب‌وکار
- مدل‌سازی داده
- طراحی فرآیندها و نقش‌ها
- تعیین مرز سفارشی‌سازی در Odoo
- طراحی فنی ماژول‌های اختصاصی
- طراحی معماری اکوسیستم و فرانت‌اند مستقل
- برنامه‌ریزی برای استقرار، مهاجرت و فازبندی اجرا

---

## اصول پیاده‌سازی

این پروژه بر چند اصل اجرایی مهم تکیه دارد:

- **Odoo First:** ابتدا بررسی شود که نیاز با قابلیت استاندارد Odoo قابل پوشش هست یا نه.
- **Minimal Customization:** توسعه اختصاصی فقط در جایی انجام شود که ارزش واقعی ایجاد کند.
- **Frontend Decoupling:** تجربه کاربری نهایی وابسته به UI داخلی Odoo نباشد.
- **Clear Ownership:** نقش‌ها، دسترسی‌ها و مسئولیت تصمیم‌گیری شفاف باشند.
- **Document-Driven Delivery:** هر تصمیم مهم باید در مستندات قابل ردیابی باشد.

---

## اجزای کلیدی دامنه

موجودیت‌ها و مفاهیم اصلی این سامانه شامل موارد زیر هستند:

- Customer / Guest
- Service Request / Ticket
- Asset / Device
- Contract
- Service Policy / SLA
- Service Package
- Service Report
- Technician Task
- Parts / Inventory
- Financial / Credit Status
- Customer Portal
- Notification Center
- Dashboards

---

## نکته مهم درباره مدل داده

در ساختار مستندات، هم نسخه اولیه مدل داده و هم نسخه بازنگری‌شده وجود دارد.  
برای تصمیم‌گیری‌های جدید، بهتر است **نسخه Revised** در مسیر زیر مرجع اصلی باشد:

- `docs/01-data-model-revised/`

به‌ویژه:
- `docs/01-data-model-revised/DECISIONS-and-CHANGELOG.md`
- `docs/01-data-model-revised/DOC-054-CANONICAL-data-model.md`

---

## خروجی نهایی مورد انتظار

خروجی نهایی این پروژه باید یک بسته کامل و قابل انتقال برای اجرا و توسعه باشد، شامل:
- مستندات تحلیل کسب‌وکار
- معماری سیستم
- مدل داده نهایی
- طراحی فنی ماژول‌ها
- مرز دقیق توسعه‌های اختصاصی
- برنامه استقرار
- برنامه مهاجرت و پشتیبان‌گیری
- مبنای توسعه برای مخزن GitHub اجرایی

---

## Repository Notes

- فایل فعلی `README.md` نقش نمای کلی مخزن را دارد.
- مستندات جزئی در پوشه `docs/` قرار دارند.
- در صورت توسعه بیشتر مخزن، پیشنهاد می‌شود بخش‌های زیر نیز بعداً اضافه شوند:
  - `CONTRIBUTING.md`
  - `ARCHITECTURE.md`
  - `ROADMAP.md`
  - `CHANGELOG.md`

---

## License

در حال حاضر لایسنس پروژه در این فایل مشخص نشده است.  
در صورت نهایی شدن، پیشنهاد می‌شود یک فایل `LICENSE` به ریشه مخزن اضافه شود.

---

## Maintained Scope

این مخزن بر طراحی و مستندسازی سامانه‌ای متمرکز است که:
- هسته بک‌اند آن بر پایه **Odoo Community 19** است
- فرانت‌اند آن **مستقل** و ترجیحاً مبتنی بر **Next.js** است
- یک **API Gateway** برای یکپارچه‌سازی و کنترل دسترسی دارد
- برای سناریوهای واقعی خدمات پس از فروش، قرارداد، SLA، پورتال مشتری و عملیات تکنسین طراحی شده است
