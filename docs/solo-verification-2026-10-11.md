# Solo conquest prototype verification

This is incremental Roblox-only work, not a final release or publication approval.
Regular OpenBack's tracked tree and baseline commit remain unchanged.

## Evidence

- Real Luau runs cover adjacency, invalid inputs, troop costs, income, snapshot
  isolation, bounded resources, deterministic bot behavior, elimination and timeout.
- A deterministic 600-step simulation reaches a valid match outcome. This is not
  evidence of a human completing a ten-minute match inside Studio.
- Studio 0.742.0.7421053 emitted `OPENBACK_STUDIO_SOLO_PASS` at
  2026-10-11 15:50:37 UTC in the disposable verification place. Actual remotes,
  server rules and client rendering were exercised: start, invalid/malformed
  orders, adjacent capture, rendered ownership, exit cleanup and fresh restart.
- iPhone XR landscape simulation exposed HUD obstruction; the interface now
  reduces vertical space usage and camera framing accounts for both HUD bars.
- A traced simulated tap selected Territory38 with a screen ray but Territory2
  with a viewport ray. The client now uses viewport rays for world-tap events and
  screen rays for mouse events, with an automated dispatch regression test.
- Guarded production export succeeds. Disposable verification scripts are not
  mapped into the production place.

## Not yet qualified

Physical-phone multi-touch and the final touch-targeting change need further
hands-on qualification. Complete-match human playtests, multiplayer, reconnects,
construction, naval/weapon gameplay, the five-minute tutorial, purchases,
subscriptions, full presentation parity and publication remain unfinished.

Do not describe this prototype as the finished OpenBack game or activate sales.
