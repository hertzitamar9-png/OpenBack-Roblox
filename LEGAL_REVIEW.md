# Roblox publication rights review

Preliminary technical licensing review, 2026-10-11. This is not a legal opinion,
a warranty of non-infringement, or approval by Roblox or the rights holders.

## Publication decision

Do not upload the existing code or assets to Roblox until the required rights
are verified. Public source on GitHub is not proof of the rights needed to grant
Roblox its platform license. The original OpenBack checkout remains unchanged.

The first native foundation now contains newly authored Luau and primitive-part
designs only, with no inherited media imported. Its hash-based bundle gate is an
engineering safeguard, not legal clearance; see [RIGHTS.md](RIGHTS.md). This
limited source implementation does not resolve rights questions for the full port.

## Findings

| Material | Existing record | Required next check |
| --- | --- | --- |
| OpenFront-derived code | AGPL-3.0 and contributor copyright notices | Review compatibility of the derivative Roblox runtime and Roblox platform terms; obtain additional permissions where required. Public source does not by itself resolve platform licensing. |
| Inherited artwork | CC BY-SA 4.0 in OpenBack's credits | Review attribution, share-alike, non-sublicensability and downstream-restriction conditions against Roblox's required rights. |
| Optional 3D models | Mixed CC0 and CC BY 3.0, per-file manifest | Check every file's provenance and license; CC0 is not a guarantee that trademark or other rights are cleared. Attribution-licensed work needs specific platform review. |
| Shop flags and maps | Multiple creators and data licenses | Audit each bundled and externally served asset, including trademarks, geographic data restrictions and third-party dependencies. |
| Fonts and music | Separate license and provenance records | Review each license and music ownership/clearance requirements; permission for general commercial use is not automatically permission to grant all Roblox rights. |
| Tank battle thumbnail | `resources/images/OpenBackSocialPreview.png` | Verify creator, source and ownership of the complete composition, including any incorporated artwork, before Roblox upload. Locating the file is not clearance. |
| OpenFront proprietary/CDN assets | Explicitly excluded by OpenBack's credits | Do not copy or redistribute them without express permission. |

OpenBack's credits also say the original source of the bitmap digit atlas is not
recorded. This review does not assume that an inherited notice independently
proves the provenance of every file. A complete file-level audit has not been
performed yet.

## Platform issue

[Roblox Creator Terms, May 19, 2026 PDF](https://en.help.roblox.com/hc/en-us/article_attachments/47741686745236),
section 2(b)(ii), require a broad perpetual license with sublicensing rights for
uploaded UGC. Section 11 requires the necessary rights to grant that license and
represents that the use will not require Roblox to obtain licenses, pay third
parties, or provide third-party attribution. These requirements create an
unresolved compatibility concern for this project's inherited licenses; this
document does not assert that every open-source license is prohibited on Roblox.

The live HTML terms page displayed a November 1, 2026 effective date during this
review, later than the review date. The linked May 19 PDF contains the relevant
sublicensing and third-party-attribution provisions; the review does not treat
the future-dated HTML header as proof that those upcoming terms already apply.

[CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/legalcode.en)
grants a non-sublicensable license, retains attribution requirements and bars
certain downstream restrictions. The code's AGPL license is retained in this
repository. Its network-source obligation and other redistribution conditions
must be preserved in any applicable derivative version.

## Conditions for proceeding with exact-content reuse

1. Build a per-file provenance and rights inventory for the proposed Roblox upload.
2. Have qualified IP/platform counsel review the applicable licenses and current
   Roblox terms. Ask Roblox for written platform clarification where needed.
3. Obtain additional written rights from the relevant rights holders if the
   current licenses do not permit the required platform grant. A single upstream
   maintainer's permission may not cover contributors or third-party assets.
4. Preserve copyright, license, contributor and asset notices, and provide the
   complete corresponding source for the derivative version as required.
5. Only after clearance, implement and test the native runtime, purchases,
   subscription entitlements, moderation and publication requirements.

If permissions cannot be obtained, exact reuse cannot be promised. On 2026-10-11,
the owner approved replacement code and assets exclusively for the Roblox version,
with the regular OpenBack version left unchanged. That approval is not additional
permission from third-party rights holders and is not a finding of legal clearance.
