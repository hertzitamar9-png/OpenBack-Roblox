# Initial asset inventory and replacement decisions

Reviewed against OpenBack commit `3e70043931e667e0c80ddafdf0b7b65925407407`.
This is a metadata-only review; no game assets have been imported here.
The original game remains unchanged. Review by **frootz jhklphy**'s project.

## Bundled optional 3D models

All 22 local model SHA-256 hashes matched the existing `resources/3d/manifest.json`
on 2026-10-11. This confirms file identity, not ownership or legal clearance.
Eight are recorded as CC BY 3.0 and fourteen as CC0 1.0.

| Model | Recorded license | Roblox decision |
| --- | --- | --- |
| Transport | CC BY 3.0 | Replace with original model unless additional permission is obtained |
| Warship | CC BY 3.0 | Replace unless additional permission is obtained |
| Shell | CC BY 3.0 | Replace unless additional permission is obtained |
| SAMMissile | CC BY 3.0 | Replace unless additional permission is obtained |
| SAM Launcher | CC BY 3.0 | Replace unless additional permission is obtained |
| MIRV | CC BY 3.0 | Replace unless additional permission is obtained |
| Plane | CC BY 3.0 | Replace unless additional permission is obtained |
| Military Base | CC BY 3.0 | Replace unless additional permission is obtained |
| Port | CC0 1.0 | Candidate; verify original source and other rights before import |
| Atom Bomb | CC0 1.0 | Candidate; verify original source and other rights before import |
| Hydrogen Bomb | CC0 1.0 | Candidate; verify original source and other rights before import |
| Trade Ship | CC0 1.0 | Candidate; source page could not be retrieved in this review |
| Missile Silo | CC0 1.0 | Candidate; verify original source and other rights before import |
| Defense Post | CC0 1.0 | Candidate; verify original source and other rights before import |
| City | CC0 1.0 | Source pack page confirms CC0; verify exact pack-file provenance before import |
| MIRV Warhead | CC0 1.0 | Candidate; verify original source and other rights before import |
| Train | CC0 1.0 | Source pack page confirms CC0; verify exact pack-file provenance before import |
| Factory | CC0 1.0 | Source pack page confirms CC0; verify exact pack-file provenance before import |
| Runway | CC0 1.0 | Candidate; verify original source and other rights before import |
| MANPAD | CC0 1.0 | Candidate; verify original source and other rights before import |
| Tank | CC0 1.0 | Candidate; source page could not be retrieved in this review |
| Tank Mine | CC0 1.0 | Candidate; verify original source and other rights before import |

Verified source pack pages:

- [Kenney Train Kit](https://kenney.nl/assets/train-kit): displays CC0.
- [Kenney City Kit Industrial](https://kenney.nl/assets/city-kit-industrial): displays CC0.

The Quaternius animated-tank and ultimate-ships source pages were inaccessible
through the browsing tool. Their existing manifest entries are not promoted to
verified-source status on that basis.

## Other material

The map provenance registry has 135 entries: 133 recorded as CC BY-SA 4.0,
one as CC BY 3.0, and one as Public Domain. This is a count of registry records,
not proof that every map file or underlying datum has those rights. Original
OpenBack fictional maps can potentially be separately licensed by their owner,
but third-party contributions are not covered by one person's consent.

Do not copy the existing map binaries, shop, font atlases, sounds or image folders
wholesale. CC BY/CC BY-SA material requires additional platform-rights review;
unknown and proprietary material is excluded. New original equivalents are the
default where permissions cannot be demonstrated.

The owner reports that ChatGPT generated the OB logo and tank-battle thumbnail.
[OpenAI's Terms of Use](https://openai.com/policies/terms-of-use/) assign OpenAI's
rights in generated output to the user to the extent permitted by law, but do not
clear third-party inputs or guarantee non-infringement or copyrightability.
Record generation provenance and reference-image inputs before exact reuse.
