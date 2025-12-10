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

- G3.2 The time required to create the proof of device binding is less than 1 second for the proof generation, and less than 1MB in transmission size.
- G5.1 The security evaluation of the subset of available libraries is available and verifiable by third parties.
- G6.1 The security evaluation of the libraries relevant to revocation is available and verifiable by third parties.
- G5.2 The time required is less than 1 second for the proof generation, and less than 1MB in transmission size.
- G6.2 The time required to prove the non-revocation, as well as the daily updates necessary, are less than 1 second for the proof generation, and less than 1MB in transmission size.
- G0.2 Minimum Viable Project report for MS2
- G4.2 The time required to sign and transmit a credential is less than 1 second for the proof generation, and less than 1MB in size.

# G0.2 - Milestone 2 Report

The report for the Milestone 2 of the Innosuisse grant is in the subdirectory [./report]

To compile, [install devbox](https://www.jetify.com/docs/devbox/installing-devbox/index),
then run:

```bash
devbox compile
```

Or use `devbox watch` to have the `index.pdf` automatically updated.
