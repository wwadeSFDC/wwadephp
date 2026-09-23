# Day 6 — Full 60-Minute Dry Run Script

*Master run-of-show. Rehearse against this end-to-end, with a timer, before presentation day. Everything referenced here is real and already built — this is a script for saying it out loud, not a to-do list.*

---

## 0:00–0:10 | Architecture Walkthrough (~90 sec per rubric area)

Use the narration script in [architecture_diagram.md](architecture_diagram.md) as the spine — walk the diagram left to right (Personas → Agents → CRM → Data Cloud → SmartRent). Land one sentence per rubric area as you pass through it:

1. **Business Value & Impact** — "PHP's leasing agents, on-call managers, and property managers all spend time re-answering the same answerable-from-data questions. [Business Value Brief](business_value_brief.md) — three agents map to three specific groups of returned time, with phased Data Cloud expansion planned, not a one-shot build."
2. **Solution Architecture** — walk the diagram: three personas, three scoped agents, one shared CRM data model, one real Data Cloud pipeline, one credential-brokered external integration (SmartRent). Say *why* three agents and not one: "topics don't reach into each other; the router re-evaluates every turn, so scope stays clean."
3. **Agent Design & Logic** — name the real topics per agent (below) and be ready to read the Door Unlock jailbreak instruction verbatim if asked — it's the most specific guardrail in the build.
4. **Testing** — "systematically tested at the Apex layer — [testing_evidence_summary.md](testing_evidence_summary.md) — including a real schema-drift bug we found and fixed, not just a happy-path demo."
5. **DevOps & Deployment** — "single org today, but every component is metadata-tracked in git with a defined promotion path — [devops_and_data_cloud_plan.md](devops_and_data_cloud_plan.md) — and Data Cloud has a Hibernate Plan so we're not paying for an unused stream."
6. **Trust & Security** — "Private OWD everywhere, role hierarchy plus one justified Sharing Rule exception, PII masked in the OTP audit log, and the agents actively refuse jailbreak attempts — I'll show that live, not just describe it."

---

## 0:10–0:22 | Live Demo — Leasing Assistant (Jordan)

**Real topics:** `Apartment_Search`, `Lead_Capture_and_Property_Information`, `Get_Move_In_Specials`, `GeneralFAQ` (+ escalation/off-topic housekeeping).

- Run an apartment search (bedroom count + move-in date) — point out the result is grounded in real `Apartment__c`/`Apt_Location__c` records, including the `State__c` field fix from Day 5.
- Ask a move-in-special question — show it quoting a real discount from `Move_in_Specials__c` and note this is the *one* place pricing-adjacent numbers are allowed to be quoted (contrast with the next bullet).
- Try to negotiate/ask base rent directly — show the pricing guardrail firing: it redirects to the leasing team instead of quoting a number. This is your "guardrail design" answer if probed.
- Ask a policy question sourced from the Resident Handbook retriever (grounded, not model-guessed).
- If probed on escalation logic: explain the `escalation` subagent — explicit human transfer request triggers it, and a failed transfer falls back to logging a Case instead of silently dropping the user.

---

## 0:22–0:34 | Live Demo — Tenant Concierge (Alex)

**Real topics:** `Tenant_Verification`, `Maintenance_Requests`, `Lease_Renewal`, `Door_Unlock_Access` (+ escalation/off-topic housekeeping).

- Run the full verification → maintenance case trace from [testing_evidence_summary.md §3](testing_evidence_summary.md). Open the session trace live and point out the OTP code is absent from the visible trace — the Day 4 PII fix, shown, not claimed.
- Demonstrate the jailbreak refusal from the rehearsed script (Door_Unlock_Access, exact-match refusal at `PHP_Tenant_Concierge.agent:524`) — this is the judge's favorite live-test moment per the guide.
- If probed on after-hours handling: point out `Door_Unlock_Access` and `Maintenance_Requests` both work identically at 2 AM as at 2 PM — there's no time-of-day gate, by design, because routine access/maintenance shouldn't require a human just because it's after hours; the guardrail that *does* gate is identity (OTP), not the clock.
- If probed on authentication/access control: OWD is Private on `Case`/`Apt_Location__c`/`Apartment__c`, and the Tenant_Verification topic's OTP flow is the only door into any tenant-specific data — no verification, no case creation, no unlock.

---

## 0:34–0:45 | Live Demo — Ops Copilot (Morgan)

**Real topics:** `Property_Review`, `Renewal_Email_Drafting`, `GeneralFAQ` (+ housekeeping).

