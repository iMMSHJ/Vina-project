
DOC-054 — Entity Mapping Matrix
Draft 
:Status Phase 1 (Odoo 19 / Next.js MVP) 
:Phase Business Analysis & Data Model Design :Document Type
:Note

This document supersedes previous implicit mapping assumptions

.about Ticket and Asset models in the MVP

For technical details of Asset / Package / Contract / SLA
.	
DOC-041 §2
	 implementations, refer to
Objective .1
Prepress هدف این سند، تعریف یک ماتریس شفاف برای نگاشت موجودیتهای دامنهی و سایرCustomer، Asset، Package، Contract، SLA، Ticket، Service Report شامل است؛ بهگونهای که:Odoo 19 موجودیتهای مرتبط به مدلهای
			 انجام شود؛Odoo حداکثر استفاده از مدلهای استاندارد	 •	 ایجاد شوند؛Business Gap مدلهای سفارشی فقط در صورت وجود	 •	 روشن باشد؛Frontend (Next.js)  وBackend (Odoo) مرز بین	 •،Next.js  وOdoo Community 19 ، یعنیMVP طراحی بر اساس تصمیمهای فعلی	 •			انجام شود.
 وprepress_serviceاین ماتریس مبنای طراحی ماژولهای prepress_core 		.خواهد بود
 

Scope .2
:دامنهی این سند شامل موارد زیر است
،Customer، Contact، User، Site، Asset، Product : اصلیBusiness Objects	 •،Service Package، Contract، Service Policy، SLA، Ticket، Service Report						؛Inventory  وParts		،Native  با استراتژیOdoo 19  به مدلهایBusiness Object نوع نگاشت هر	 •				؛New  یاExtension			؛Custom  وNative، Extended تفکیک مدلهای	 •				روابط کلیدی بین موجودیتها در سطح منطقی.	 •
موضوعات خارج از دامنهی این سند:
( برای هر مدل؛Field-level specification) طراحی جزئی فیلدها	 •؛Service Contract تعریف کامل فرآیندهای فروش و مالی خارج از	 •
 که در Next.js  وAPI جزئیات پیادهسازیDOC-042 و اسناد فرانتاند پوشش داده	 •
میشوند.
Mapping Principles .3
:اصول پایهی نگاشت عبارتاند از
 ،	 تا حد امکان، مانندres.partnerاستفاده از Native Odoo Models	 •
		
 و*.account؛	*.stock	 ،	product.product	 ،	res.users	
استفاده از Extension فقط زمانی که نیازهای دامنه با افزودن فیلد یا منطق تکمیل	 •
						؛Odoo شوند، بدون تغییر در هستهیایجاد New (Custom) Models؛OCA  یاOdoo  فقط در صورت نبود معادل مناسب در	 •		 مستقیم مدلهایPatch  یاFork ، شامل عدمCore Odoo عدم تغییر ساختاری در	 •							استاندارد؛ هرجا ممکن باشد؛Frontend (Next.js)  و تجربهی کاربری در الیهیUI نگهداشتن منطق	 •					 عمل میکند؛API Gateway  وBackend  بهعنوانOdoo		 فقط برSLA  وContract . همیشه باز استTicket  یاService Request امکان ثبت	 •				 نمیشوند.Ticket نحوهی سرویسدهی و اولویت اثر میگذارند و مانع ایجاد
 

Entity Mapping Matrix .4
Main Business Objects .4.1
Notes	Strategy	Odoo Model	Business
			Object
is_company = True؛			
			
افزودن فیلدهای دامنهای مانند کد	Extension	res.partner	Customer
مشتری، گروه اعتبار و نوع مشتری.
is_company = False؛		
res.partner
	
 از طریق Customer ارتباط با	Native		Contact
.	parent_id				
 لینکشده بهres.partner؛	Native	(portal) 	
res.users
	Portal User
 و فاقد نقشPortal دارای دسترسی				
داخلی.
 نقشها از طریقres.groups		Internal
 در ماژولهایprepress	Native	res.users	
			User
