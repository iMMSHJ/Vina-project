# DOC-029 — Role Based Dashboard Experience

**Version:** 1.2  
**Status:** 🔒 LOCKED

---

# 1. Purpose

تعریف معماری Dashboardها بر اساس Role و Permission.

هدف:

- نمایش اطلاعات مرتبط با هر Role
- جلوگیری از نمایش اطلاعات غیرضروری
- جداسازی کاربران داخلی و خارجی
- حفظ ساختار استاندارد Odoo

---

# 2. Dashboard Principle

Dashboard فقط برای:

- View
- Summary
- Quick Action

است.

Workflow اصلی داخل Dashboard اجرا نمی‌شود.

---

# 3. User Domain Separation

سیستم دارای دو Domain مستقل است:

```

USER DOMAIN

├── INT (Internal Users)

└── EXT (External Users)

```

---

# 4. Internal Roles (INT)

ساختار:

```

INT

├── Super Admin

├── Admin

├── CEO

├── Secretary

├── Service Manager

├── Technician

├── CRM User

├── Marketplace Manager

├── Inventory Manager

├── Accounting User

└── Accounting Manager

```

---

# 5. Future Roles

Roleهایی که در Phase 1 فعال نیستند:

```

HR (Future Role)

```

HR فقط به عنوان ساختار سازمانی در نظر گرفته می‌شود.

ماژول و Dashboard اختصاصی HR در Phase 1 وجود ندارد.

---

# 6. External Roles (EXT)

کاربران خارج سازمان:

```

EXT

├── Customer Admin

├── Customer Official

└── Customer Service Operator

```

---

# 7. Dashboard Architecture

## 7.1 Admin Dashboard

Role:

Admin

هدف:

مدیریت سیستم و عملیات مدیریتی.

تمرکز:

- User Management
- Role Overview
- Access Overview
- Configurationهای مجاز
- Master Data Control
- System Administration

محدودیت:

Admin جایگزین Super Admin نیست.

عدم دسترسی:

- Odoo Technical Settings
- Apps
- Security Rules اصلی

---

# 7.2 Secretary Dashboard

Role:

Secretary

هدف:

Administrative Operation

تمرکز:

- Customer Information
- Contact Management
- Data Entry
- Document Follow Up
- Administrative Requests
- اطلاعات مورد نیاز عملیات داخلی

Secretary مسئول System Administration نیست.

---

# 7.3 CEO Dashboard

Role:

CEO

تمرکز:

- Executive Overview
- KPI Summary
- Business Reports

اصل:

حداقل دسترسی عملیاتی.

---

# 7.4 Service Manager Dashboard

Role:

Service Manager

(طراحی کامل در DOC جداگانه)

تمرکز:

- Ticket Queue
- SLA
- Assignment
- Technician Management
- Part Approval
- Service KPI

---

# 7.5 Technician Dashboard

Role:

Technician

(طراحی کامل در DOC جداگانه)

تمرکز:

- Assigned Tasks
- Work Order
- Activities
- Time Sheet
- Service Report
- Expense Access

---

# 7.6 Functional Dashboards

Roleهای تخصصی:

## CRM User

- Sales Activities
- Leads
- Opportunities

---

## Marketplace Manager

- Product Catalog
- Quote Request
- Product Information

---

## Inventory Manager

- Stock Overview
- Part Requests
- Returns

---

## Accounting User / Manager

- Financial Activities
- Approval
- Reports

---

# 8. Permission Principle

اصل:

```

Minimum Required Access

```

یعنی:

- هر Role فقط اطلاعات مورد نیاز خود را می‌بیند.
- Permission اضافی فقط در صورت نیاز اضافه می‌شود.
- Role سازمانی مساوی با دسترسی کامل نیست.

---

# 9. Odoo Alignment

پیاده‌سازی بر اساس استاندارد Odoo:

```

User

↓

Groups

↓

Access Rights

↓

Record Rules

↓

Menu / View Access

```

---

# 10. Phase 1 Scope

Dashboardهای اصلی:

```

Internal

├── Admin Dashboard

├── Secretary Dashboard

├── CEO Dashboard

├── Service Manager Dashboard

└── Technician Dashboard

External

└── Customer Portal Dashboard

```

---

# 11. Out of Scope Phase 1

عدم وجود:

- HR Module
- HR Dashboard
- Device Monitoring Dashboard
- IoT Monitoring

---

# Final Decision

✅ Role Based Dashboard Architecture  
✅ INT / EXT Separation  
✅ Secretary Added  
✅ HR Future Role  
✅ Admin Boundary Defined  
✅ Dashboard Scope Controlled  
✅ Odoo Compatible  

---

# Status

🔒 DOC-029 LOCKED
