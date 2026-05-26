# Flight Safety Video Taxonomy

A normalized relational database schema for cataloging and managing airline flight safety video metadata — designed for inflight entertainment (IFE) operations.

Built to apply metadata schema design, controlled vocabulary, audiovisual cataloguing standards, and content rights tracking to the highest-priority content type in the IFE media cycle.

---

## Why This Exists

Airline safety videos are the highest-stakes content in an IFE system. They are regulatory-mandated, OEM-specific, multilingual, and version-sensitive. A single metadata error — wrong locale, wrong OEM format, wrong aircraft type — can cause content to fail to load or display incorrectly on the aircraft. Wrong metadata on a safety video is not a search problem. It is a compliance problem.

This schema addresses that: a queryable, governed structure that captures every dimension a metadata specialist needs to manage safety video content across carriers, OEM systems, language variants, and regulatory environments.

---

## FIAF WVMI Hierarchy Applied

The schema follows the **FIAF Moving Image Cataloguing Manual (2016)** Work/Variant/Manifestation/Item (WVMI) hierarchy, adapted for the IFE operational context.

| FIAF Level | This Schema | IFE Meaning |
|---|---|---|
| **Work** | `SAFETY_VIDEO_WORK` | The conceptual safety video (e.g., "Singapore Airlines Safety Video 2024") |
| **Variant** | `VIDEO_VARIANT` | Language/audience version (English spoken, Mandarin dubbed, Business Class cut) |
| **Manifestation** | `VIDEO_MANIFESTATION` | OEM-specific technical deliverable (Panasonic MP4, Thales MXF) |
| **Item** | QC tracked via `qc_status` | Specific file instance — signed-off and ready for cycle load |

This hierarchy solves a core IFE metadata problem: one safety video concept generates multiple deliverables per OEM per language. Without the WVMI structure, those deliverables collapse into a flat list with no queryable relationship between them.

---

## Schema — 7 Tables

```
CARRIER                  Airline operator
SAFETY_VIDEO_WORK        Work level — conceptual video per carrier
PRODUCTION_AGENT         Agent relationships (production company, director)
VIDEO_VARIANT            Variant level — language and audience versions
VIDEO_MANIFESTATION      Manifestation level — OEM-specific deliverables
TECHNICAL_METADATA       Technical specs per manifestation (codec, aspect ratio, audio)
AIRCRAFT_COMPATIBILITY   Aircraft types served by each manifestation
CONTENT_RIGHTS           Licensing and rights at work level
```

---

## Technical Metadata — Why It Matters in IFE

OEM systems have different format requirements. A file that plays correctly on Panasonic Avionics will not necessarily load on Thales AVANT or Collins Aerospace without re-encoding. The `TECHNICAL_METADATA` table captures the specification per manifestation:

| Field | Why It Matters |
|---|---|
| `file_format` | MP4 (Panasonic), MXF (Thales/Collins) — OEM-dependent |
| `video_codec` | H.264 standard across most; H.265 for newer 4K-capable systems |
| `aspect_ratio` | 16:9 standard; 4:3 still required for older narrowbody seat screens |
| `audio_channels` | Mono for economy headrests; stereo/5.1 for premium cabins |
| `frame_rate` | 25fps (PAL markets), 29.97fps (NTSC/US markets), 23.976fps (global) |

---

## IFE-Specific Fields

Three fields were added beyond a standard DAM schema to reflect IFE operational reality:

| Field | Table | Purpose |
|---|---|---|
| `cycle_lock_date` | `VIDEO_MANIFESTATION` | NLC deadline — the date metadata and files must be locked for aircraft load |
| `qc_status` | `VIDEO_MANIFESTATION` | QC gate per OEM deliverable — Pending → Approved → Signed-Off |
| `content_status` | `SAFETY_VIDEO_WORK` | Active / Superseded / Archived — version control across carrier refresh cycles |

---

## OEM Systems Referenced

- **Panasonic Avionics** — most widely deployed commercial IFE system globally
- **Thales AVANT / AVANT Up** — Air France, Qatar Airways, Air India
- **Collins Aerospace** — commercial and business aviation
- **Safran** — narrowbody fleet specialist

---

## Regulatory Standards Referenced

| Code | Body | Jurisdiction |
|---|---|---|
| FAA | Federal Aviation Administration | United States |
| EASA | European Union Aviation Safety Agency | Europe |
| CAAC | Civil Aviation Administration of China | China |
| DGCA | Directorate General of Civil Aviation | Indonesia, India |
| Multi | Multiple standards in one video | Global carriers |

---

## Files

| File | Contents |
|---|---|
| `schema.sql` | Full CREATE TABLE statements with constraints, ENUMs, and FIAF annotations |
| `sample_data.sql` | Sample records across 5 carriers, 3 OEM systems |
| `erd.png` | Entity relationship diagram |

---

## Standards Referenced

- FIAF Moving Image Cataloguing Manual (2016), International Federation of Film Archives
- FIAF Work/Variant/Manifestation/Item (WVMI) hierarchy
- ISAN — International Standard Audiovisual Number (optional identifier field)

---

## Author

Kelsey Kiantoro
MS Information Science, Pratt Institute 2026
kelseykiano.framer.website | github.com/kianoding
