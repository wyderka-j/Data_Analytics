--wyświetlenie wszystkich informacji z tabeli
SELECT * FROM filmy;

SELECT * FROM kina;

SELECT * FROM sale_kinowe;

SELECT * FROM seanse;

--wybrane kolumny z tabeli
SELECT nazwa_sali, ilosc_miejsc FROM sale_kinowe;

SELECT data_seansu, godzina_seansu, cena_biletu_normalnego, cena_biletu_ulgowego FROM seanse;

--zmiana wyświetlanej nazwy kolumny
SELECT nazwa_sali AS "Nazwa sali", ilosc_miejsc AS "Ilość miejsc" FROM sale_kinowe;


--wyświetlenie wszystkich informacji o sali numer 30
SELECT * FROM sale_kinowe_miejsca
WHERE id_sali = 30;

--wszystkie seanse które mają identyfikator filmu równy 1
SELECT * FROM seanse
WHERE id_filmu = 1;

-- wybrane informacje o seansach dla filmu o id = 2
SELECT id_sali, data_seansu, godzina_seansu, cena_biletu_normalnego
FROM seanse
WHERE id_filmu = 2;

--wszystkie seanse z ceną biletu mniejszą niż 25
SELECT * FROM seanse
WHERE cena_biletu_normalnego < 25.00;

--wszystkie seanse gdzie data seansu jest późniejsza niż 2021-08-03
SELECT * FROM seanse
WHERE data_seansu > '2021-08-03';

--wszystkie tytuły filmów z gatunku komiedia
SELECT tytul_filmu, gatunek FROM filmy
WHERE gatunek = 'KOMEDIA';

--wszystkie informacje o filmach w których gra Hanks
SELECT * FROM filmy 
WHERE obsada LIKE '%Hanks%';

--tylko tytuły i daty dostępności filmów
SELECT tytul_filmu, dostepny_od, dostepny_do
FROM filmy;

--tylko tytuły i daty dostępności filmów, podanym przedziale czasowym
SELECT tytul_filmu, dostepny_od, dostepny_do
FROM filmy
WHERE dostepny_od BETWEEN '2021-04-01' AND '2021-07-01';

--wszystkie kina które są otwarte
SELECT * FROM kina
WHERE data_zamkniecia IS NULL;

--wszystkie kina które są zamknięte
SELECT * FROM kina
WHERE data_zamkniecia IS NOT NULL;

--kilka warunków
--wszystkie kina z Krakowa, działające w 2019
SELECT * FROM kina
WHERE miejscowosc = 'Kraków' AND data_otwarcia < '2019-12-31' AND (data_zamkniecia IS NULL OR data_zamkniecia > '2019-12-31');

--wszystkie filmy dostępne w maju 2021
SELECT tytul_filmu, dostepny_od, dostepny_do
FROM filmy
WHERE dostepny_od < '2021-05-01' AND dostepny_do > '2021-05-31';


---------------------------------------------------
--Podzapytania
--wyszukanie kin w Warszawie
SELECT * FROM kina WHERE miejscowosc = 'Warszawa';

--wyszukanie identyfikatorów sal w wybranym kinie
SELECT id FROM sale_kinowe WHERE id_kina = 9;

--wyszukanie informacji o seansach w wybranym wcześniej kinie
SELECT * FROM seanse WHERE data_seansu = '2021-08-01' AND id_sali IN (73,74,75,76,77,78,79,80,81);


--zapytanie z podzapytaniami
SELECT id_filmu, data_seansu, godzina_seansu, cena_biletu_normalnego, cena_biletu_ulgowego FROM seanse WHERE data_seansu = '2021-08-01' AND id_sali IN (
	SELECT id FROM sale_kinowe WHERE id_kina IN (
		SELECT id FROM kina WHERE miejscowosc = 'Warszawa')
);



----------------------------------------
-- Wyszukiwanie po wielu tabelach - JOIN

--wyszukanie wszystkich informacji o salach kinowych
SELECT * 
FROM sale_kinowe JOIN kina
ON sale_kinowe.id_kina = kina.id;

--wyszukanie wybranych informacji o salach kinowych
SELECT sk.nazwa_sali, sk.pietro, sk.ilosc_miejsc, k.nazwa_kina, k.miejscowosc
FROM sale_kinowe sk JOIN kina k
ON sk.id_kina = k.id;

--wyszukanie określonych informacji dla wybranego kina
SELECT sk.nazwa_sali, sk.pietro, sk.ilosc_miejsc, k.nazwa_kina, k.miejscowosc
FROM sale_kinowe sk JOIN kina k
ON sk.id_kina = k.id
WHERE k.nazwa_kina = 'Helio';


-- Repertuar kina Helio w Łodzi na dzień 01-08-2021
SELECT f.tytul_filmu, f.czas_trwania, s.data_seansu, s.godzina_seansu, s.cena_biletu_normalnego, 
		s.cena_biletu_ulgowego, f.wersja_jezykowa, sk.nazwa_sali, sk.pietro  
FROM seanse s
JOIN filmy f ON s.id_filmu=f.id
JOIN sale_kinowe sk ON sk.id = s.id_sali
WHERE s.data_seansu = '2021-08-01'
	AND sk.id_kina IN (SELECT id FROM kina WHERE nazwa_kina = 'Helio');

