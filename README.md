# Pacific Haven Properties Salesforce Project

This repository contains the Salesforce source for a Pacific Haven property-management and tenant service experience. It includes Experience Cloud pages, custom property data, AI-assisted service flows, and Apex logic for tenant authentication and smart-access actions.

## Project Summary

This project is built around a residential property-management use case with:

- Tenant-facing Experience Cloud components and self-service pages
- AI and bot-based service experiences for leasing, operations, and tenant support
- Apex actions for OTP-based identity checks and SmartRent access integration
- Custom objects for apartments, lease payment workflows, unit locations, move-in specials, and OTP tracking
- Knowledge articles and documentation for policy and operational guidance

## Major Components

### Experience Cloud and UI

- `force-app/main/default/pages` for site login, registration, and authorization pages
- `force-app/main/default/aura` and `force-app/main/default/lwc` for custom UI and experience components
- `force-app/main/default/staticresources` for packaged frontend assets
- `force-app/main/default/experiences` and community-related metadata for the hosted experience

### AI and Bot Configuration

- `force-app/main/default/aiAuthoringBundles` includes agent design bundles such as:
  - `PHP_LeasingAssistant`
  - `PHP_OpsCopilot`
  - `PHP_Tenant_Concierge`
  - `PHP_Dummy_Agent`
- `force-app/main/default/bots` contains the bot definitions for the same tenant/ops experience surfaces.

### Apex Services

- `PHP_OTPService.cls` generates and validates time-limited OTP codes for tenant verification.
- `PHP_SmartRentService.cls` performs SmartRent actions such as door unlocks and keyfob deactivation via named credential callouts.
- Additional Salesforce site/auth controllers and support classes exist under `force-app/main/default/classes` for site login, self-registration, profile, and experience support.

### Data Model

The project includes custom objects and related metadata for:

- Accounts and person-account use cases
- Apartment and location records
- Lease payment tracking
- Move-in specials
- OTP session persistence
- Case and lead handling
- MessagingSession support
- Knowledge articles

## Repository Structure

```text
.
├── force-app/
│   └── main/
│       └── default/
│           ├── aiAuthoringBundles/
│           ├── aura/
│           ├── bots/
│           ├── classes/
│           ├── experiences/
│           ├── flows/
│           ├── lwc/
│           ├── objects/
│           ├── pages/
│           └── staticresources/
├── documentation/
│   ├── all.md
│   ├── handbook.txt
│   └── objects-metadata.json
├── manifest/
│   └── package.xml
├── scripts/
│   ├── apex/
│   └── soql/
├── config/
│   └── project-scratch-def.json
├── package.json
├── sfdx-project.json
├── README.md
└── eslint.config.js
```

## Local Setup

Prerequisites:

- Salesforce CLI (`sf`)
- Node.js and npm
- Access to a Salesforce org with the relevant Experience Cloud and Agentforce features enabled
- An authenticated org alias configured for deployment and testing

Install dependencies:

```bash
npm install
```

## Validation and Testing

The project includes standard Salesforce DX and LWC validation commands:

```bash
# Lint Aura/LWC JS
npm run lint

# Run LWC tests
npm test

# Run LWC tests with coverage
npm run test:unit:coverage

# Verify formatting
npm run prettier:verify
```

For Apex validation, use Salesforce CLI against the target org:

```bash
sf apex run test --target-org <org-alias> --test-level RunLocalTests --wait 30
```

## Deployment

Deploy the project source to an org:

```bash
sf org login web --alias <org-alias>
sf project deploy start --source-dir force-app --target-org <org-alias>
```

Or use the manifest-aware deploy method:

```bash
sf project deploy start --manifest manifest/package.xml --target-org <org-alias>
```

## Project Configuration Notes

- `sfdx-project.json` uses the default package directory at `force-app`.
- The project is configured for Salesforce API version `65.0`.
- Environment-specific values like org aliases, named credentials, site URLs, and external integrations should be maintained in the target org configuration rather than hardcoded into the source.
- `package.json` includes standard Salesforce project scripts for linting, Jest-based LWC testing, formatting, and pre-commit simplicity.

## Documentation and Knowledge

The project also contains a large set of tenant policy and support documentation in `documentation/all.md`, which appears to be the source for knowledge articles and service policy guidance. This is an important operational artifact because it documents the tenant experience and business rules behind the automation.

## Useful Links

- [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/platform/sfdx-setup/guide)
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us/sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)
- [Salesforce Extensions for VS Code](https://developer.salesforce.com/tools/vscode/)
