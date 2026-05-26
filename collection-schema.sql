-- ============================================================
-- Flight Safety Video Taxonomy — Schema v2.0
-- Kelsey Kiantoro | MS Information Science, Pratt Institute 2026
--
-- FIAF WVMI Hierarchy Applied:
--   WORK         → SAFETY_VIDEO_WORK     (conceptual work per carrier)
--   VARIANT      → VIDEO_VARIANT         (language/audience versions)
--   MANIFESTATION→ VIDEO_MANIFESTATION   (OEM-specific technical versions)
--   ITEM         → QC tracking via qc_status on manifestation
--
-- Reference: FIAF Moving Image Cataloguing Manual (2016)
--            International Federation of Film Archives
-- ============================================================


-- ------------------------------------------------------------
-- CARRIER
-- Airline operator. One carrier has many safety video works.
-- ------------------------------------------------------------

CREATE TABLE CARRIER (
    carrier_id      INT             NOT NULL AUTO_INCREMENT,
    carrier_name    VARCHAR(100)    NOT NULL,
    iata_code       CHAR(2)         NOT NULL,
    icao_code       CHAR(3)         NOT NULL,
    alliance        ENUM('Star Alliance', 'oneworld', 'SkyTeam', 'Independent')
                                    NOT NULL DEFAULT 'Independent',
    region          ENUM('Asia-Pacific', 'Europe', 'Americas', 'Middle East', 'Africa')
                                    NOT NULL,
    PRIMARY KEY (carrier_id),
    UNIQUE KEY uq_iata (iata_code),
    UNIQUE KEY uq_icao (icao_code)
);


-- ------------------------------------------------------------
-- SAFETY_VIDEO_WORK  [FIAF: Work level]
-- The conceptual work. One entry per safety video concept
-- regardless of language version or technical format.
-- Equivalent to FIAF Work: the intellectual creation.
-- ------------------------------------------------------------

