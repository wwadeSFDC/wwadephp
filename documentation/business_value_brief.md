# Pacific Haven Properties — Business Value Brief

*Reference for Part 1 (0:00–0:10, Business Value & Impact) and Q&A defense. ~90 seconds live; this doc is the backing detail.*

## The Business Challenge

PHP runs its leasing, resident services, and property operations through a small, stretched staff: leasing agents field prospect inquiries during business hours, property managers handle maintenance/access requests around the clock, and the same managers do their own reporting and renewal outreach by hand. Every routine, answerable-from-data request (unit availability, move-in specials, maintenance status, after-hours access) still costs a human touch — and the humans who'd otherwise be touring prospects or closing renewals are instead answering the same handful of questions on repeat.

The problem isn't a lack of data — PHP already has the CRM records (`Apartment__c`, `Apt_Location__c`, `Case`, `Lease_Payment__c`) and a Resident Handbook. The problem is that a human has to be the one to go get it, every single time, including at 2 AM.

## Capability → Outcome Map

| Agent | Capability | Whose time it returns | What they do with it instead |
| :---- | :---- | :---- | :---- |
| **Leasing Assistant (Jordan)** | Answers availability/bedroom/move-in-date search and move-in-special questions directly from CRM data; redirects base-rent negotiation to a human by design (guardrail, not a gap) | **Leasing agents'** — no longer fielding the "is anything open" first-contact question | Spend the saved time on tours and closing prospects who are already qualified |
| **Tenant Concierge (Alex)** | Verifies tenant identity via OTP, then self-serves maintenance case creation/status, door unlock, and keyfob replacement, 24/7 | **After-hours on-call staff'** — routine requests no longer page a person | Reserve after-hours human attention for the emergencies the agent is designed to escalate, not routine keyfob/lockout requests |
| **Ops Copilot (Morgan)** | Surfaces occupancy/backlog/payment status on demand and drafts lease-renewal emails from a prompt template | **Property managers'** — less time assembling weekly status manually and drafting renewal outreach from scratch | Spend it on the judgment calls the agent is explicitly scoped *not* to make (rent negotiation, protected-class-sensitive decisions) |

**Target KPIs to name and defend (Q&A will probe these — treat as commitments to validate post-launch, not audited history, since this is a pre-launch capstone):**
- **Prospect inquiry deflection:** target 60–70% of "is X available / what specials are running" conversations resolved without a leasing agent touch, measured via Case/escalation rate out of the Apartment_Search and Get_Move_In_Specials topics.
- **After-hours case deflection:** target 50% reduction in after-hours phone escalations for routine maintenance/access requests, measured by comparing Case `CreatedDate` after-hours volume pre/post launch.
- **Manager admin time:** target 2–3 hours/week/property manager returned via automated weekly property review + renewal email drafting (Ops Copilot), validated by manager time-tracking survey at 30/60/90 days.

## Phased Roadmap

- **Phase 1 (this build):** Three scoped agents on live CRM data, guardrails matched to real PHP policy (pricing, jailbreak, PII), a working (if minimal) Data Cloud pipeline (`Open_Case_Count_by_Property` Calculated Insight), and a Sharing Rules model proven with the Tom/Jerry two-property-manager scenario.
- **Phase 2:** Surface the Data Cloud Calculated Insight directly into Ops Copilot's weekly review topic so backlog-by-property becomes a proactive alert, not a pulled report. Expand the Ops Manager permission set group pattern to onboard additional property managers/portfolios beyond the Tom/Jerry pilot.
- **Phase 3:** Move OTP delivery from the mocked `sendOTP()` stub to a real SMS provider; extend Data Cloud ingestion to lease and engagement data for renewal-risk scoring; evaluate widening Leasing Assistant's autonomy (e.g., bounded move-in-special negotiation) once Phase 1's guardrail model has a track record.

**Why this shape, not a bigger Phase 1:** every capability in Phase 1 is grounded in data PHP already has and a guardrail that reflects a real policy constraint (never quote rent, never unlock on a jailbreak attempt, never leak OTP/PII). Nothing here is a demo-only shortcut — it's the subset of the full vision that's safe to run unsupervised on day one.
