DROP DATABASE IF EXISTS medical_center;

CREATE DATABASE medical_center;

\c medical_center

-- Physicians table
CREATE TABLE physicians
(
    physician_id SERIAL PRIMARY KEY
    , first_name TEXT NOT NULL
    , last_name TEXT NOT NULL
);

INSERT INTO physicians
    (first_name, last_name)
VALUES
    ('Emmett', 'Brown')
    , ('Otto', 'Octavius');

-- Patients table
CREATE TABLE patients
(
    patient_id SERIAL PRIMARY KEY
    , first_name TEXT NOT NULL
    , last_name TEXT NOT NULL
);

INSERT INTO patients
    (first_name, last_name)
VALUES
    ('Marty', 'McFly')
    , ('Peter', 'Parker');

-- Visits
CREATE TABLE visits
(
    encounter_id SERIAL PRIMARY KEY
    , encounter_date DATE
    , physician_id INT
    , patient_id INT
    , CONSTRAINT fk_physician_id
        FOREIGN KEY(physician_id)
        REFERENCES physicians(physician_id)
    , CONSTRAINT fk_patient_id
        FOREIGN KEY(patient_id)
        REFERENCES patients(patient_id)
);

INSERT INTO visits
    (encounter_date, physician_id, patient_id)
VALUES
    ('2024-03-01', 1, 1)
    , ('2024-03-02', 2, 1)
    , ('2024-03-06', 2, 2);

-- Diseases
CREATE TABLE diseases
(
    disease_id SERIAL PRIMARY KEY
    , icd_version INT
    , code_value TEXT NOT NULL
    , code_desc TEXT NOT NULL
);

INSERT INTO diseases
    (icd_version, code_value, code_desc)
VALUES
    (9, '401.1', 'Primary Hypertension')
    , (10, 'I10', 'Primary Hypertension')
    , (10, 'W56.01', 'Bitten by Dolphin');

-- Diagnosis events
CREATE TABLE diagnoses
(
    diagnosis_id SERIAL PRIMARY KEY
    , encounter_id INT
    , disease_id INT
    , CONSTRAINT fk_encounter_id
        FOREIGN KEY(encounter_id)
        REFERENCES visits(encounter_id)
    , CONSTRAINT fk_disease_id
        FOREIGN KEY(disease_id)
        REFERENCES diseases(disease_id)
);

INSERT INTO diagnoses
    (encounter_id, disease_id)
VALUES
    (1, 1)
    , (2, 3)
    , (3, 2)
    , (3, 3);

/*
select
	a.encounter_id
	, a.encounter_date 
	, b.first_name || ' ' || b.last_name as physician_full_name 
	, c.first_name || ' ' || c.last_name as patient_full_name
	, e.icd_version
	, e.code_value
	, e.code_desc
from 
	visits a 
inner join 
	physicians b
	on a.physician_id = b.physician_id 
inner join 
	patients c
	on a.patient_id = c.patient_id
inner join 
	diagnoses d
	on a.encounter_id = d.encounter_id
inner join 
	diseases e
	on d.disease_id = e.disease_id;
*/