.تعریف میشوند	—	
 مدل جداگانه ندارد؛ اطالعاتGuest	(	 New (Data in		Guest
 ذخیرهTicket  در خودGuest				
		pps.ticket
		
.میشود				
			
pps.site
	Site
Newمحل ارائهی سرویس؛ مرتبط با	.Asset  وCustomer		
دارایی مشتری؛ جایگزین نگاشت
	قبلی به 	New	pps.asset	Asset
.	maintenance.equipment
		
	.قطعات یدکی و مواد مصرفی	Native	
product.product
	Product
				(Part)
	دستگاهها برای فروش و ایجاد	
product.product
	
			Product
	 استفاده میشوند و دارایAsset	Extension		
				(Machine)
	.فیلدهای فنی دستگاه هستند		
		
pps.service.package
	
	Newها برای یکAsset گروه قراردادی	.Site  و یکCustomer		Service
			Package

 

Notes	Strategy	Odoo Model	Business
			Object
			
قرارداد رسمی سرویس حول	New	pps.service.contract	Contract
.Policy  وPackage			
	New	
pps.service.policy
	Service
سیاست کلی سرویس شامل نوع			
، کانالها، ساعات پاسخ و مواردSLA			
			Policy
.مشابه			
 سطوح خدمت؛ جایگزین
helpdesk.sla که	New	pps.service.sla	SLA
 است.Enterprise-only
تیکت کامال ً سفارشی و نقطهی ورودهمهی درخواستها.	New	
pps.ticket
	Ticket
		
pps.service.report
	Service
Newگزارش اجرای سرویس برای هراقدام تکنسین.		
		Report
	
*.product
	 ,	
*.stock
	
Nativeمدیریت شاخصها، موجودی وحرکتها کامال ً استاندارد است.				 &Parts
				Inventory
	
ir.attachment
	
.Service Report  وTicket ضمایم	Native		Attachment
،Ticket فعالیتها و پیگیریها روی.Contract  وAsset	Native	
mail.activity
	Activities
Strategy Values .4.2
:Native بدون تغییر ساختار. ممکن استOdoo  استفادهی مستقیم از مدل استاندارد	 •	 از مدل استفاده شود.Security  یاView فقط در:Extension افزودن فیلدها و منطق دامنهای روی مدل استاندارد، بدون تغییر رفتار پایهی	 •			آن.
 تعریف مدل سفارشی در ماژولهای*_prepress، با وابستگی به مدلهای	:New	 •
استاندارد در صورت نیاز.
 

Relationship Mapping .5
Core Domain Relationships .5.1
Customer
Contact (res.partner, child of Customer) ──├ 
Site (pps.site) ──├ 
Asset (pps.asset) ──└       │ 
Service Report (pps.service.report) ──└               │ Service Package (pps.service.package) ──├ 
Asset (pps.asset) ──├       │ 
Service Contract (pps.service.contract) ──└       │ Service Policy (pps.service.policy) ──└               │ SLA (pps.service.sla) ──└                       │ 
Ticket (pps.ticket) ──└ 
Service Report (pps.service.report) ──└ 
:نکات کلیدی
Asset میتواند بینAsset . نصب میشودSite  است و در یکCustomer  متعلق به	 •	ها جابهجا شود، اما تاریخچهی کامل سرویس آن باید حفظ شود.Customer
Service Packageهای یکAsset  یک مفهوم قراردادی است که زیرمجموعهای از پوشش میدهد.Site  را برای یکCustomer
 دقیقا ً یکService Contract وSLA  شاملContract . دارد هرService Package	 •
 •
شرایط تجاری است.
،. در صورت وجودPackage  یاContract  همیشه قابل ثبت است، حتی بدونTicket
 مربوطه لینک میشود.SLA  وContract  بهTicket
. لینک میشودAsset  و معموال ً به یکTicket  به یک هرService Report	 •
 •
Ticket-Centric View .5.2
Guest / Customer

↓ 

Ticket (pps.ticket) 

│ 




 

Customer / Site / Asset (optional) ──├ 

Contract / SLA (optional) ──├ 

Service Report(s) ──└ 

Consumable Parts (stock / product) ──├ 

Technician & Time Tracking ──└ 
Native Odoo Models .6
: استفاده میشوندNative مدلهای زیر بدون تغییر ساختاری و بهصورت
Identity & Access
res.users
res.groups	 •
 •
 •

res.company
	 •
	Partner & Contact res.partner؛Native  بهصورتContact  برای	 •
 •
.Extension  از نوعStrategy  باCustomer  برای	res.partner	 •
Product & Inventory	 •
product.template
	 •
product.product
	 •
stock.location
	 •
stock.quant
	 •
stock.move
	 •
stock.picking
	 •
. و مدلهای مرتبط	
uom.uom
	 •
Accounting & Invoicing	 •
account.move
	 •
account.move.line
	 •

 

.Billing  برای فازهای بعدی فروش وPayment  وInvoice سایر مدلهای مرتبط باCommunication & Attachments	 •
 •
mail.thread
mail.message 
mail.activity 
ir.attachment	 •
 •
 •
 •
 این مدلها در ماژولهای*_prepress فقط مصرف میشوند و منطق هستهای آنها تغییرنمیکند.
Extended Odoo Models .7
: با فیلدها یا منطق جدید توسعه مییابندMVP مدلهای زیر در
(	res.partner	 )Customer
:فیلدهای پیشنهادی
				pps_customer_code	 •
				pps_credit_group	 •
 و	publisher
	 ،	 ، مانندprint_house	pps_customer_type corporate	 •

		 •
	. مربوط به اطالعرسانی و ترجیحات خدماتFlags	
(	product.product	) Product	
:فیلدهای پیشنهادی برای دستگاهها
pps_machine_brand
pps_machine_model
pps_machine_category	 •
 •
 •
.Technician مشخصات فنی مهم برای	 •

 

Portal / UX Integration
 وportal استفاده میشود. جزئیات بیشتر در	 ازFrontend برای اتصال بهres.users
	. ارائه خواهد شد	DOC-042
در این سند، helpdesk.ticket نیست و طبق تصمیم جدید، مدلExtended  دیگر
. خواهد بود	pps.ticket	 با نام Custom ً کامالTicket
Custom Models .8
:مدلهای زیر باید بهصورت کامل در ماژولهای جدید پیادهسازی شوند
Core Service Models
pps.site
	 •
pps.asset
	 •
pps.service.package
	 •
pps.service.contract	 •
pps.service.policy
	 •
pps.service.sla
	 •
pps.ticket
	 •
pps.service.report
	 •
Summary Table .8.1
Purpose	Module	Model Name
		
 برای نصب وSite تعریف	prepress_core	pps.site

ارائهی سرویس.		
	
prepress_core
	
pps.asset

مدیریت داراییهای مشتری و		
تاریخچهی سرویس.		
تعریف گروه قراردادی
Customer ها برای یکAsset	prepress_core	pps.service.package
.Site و یک
 

Purpose	Module	Model Name
		
تعریف قرارداد رسمی سرویس	prepress_service
	pps.service.contract

و تعهدات آن.		
	
prepress_core
	
pps.service.policy

تعریف سیاست کلی ارائهی		
سرویس.		
	
prepress_core
	
pps.service.sla

تعریف سطوح خدمت برای		
.Asset  وTicket انواع		
	
prepress_service
	
pps.ticket

ثبت درخواست سرویس برای		
.Customer  یاGuest		
	
prepress_service
	
pps.service.report

ثبت عملیات انجامشده توسط		
.Technician		
API / Frontend Mapping .9
: در ایجاد و مدیریت موجودیتها بهصورت زیر تعریف میشودOdoo 19  وNext.js نقش
Next.js (Frontend)
؛Customer  وGuest  مشترک برایTicket Wizard ارائهی	 •
؛State  یاLocalStorage  درDraft Ticket نگهداری	 •
؛Odoo  درDraft عدم ایجاد رکورد	 •
 برای:Customer احراز هویت	 •
مشاهدهی کاتالوگ؛ •
؛Guest  و نهCustomer ثبت سفارش، فقط برای	 •
؛Customer های مربوط بهTicket مدیریت	 •
؛Service Report  وTicket نمایش وضعیت •
.Service Report  برایCustomer دریافت تأیید	 •
Odoo 19 (Backend / API Gateway)
: برایAPI ارائهی
ایجاد pps.ticket؛Ticket Wizard  بر اساس دادههای	 •
؛Portal ها برایService Report ها وTicket بازیابی	 •
.Frontend  بدون دخالت مستقیمSLA  وAsset، Package، Contract مدیریت	 •
 

:اجرای منطق دامنهای شامل
؛Deadline  و زمانهایSLA محاسبهی	 •
 و سیاست سرویس؛Contract اعمال قوانین •
کنترل دسترسی داخلی بر اساس نقشها؛ •
 درAttachment  وProduct، Inventory، Accounting ارتباط با مدلهای استاندارد	 •
صورت نیاز.
Design Decisions .10
(	pps.ticket	) Ticket as Custom Model .10.1	
	:، یک مدل اختصاصی تعریف میشود تا	 رویExtension بهجایhelpdesk.ticket	 •
	 حذف شود؛Enterprise وابستگی به نسخهی	
	تداخل با maintenance.request و سایر ماژولها ایجاد نشود؛	 •
	 بهصورت زیرساختی پشتیبانیContract  وGuest، Customer، Asset نیازهای خاص	 •
شوند؛
	 بهعنوان نقطهی ورود واحد همهی درخواستهای سرویس عمل کند.Ticket	 •
(	pps.asset	) Asset as Custom Model .10.2	
 بهAsset نگاشتmaintenance.equipment حذف شده است. مدل اختصاصی امکان
موارد زیر را فراهم میکند:
ها؛Customer مدیریت انتقال مالکیت بین	 •
حفظ تاریخچهی مالکیت و سرویس؛	 •
 مشتری از تجهیزات داخلی شرکت؛Asset جدا کردن مفهوم	 •
.Service Report  وTicket ادغام سادهتر با	 •
 

SLA as Custom Model .10.3
(	pps.service.sla	)
 استفاده ازhelpdesk.sla بودن و محدودیتهای دامنهایEnterprise-only  به دلیل چند سطحMVP  بهصورت باز و قابل توسعه طراحی میشود و درSLA مناسب نیست. ساختارساده را پوشش خواهد داد.
Contract as Custom Model .10.4
(	pps.service.contract	)	
: در نسخهی اولیه کنار گذاشته میشود تا	 OCA استفاده ازcontract.contract	 •
 •
 •
 انجام شود؛Finance  وService Manager طراحی قرارداد خدمات متناسب با نقشهای وارد نشود؛MVP  بهOCA پیچیدگیهای
 بهصورت کنترلشدهSLA  وContract، Package، Policy قوانین اختصاصی ارتباط	
پیادهسازی شوند.
 بررسی خواهد شد.OCA در فازهای بعد، امکان همراستا کردن مدل اختصاصی باInventory as Native .10.5
 ، ساختارstock بدون تغییر اساسی باقی میماند. ارتباط منطقی	 مطابقDOC-008
stock.move یا یک جدول میانی	 از طریق MVP  با مصرف قطعات درService Report
ساده انجام خواهد شد.
Validation Rules (High-Level) .11
		Ticket ایجاد مجاز است.Package  وContract  بدونTicket ایجاد	 • بهصورت خودکار یا برTicket ، ارتباطAsset  یاCustomer در صورت شناخته بودن	 •		اساس انتخاب کاربر انجام میشود.
 میتواند بدون ایجاد حساب کاربری درخواست سرویس ثبت کند.Guest	 •
 

. ایجاد نمیشودGuest  ذخیره میشود و مدل مستقل برایTicket  درGuest اطالعات	 •
Asset
.ها باید تاریخچهی مالکیت را حفظ کندCustomer  بینAsset انتقال	 •
 فعلی مرتبط باشد.Site  فعلی و در صورت نصب بودن، بهCustomer  باید بهAsset هر	 •
کاربر خارجی فقط تاریخچهی مربوط به دورهی مالکیت خودش را مشاهده میکند.	 •
 نباید در اثر انتقال مالکیت حذف یاAsset های قبلیTicket ها وService Report	 •
.بازنویسی شوند
Contract / SLA
Renewal  یاAmendment  ممنوع است؛ در فازهای بعد ازContract تغییر مستقیم	 •
استفاده میشود.
 روی زنجیرهی ارتباطی زیر اعمال میشود:Integrity ، حداقلMVP در	 •

Contract → Package → Policy → SLA	
. الزامی نیستTicket  برای ایجادSLA  یاContract وجود و اولویت سرویس بر اساس قواعد مصوبSLA، Deadline  وContract در صورت وجود	 •
 •
محاسبه میشوند.
Service Report
. مرتبط باشدTicket  باید به یکService Report هر	 •
 نیز مرتبط خواهد بود.Asset  بهService Report ،در حالت معمول	 •
 قابل ثبتService Report ، زمان صرفشده و قطعات مصرفی باید درTechnician	 •
.باشند
. مدیریت میشوند	 از طریق Service Report ضمایمir.attachment	 •
Open Questions .12
 مانندOCA  نیاز به یکپارچهسازی با ماژولهایMVP آیا درcontract وجود دارد یا	 .1
این قابلیت بهطور کامل در pps.service.contract پیادهسازی میشود؟
 

: در نسخهی اول تا کجا پیش میرود؟ برای مثالSLA سطح جزئیات موردنیاز	 .2
تفکیک زمان پاسخ و زمان رفع؛ .3
؛Asset  بر اساس نوعSLA تفکیک	 .4
.Ticket  بر اساس اولویتSLA تفکیک .5
 انتخاب میشود:MVP  کدام رویکرد درParts Consumption برای	 .6
 به Service Report اتصال مستقیمstock.move؛	 .7
یا استفادهی اولیه از یک جدول منطقی بدون ایجاد حرکت واقعی انبار؟	 .8
 باید امکان داشتن چند آدرس عملیاتی یا چند محل نصب مستقل برای یکSite آیا	 .9
 را داشته باشد؟Customer
 قرار گیرد یاService Package  میتواند بهصورت همزمان در بیش از یکAsset آیا یک	 .10
 محدود شود؟Package عضویت آن باید در هر لحظه به یک
