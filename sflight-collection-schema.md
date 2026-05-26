---
title: "Flight Safety Video Taxonomy — Schema v2.0"
---
erDiagram
    CARRIER {
        INT carrier_id PK
        VARCHAR carrier_name
        CHAR iata_code UK
        CHAR icao_code UK
        ENUM alliance "Star Alliance | oneworld | SkyTeam | Independent"
        ENUM region "Asia-Pacific | Europe | Americas | Middle East | Africa"
    }

    SAFETY_VIDEO_WORK {
        INT work_id PK
        INT carrier_id FK
        VARCHAR preferred_title
        YEAR year_produced
        ENUM production_style "Live-Action | Animated | Celebrity | Hybrid | CGI"
        ENUM regulatory_standard "FAA | EASA | CAAC | DGCA | Multi"
        ENUM content_status "Active | Superseded | Archived"
        VARCHAR isan "International Standard Audiovisual Number"
        TEXT notes
    }

    PRODUCTION_AGENT {
        INT agent_id PK
        INT work_id FK
        VARCHAR agent_name
        ENUM agent_type "Production Company | Director | Broadcaster | Distributor"
    }

    VIDEO_VARIANT {
        INT variant_id PK
        INT work_id FK
        VARCHAR variant_title "If different from work preferred title"
        VARCHAR spoken_language
        VARCHAR subtitle_language
        BOOLEAN dubbed
        INT duration_seconds
        BOOLEAN region_specific
        VARCHAR audience_note "e.g. Business Class version"
    }

    VIDEO_MANIFESTATION {
        INT manifestation_id PK
        INT variant_id FK
        ENUM oem_system "Panasonic | Thales | Collins | Safran | Other"
        VARCHAR version_label "e.g. v2.1 NLC-2024-03"
        DATE cycle_lock_date "NLC deadline for this OEM deliverable"
        ENUM qc_status "Pending | Approved | Failed | Signed-Off"
        DATE delivery_date
    }

    TECHNICAL_METADATA {
        INT tech_id PK
        INT manifestation_id FK "UK"
        ENUM file_format "MP4 | MOV | MXF | AVI | Other"
        ENUM video_codec "H.264 | H.265-HEVC | MPEG-2 | ProRes | Other"
        ENUM resolution "SD | HD 720p | HD 1080p | 4K UHD"
        ENUM aspect_ratio "16:9 | 4:3 | 21:9 | Other"
        ENUM color_space "Rec.709 | Rec.2020 | sRGB | Other"
        ENUM audio_format "AAC | MP3 | PCM | Dolby Digital | Other"
        ENUM audio_channels "Mono | Stereo | 5.1 Surround | Other"
        DECIMAL file_size_mb
        DECIMAL frame_rate "e.g. 23.976 25.0 29.97"
    }

    AIRCRAFT_COMPATIBILITY {
        INT compat_id PK
        INT manifestation_id FK
        VARCHAR aircraft_type "e.g. Boeing 777 Airbus A380"
        ENUM cabin_class "Economy | Business | First | Universal"
    }

    CONTENT_RIGHTS {
        INT rights_id PK
        INT work_id FK
        VARCHAR rights_holder
        ENUM distribution_scope "Domestic | International | Global"
        DATE expiry_date
        ENUM license_type "Exclusive | Non-Exclusive | Regulatory-Mandated"
        TEXT notes "e.g. celebrity likeness rights"
    }

    %% ── FIAF WVMI Hierarchy ──
    %% WORK level
    CARRIER ||--o{ SAFETY_VIDEO_WORK : "operates"
    SAFETY_VIDEO_WORK ||--o{ PRODUCTION_AGENT : "produced by"
    SAFETY_VIDEO_WORK ||--o{ CONTENT_RIGHTS : "licensed under"

    %% VARIANT level
    SAFETY_VIDEO_WORK ||--o{ VIDEO_VARIANT : "has versions"

    %% MANIFESTATION level
    VIDEO_VARIANT ||--o{ VIDEO_MANIFESTATION : "delivered as"
    VIDEO_MANIFESTATION ||--|| TECHNICAL_METADATA : "specified by"
    VIDEO_MANIFESTATION ||--o{ AIRCRAFT_COMPATIBILITY : "compatible with"
