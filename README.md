# MS2 - Minimal Viable Project

## Description

This milestone is used as the Go/no-Go for Innosuisse, as described in D0.2.
As a next step we research more privacy-preserving implementations, with the main constraint of doing the holder binding to the mobile devices. Technically
this means that the chosen algorithm must support ECDSA signatures.
The WP3 to WP6 will be done in parallel, going through the three following phases, which will also slightly overlap: research, build, verify and refine.
For M2, only the research and the build phase will be done, and then presented as a minimal viable project:
Research: start by looking at the existing solutions and their shortcomings. Then either extend the existing algorithms or create entirely new ones to solve the
problems of the specific WPs.
Build: once the research is on sound foundations, start building the proof-of-concept code to test the research. Results of the build process will also go back
into a second research effort to reduce potential problems with regard to speed, space requirements, or other restrictions detected during the build process.

The first phase will be mostly exclusively research, with only little building. This first phase is driven by C4DT with little involvement of SICPA.
In a second phase, building will take up the most time, but some research will still happen to change the algorithms according to the needs of the build
process. This phase will be a joined effort of C4DT and SICPA.

## Milestone Goals for 2026-01-07

All goals are documented in the [MS2 report](https://github.com/eid-privacy/MS2-Minimal-Viable-Project/releases/download/2026-10-22_13-38/eid_privacy-101.292-IP-ICT-ms2-report-2026-10-22_13-38.pdf).
Times and sizes are from the report, measured on a MacBook Pro, for the Noir/UltraHONK
and the Docknetwork proof-of-concepts in [zkp-pocs](https://github.com/eid-privacy/zkp-pocs).

- G3.2 The time required to create the proof of device binding is less than 1 second for the proof generation, and less than 1MB in transmission size.
  - Done: Noir 0.7s / 16kB, Docknetwork/ZKAttest 0.95s / 182kB, Longfellow ~0.08s / <300kB (from the paper) -
    report section _G3.2 - Proof of Device (Holder) Binding_, code
    [noir/c03_holder_binding](https://github.com/eid-privacy/zkp-pocs/tree/main/noir/c03_holder_binding),
    [docknetwork c03_holder_binding](https://github.com/eid-privacy/zkp-pocs/blob/main/docknetwork/tests/c03_holder_binding.rs)
- G4.2 The time required to sign and transmit a credential is less than 1 second for the proof generation, and less than 1MB in size.
  - Done: Noir 0.8s / 16kB, Docknetwork/BBS 0.01s / 1kB, Longfellow 0.47s / 291kB -
    report section _G4.2 - Proof of Credential Signing_, code
    [noir/c04_issuer_signature](https://github.com/eid-privacy/zkp-pocs/tree/main/noir/c04_issuer_signature),
    [docknetwork c04_issuer_signature](https://github.com/eid-privacy/zkp-pocs/blob/main/docknetwork/tests/c04_issuer_signature.rs)
- G5.1 The security evaluation of the subset of available libraries is available and verifiable by third parties.
  - Done: evaluation of the libraries in [WP2-Libraries](https://github.com/eid-privacy/WP2-Libraries), and of Docknetwork and Noir in the
    report sections _Frameworks used for our Proof-of-Concepts_ and _Participation in OSS Development_.
    See also the blog post
    [Choosing a Cryptographic Library for Anonymous Credentials](https://eid-privacy.github.io/wp2/2026/01/27/docknetwork-crypto-library.html)
- G5.2 The time required is less than 1 second for the proof generation, and less than 1MB in transmission size.
  - Done: Noir 0.2s / 16kB, Docknetwork/Bulletproofs 0.04s / 2kB, Longfellow 0.41s / 291kB -
    report section _G5.2 - Proof of Predicates_, code
    [noir/c05_age_verification](https://github.com/eid-privacy/zkp-pocs/tree/main/noir/c05_age_verification),
    [docknetwork c05_age_verification](https://github.com/eid-privacy/zkp-pocs/blob/main/docknetwork/tests/c05_age_verification.rs)
- G6.1 The security evaluation of the libraries relevant to revocation is available and verifiable by third parties.
  - Done: cryptographic accumulators (Docknetwork) vs. revocation lists (Swiyu / IETF token status list) in the
    report section _G6.2 - Proof of Non-Revocation_
- G6.2 The time required to prove the non-revocation, as well as the daily updates necessary, are less than 1 second for the proof generation, and less than 1MB in transmission size.
  - Done: Noir 0.8s / 16kB with a signed revocation list, Docknetwork/Accumulators 0.01s / 1kB, but expensive witness updates
    for the holders - report section _G6.2 - Proof of Non-Revocation_, code
    [noir/c06_non_revocation](https://github.com/eid-privacy/zkp-pocs/tree/main/noir/c06_non_revocation),
    [docknetwork c06_non_revocation](https://github.com/eid-privacy/zkp-pocs/blob/main/docknetwork/tests/c06_non_revocation.rs)
- G0.2 Minimum Viable Project report for MS2
  - Done: [MS2 report](https://github.com/eid-privacy/MS2-Minimal-Viable-Project/releases/download/2026-10-22_13-38/eid_privacy-101.292-IP-ICT-ms2-report-2026-10-22_13-38.pdf), sources in [./report](./report).
    Bonus: a full proof combining G3.2 to G6.2 takes 2.0s / 16kB with Noir and 1.0s / 185kB with Docknetwork:
    [noir/c09_full_proof](https://github.com/eid-privacy/zkp-pocs/tree/main/noir/c09_full_proof),
    [docknetwork c09_full_proof](https://github.com/eid-privacy/zkp-pocs/blob/main/docknetwork/tests/c09_full_proof.rs)

# G0.2 - Milestone 2 Report

The report for the Milestone 2 of the Innosuisse grant is in the subdirectory [./report](./report).
The PDF is available in the [releases](https://github.com/eid-privacy/MS2-Minimal-Viable-Project/releases), latest version: [MS2 report](https://github.com/eid-privacy/MS2-Minimal-Viable-Project/releases/download/2026-10-22_13-38/eid_privacy-101.292-IP-ICT-ms2-report-2026-10-22_13-38.pdf).

To compile, [install devbox](https://www.jetify.com/docs/devbox/installing-devbox/index),
then run:

```bash
devbox compile
```

Or use `devbox watch` to have the `index.pdf` automatically updated.
