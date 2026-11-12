# People of Bengaluru — mirror

A byte-for-byte copy of https://peopleofbengaluru.com (a walkable low-poly 3D Bengaluru where every character is a
real designer or builder), mirrored on 2026-11-12 so it can be studied and customised.

The original is a Next.js 16 (Turbopack) app on Vercel, rendered with three.js + @react-three/fiber, with Supabase
for people profiles and sign-in. Its source is not public, so this repo holds the **built** site, not the project
source. See "What is and isn't here" below before planning changes.

## Run it

```powershell
. ..\use-node.ps1          # portable Node from the parent folder (or any Node 18+)
node scripts/serve.mjs     # http://localhost:4178/
```

Any static file server works (`npx serve site`, GitHub Pages, Vercel static, Netlify). The whole site is one page.

## Layout

| Path | What |
|---|---|
| `site/` | The mirrored site, served as-is. `index.html` + `_next/static/immutable/` (JS chunks, CSS, 12 woff2 fonts) |
| `site/models/characters/*.glb` | 13 rigged character models (designer, founder, developer, investor, maker, pm, …) + `robot.glb` |
| `site/audio/sfx/` | 15 footstep sounds (concrete / grass / wood × 5) |
| `site/icon.svg`, `manifest.webmanifest`, `opengraph-image.png` | PWA + share assets |
| `src-readable/` | The same JS/CSS run through Prettier so it can be read and searched. **Not loaded by the site**: edit `site/_next/.../chunks/*.js` for a live change, or port from here |
| `scripts/serve.mjs` | Zero-dependency static server |
| `scripts/mirror.sh` | Re-download the live site (Git Bash). Chunk names change on every upstream deploy |

Key files in `src-readable/`:

- `035vmpn0sfakj.js` (66k lines) — the app: three.js, R3F, the whole city generator (buildings, roads, trees,
  metro line, portal to HSR Layout), player controls, NPCs, profile cards, "become visible" flow, find-someone
  search, HUD. Search for `ENTER KORAMANGALA`, `homeDistrict`, `footstep_`, `from("profiles")`.
- `1i7q061u1g5kn.js` — Supabase JS client + the client config (`createClient(url, publishable key)` near line 10397).
- `2iy3a65sm0q88.css` / `1hz6dor36dd5j.css` — all styles (Barlow / Barlow Condensed / Noto Sans Kannada fonts).

## What is and isn't here

The city, characters, controls, UI and styling are complete and run offline. Three things live outside the bundle:

1. **People data** comes live from the original's Supabase project (public read on table `profiles`). The clone
   therefore shows *their* people until you point it at your own database. The 12 built-in demo people in
   the bundle (search `ANANYA RAO`) are used when the database is unreachable.
2. **Sign-in / "Become visible"** uses Supabase magic-link auth plus server routes that are not downloadable:
   `/api/apply/submit`, `/api/apply/checkout`, `/api/apply/confirm`, `/api/invite/redeem`. These will 404 on the
   mirror. Re-create them (Next.js route handlers, or any backend) when you need them.
3. **Google Analytics** tag `G-EEGWQWP5NM` in `site/index.html` reports to the original owner — remove or replace it.

Profile row shape, as the app writes it (`profiles` table):

```
id (auth user id), name ≤40, role ≤60, company ≤60, location (Koramangala | HSR Layout | …),
building ≤80, previously ≤80, open_to_work bool, skills text[] ≤6, portfolio, linkedin, x,
character (designer|founder|developer|investor|maker|pm|rockstar|creative|hero|moonshot|adventurer_f|formal_f|swat_m),
spot (named spawn spot in the district), note_text, note_emoji, note_expires_at
```
Other tables touched: `app_settings` (key `application_fee`), `applications` (status, reason, user_id),
`member_settings` (user_id, emails).

## Customising

Quick wins without a rebuild (edit the minified file in `site/`, or make the edit in `src-readable/` and copy the
relevant string):

- Texts, city name, button labels: plain strings in `035vmpn0sfakj.js` (`"ENTER KORAMANGALA ▸"`, `"EARLY ACCESS"`,
  the hero copy) and the `<title>` / meta tags in `site/index.html`.
- Your own Supabase: replace the URL + publishable key in `1i7q061u1g5kn.js` (one line) and create the tables above.
- Characters: drop new `.glb` files (same rig/animation names) into `site/models/characters/` and map them in the
  character list in `035vmpn0sfakj.js`.
- Colours and fonts: the two CSS files.

For anything structural (new districts, new mechanics) the realistic path is a fresh Next.js + R3F project that
uses `src-readable/` as the reference and `site/models`, `site/audio` and the CSS as assets.

## Credit and rights

Design, code, models and copy belong to the makers of peopleofbengaluru.com. This mirror is for personal study and
as a starting point; replace their branding, people data and assets before publishing anything derived from it.
