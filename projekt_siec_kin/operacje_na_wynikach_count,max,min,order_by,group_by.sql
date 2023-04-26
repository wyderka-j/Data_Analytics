--------------------
--Operacje na wynikach - COUNT, MAX, MIN 

--zliczenie wszystkich rekordów
SELECT COUNT(*)
FROM kina;

SELECT COUNT(id)
FROM kina;

-- zwraca liczbę kin które są zamknięte
SELECT COUNT(data_zamkniecia)
FROM kina;

--zwraca liczbę otwartych kin
SELECT COUNT(*)
FROM kina
WHERE data_zamkniecia IS NULL;

--rekordy z tabeli seanse gdzie id sali jest większe od 40
SELECT COUNT(*)
FROM seanse
WHERE id_sali IN (SELECT id FROM sale_kinowe WHERE id > 40);

SELECT *
FROM seanse
WHERE id_sali IN (SELECT id FROM sale_kinowe WHERE id > 40);

--wyznaczenie sumy, średniej, wartości minimalnej i maksymalnej ceny biletu
SELECT SUM(cena_biletu_normalnego), AVG(cena_biletu_normalnego), MIN(cena_biletu_normalnego), MAX(cena_biletu_normalnego)
FROM seanse
WHERE id_sali < 20;

--zmiana cen biletów
UPDATE seanse
SET cena_biletu_normalnego = 28.00
WHERE id_sali > 40;

SELECT SUM(cena_biletu_normalnego), AVG(cena_biletu_normalnego), MIN(cena_biletu_normalnego), MAX(cena_biletu_normalnego)
FROM seanse;


-- LIMIT i OFFSET
--wyświetlenie pierszych 20 rekordów
SELECT * FROM sale_kinowe_miejsca
LIMIT 20;

--wyświetlenie kolejnych 20 rekordów
SELECT * FROM sale_kinowe_miejsca
LIMIT 20 OFFSET 20;


-- ORDER BY
--posortowanie alfabetyczne filmów
SELECT tytul_filmu, gatunek, czas_trwania 
FROM filmy
ORDER BY tytul_filmu ASC;

--posortowanie malejąco po czasie trwania filmu
SELECT tytul_filmu, gatunek, czas_trwania 
FROM filmy
ORDER BY czas_trwania DESC;

--sortowanie po kilku kolumnach
SELECT tytul_filmu, gatunek, czas_trwania 
FROM filmy
ORDER BY gatunek ASC, czas_trwania DESC;


-- GROUP BY
--wyliczenie ilości sal które posiada każde kino
SELECT k.nazwa_kina, COUNT(sk.id) AS "Ilość sal"
FROM kina k LEFT JOIN sale_kinowe sk ON k.id = sk.id_kina
GROUP BY k.nazwa_kina
ORDER BY "Ilość sal" DESC;

-- Ilość miejsc w każdej sali w kinie Helio
SELECT sk.id, COUNT (skm.id)
FROM sale_kinowe sk LEFT JOIN sale_kinowe_miejsca skm ON sk.id = skm.id_sali
WHERE sk.id_kina = (SELECT id FROM kina WHERE nazwa_kina = 'Helio')
GROUP BY sk.id;

-- Ilość miejsc w każdym kinie
SELECT k.nazwa_kina, COUNT(skm.id) AS "Ilość miejsc"
FROM kina k 
LEFT JOIN sale_kinowe sk ON k.id = sk.id_kina
LEFT JOIN sale_kinowe_miejsca skm ON sk.id = skm.id_sali
GROUP BY k.nazwa_kina;