- Run a `Property_Review` query (occupancy/backlog/payment status) — this is where the Tom/Jerry Sharing Rules scenario becomes visible: log in as Tom, show he only sees his own portfolio's properties/cases; mention Jerry's are invisible by the same Private OWD, and the one deliberate exception (escalated cases → Maintenance Escalation Manager role) is a scoped Sharing Rule, not a blanket carve-out.
- Run `Renewal_Email_Drafting` — show it pulling from `PHP_RenewalEmail_PromptTemplate`, grounded in the specific tenant's lease data, not a generic template.
- If probed on sensitive tenant data / protected classes: point to the objectPermissions scoping in `PHP_Ops_Manager_PS` — read/edit on `Apartment__c`/`Apt_Location__c` but no `modifyAllRecords`/`viewAllRecords`, and no delete anywhere. Ops Copilot's access is bounded by the same Sharing model as the humans using it.
- If probed on cost-conscious Einstein action selection: explain that `Property_Review` and `Renewal_Email_Drafting` are separate, narrowly-scoped topics rather than one do-everything topic — each topic's router only pulls in the reasoning/actions it needs for that specific job, so a simple occupancy question doesn't invoke the heavier renewal-email prompt template.

---

## 0:34–0:45 (parallel thread) | Trust & Security — weave into whichever agent demo fits, don't bolt on separately

- **Jailbreak refusal:** shown live in the Tenant Concierge segment above.
- **PII masking in the audit log:** open `PHP_OTPService.cls` debug logs live — show `maskPhone()` output (`****1234`) and the absence of the raw code anywhere in `System.debug`. Contrast with what it looked like before the Day 4 fix if you want the "here's what I changed and why" narrative.
- **Sharing Rules design:** shown live in the Ops Copilot segment above (Tom vs. Jerry). Be ready to say *what one property manager can and cannot access*: their own portfolio's `Apt_Location__c`/`Apartment__c`/`Case` records via role hierarchy up to VP of Operations; nothing in the sibling portfolio unless a case is escalated, in which case only the Maintenance Escalation Manager role — not the other property manager — gets visibility.

---

## 0:45–0:57 | Q&A — Defend These Trade-offs

Pre-loaded answers for the "why did you do X instead of Y" pattern the guide warns about:

- **Why Apex over Flow for OTP?** Single `@InvocableMethod` per class constraint — one action dispatched by an `action` field rather than two separate invocable methods; session state persisted on `OTP_Session__c` because GENERATE/VALIDATE run as separate transactions when invoked from an Agent.
- **Why Private OWD instead of Public Read Only?** Two property managers on different portfolios is the whole point of the Tom/Jerry scenario — Public Read/Write would make that isolation undemonstrable. Private + role hierarchy + one scoped Sharing Rule shows deliberate, minimal-necessary access, not default-open.
- **Why hide the OTP code from the agent's own trace instead of just not logging it?** Two separate leaks existed — the Apex debug log and the Flow's own output contract (`outputDebugOtpCode`). Fixing only one leaves the code visible in the session trace even with clean debug logs; the fix had to close both.
- **Why is Data Cloud not load-bearing in the live demo?** It's real (Case + Apt_Location__c streamed, one working Calculated Insight), but Phase 1 didn't need it to work; wiring it in half-finished under demo pressure would be worse than showing a paused, ready-to-extend pipeline with an honest Hibernate Plan.
- **Why only one Sharing Rule instead of several?** One well-justified, criteria-scoped exception (`Status = 'Escalated'` → Maintenance Escalation Manager, Edit) demonstrates the *pattern* without diluting the isolation story — more rules would mean more exceptions to defend, not more coverage.

---

## 0:57–1:00 | Wrap-up

One sentence, said with conviction, not read: *"Three agents, each scoped to exactly one persona's real job, grounded in PHP's actual data and actual guardrails — not a demo shortcut, but the subset of the full vision that's safe to run unsupervised on day one."*

---

## Pre-Flight Checklist (from the guide, filled in)

- [x] Architecture diagram ready — [architecture_diagram.md](architecture_diagram.md)
- [x] All 3 personas identified and scoped — Prospect / Tenant / Property Manager
- [x] Key capabilities ready per agent — real topic names listed above per agent
- [x] Bulk test results — Apex evidence in [testing_evidence_summary.md](testing_evidence_summary.md); **Agent Builder bulk-test CSVs still need to be run by you before demo day**
- [x] Session trace ready to walk through — Tenant Concierge verification→case trace, script above
- [x] Jailbreak refusal ready to demonstrate live — Door_Unlock_Access exact-match refusal
- [x] PII masking visible in audit log — `PHP_OTPService.maskPhone()`
- [x] Tom vs. Jerry Sharing Rules scenario ready — **confirm sample records are actually owned by Tom vs. Jerry in-org before demo day**, per the earlier open item
- [x] Deployment plan ready — [devops_and_data_cloud_plan.md](devops_and_data_cloud_plan.md)
- [x] Data Cloud Hibernate Plan ready — same doc
- [x] Business Value Statement/Brief prepared — [business_value_brief.md](business_value_brief.md)
- [x] KPIs and deflection targets named and justified — same doc, flagged as targets to defend, not audited history

**Two genuine open items before this is demo-ready** (both are user actions, not something further CLI work resolves):
1. Run the Agent Builder bulk-test CSVs and record real pass rates.
2. Confirm sample `Apt_Location__c`/`Apartment__c`/`Case` records are actually assigned to Tom vs. Jerry (and that a Maintenance Escalation Manager demo user exists) so the Sharing Rules walkthrough is live, not hypothetical.
