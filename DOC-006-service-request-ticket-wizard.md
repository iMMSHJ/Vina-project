
DOC-006: Service Request Ticket Wizard
1. Objective & Scope
The Ticket Wizard is the unified entry point for guest users (unauthenticated) and registered customers (authenticated) to report issues, request assistance, or log service requests.
This document defines the functional requirements, user workflows, data validation rules, and integration boundaries for the Ticket Wizard interface in the Vina ecosystem.
2. General Principles & System Rules
GP-001: Unified Frontend Entry Point
There is a single, unified wizard flow for all end users. The wizard dynamically adjusts its fields, read-only states, and data mapping based on whether the user is authenticated as a Customer or accessing the system as a Guest.
GP-002: Customer and Guest Distinction
Customer
• Automatically identified through the authenticated session.
• User details are pre-filled and rendered as read-only.
• Only assets associated with the customer’s account are retrieved and displayed.
Guest
• Must manually provide identification and organization details.• Must manually provide device or asset identification details.
 

GP-003: No Technical Self-Diagnosis
End users, whether Customers or Guests, are not permitted or prompted to:
• Categorize the technical nature of their request.• Select a support team.
• Determine the required service action.
All requests are described through a mandatory free-text field, with optional attachments. Initial categorization, prioritization, and technical routing are handled internally by the Service Manager or Technical Supervisor after submission.
GP-004: Frontend-Only Draft State
• Draft tickets are not persisted in the Odoo backend database.
• Any unsubmitted form data is stored locally in the frontend client state,
such as SessionStorage or LocalStorage.
• This temporary state is subject to client-side expiration.
• A database record is generated only after a successful Submit action.
GP-005: Financial Eligibility Verification
The wizard does not block ticket submission based on financial status or lack of an active contract.
1. Every submitted wizard generates a ticket with status New.
2. The backend asynchronously processes billing terms, contract status, and 	creditworthiness.
3. The result is attached to the ticket as a visual warning, tag, or credit-status 	indicator.
4. The Service Manager determines whether to route the ticket to a financial 	hold queue or assign it directly to a technician.
 

3. Detailed Wizard Step Workflow
The wizard progresses through a linear sequence of steps. For registered Customers, the wizard pre-fills step data where appropriate.
	[Start]
		 │
		 ▼
Step 1: Contact Information (Read-only for Customer / Input for Guest)		 │
		 ▼
Step 2: Device & Location Selection (Select Asset for Customer / Free-t		 │
		 ▼
Step 3: Description & Attachments (Mandatory Text + Optional Files)		 │
		 ▼
Step 4: Summary & SLA Preview
		 │
		 ▼
[Submit] ──► (Generates helpdesk.ticket in 'New' status)
Step 1: Contact Information
Customer Mode
The following information is fetched from the logged-in session and rendered as read-only:
• First Name
• Last Name
• Organization or Company
• Phone Number
 

Guest Mode
The following fields are mandatory:
1. Contact Name (Full Name)
2. Company or Organization Name
3. Phone Number
Note: Email and City fields are excluded from this form layout.
Step 2: Device & Location Selection
Customer Mode
The frontend displays a list of assets associated with the customer’s account.
These are pps.asset records linked to the customer’s Partner ID.
The customer selects the specific asset experiencing the issue. Upon selection,
the system retrieves:
• Associated Site or Location
• Active Contract (contract.contract)
• Active SLA Package (pps.sla)
Guest Mode
The user manually enters device identification details into a single free-text input
field. Examples include:
• Serial Number
• Model
• Device Label
No automatic asset verification occurs for Guests at this stage.
 

Step 3: Description & Attachments
Description
A mandatory text area allows the user to provide a free-form explanation of the problem or service request.
Attachments
Users may optionally upload images or documents related to the issue. File size and format limits are enforced by the frontend.
Step 4: Summary & SLA Preview
The wizard displays a recap of all information provided by the user.
SLA Preview
Customer with an Active Contract 
The wizard displays the response-time target derived from the customer’s mapped pps.sla policy.
Example:
Standard Support: 4-Hour Response Target
Guest or Customer without an Active Contract The wizard displays a fallback warning.
Example:
Standard Fallback Support: Response times may vary based on

technical availability.


 

4. Post-Submission Lifecycle
Upon clicking Submit, the following operations occur.
4.1 Ticket Creation
1. The frontend sends a JSON payload through the API Gateway to Odoo. 2. Odoo creates a new helpdesk.ticket record. 
3. The ticket is created with status New.
4.2 SLA Snapshotting
The active SLA rules at the moment of submission are copied and permanently stamped onto the ticket record as an SLA Snapshot.
Subsequent changes to the master SLA policy or contract do not alter the historical commitments recorded for that ticket.
4.3 Tracking Code
A unique Tracking Code is returned to the user interface.
For Guests, this Tracking Code is the sole identifier used to check ticket progress.
5. Architecture & Boundary Design
+-------------------------------------------------------------+

|                     Next.js Frontend                        |

+------------------------------┬------------------------------+

 │ (JSON-RPC / REST API)

 ▼

+-------------------------------------------------------------+

|                       API Gateway                           |

+------------------------------┬------------------------------+








 

 │ (Internal Routing)
 ▼
+-------------------------------------------------------------+

|                      Odoo Backend                           |

|  +-------------------------------------------------------+  |
|  |                   Service Layer                       |  | |  |  (Processes Ticket Creation & SLA Snapshot Logic)     |  | |  +---------------------------┬---------------------------+  | |                              ▼                              | |  +-------------------------------------------------------+  | |  |                   Data Models                         |  | |  |  - helpdesk.ticket                                    |  | |  |  - pps.asset                                          |  | |  |  - contract.contract                                  |  | |  |  - pps.sla                                            |  | |  +-------------------------------------------------------+  | +-------------------------------------------------------------+
5.1 Decoupled Frontend
The wizard interface is served entirely by the standalone frontend ecosystem. It communicates with Odoo in a headless manner through the API Gateway.
5.2 Service Layer Encapsulation
The logic for the following operations resides within a dedicated Python Service Layer in Odoo:
• Checking asset ownership
• Determining the active SLA
• Creating the ticket
• Generating the SLA Snapshot
The controller and API Gateway call this Service Layer. This separation ensures that changes to frontend routing do not disrupt core business logic.
