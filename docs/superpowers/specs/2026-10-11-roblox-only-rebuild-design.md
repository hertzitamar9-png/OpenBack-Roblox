# OpenBack Roblox: isolated native rebuild

Date: 2026-10-11. Status: written design awaiting review; not implemented.
Project owner: **frootz jhklphy**. Intended Roblox account: `itapita_rules`.

## Agreed outcome and boundary

Build a native Roblox version that preserves OpenBack's strategy gameplay and
recognizable presentation as closely as possible, while replacing material whose
rights are unsuitable or unverified for Roblox. The user explicitly approved
replacements for the Roblox version only. The normal OpenBack game must not be
changed, relicensed, pruned, or republished as part of this work.

All new work belongs in this repository and checkout. The regular checkout at
`C:/Users/hertz/Documents/OpenBack` is read-only reference material. Its baseline
is commit `3e70043931e667e0c80ddafdf0b7b65925407407`. Do not import its Git history,
TypeScript implementation, maps, media, or dependencies wholesale. Do not change
its remotes or stage its untracked files.

Feature parity is the goal, not a promise of byte-identical implementation,
visuals, platform services or completed delivery. Replacing copyright-protected
material may require visible differences. Missing functionality must be reported
as missing rather than disguised by menu buttons or placeholder assets.

## Selected approach

A direct TypeScript-to-Luau translation would retain the inherited code's
obligations. A licensed port could work if additional rights are obtained, but
those permissions are not currently available. The selected engineering direction
is new native Luau modules, original Roblox-native visual assets, and independently
cleared third-party material where useful. This direction minimizes reliance on
restricted material; it is not a legal finding that the result is independent or
non-infringing. Do not describe this as a clean-room project: the developer has
already inspected the existing project. Review the resulting work and any reuse
before asserting compatible licensing.

Keep the existing AGPL license and provenance document intact. Do not replace
them with MIT or pretend inherited rights disappeared. Clearly label the scope
of any future license for newly authored work. Public GitHub availability is
separate from permission to grant Roblox's upload license.

## Decomposition

The complete conversion is larger than a single implementation project:

1. Rights/provenance inventory and isolated native foundation.
2. Playable territorial strategy and server-authoritative multiplayer.
3. Economy, construction, units, weapons, alliances and bot behavior.
4. Presentation, mobile input, notifications and scripted tutorial.
5. Durable Robux purchases, subscriptions, account progression and release tests.
6. Rights review, moderation/compliance and publication under the owner account.

Each stage needs its own acceptance evidence. Publication is not a substitute
for gameplay tests and must not happen while the runtime or rights checks remain
incomplete. Only the first stage should be expanded into the next implementation
plan; the remaining stages are parity commitments, not a preapproved untested
monolithic implementation.

## First-stage requirements

- Maintain a machine-readable asset allowlist with file hash, creator, origin,
  license/permission evidence, permitted uses and clearance status. Default deny:
  unlisted files cannot enter the Roblox upload bundle. Metadata-only audit
  records may reference the old repository without copying its assets.
- Use original procedural Roblox parts for restricted ship, plane, launcher,
  missile and building visuals; no traced reproductions of third-party meshes.
  Approved source assets can replace these only after provenance verification.
- Use newly authored maps until an independently usable source is cleared. Keep
  map names and equivalent tactical variety where rights permit; do not extract
  protected coastlines from screenshots or inherited map binaries.
- Preserve the OB brand where ownership is established. The user reports that
  ChatGPT generated the logo and tank-battle thumbnail. Record this separately
  from verified provenance. Check any uploaded reference-image inputs and third-
  party components before reusing the exact files.
- Establish a native project structure separating shared rules/data, server
  simulation, client rendering/input, and asset generation. No browser engine or
  external browser wrapper. No purchases or subscription prompts in this stage.
- Prepare original presentation assets for both overhead/2D-style and 3D camera
  views, with matching silhouettes rather than two inconsistent unit families.
- Verify the foundation inside Roblox Studio before describing it as runnable.

## Target runtime and later acceptance

The server owns territory, unit movement, construction, resources, damage and
purchase grants. Clients send bounded intents, not authoritative balances or
ownership changes. Validate intents, rate-limit them, and reject invalid state
transitions. Client view changes must not change simulation results.

The later playable version must cover conquest, resource growth, troop controls,
construction, naval transport/trade/combat, tanks, planes, interception and
missile/nuclear weapons. Solo/bots and multiplayer must each finish complete
matches. Preserve familiar menus without implying the old website accounts or
backend are Roblox accounts. Account migration is not authorized by this design.

Mobile controls must respect notches/safe areas and distinguish camera gestures
from orders. Units must face movement, display stacks once, show projectiles and
trails, and clear selection highlighting when deselected. Passive notifications
must be dismissible; requests requiring a response remain distinct. The tutorial
must use deterministic scripted opponents, actual gameplay actions, at least five
minutes of active lessons, and accessible Skip/Exit/replay controls.

Robux will buy match gold, as the user selected. Server receipt handling must be
durable and idempotent. Define how undelivered purchases survive disconnection,
defeat and match closure before activating sales. Do not grant from client events
or claim a purchase succeeded merely because the prompt closed. Prices, amounts
and subscription benefits are owner decisions to settle before monetization;
unknown values must not be invented or charged. Subscription benefits must reflect
verified entitlement and stop when entitlement ends.

## Verification and publication gates

- Check regular OpenBack's tracked diff and HEAD before/after every work batch;
  both must remain unchanged by this task.
- Test asset allowlist rejection for unknown hashes, missing permission evidence
  and explicitly denied licenses. Source-page license and local hash are evidence
  inputs, not automatic legal clearance.
- Test simulation invariants, remote-input abuse, repeated receipts, recovery,
  entitlement expiry and reconnects as relevant to each completed stage.
- Require live Studio proof of desktop/mobile input and complete matches, followed
  by multiplayer sessions; source checks alone are insufficient.
- Obtain qualified review for unresolved copyright/platform issues, especially
  any retained derived code/assets. No assurance of complete legality from a
  manifest, original-looking artwork or a public repository alone.
- Publishing requires authorized access to `itapita_rules`, the account's current
  publication eligibility and required Roblox content disclosures. Never request
  passwords or session cookies in chat. No Roblox publication has occurred.
- Every actual player-facing Roblox change must carry readable OpenBack-versioned
  release notes and credit **frootz jhklphy**. Design/audit documents are not a game
  release and must not be advertised as one.
