# Testing Evidence Summary

*Reference for Part 1 (0:00–0:10, Testing) and Q&A. Per the guide, this is demo-light and verbal-friendly — have the numbers below ready to reference, don't try to re-run tests live.*

## 1. Apex-Level Evidence (real, run this session — `sf apex run test`)

| Test Class | Result | What it covers |
| :---- | :---- | :---- |
| `PHP_OTPServiceTest` | 5/5 pass | OTP generate/validate, expiry, max-attempt lockout — the identity verification backbone for Tenant Concierge |
| `PHP_SmartRentServiceTest` | 3/3 pass | Door unlock, keyfob deactivation, unknown-action handling — the physical-access integration |
| `PHPApartmentGalleryControllerTest` | 4/4 pass *after fix* | Apartment search filtering by state/bedrooms/rent — Leasing Assistant's core grounding query |

**A real failure, found and fixed via this testing, worth telling the judge about directly** (this is exactly the "reviewed failures, not just happy path" signal the rubric wants): the bulk run initially showed `PHPApartmentGalleryControllerTest` failing 4/4 with `System.QueryException: No such column 'State__c' on entity 'Apt_Location__c'`. Root cause: the `Apt_Location__c.State__c` field existed in the Metadata API's own index (confirmed via `sf org list metadata` and a successful field retrieve) but had never actually materialized as a queryable column in this org — a metadata/schema drift specific to this OrgFarm sandbox, not a code defect. Redeployed the field to force a real create; **verify in-org before demo day** that `Apt_Location__c` → Setup → Fields now shows `State` and that the apartment search topic returns state-filtered results live (see Follow-up below — this class of drift has recurred with other component types in this org and deserves a UI-level confirmation, not just a green CLI deploy).

Org-wide Apex coverage: 16% (expected — this org carries a large volume of pre-existing, non-PHP Experience Cloud controller classes outside this capstone's scope; the PHP-specific classes that matter for the demo sit at 57–100%).

## 2. Agent-Level Bulk Testing (run this in Agentforce Testing Center before demo day — not something I can execute from here)

Salesforce's Agent Builder **Testing** tab supports bulk test runs: a CSV of sample utterances + expected topic/outcome, graded automatically for topic-routing accuracy and instruction adherence. Build one CSV per agent covering:

- **Leasing Assistant:** apartment search (various bedroom/price/date combos), move-in special lookup, a base-rent negotiation attempt (expect the pricing guardrail to fire, not a quote), an off-topic question, an escalation request.
- **Tenant Concierge:** OTP verification happy path, wrong-code retry, expired-code retry, maintenance case creation, door unlock post-verification, the jailbreak refusal prompt from the Trust & Security rehearsal script.
- **Ops Copilot:** occupancy/backlog query, renewal email draft request, a sensitive-tenant-data question that should be declined or redirected, a low-value request that should route to a cheaper action rather than a full LLM call (cost-conscious action selection).

Run each CSV, record the pass rate and any misroutes, and have that pass-rate table ready to reference verbally — you don't need to run it live for the judge, but you do need the numbers in hand.

## 3. Session Trace Walkthrough (pick one, narrate it live)

**Recommended trace: Tenant Concierge end-to-end verification → maintenance case.** This is the single richest trace to walk a judge through because it touches identity verification, PII handling, and a grounded CRM write in one conversation:

1. Tenant provides phone number → `Get_Account_By_Phone` flow lookup (point out: OWD is Private, so this only resolves for the correct Account).
2. `Generate_OTP` action call → `PHP_OTPService.execute(action=GENERATE)` → point out in the trace that the response surfaces `success`/`message`, **not** the code itself — that's the PII fix from Day 4 (`Send_OTP.code` hidden from planner, `outputDebugOtpCode` removed from the flow's outputs entirely).
3. Tenant submits code → `VALIDATE` action → `isValid`/`message` only.
4. Verified tenant reports a maintenance issue → case created against `Case`, owned appropriately for the sharing model.

Walk the judge through the trace panel showing exactly where the raw OTP would have appeared pre-fix versus where it's absent now — that's a concrete, visual "trust layer in action" moment, not just a claim.

## 4. Follow-up Before Presentation Day

- [ ] Confirm `Apt_Location__c.State__c` is visible in Setup and the Leasing Assistant's apartment search returns state-filtered results live (the fix above needs a UI confirmation, not just a green deploy — this org has shown metadata/schema drift before).
- [ ] Run the three bulk-test CSVs in Agent Builder Testing Center and record pass rates.
- [ ] Pull and screenshot/record the Tenant Concierge trace above as backup evidence in case Org Farm is down on presentation day.
