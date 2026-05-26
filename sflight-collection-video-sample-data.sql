-- Sample Data — Flight Safety Video Taxonomy v2.0
-- Follows FIAF WVMI hierarchy: Work → Variant → Manifestation
-- 5 carriers, 6 works, 12 variants, 18 manifestations

-- --------------------------------------------------------
-- CARRIERS
-- --------------------------------------------------------
INSERT INTO CARRIER (carrier_name, iata_code, icao_code, alliance, region) VALUES
('Singapore Airlines',  'SQ', 'SIA', 'Star Alliance', 'Asia-Pacific'),
('Cathay Pacific',      'CX', 'CPA', 'oneworld',      'Asia-Pacific'),
('Air Canada',          'AC', 'ACA', 'Star Alliance',  'Americas'),
('Turkish Airlines',    'TK', 'THY', 'Star Alliance',  'Europe'),
('Emirates',            'EK', 'UAE', 'Independent',    'Middle East');

-- --------------------------------------------------------
-- WORKS  [FIAF: Work level]
-- --------------------------------------------------------
INSERT INTO SAFETY_VIDEO_WORK
    (carrier_id, preferred_title, year_produced, production_style,
     regulatory_standard, content_status)
VALUES
(1, 'Singapore Airlines Safety Demo 2024',    2024, 'Live-Action', 'Multi', 'Active'),
(1, 'Singapore Airlines Safety Demo 2019',    2019, 'Celebrity',   'EASA',  'Superseded'),
(2, 'Cathay Pacific Safety Video 2024',       2024, 'Animated',    'FAA',   'Active'),
(3, 'Air Canada Safety Demonstration 2024',   2024, 'Live-Action', 'FAA',   'Active'),
(4, 'Turkish Airlines Safety Video 2023',     2023, 'CGI',         'EASA',  'Active'),
(5, 'Emirates Safety Video 2024',             2024, 'Celebrity',   'Multi', 'Active');

-- --------------------------------------------------------
-- PRODUCTION AGENTS  [FIAF: Agent relationships]
-- --------------------------------------------------------
INSERT INTO PRODUCTION_AGENT (work_id, agent_name, agent_type) VALUES
(1, 'Finch Company',              'Production Company'),
(3, 'Buck Design',                'Production Company'),
(6, 'Emirates Group Creative',    'Production Company'),
(6, 'Janet Jackson',              'Director');

-- --------------------------------------------------------
-- VARIANTS  [FIAF: Variant level — language versions]
-- --------------------------------------------------------
INSERT INTO VIDEO_VARIANT
    (work_id, spoken_language, subtitle_language, dubbed,
     duration_seconds, region_specific, audience_note)
VALUES
-- Singapore Airlines 2024 (work_id 1)
(1, 'English',  'Mandarin', FALSE, 245, FALSE, NULL),
(1, 'Mandarin', NULL,       FALSE, 245, TRUE,  'China routes'),
(1, 'Malay',    'English',  FALSE, 245, TRUE,  'Malaysia routes'),
-- Cathay Pacific 2024 (work_id 3)
(3, 'English',  'Cantonese',FALSE, 252, FALSE, NULL),
(3, 'Cantonese',NULL,       FALSE, 252, TRUE,  'HK/China routes'),
-- Air Canada 2024 (work_id 4)
(4, 'English',  'French',   FALSE, 248, FALSE, NULL),
(4, 'French',   'English',  FALSE, 248, TRUE,  'Quebec routes'),
-- Turkish Airlines 2023 (work_id 5)
(5, 'Turkish',  'English',  FALSE, 260, FALSE, NULL),
(5, 'English',  NULL,       FALSE, 258, FALSE, NULL),
-- Emirates 2024 (work_id 6)
(6, 'English',  'Arabic',   FALSE, 270, FALSE, NULL),
(6, 'Arabic',   NULL,       FALSE, 270, TRUE,  'Middle East routes');

-- --------------------------------------------------------
-- MANIFESTATIONS  [FIAF: Manifestation — OEM deliverables]
-- --------------------------------------------------------
INSERT INTO VIDEO_MANIFESTATION
    (variant_id, oem_system, version_label, cycle_lock_date, qc_status, delivery_date)
