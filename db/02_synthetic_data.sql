-- hospital_kota_malang
UPDATE public.hospital_kota_malang
SET 
    -- 1. Standardize Address Info
    addr_city = COALESCE(addr_city, 'Kota Malang'),
    addr_stree = COALESCE(addr_stree, 'Jalan Raya Malang No. ' || floor(random() * 100 + 1)::text),
    addr_postc = COALESCE(addr_postc, (65100 + floor(random() * 50 + 10))::text), -- Random Malang Postcodes

    -- 2. Critical Facilities (Assume yes for hospitals if null)
    emergency = COALESCE(emergency, 'yes'),
    wheelchair = COALESCE(wheelchair, 'yes'),

    -- 3. Infer Operator based on Name
    operator = COALESCE(operator, 
        CASE 
            WHEN name ILIKE '%RSUD%' OR name ILIKE '%Puskesmas%' THEN 'Pemerintah Kota Malang'
            WHEN name ILIKE '%Islam%' THEN 'Yayasan Rumah Sakit Islam Malang'
            WHEN name ILIKE '%Muhammadiyah%' THEN 'Persyarikatan Muhammadiyah'
            ELSE 'PT. Kesehatan Malang Sejahtera'
        END),

    -- 4. Generate Synthetic Contacts
    email = COALESCE(email, 'admin@' || lower(regexp_replace(name, '\s+', '', 'g')) || '.co.id')
WHERE 
    addr_city IS NULL OR emergency IS NULL OR operator IS NULL;


-- school_kota_malang
UPDATE public.school_kota_malang
SET 
    -- 1. Standardize Location
    "addr:city" = COALESCE("addr:city", 'Kota Malang'),
    "addr:province" = COALESCE("addr:province", 'Jawa Timur'),
    "addr:postcode" = COALESCE("addr:postcode", (65100 + floor(random() * 50 + 10))::text),
    "addr:street" = COALESCE("addr:street", 'Jalan Pendidikan No. ' || floor(random() * 200 + 1)::text),

    -- 2. Infer School Type (Jenjang) from Name
    "school:type_idn" = COALESCE("school:type_idn", 
        CASE 
            WHEN name ILIKE '%SD%' OR name ILIKE '%MI%' THEN 'sekolah dasar'
            WHEN name ILIKE '%SMP%' OR name ILIKE '%MTS%' THEN 'sekolah menengah pertama'
            WHEN name ILIKE '%SMA%' OR name ILIKE '%SMK%' OR name ILIKE '%MA%' THEN 'sekolah menengah atas'
            WHEN name ILIKE '%TK%' OR name ILIKE '%PAUD%' THEN 'taman kanak-kanak'
            ELSE 'sekolah umum'
        END),

    -- 3. Infer Operator (Public vs Private)
    operator = COALESCE(operator, 
        CASE 
            WHEN name ILIKE '%Negeri%' THEN 'Dinas Pendidikan Kota Malang'
            WHEN name ILIKE '%Katolik%' THEN 'Yayasan Pendidikan Katolik'
            WHEN name ILIKE '%Kristen%' THEN 'Yayasan Pendidikan Kristen'
            WHEN name ILIKE '%Muhammadiyah%' THEN 'Majelis Dikdasmen Muhammadiyah'
            ELSE 'Yayasan Pendidikan Swasta'
        END),

    -- 4. Generate Synthetic Phone Numbers (Malang Area Code 0341)
    phone = COALESCE(phone, '(0341) ' || floor(random() * (599999-400000) + 400000)::text),

    -- 5. Generate Synthetic Website
    website = COALESCE(website, 'https://' || lower(regexp_replace(name, '[^a-zA-Z]', '', 'g')) || '.sch.id')

WHERE 
    "addr:city" IS NULL OR operator IS NULL OR phone IS NULL;

-- cleanup geometries with SRID 0
UPDATE public.hospital_kota_malang SET geom = ST_SetSRID(geom, 4326) WHERE ST_SRID(geom) = 0;
UPDATE public.school_kota_malang SET geom = ST_SetSRID(geom, 4326) WHERE ST_SRID(geom) = 0;