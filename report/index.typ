#import "@preview/dashy-todo:0.1.3": todo
#set heading(numbering: "1.")

= Introduction

This report is the G0.2 for the milestone 2 of the Innosuisse grant 101.292 IP-ICT.
It recaps the results we gained from building a Proof-of-Concept for an anonymous,
unlinkable credential which has the following capabilities:

- device/holder binding - proving that the credential is stored on a specific smartphone
- issuer signature - proving that the credential has been signed by the issuer
- predicates - proving specific attributes for equality, comparison, or revelation
- non-revocation - proving that the credential is still valid

The report starts with a summary and recap of the terms used, problems encountered, and
solutions tried.
Then it goes through the WP 3 to 6, and presents the solutions we propose.
It links to our different technical blog posts @EIDBlog, our taxonomy whitepaper @EIDTaxonomy,
and the implementations we wrote.

== Summary of Results

In @table_summary you can find the different solutions we propose in the work packages.
As every solution has their advantages and drawbacks, it is not yet clear which
ones are to be chosen.
In the second half of the grant, we will discuss with our partners which of these make
the most sense to implement.

#figure(
  table(
    columns: 4,
    table.header([Work Package], [Solution], [Time / Size], [Comments]),
    table.cell(rowspan:3)[WP3 - Device Binding], [ZKAttest], [5s / 10kB], [@zkattest-rs],
    [Noir], [0.5s / 5kB], [https://github.com/eid-privacy/WP3-Holder-Binding],
    [Longfellow], [1s / 300kB], [@FS24],

    table.cell(rowspan:3)[WP4 - Issuer Signature], [BBS], [5s / 10kB], [@zkattest-rs],
    [Noir], [0.5s / 5kB], [https://github.com/eid-privacy/WP4-Unlinkable-Anonymous-Credentials],
    [Longfellow], [1s / 300kB], [@FS24],

    table.cell(rowspan:3)[WP5 - Predicates], [BBS], [5s / 10kB], [@zkattest-rs],
    [Noir], [0.5s / 5kB], [https://github.com/eid-privacy/WP5-Predicate-Proofs],
    [Longfellow], [1s / 300kB], [@FS24],

    [WP6 - Non-Revocation], [Noir], [5s / 10kB], [https://github.com/eid-privacy/WP6-Revocation],
  ),
  caption: [Summary of our proof-of-concepts]
) <table_summary>

== Recap of Cryptography

We will use the following terms in this report, which you can find explained in
more details in our Taxonomy Paper @EIDTaxonomy.

/ One-way functions: the basic building block of asymmetric cryptography:
  functions which
  apply to two or more domains, are easy to calculate in one direction, but very
  difficult to reverse, and with homomorphic properties between the domains
/ RSA: one of the first *one-way function* used in cryptography, still widely
  used in 2025
/ Elliptic Curves: smaller than *RSA* but with the same security guarantees,
  they provide more functionality to create interesting cryptographic operations
/ Hash functions: can be used as a *one-way function*, but mostly used as an
  *oracle* to link a given message to a random, but deterministic, identifier
/ Post-quantum security: abbreviated as *PQS* or simply *PQ*, signifies that
  the given algorithm is secure, even in the presence of universal, big,
  error-free, and fast quantum computers
/ Signature: a cryptographic algorithm where the holder of a private key
  can create a proof (the signature) linked to a message. This proof can then
  be verified using the public key of the holder

== Recap of Zero-Knowledge Proofs

Throughout our work we make extensive use of Zero-Knowledge Proofs (ZKP).
In the most generic terms, a ZKP is a protocol between a *Prover*, which has
a secret *Witness*, and a *Verifier*, which wants to be sure that the
witness corresponds to an agreed-upon *Statement*, without learning
more about the witness.
An example for e-ID is a holder (prover) with their credential (witness),
which creates a *Proof* that they are aged 18 or over (statement),
to convince an internet service (verifier), without them learning the exact
age.

The challenge in ZKPs are manyfold:

/ Size of the proof: some ZKPs create proof sizes in the range of gigabytes,
  which is too big to be sent from a holder to a verifier in an e-ID
  scenario. We consider everything below 1MB to be acceptable
/ Proof creation time: depending on the algorithms, this can be sub-second or
  take many minutes. We consider everything faster than 1s to be acceptable
/ Auditability: there is little standardization of ZKPs, so optimizations are
  often only done in academic papers and rarely go through extensive
  security reviews
/ Composability: as ZKPs are very complex, it is difficult for non-expert
  software engineers to create such proofs and use them

In @table_zkp_comparison we give a short overview for the algorithms
presented in this report and how they fare for the operations used.
It is to be noted that this evaluation can greatly differ depending on the
goals for these algorithms.
Also, when writing Noir, we refer ourselves to the version 1.0.0-beta15
with the Barretenberg backend using hyper-plonk.

#figure(
  table(
    columns: 5,
    table.header([Algorithm], [Proof size], [Proof time], [Auditability], [Composability]),

    [ZKAttest], [OK], [OK], [OK], [Limited],
    [Noir], [OK], [OK..Bad], [Some], [OK],
    [Longfellow], [OK], [OK], [Some], [No],
    [BBS], [OK], [OK], [OK], [Some]
  ),
  caption: [Short comparison of algorithms used in this report]
) <table_zkp_comparison>

== Recap of Credentials

An e-ID system is based upon *Credentials* which hold the information about a user
and are signed by the issuers.
In EU and CH, but also some places in the USA, the following credential types are
used:

\ mDoc / mDL: mobile driving license credential based on ISO/IEC 18013-5:2021
\ SD-JWT: generic credential with selective disclosure capabilities

For our tests, we also used the following two credentials:

\ BBS: a special signature type which allows to create simple proofs about the
attributes of a credential
\ Flat: the simplest credential where every attribute is represented with a
fixed size in all credentials

== Recap of Needed Elements

Throughout this report we'll reference the following proofs, which need
to be valid, but which are not all proven at the same time until
work package 7.

#let Pub_holder = $"Pub"_"holder"$
#let Pub_issuer = $"Pub"_"issuer"$
#let challenge = $"Challenge"$
#let credential = $"Credential"$
#let Pr_holder = $"Pr"_"holder"$
#let Pr_sig_ch = $"Pr"_"sig"_"chal"$
#let Pr_Pub_holder = $"Pr"_"Pub"_"holder"$
#let Pr_sig_cred = $"Pr"_"sig"_"cred"$
#let Pr_predicate = $"Pr"_"predicate"$
#let Pr_non-rev = $"Pr"_"non-rev"$

/ #credential: the data stored on the mobile device of the holder containing
  various attributes and signed by the issuer
/ #Pub_holder: the public key of the secure element of the holder - needs to be
  kept secret
/ #Pub_issuer: the public key of the issuer, supposed to be known by all parties
/ #challenge: a random string sent by the verifier to avoid replay attacks.
  Is known to both the verifier and the holder.
/ #Pr_holder: ZKP that the #credential is still on the same device, composed of
  #Pr_sig_ch and #Pr_Pub_holder (@proof_device_binding)
  / #Pr_sig_ch: ZKP of a signature on the #challenge, verifiable by #Pub_holder
  / #Pr_Pub_holder: ZKP that #Pub_holder is in the #credential
/ #Pr_sig_cred: ZKP that the #credential has been signed by #Pub_issuer,
  which is publicly known (@proof_issuer_signature)
/ #Pr_predicate:ZKP that the predicate is true for #credential (@proof_predicate)
/ #Pr_non-rev: ZKP that #credential has not been revoked and is still valid
  (@proof_non_revocation)


= G3.2 - Proof of Device (Holder) Binding <proof_device_binding>

For this first work package where we created a proof-of-concept, we had to
solve the following problem:
to avoid copying of credentials from one device to another, the holder must
provide a signature created by the *Secure Element* of their mobile phone.
As it's technically very difficult to move the private key from one
secure element to another, the verifier can suppose that this signature
proves that the holder still uses the same mobile phone.
But the following two problems exist with this solution:

1. Current secure elements can only produce signatures of a specific type:
  ECDSA over P-256. Unfortunately these signatures are difficult to integrate
  in ZKPs.
2. To verify the signature, the verifier must know the public key.
  But this information is unique, and can be used to track the holder.

== Using ZKAttest / SHIELDS

SHIELDS has been developed by Ubique @SHIELDS and is based on the
ZKAttest @zkattest work by Cloudflare.
It can be used to create #Pr_holder and #Pr_sig_cred in a reasonable time
and size.
The credential used is *BBS*, and the ZKP is of the type *Sigma-Protocol*.
We presented this work in our hands-on workshop @how_eid_privacy_25 to our
partners.
We used the docknetwork-library, which we extended with the necessary
methods, to create the full proofs.

While the ZKP is easy to understand, and security audits are available for
some of the libraries, BBS is not standardized, and it is not clear if
it ever will be.
Some comments write that BBS is not proven, which is wrong, while NIST
doesn't want to standardize non-PQS algorithms #todo[Add references].

== Using Noir



== Longfellow

Time and size

== Summary

#figure(
  table(
    columns: 5,
    align:(left),
    table.header([Algorithm], [time], [size], [Pro], [Con]),
    [ZKAttest], [1s], [300kB],
      [Simple proof, understandable and verifiable with reasonable level of expertise],
      [Uses BBS, a non-standardized credential format which is not PQS]
  ),
  caption: [Summary of G3.2]
)

= G4.2 - Proof of Credential Signing <proof_issuer_signature>

== Using BBS

== Using Noir

== Longfellow

= G5.2 - Proof of Predicates <proof_predicate>

== Types of Predicates

- equality
- less / bigger
- selective disclosure

== Using BBS

== Using Noir

== Longfellow

= G6.2 - Proof of Non-Revocation <proof_non_revocation>

== Revocation Lists

- accumulators
- revocation lists

== Using Noir



= Byproducts

== Participation in OSS Development

- Docknetwork
- Noir

== Discussions and Meetings

Networking with FOITT, Ubique, ETHZ, UniBe, Human Colossus

== Hands-on Workshop


#bibliography("references.bib")