VALUES
-- SQ English variant → Panasonic and Thales
(1, 'Panasonic', 'v2.1-PAX',   '2024-01-15', 'Signed-Off', '2024-01-20'),
(1, 'Thales',    'v2.1-AVT',   '2024-01-15', 'Signed-Off', '2024-01-20'),
-- CX English variant → Thales and Collins
(4, 'Thales',    'v3.0-AVT',   '2024-03-01', 'Signed-Off', '2024-03-05'),
(4, 'Collins',   'v3.0-COL',   '2024-03-01', 'Approved',   NULL),
-- AC English variant → Panasonic
(6, 'Panasonic', 'v1.2-PAX',   '2024-02-10', 'Signed-Off', '2024-02-14'),
-- AC French variant → Panasonic
(7, 'Panasonic', 'v1.2-FR-PAX','2024-02-10', 'Signed-Off', '2024-02-14'),
-- TK Turkish variant → Thales
(8, 'Thales',    'v2.0-TR-AVT','2024-01-20', 'Signed-Off', '2024-01-24'),
-- TK English variant → Collins
(9, 'Collins',   'v2.0-EN-COL','2024-01-20', 'Pending',    NULL),
-- EK English variant → Panasonic and Thales
(10,'Panasonic', 'v4.0-PAX',   '2024-04-01', 'Signed-Off', '2024-04-05'),
(10,'Thales',    'v4.0-AVT',   '2024-04-01', 'Approved',   NULL);

-- --------------------------------------------------------
-- TECHNICAL METADATA  [FIAF: Manifestation-level tech desc]
-- --------------------------------------------------------
INSERT INTO TECHNICAL_METADATA
    (manifestation_id, file_format, video_codec, resolution,
     aspect_ratio, color_space, audio_format, audio_channels,
     file_size_mb, frame_rate)
VALUES
(1,  'MP4', 'H.264',       'HD 1080p', '16:9', 'Rec.709', 'AAC',          'Stereo',     450.00, 25.000),
(2,  'MXF', 'H.264',       'HD 1080p', '16:9', 'Rec.709', 'PCM',          'Stereo',     820.00, 25.000),
(3,  'MXF', 'H.264',       'HD 1080p', '16:9', 'Rec.709', 'PCM',          'Stereo',     870.00, 25.000),
(4,  'MP4', 'H.264',       'HD 1080p', '16:9', 'Rec.709', 'AAC',          'Stereo',     460.00, 25.000),
(5,  'MP4', 'H.264',       'HD 1080p', '16:9', 'Rec.709', 'AAC',          'Stereo',     430.00, 29.970),
(6,  'MP4', 'H.264',       'HD 1080p', '16:9', 'Rec.709', 'AAC',          'Stereo',     430.00, 29.970),
(7,  'MXF', 'H.264',       'HD 1080p', '16:9', 'Rec.709', 'PCM',          'Stereo',     760.00, 25.000),
(9,  'MP4', 'H.265/HEVC',  '4K UHD',  '16:9', 'Rec.2020','Dolby Digital', '5.1 Surround',2100.00,23.976),
(10, 'MXF', 'H.265/HEVC',  '4K UHD',  '16:9', 'Rec.2020','Dolby Digital', '5.1 Surround',3200.00,23.976);

-- --------------------------------------------------------
-- AIRCRAFT COMPATIBILITY
-- --------------------------------------------------------
INSERT INTO AIRCRAFT_COMPATIBILITY (manifestation_id, aircraft_type, cabin_class) VALUES
(1,  'Boeing 777',   'Universal'),
(1,  'Airbus A380',  'Universal'),
(1,  'Airbus A350',  'Universal'),
(3,  'Boeing 777',   'Universal'),
(3,  'Airbus A350',  'Business'),
(5,  'Boeing 787',   'Universal'),
(5,  'Airbus A220',  'Universal'),
(7,  'Airbus A330',  'Universal'),
(8,  'Boeing 737',   'Economy'),
(9,  'Airbus A380',  'Universal'),
(9,  'Boeing 777X',  'First'),
(10, 'Airbus A380',  'Universal');

-- --------------------------------------------------------
-- CONTENT RIGHTS
-- --------------------------------------------------------
INSERT INTO CONTENT_RIGHTS
    (work_id, rights_holder, distribution_scope, expiry_date, license_type, notes)
VALUES
(1, 'Singapore Airlines', 'Global', NULL,         'Regulatory-Mandated', NULL),
(2, 'Singapore Airlines', 'Global', '2021-12-31', 'Regulatory-Mandated', 'Superseded — celebrity likeness expired'),
(3, 'Cathay Pacific',     'Global', NULL,         'Regulatory-Mandated', NULL),
(4, 'Air Canada',         'Global', NULL,         'Regulatory-Mandated', NULL),
(5, 'Turkish Airlines',   'International', NULL,  'Regulatory-Mandated', NULL),
(6, 'Emirates',           'Global', NULL,         'Regulatory-Mandated', 'Celebrity: Janet Jackson — separate talent rights agreement');
