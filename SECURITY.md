# Security Policy

## Supported versions

Security and privacy fixes are provided for the latest released minor version
of pcatR.

| Version | Security support |
|---|---|
| 1.0.x | Supported |
| Earlier development versions | Not supported |

## Reporting a vulnerability

Please do not open a public GitHub issue for:

- a suspected software vulnerability;
- exposed credentials or authentication material;
- accidental disclosure of confidential or sensitive data;
- a vulnerability that could be actively exploited; or
- a report that requires coordinated disclosure.

The preferred reporting method is GitHub's private vulnerability reporting
feature:

1. Open the pcatR repository.
2. Select **Security and quality**.
3. Select **Advisories**.
4. Select **Report a vulnerability**.

If private vulnerability reporting is unavailable, email the maintainer at:

`jaemanblp2@gmail.com`

Use the subject line:

`pcatR private security report`

Include, when applicable:

- the affected pcatR version;
- the operating system and R version;
- a minimal, de-identified reproduction;
- the expected and observed behavior;
- the potential impact;
- proposed remediation, if known; and
- whether the report should remain embargoed.

Do not transmit real respondent data, protected health information, personally
identifiable information, credentials, access tokens, or confidential free-text
comments as part of a vulnerability report.

## Response targets

The maintainer aims to:

- acknowledge a report within five business days;
- complete initial triage within ten business days;
- communicate whether the report has been accepted, declined, or requires more
  information; and
- coordinate remediation and public disclosure based on severity and impact.

These are response targets rather than guaranteed remediation deadlines.

## Scope

The following are within scope:

- pcatR package source code;
- data import, validation, classification, summarization, and export functions;
- the bundled Shiny application;
- package-generated files and reports;
- GitHub Actions workflows;
- release artifacts; and
- documentation that could cause insecure use of the software.

The following are generally outside scope:

- vulnerabilities solely within R, CRAN, GitHub, an operating system, or another
  third-party service;
- social-engineering attacks;
- reports requiring access to real sensitive data;
- unsupported development versions; and
- reports concerning an institution's local data-governance practices rather
  than pcatR software behavior.

## Data-security boundary

pcatR is a local analytic software package. It is not:

- a secure survey-collection platform;
- an identity or access-management system;
- an encrypted data-storage service;
- a hosted data-processing service;
- an electronic health-record system; or
- a regulatory-compliance product.

Users are responsible for institutional approval, access control, encryption,
approved storage, de-identification, minimum-cell suppression, retention
policies, secure transfer, and review of free-text comments.

The bundled Shiny application should be used only with de-identified data unless
it has been deployed within an independently approved and appropriately secured
environment.

## Coordinated disclosure

Please allow the maintainer reasonable time to investigate and remediate a
confirmed vulnerability before public disclosure. Valid reporters may be
credited in a security advisory unless anonymity is requested.
