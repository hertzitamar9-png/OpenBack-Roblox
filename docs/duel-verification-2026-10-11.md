# Duel prototype verification

OpenBack v0.35.2, created by **frootz jhklphy**.

The Roblox-only slice adds same-server two-player queueing and shared authoritative
conquest. Regular OpenBack is not modified. This is not a finished port.

Real Luau tests cover duplicate queue rejection, queue cancellation, seat-specific
orders, shared ownership, snapshot isolation, absence of bot actions in duels,
independent solo matches, departure victory, empty-match cleanup and replay to solo.
The full local suite passed: 33 tests passed, one Windows file-symlink fixture
skipped because the host denies creation; the directory-junction fixture ran.

A fresh-context read-only review found that action broadcasts updated unrelated
sessions. A failing test demonstrated missing session-specific recipients; the fix
routes action updates only to affected members. The whole suite passed afterward.

Deferred review minors: initial foundation header still mentions solo only;
finished-duel-to-new-duel lifecycle deserves an additional focused test.

Live two-client RemoteEvent, HUD/input, departure and restart acceptance remains
pending. Physical-phone gestures, full strategy systems, reconnect grace,
cross-server matching, monetization and publication qualification are not proven.
Source approval hashes are technical bundle checks, not legal clearance.
Upstream published release checked through GitHub: v0.34.24; this slice stays on
OpenBack's v0.35 patch series.