CREATE TABLE SAFETY_VIDEO_WORK (
    work_id             INT             NOT NULL AUTO_INCREMENT,
    carrier_id          INT             NOT NULL,
    preferred_title     VARCHAR(200)    NOT NULL,
    year_produced       YEAR            NOT NULL,
    production_style    ENUM('Live-Action', 'Animated', 'Celebrity', 'Hybrid', 'CGI')
                                        NOT NULL,
    regulatory_standard ENUM('FAA', 'EASA', 'CAAC', 'DGCA', 'Multi')
                                        NOT NULL,
    content_status      ENUM('Active', 'Superseded', 'Archived')
                                        NOT NULL DEFAULT 'Active',
    isan                VARCHAR(26)     NULL COMMENT 'International Standard Audiovisual Number',
    notes               TEXT            NULL,
    PRIMARY KEY (work_id),
    FOREIGN KEY (carrier_id) REFERENCES CARRIER(carrier_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);


-- ------------------------------------------------------------
-- PRODUCTION_AGENT  [FIAF: Agent relationship at Work level]
-- Production company and key crew linked to the work.
-- FIAF 1.4.1: Agents include cast, credits, organisations.
-- ------------------------------------------------------------

CREATE TABLE PRODUCTION_AGENT (
    agent_id        INT             NOT NULL AUTO_INCREMENT,
    work_id         INT             NOT NULL,
    agent_name      VARCHAR(200)    NOT NULL,
    agent_type      ENUM('Production Company', 'Director', 'Broadcaster', 'Distributor')
                                    NOT NULL,
    PRIMARY KEY (agent_id),
    FOREIGN KEY (work_id) REFERENCES SAFETY_VIDEO_WORK(work_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);


-- ------------------------------------------------------------
-- VIDEO_VARIANT  [FIAF: Variant level]
-- A version of the work adapted for a specific language,
-- audience, or aircraft type. FIAF Variant = a version
-- with different language, dubbed/subtitled, or edited content.
-- Duration may differ per variant (subtitled vs dubbed).
-- ------------------------------------------------------------

CREATE TABLE VIDEO_VARIANT (
    variant_id          INT             NOT NULL AUTO_INCREMENT,
    work_id             INT             NOT NULL,
    variant_title       VARCHAR(200)    NULL COMMENT 'If different from work preferred title',
    spoken_language     VARCHAR(50)     NOT NULL,
    subtitle_language   VARCHAR(50)     NULL,
    dubbed              BOOLEAN         NOT NULL DEFAULT FALSE,
    duration_seconds    INT             NOT NULL,
    region_specific     BOOLEAN         NOT NULL DEFAULT FALSE,
    audience_note       VARCHAR(200)    NULL COMMENT 'e.g. Business Class version, short cut',
    PRIMARY KEY (variant_id),
    FOREIGN KEY (work_id) REFERENCES SAFETY_VIDEO_WORK(work_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);


-- ------------------------------------------------------------
-- VIDEO_MANIFESTATION  [FIAF: Manifestation level]
-- The technical embodiment of a variant for a specific OEM
-- system. FIAF Manifestation = the format in which the work
-- is available, including all analogue, digital, and online media.
-- One variant may have multiple manifestations (one per OEM).
-- cycle_lock_date and qc_status operate at this level
-- because QC is performed per OEM deliverable.
-- ------------------------------------------------------------

CREATE TABLE VIDEO_MANIFESTATION (
    manifestation_id    INT             NOT NULL AUTO_INCREMENT,
    variant_id          INT             NOT NULL,
    oem_system          ENUM('Panasonic', 'Thales', 'Collins', 'Safran', 'Other')
                                        NOT NULL,
    version_label       VARCHAR(50)     NOT NULL COMMENT 'e.g. v2.1, NLC-2024-03',
    cycle_lock_date     DATE            NULL COMMENT 'NLC deadline for this OEM deliverable',
    qc_status           ENUM('Pending', 'Approved', 'Failed', 'Signed-Off')
                                        NOT NULL DEFAULT 'Pending',
    delivery_date       DATE            NULL,
    PRIMARY KEY (manifestation_id),
    FOREIGN KEY (variant_id) REFERENCES VIDEO_VARIANT(variant_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);


-- ------------------------------------------------------------
-- TECHNICAL_METADATA  [FIAF: Manifestation-level technical desc]
-- Technical specifications per OEM manifestation.
-- FIAF Manual references: aspect ratio, format, sound,
-- duration, colour, and other technical attributes
-- documented at the Manifestation level.
-- IFE-specific: codec and container requirements differ
-- per OEM system (Panasonic: MP4/H.264, Thales: MXF/H.264).
-- ------------------------------------------------------------

CREATE TABLE TECHNICAL_METADATA (
    tech_id             INT             NOT NULL AUTO_INCREMENT,
    manifestation_id    INT             NOT NULL,
    file_format         ENUM('MP4', 'MOV', 'MXF', 'AVI', 'Other')
                                        NOT NULL,
    video_codec         ENUM('H.264', 'H.265/HEVC', 'MPEG-2', 'ProRes', 'Other')
                                        NOT NULL,
    resolution          ENUM('SD', 'HD 720p', 'HD 1080p', '4K UHD')
                                        NOT NULL,
    aspect_ratio        ENUM('16:9', '4:3', '21:9', 'Other')
                                        NOT NULL DEFAULT '16:9'
                                        COMMENT 'Critical for seat screen compatibility',
    color_space         ENUM('Rec.709', 'Rec.2020', 'sRGB', 'Other')
                                        NOT NULL DEFAULT 'Rec.709',
    audio_format        ENUM('AAC', 'MP3', 'PCM', 'Dolby Digital', 'Other')
                                        NOT NULL,
    audio_channels      ENUM('Mono', 'Stereo', '5.1 Surround', 'Other')
                                        NOT NULL DEFAULT 'Stereo',
    file_size_mb        DECIMAL(8,2)    NULL,
    frame_rate          DECIMAL(5,3)    NULL COMMENT 'e.g. 23.976, 25.0, 29.97',
    PRIMARY KEY (tech_id),
    UNIQUE KEY uq_manifestation (manifestation_id),
    FOREIGN KEY (manifestation_id) REFERENCES VIDEO_MANIFESTATION(manifestation_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);


-- ------------------------------------------------------------
-- AIRCRAFT_COMPATIBILITY
-- Aircraft types and cabin classes linked to a manifestation.
-- Linked at manifestation level because OEM determines
-- which aircraft types a specific file version serves.
-- ------------------------------------------------------------

CREATE TABLE AIRCRAFT_COMPATIBILITY (
    compat_id       INT             NOT NULL AUTO_INCREMENT,
    manifestation_id INT            NOT NULL,
    aircraft_type   VARCHAR(50)     NOT NULL COMMENT 'e.g. Boeing 777, Airbus A380',
    cabin_class     ENUM('Economy', 'Business', 'First', 'Universal')
                                    NOT NULL DEFAULT 'Universal',
    PRIMARY KEY (compat_id),
    FOREIGN KEY (manifestation_id) REFERENCES VIDEO_MANIFESTATION(manifestation_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);


-- ------------------------------------------------------------
-- CONTENT_RIGHTS
-- Rights and licensing at the Work level.
-- Safety videos are typically Regulatory-Mandated,
-- but some carriers use licensed music or celebrity talent
-- that require additional rights tracking.
-- ------------------------------------------------------------

CREATE TABLE CONTENT_RIGHTS (
    rights_id           INT             NOT NULL AUTO_INCREMENT,
    work_id             INT             NOT NULL,
    rights_holder       VARCHAR(200)    NOT NULL,
    distribution_scope  ENUM('Domestic', 'International', 'Global')
                                        NOT NULL DEFAULT 'Global',
    expiry_date         DATE            NULL,
    license_type        ENUM('Exclusive', 'Non-Exclusive', 'Regulatory-Mandated')
                                        NOT NULL,
    notes               TEXT            NULL COMMENT 'e.g. celebrity likeness rights, music licensing',
    PRIMARY KEY (rights_id),
    FOREIGN KEY (work_id) REFERENCES SAFETY_VIDEO_WORK(work_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);
