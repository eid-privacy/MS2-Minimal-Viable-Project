= Introduction

Present the 4 goals
Other work done: participating in OSS projects, support implementation of Tom256 in docknetwork
Link to relevant blog posts


== Summary

Create table with the different goals, proposed solutions, and measurements.

== Recap of Cryptography

One-way functions: RSA, Elliptic Curves
Hash functions?
Post-quantum security: don't inverse the one-way functions, use other algorithms

== Recap of ZKPs

Sigma-proof based: only limited operations, might be slow
Circuit-based: universal ZKPs, but slow
Optimization goals: blockchains want short verifier times, eID wants short prover times
Setup: can be slow and/or produce toxic waste

== Recap of Credentials

SD-JWT - used by everybody, but not prepared for any ZKP operation
BBS(+) - privacy-preserving presentation of attributes, but using non-standard ant not PQS cryptography

= G3.2 - Proof of Device (Holder) Binding

Recap of the problem: TEEs only have ECDSA, public key cannot be divulged, BBS is not accepted.

== Using ZKAttest

Copy from hands-on-workshop
Time and size

== Using Noir

Time and size

== Longfellow

Time and size

= G4.2 - Proof of Credential Signing


= G5.2 - Proof of Predicates


= G6.2 - Proof of Non-Revocation


= Byproducts

== Participation in OSS Development

- Docknetwork
- Noir

== Discussions and Meetings

Networking with FOITT, Ubique, ETHZ, UniBe, Human Colossus

== Hands-on Workshop
