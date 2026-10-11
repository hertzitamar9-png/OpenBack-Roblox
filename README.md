# OpenBack Roblox

Public project repository for a proposed native Roblox version of OpenBack,
maintained for **frootz jhklphy**. Intended Roblox owner: `itapita_rules`.

## Status

This repository is not a playable Roblox game and contains no Roblox place,
native runtime, or uploaded game assets yet. Creating this repository does not
make the browser game compatible with Roblox or clear its rights for Roblox.
Publication is blocked pending the rights review described in [LEGAL_REVIEW.md](LEGAL_REVIEW.md).

The Roblox-only replacement direction is recorded in the
[native rebuild design](docs/superpowers/specs/2026-10-11-roblox-only-rebuild-design.md).
The [initial asset review](docs/asset-review-2026-10-11.md) identifies eight
attribution-licensed models for replacement and fourteen CC0 candidates for
further verification. The owner has approved replacements only in the Roblox
version; the regular OpenBack game remains unchanged. The written design still
needs review before its implementation plan is prepared.

The requested goal is feature and presentation parity with OpenBack, not a
simplified replacement: existing strategy gameplay, maps, units, multiplayer,
bots, tutorials, mobile controls, and 2D/3D presentation. The requested Roblox
monetization is Robux purchases of match gold and subscriptions. These are
requirements, not implemented features.

## Existing source and attribution

The unchanged browser-game baseline remains in
[OpenBack](https://github.com/hertzitamar9-png/OpenBack/tree/3e70043931e667e0c80ddafdf0b7b65925407407).
Its source and assets have not been duplicated here pending review. The browser
runtime uses TypeScript, browser graphics APIs and a Node server; Roblox requires
a native runtime implementation. Exact byte-for-byte code reuse is not a port.

OpenBack modifications by **frootz jhklphy** and contributors.
Copyright OpenFront and Contributors. OpenBack is a modified version of
OpenFrontIO, not an official release or endorsed by OpenFront Inc.

The inherited code license is AGPL-3.0; see [LICENSE](LICENSE). Any derivative
port must retain the applicable notices and provide its complete corresponding
source as required. Asset licenses are separate, not replaced by the code
license. The existing [credits](https://github.com/hertzitamar9-png/OpenBack/blob/3e70043931e667e0c80ddafdf0b7b65925407407/CREDITS.md)
and per-asset manifests remain authoritative records, not blanket Roblox clearance.
