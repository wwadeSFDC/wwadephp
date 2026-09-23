# DevOps, Deployment & Data Cloud Hibernate Plan

*Reference for Part 1 (0:00–0:10, DevOps & Deployment) and Q&A. Per the presentation guide, this section is verbal-friendly — a confident explanation satisfies Level 3. This doc is the talking-point backing.*

## Current State (be honest about this if asked)

The capstone build lives in a single OrgFarm sandbox (`phpProd` alias — despite the name, it's the one demo/build org for this program). Every component is tracked in this git repo (`force-app/main/default/...`), deployed via `sf project deploy start`, with `manifest/package.xml` as the retrieve/deploy unit covering all PHP-relevant metadata types (Apex, Flows, CustomObjects/Fields, the Agentforce bundle types, PermissionSets, NamedCredentials, Experience Cloud, etc.). There is no CI pipeline wired up yet and no separate Dev/UAT/Prod orgs — that's the honest current state, and it's fine to say so. **What follows is the promotion path PHP would run for a real rollout**, not a claim that three live orgs exist today.

## Proposed Multi-Environment Promotion Path

```
Developer Scratch Org  →  Integration/UAT Sandbox  →  Production
   (per-feature)             (shared, judge-facing)      (tenant-facing)
```

1. **Dev (scratch org per feature/agent change).** Agent Script (`.agent` files), Flows, and Apex changed and unit-tested in isolation. Scratch orgs are cheap to spin up/tear down from `sfdx-project.json` + the same manifest, so an agent topic change never risks the shared demo org.
2. **UAT/Integration (this org today).** Where the three agents, the shared CRM data model, and the Data Cloud pipeline all run together — this is where cross-agent behavior (e.g., does a Tenant Concierge case show up correctly in Ops Copilot's weekly review) actually gets validated, and where the judge-facing demo happens.
3. **Production.** Same metadata, promoted via the same `package.xml`, with one deliberate split at promotion time: **metadata vs. data.**

## Metadata vs. Data — the distinction that matters most here

Everything under `force-app/main/default/` — Apex, Flows, CustomObject/Field definitions, PermissionSets, SharingRules, Roles, the `AiAuthoringBundle` agent scripts — is **metadata**: version-controlled, diffable, promoted the same way every time via `sf project deploy start -x manifest/package.xml`.

**Data does not travel with metadata**, and this build has three concrete examples worth naming if asked:
- **Permission Set Group membership** (`PermissionSetGroupComponent`) — the `PHP_Ops_Manager_PSG` group's shell (label, description, status) is metadata and deploys cleanly; which permission sets belong to it is data, assigned per-org after deploy.
- **Sample records** — the Tom vs. Jerry sharing scenario needs real `Apt_Location__c`/`Apartment__c`/`Case` records owned by the right users in each environment; those records don't get created by a metadata deploy.
- **Named Credential secrets** — `PHP_SmartRent_NC`'s URL/auth *structure* is metadata; the actual auth token is deliberately not replicated and must be re-entered per environment, so a compromised UAT credential can't leak into production metadata.

## Technical Standards for Production Readiness

- **Apex test coverage as a deploy gate**, not an afterthought — `PHP_OTPServiceTest` and `PHP_SmartRentServiceTest` cover the two most sensitive integrations (OTP generation/validation, SmartRent door control) at 80–100% line coverage; a production deploy should run `--test-level RunSpecifiedTests` against these before any Apex touching identity or physical access ships.
- **Guardrails as reviewed text, not tribal knowledge** — every "never do X" instruction (pricing, jailbreak, PII, system-config disclosure) lives in the versioned `.agent` source, so a guardrail change is a diffable PR, not a click in a UI that no one remembers to review.
- **Least-privilege as the default, not the exception** — OWD is `Private` on `Case`/`Apt_Location__c`/`Apartment__c`; access is granted back in deliberately, either through role hierarchy (property manager → VP of Operations) or a scoped criteria-based Sharing Rule (escalated cases → Maintenance Escalation Manager), never through a blanket "everyone sees everything" shortcut.

## Data Cloud Hibernate Plan

The build includes one real (intentionally minimal) Data Cloud pipeline: `Case` and `Apt_Location__c` stream in via the standard Salesforce CRM Connector into `ssot__Case__dlm` and the custom `Apt_Location_c_Home__dlm`, joined by a Calculated Insight (`Open_Case_Count_by_Property`) that aggregates open-case count per property.

**Why "Hibernate," not "decommission":** Data Cloud consumption is metered, and this pipeline isn't yet a dependency for the live agent (per the architecture doc, it's phase-2 wiring into Ops Copilot's weekly review). Between the capstone demo and Phase 2 actually consuming it, the responsible move is to pause ingestion rather than pay for a stream nothing reads yet:

1. **Pause, don't delete, the Data Streams** (`Case_Home`, `Apt_Location_c_Home`) — stopping a stream preserves the DMO mappings and the Calculated Insight definition, so re-activating later is a toggle, not a rebuild.
2. **Leave the DMOs and Calculated Insight definition in place** — they cost nothing idle and are the reusable contract Phase 2 builds on.
3. **Re-activate ingestion the moment Ops Copilot's weekly review is scoped to actually query the Calculated Insight** — at that point the pipeline stops being "real but unused" and starts paying for itself.

This is also the honest answer if a judge asks "why isn't Data Cloud in the live demo" — it's built, it's real, and it's deliberately not yet load-bearing, which is a more defensible position than either skipping Data Cloud entirely or wiring it in half-finished under demo pressure.
