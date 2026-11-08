# Security Policy

## Scope

This repository is a public information and community hub. The deployed website, APIs, mod binaries, and private development infrastructure may be maintained in separate systems.

## Reporting a vulnerability

Please do **not** publish exploitable vulnerabilities, proof-of-concept exploit code, credentials, or sensitive endpoint details in public issues or discussions.

Use GitHub's **Report a vulnerability** feature (Security tab) if private vulnerability reporting is enabled. Otherwise, contact the maintainer through a verified contact method published on the official project website.

Include:
- A concise description of the issue.
- Affected component and version, if known.
- Impact and realistic attack scenario.
- Minimal reproduction steps, avoiding access to other users' data.

Do not attempt destructive testing, data extraction, service disruption, or access to systems or information that do not belong to you.

## Secrets

If a credential or token is accidentally exposed, treat it as compromised: revoke or rotate it immediately. Removing it from the latest commit is not sufficient if it remains in Git history.
