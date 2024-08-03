USE heart_failure;

SELECT * FROM heart_failure;

--Basic patient count

SELECT COUNT(Patient_ID) AS patient_count
FROM heart_failure;

--Counting gender distribution

SELECT sex,
	COUNT(sex) AS gender_count
FROM heart_failure
GROUP BY sex;

--Counting anaemia distribution

SELECT sex,
    COUNT(anaemia) as anaemia_count
FROM heart_failure
WHERE anaemia = 1
GROUP BY sex;

--Counting high blood pressure

SELECT sex,
    COUNT(high_blood_pressure) as high_bp_count
FROM heart_failure
WHERE high_blood_pressure = 1
GROUP BY sex;

--Counting smokers per gender

SELECT sex,
    COUNT(smoking) AS smoker
FROM heart_failure
WHERE smoking = 1
GROUP BY sex;

--Counting diabetes per gender

SELECT	sex,
    COUNT(diabetes) AS diabetic
FROM heart_failure
WHERE diabetes = 1
GROUP BY sex;

-- --Counting deaths per gender

SELECT	sex,
    COUNT(DEATH_EVENT) as deaths
FROM heart_failure
WHERE DEATH_EVENT = 1
GROUP BY sex;

--Using window functions and an aggregate count to find age trends

SELECT
    age,
    COUNT(*) AS age_count,
    ROUND(AVG(platelets),2) AS avg_platelet_count,
    ROUND(AVG(serum_creatinine),2) AS avg_creatine,
    ROUND(AVG(serum_sodium),2) AS avg_sodium,
    ROUND(AVG(ejection_fraction),2) AS avg_ejec_frac,
    ROUND(AVG(age) OVER(),2) AS avg_age,
    MIN(age) OVER() AS min_age,
    MAX(age) OVER() AS max_age
FROM heart_failure
GROUP BY age
ORDER BY age_count DESC, age DESC;

--Use a CTE to create bins of ages

WITH age_bin AS (
    SELECT
        Patient_ID,
        CASE
            WHEN age >= 40 AND age < 46 THEN '40-45'
            WHEN age >= 46 AND age < 51 THEN '46-50'
            WHEN age >= 51 AND age < 56 THEN '51-55'
            WHEN age >= 56 AND age < 61 THEN '56-60'
            WHEN age >= 61 AND age < 66 THEN '61-65'
            WHEN age >= 66 AND age < 71 THEN '66-70'
            WHEN age >= 71 AND age < 76 THEN '71-75'
            WHEN age >= 76 AND age < 81 THEN '76-80'
            WHEN age >= 81 AND age < 86 THEN '81-85'
            WHEN age >= 86 AND age < 91 THEN '86-90'
            WHEN age >= 91 AND age < 96 THEN '91-95'
        END AS age_bin
FROM heart_failure
)
--Selecting averages and sums of all applicable attributes across each bin
SELECT
    age_bin,
    COUNT(*) AS age_count,
    ROUND(AVG(platelets),2) AS avg_platelet_count,
    ROUND(AVG(serum_creatinine),2) AS avg_serum_creatine,
    ROUND(AVG(serum_sodium),2) AS avg_serum_sodium,
    ROUND(AVG(ejection_fraction),2) AS avg_ejec_frac,
    ROUND(AVG(creatinine_phosphokinase),2) AS avg_creatine_phos,
    SUM(smoking) AS smoking_count,
    SUM(diabetes) AS diabetic_count,
    SUM(anaemia) AS anaemia_count,
    SUM(high_blood_pressure) AS high_bp_count,
    SUM(DEATH_EVENT) AS deaths
FROM heart_failure
JOIN
    age_bin ON heart_failure.Patient_ID = age_bin.Patient_ID
GROUP BY age_bin
ORDER BY age_bin;

