# DVSA Vulnerability Discovery and Remediation

**Course:** ICS-344 Information Security — Term 252
**Student:** Abdullah Almarhoun (202017980)
**DVSA URL:** http://dvsa-website
**API Gateway:** https://
**Region:** us-east-1

---

## Repository Structure

## Repository Structure

```
dvsa_project/
├── README.md                          ← this file
├── report/
│   └── DVSA_Security_Audit_Report.md  ← 7-lesson report
├── commands/
│   ├── L1_event_injection.sh
│   ├── L2_jwt_forgery.sh
│   ├── L3_sensitive_data_exposure.sh
│   ├── L4_idor.sh
│   ├── L5_verbose_errors.sh
│   ├── L6_dos_flood.sh
│   ├── L7_overprivileged.sh
├── fixes/
│   ├── L1_event_injection_fix.js
│   ├── L2_jwt_verification_fix.js
│   ├── L3_receipt_ownership_fix.js
│   ├── L4_idor_ownership_fix.js
│   ├── L5_error_handling_fix.js
│   ├── L6_dos_throttle_config.json
│   ├── L7_least_privilege_policy.json
├── screenshots/
│   └── README.md                     
└── slides/
    ├── 12_slide_outline.md
    └── DVSA_Presentation.pptx
```

---

## How to Reproduce

### 1. Read the report

`report/DVSA_Security_Audit_Report.md` is the main deliverable. It 7 official lessons in the required 10-part format (Goal → Root Cause → Setup → Reproduction → Evidence → Fix Strategy → Code Changes → Verification → Structured Analysis → Takeaway).




## Important Notes

- **DVSA is intentionally vulnerable.** Every step in this project assumes a non-production AWS account. None of these techniques should be used outside the controlled lab environment.

---

