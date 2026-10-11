# OpenBack Roblox

Public project repository for a proposed native Roblox version of OpenBack,
maintained for **frootz jhklphy**. Intended Roblox owner: `itapita_rules`.

## Status

This repository contains a Roblox-native foundation and early solo/duel conquest
prototype: ten original primitive-part unit designs, an original island showcase,
overhead/3D views and a safe-area-aware interface. The solo rules provide server-owned
territory capture, troop/gold income, a deterministic opponent and match outcomes.
Two-player duels pair players in the same server with shared authoritative state,
queue cancellation, separate player seats and victory when an opponent leaves.
Cross-server matchmaking and reconnect grace are not implemented. The duel logic
has automated coverage; a live two-client Studio acceptance test remains pending.
A guarded local place export succeeds. This is not the complete OpenBack port
and has not been published to Roblox. Earlier foundation-only local Studio
playtests verified initialization, both views and stop/restart. Separate engine
assertions passed for unit assembly and camera transitions/restoration/cleanup.
Automated Luau/export checks and these fixture tests do not validate full gameplay.
The preview adapts its layout and hints to PC or touch input, with mouse orbit/zoom
on desktop and two-finger orbit/pinch zoom on mobile. New responsive layout and
pinch changes have automated coverage; physical-phone gesture testing remains pending.
The solo slice also passed Studio remote-order and lifecycle assertions: malformed
and non-adjacent orders rejected, adjacent capture rendered, exit cleaned the board,
and restart reset ownership. This does not qualify multiplayer or a complete release.
Publication remains subject to [LEGAL_REVIEW.md](LEGAL_REVIEW.md).

The Roblox-only replacement direction is recorded in the
[native rebuild design](docs/superpowers/specs/2026-10-11-roblox-only-rebuild-design.md).
The [initial asset review](docs/asset-review-2026-10-11.md) identifies eight
attribution-licensed models for replacement and fourteen CC0 candidates for
further verification. The owner has approved replacements only in the Roblox
version; the regular OpenBack game remains unchanged. The owner approved the
design and first foundation implementation stage. [RIGHTS.md](RIGHTS.md) and
the per-file approval manifest distinguish newly authored source from imports;
no inherited images, meshes, maps, sounds or fonts are bundled in this stage.

The requested goal is feature and presentation parity with OpenBack, not a
simplified replacement: existing strategy gameplay, maps, units, multiplayer,
bots, tutorials, mobile controls, and 2D/3D presentation. The requested Roblox
monetization is Robux purchases of match gold and subscriptions. These are
requirements; the solo conquest slice is implemented, but the remaining systems
and monetization are not yet implemented. Full-match, multiplayer and physical-phone
release qualification remain pending.

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
