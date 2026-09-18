# Pacific Haven Properties Salesforce Project

Salesforce DX source for a Pacific Haven Properties tenant and leasing experience. The project combines Experience Cloud sites, AI-powered service agents, tenant policy knowledge, custom property-management data, and Apex actions for tenant authentication and smart-access operations.

## What Is Included

- **Tenant-facing experiences:** Experience Cloud metadata, authentication pages, Aura components, Visualforce pages, custom Lightning Web Components, and site assets.
- **AI and service agents:** Authoring bundles for the Tenant Concierge, Ops Copilot, Leasing Assistant, and supporting agent configurations. Bots are defined for `PHP_Tenant_Concierge`, `PHP_OpsCopilot`, and `PHP_LeasingAssistant`.
- **Tenant operations:** `PHP_OTPService` generates and validates one-time passcodes using `OTP_Session__c`; `PHP_SmartRentService` invokes SmartRent actions for door unlocking and keyfob deactivation through the `PHP_SmartRent_NC` named credential.
- **Property data model:** Custom metadata for apartments, locations, lease payments, move-in specials, OTP sessions, and Knowledge, plus extensions to standard objects such as Account, Case, Lead, and MessagingSession.
- **Knowledge content:** Tenant policies and answers covering access devices, leases, guests, maintenance, payments, move-in workflows, and related property-management topics.

## Repository Layout

| Path | Purpose |
| --- | --- |
| `force-app/main/default` | Deployable Salesforce metadata and source |
| `force-app/main/default/classes` | Apex services, controllers, and tests |
| `force-app/main/default/aiAuthoringBundles` | Agent authoring and prompt configuration |
| `force-app/main/default/bots` | Experience Cloud bot definitions |
| `force-app/main/default/lwc` | Custom Lightning Web Components |
| `force-app/main/default/objects` | Custom objects and field metadata |
| `documentation/all.md` | Tenant-facing policy and knowledge content |
| `documentation/handbook.txt` | Project and operational notes |
| `documentation/objects-metadata.json` | Inventory of the object metadata source |
| `manifest/package.xml` | Explicit metadata deployment manifest |
| `scripts/apex` and `scripts/soql` | Reusable Apex and SOQL scripts |

## Prerequisites

- Salesforce CLI (`sf`)
- Node.js and npm
- Access to a Salesforce org with the required Experience Cloud, Knowledge, Agentforce, and named-credential configuration
- An authenticated Salesforce CLI org alias

Install the Node.js development dependencies after cloning:

```bash
npm install
```

## Validate Changes

Run the checks that match the files you changed:

```bash
# LWC and Aura JavaScript linting
npm run lint

# LWC unit tests
npm test

# LWC tests with coverage
npm run test:unit:coverage

# Verify repository formatting
npm run prettier:verify
```

Apex tests run in a Salesforce org rather than through Jest. For example:

```bash
sf apex run test --target-org <org-alias> --test-level RunLocalTests --wait 30
```

## Deploy to Salesforce

Authenticate an org, then deploy the default source directory:

```bash
sf org login web --alias <org-alias>
sf project deploy start --source-dir force-app --target-org <org-alias>
```

For a manifest-based deployment:

```bash
sf project deploy start --manifest manifest/package.xml --target-org <org-alias>
```

The project is configured as a single default package directory at `force-app` and targets Salesforce source API version `65.0`. Environment-specific values, including org aliases, named credentials, site settings, and external integrations, must be configured in the target org and should not be hard-coded into source.

## Development Notes

- Keep Apex service tests alongside their classes. The OTP and SmartRent integrations require callout, security-context, and failure-path coverage when their behavior changes.
- Treat generated Experience Cloud static resources and web-runtime bundles as deployment artifacts. Prefer editing their owning Salesforce metadata or source component rather than changing generated files directly.
- Review tenant-facing policy changes in `documentation/all.md` together with the related Knowledge metadata before deployment.

## Salesforce Resources

- [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/platform/sfdx-setup/guide)
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us/sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)
- [Salesforce Extensions for Visual Studio Code](https://developer.salesforce.com/tools/vscode/)
