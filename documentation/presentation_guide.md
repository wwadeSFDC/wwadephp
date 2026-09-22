Participant Presentation Guide — Agentforce Readiness Capstone

# **Participant Resources**

| Resource | Description |
| :---- | :---- |
| [Participant Guide](https://docs.google.com/document/d/1H-Zit-O433KJ9YTOukmmCuxggGzDG9VZwjKr0xI-_XA/edit?usp=sharing) | Full program overview, timeline, rubric, and post-capstone next steps |
| [Pacific Haven Properties – Unified Agentforce Challenge](https://docs.google.com/document/d/1IE6JbOZ5tGR3O5WzW7tyZuqOY-JjvJSP8YKYyQ6AoWk/edit?usp=sharing)  [Pacific Haven Properties: Master Community Covenant and Resident Handbook](https://docs.google.com/document/d/1SGTXVeNjl4dqHzAYH6b41WyoT7ubZVrqLQvBISX3dZg/edit?usp=sharing) | Your scenario and scenario resources — the business requirements you are solving for |
| [Demo Org Setup Instructions](https://docs.google.com/document/d/1H-Zit-O433KJ9YTOukmmCuxggGzDG9VZwjKr0xI-_XA/edit?tab=t.0#heading=h.e3gwb78yas6t) | Steps to get your demo org ready before your presentation |

---

# **Suggested Troubleshooting Steps**

Most technical blockers in this program have already been hit — and solved — by someone else. This tracker alone documents 30+ resolved issues. Before filing a ticket, take a few minutes to check whether your issue is already answered here; it's usually faster than waiting on a response, and it keeps the queue clear for new troubleshooting.

&nbsp;

Follow these steps in order:

1. **Search Slackbot and Canvas:** Use Slackbot's search to check the [Agentforce Readiness Capstone – Issues & Resolutions Tracker (Last Updated 2026-08-21)](https://salesforce.enterprise.slack.com/docs/T026FPW8M/F0BHPQ46L0L) and program channels for a verified fix or FAQ that matches what you're seeing. Using AI tools (Claude, Agentforce Vibes, etc.) ([:purple-sparkle: Professional Services \- Approved AI Tools Guidelines](https://salesforce.enterprise.slack.com/docs/T026FPW8M/F08N1FPEJ78)) to troubleshoot or solve the issue is okay, as long as you can explain, walk through, and defend your solution during the Q\&A portion of your presentation.  
2. **Check the [\#help-ps-agentforce-capstone](https://slack.com/archives/C0AU4CD3YSE). Look for existing** incident reports or similar issues shared by other participants.  
3. **Log a help ticket if you're still stuck — and share what you tried.** Whether or not you land on a fix, post what you attempted so the next person hits a documented trail.  
4. **Log a [\#orgfarm](https://salesforce.enterprise.slack.com/archives/C02QCGPGG4C) Support Ticket:** If the issue remains unresolved after following steps 1-3. proceed to log a formal OrgFarm technical support ticket.

*Tip: Keep an eye on the [\#broadcast-fireinfra](https://slack.com/archives/C01PRFGMD4K) channel for open and critical issues.*

&nbsp;

---

# **Evidence Guidelines**

**Collect evidence as you build — don't wait until the end.** Given Org Farm's ongoing stability issues, capture your recordings and screenshots progressively throughout your build, not just at the finish line. If the org goes down before you've documented a working piece, you may not get another chance to show it live — so document each stage as you complete it. This also lets you keep progressing even if the org becomes unavailable later.

* **Primary Evidence — Google Meet recordings with voice-over narration, captured while Org Farm is up and running.** Record your narrated walkthrough live in Org Farm while it's functional — don't wait until presentation day. This protects you: if Org Farm has issues when it's time to present, you'll already have a working, narrated recording of your solution in hand rather than scrambling in the moment.  
* **Secondary Evidence — Screenshots:** Best used for your presentation itself — to document specific configurations, code snippets, or UI elements clearly and concisely. Screenshots support your presentation narrative but shouldn't replace a narrated explanation of your work.

&nbsp;

**Judge Q\&A — be ready to go live in Org Farm:** Even if your submitted evidence is a narration or screenshots, you may be asked during the judge evaluation session to open Org Farm and show what remains of your build. This isn't a re-demo — it's a chance to point to where things are, walk through what's there, and defend your solution and decisions in real time. Come prepared for that, regardless of what your submitted evidence looked like.

&nbsp;

---

---

# **Session Overview**

Your presentation is 60 minutes, structured in five segments. The judge is playing the role of a **Senior Customer Stakeholder** — skeptical, curious, and realistic. Your job is to make the solution real for them: not just "here's what I built," but "here's why it matters for PHP." Here is a suggested breakdown, but don't feel beholden to following this exactly.

| Segment | Time | What You're Doing |
| :---- | :---- | :---- |
| Architecture Walkthrough | 0:00 – 0:10 | Set the stage. Cover all 3 agents and all 6 rubric areas at a high level. This is the judge's only structured opportunity to assess full coverage before the demo starts. |
| Live Demo — Leasing Assistant (Agent 1\) | 0:10 – 0:22 | Highlight your build for the Sales Agent. Walk through the key capabilities you built and what makes them work. |
| Live Demo — Tenant Concierge (Agent 2\) | 0:22 – 0:34 | Highlight your build for the Service Agent. Show the authentication flow, case creation, and routing in action. |
| Live Demo — Ops Copilot (Agent 3\) | 0:34 – 0:45 | Highlight your build for the Employee Agent. Demonstrate data handling, email drafting, and cost-conscious Einstein actions. |
| Q\&A | 0:45 – 0:57 | The judge goes back to anything not fully covered. Your chance to defend your design, go deeper, and show your thinking. |
| Wrap-up | 0:57 – 1:00 | Close strong. One sentence on why this solution is ready for PHP. |

---

# **Part 1: Architecture Walkthrough**

## **0:00 – 0:10 | Cover all 6 rubric areas before the demo starts**

This is your only structured opportunity to show full coverage before the demo. You don't need to go deep here — you just need to signal to the judge that you've addressed every area. Gaps here become questions in the demo and Q\&A.

**Move through these six areas in order. Aim for \~90 seconds each.**

---

## **1\. Business Value & Impact**

**What the judge is listening for:**

The judge wants to understand *why this solution matters for PHP* — not just what it does. Articulate the business case, connect it to measurable outcomes, and show that you've thought beyond launch day.

**What Level 3 looks like:** You define the business challenge, map agentic capabilities to measurable outcomes, and show a phased roadmap.

> **Tip:** Don't just say "it saves time." Name *whose* time, by how much, and what they do with it instead.

---

## **2\. Solution Architecture**

**What the judge is listening for:**

The judge wants to see a coherent technical picture — how all the pieces fit together for PHP's three personas, how data flows through the system, and how the agents stay in their lanes.

**What Level 3 looks like:** A comprehensive technical blueprint that maps the request lifecycle through the reasoning engine to grounded data sources, with all personas and integrations accounted for.

> **Tip:** Walk the judge through the diagram as if they've never seen it — describe the flow, not just the boxes.

---

## **3\. Agent Design & Logic**

**What the judge is listening for:**

The judge wants to see that your agents are purpose-built — clear roles, grounded in PHP's data, with guardrails that reflect real-world constraints and edge cases a property management company would actually face.

**What Level 3 looks like:** Agents with distinct roles and tones, functional actions, and instructions that follow industry best practices for guardrails.

> **Tip:** Be ready to read one of your system instructions out loud. Specificity here is a strength signal.

---

## **4\. Testing**

**What the judge is listening for:**

The judge wants confidence that you validated your build systematically — not just that it works in the happy path, but that you've tested for accuracy, reviewed failures, and have a plan for what happens after go-live.

**What Level 3 looks like:** Systematic validation across core use cases, with a clear analysis of accuracy and instruction adherence using automated tools.

> **Tip:** Testing and DevOps are demo-light by nature — a verbal walkthrough is fully acceptable. Have your bulk test results and session trace ready to reference.

---

## **5\. DevOps & Deployment**

**What the judge is listening for:**

The judge wants to know your solution is production-ready — that you've thought through how it gets deployed, maintained, and handed off in a real PHP environment, not just demoed in a sandbox.

**What Level 3 looks like:** A clear multi-environment promotion path with technical standards for production readiness and solution sustainability.

> **Tip:** Like Testing, this is verbal-friendly. A clean, confident explanation of your deployment plan is enough to satisfy Level 3\.

---

## **6\. Trust & Security**

**What the judge is listening for:**

The judge wants to see that trust and security aren't an afterthought — that the Einstein Trust Layer is actively configured, tenant data is protected, and the agents refuse what they're not supposed to do.

**What Level 3 looks like:** Standard trust layer and role-based security configured, with the agent actively refusing requests that violate safety or ethical guardrails.

> **Tip:** Judges love to test this live — be ready to show a refusal in the demo, not just describe it.

---

# **Part 2: Live Demo**

## **0:10 – 0:45 | Show your build. Expect in-character questions.**

Each agent gets approximately **12 minutes** of live demo time. Use this time to highlight your build — walk the judge through what you built, why you made the design decisions you did, and show the capabilities in action. You don't need to script every interaction or run every scenario — the goal is to make the solution real and demonstrate your command of what you built.

**The judge will ask questions in character as a Senior Customer Stakeholder during your demo.** This is normal — engage with them directly. Treat it like a client walkthrough, not a technical debrief.

---

## **Leasing Assistant (Sales Agent) — Task 2**

**What to highlight in your 12 minutes:**

Consider highlighting how the agent navigates a real prospect conversation — grounding its responses in both CRM data and the Leasing Handbook, respecting its guardrails, and knowing when to escalate. This is a good place to show the intentionality behind how you scoped the agent's behavior.

**What judges will probe in-character:**

* Expect to be asked about how the agent handles a prospect inquiry using both structured and unstructured data  
* Expect to be asked about your guardrail design — what unauthorized actions you protected against and how  
* Expect to be asked about your escalation logic — what triggers a handoff and who takes over

---

## **Tenant Concierge (Service Agent) — Task 3**

**What to highlight in your 12 minutes:**

Consider highlighting the identity verification flow and what happens when a tenant needs urgent help — especially in a high-stress, after-hours scenario. This is a good place to show how you balanced responsiveness with security and appropriate escalation.

**What judges will probe in-character:**

* Expect to be asked about your after-hours handling — what the agent does when a tenant needs help at 2 AM  
* Expect to be asked about a tenant self-service transaction from start to finish  
* Expect to be asked about your authentication and access control design — what stops unauthorized users from accessing tenant data

---

## **Ops Copilot (Employee Agent) — Task 4**

**What to highlight in your 12 minutes:**

Consider highlighting how the agent surfaces actionable insights for the property manager while respecting data boundaries — particularly around sensitive tenant data and cost-conscious AI action selection. This is a good place to show the judgment calls behind your build.

**What judges will probe in-character:**

* Expect to be asked about your approach to sensitive data handling for protected classes of tenants  
* Expect to be asked about how the agent uses tenant history contextually without overstepping data boundaries  
* Expect to be asked about your Einstein action selection rationale and cost-conscious design decisions

---

## **Trust & Security — Task 5**

**What to highlight in your build:**

Consider highlighting the trust layer in action — not just described. Show the agent refusing what it shouldn't do, demonstrate how PII is handled in the audit log, and walk through how your Sharing Rules reflect real PHP access boundaries.

**What judges will probe in-character:**

* Expect to be asked to demonstrate a jailbreak refusal live  
* Expect to be asked to walk through what PII masking looks like in the audit log  
* Expect to be asked about your Sharing Rules design — what one property manager can and cannot access

---

# **Part 3: Q\&A**

## **0:45 – 0:57 | The judge comes back to gaps. You go deeper.**

The Q\&A is not a new section — it's the judge returning to anything they flagged as **Partial** or **Not Covered** during the walkthrough and demo. Expect them to:

* Ask you to defend design decisions you made  
* Push on edge cases you didn't demo  
* Ask you to explain technical concepts in plain language (as if to a PHP executive)  
* Probe Testing and DevOps verbally — these are almost always Q\&A territory

**How to handle it well:**

* Be specific. Vague answers ("it's more secure") signal Level 2\. Specific answers ("it's more secure because the Zero Retention policy means the LLM provider can't use that data for training") signal Level 3+.  
* Connect back to PHP. Every answer should ground in the scenario — not Agentforce generically.  
* Defend your choices. If you made a trade-off (e.g., Apex over Flow), explain *why* — the judge is checking that you can reason through your design decisions.  
* It's okay to say "I considered that." Showing that you thought about an alternative and chose your path deliberately is a strength signal.

---

# **Scoring Quick Reference**

**Agentforce-Ready \= Score of 3+ in all 6 areas (18+ out of 30\)**

***A score below 3 in any area \= Unsatisfactory***

| Score | Label | What it looks like |
| :---- | :---- | :---- |
| 1–2 | Entry / Developing | Concept-only, happy path only, can't defend design choices |
| 3 | Proficient (Ready) | Explains core concepts, demonstrates basic implementation, production-ready |
| 4–5 | Specialist / Expert | Advanced implementations, executive-level narrative, strategic framing |

Results are shared *via email either on the Thursday of Week 6 or Week 7 depending on when your evaluation session was completed*. The judge will not share scores or a pass/fail during the session.

---

# **Presentation Checklist**

Use this to self-check before your session.

* Architecture diagram is ready and covers: Agent, Data Cloud, CRM, SmartRent API  
* All 3 personas identified and scoped: Prospect, Tenant, Property Manager  
* Key capabilities ready to highlight for each of the 3 agents (\~12 min each)  
* Bulk test results ready to reference or share  
* Session trace ready to walk through  
* Jailbreak refusal ready to demonstrate live  
* PII masking visible in audit log  
* Tom vs. Jerry Sharing Rules scenario ready  
* Deployment plan ready: Dev → UAT → Prod, metadata vs. data distinction  
* Data Cloud Hibernate Plan ready to explain  
* Business Value Statement or Brief prepared  
* KPIs and deflection targets named and justified