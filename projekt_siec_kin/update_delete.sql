--Update

--Aktualizacja wszystkich rekordów w tabeli, zmiana ceny biletu ulgowego
UPDATE seanse
SET cena_biletu_ulgowego = 10.00;


-- Aktualizacja tylko rekordów dla filmu o id = 3
UPDATE seanse
SET cena_biletu_ulgowego = 12.00
WHERE id_filmu = 3;


-- Modyfikacja kilku wartości
UPDATE seanse
SET cena_biletu_normalnego = 21.00,
	cena_biletu_ulgowego = 15.00,
	godzina_seansu = '13:00'
WHERE id_sali = 1;


UPDATE seanse
SET godzina_seansu = '20:00'
WHERE data_seansu > '2021-08-10';


-- Modyfikacja dla kilku warunków
UPDATE seanse
SET cena_biletu_normalnego = 30.00,
	cena_biletu_ulgowego = 28.00
WHERE id_filmu = 4 AND id_sali < 30;


UPDATE seanse
SET cena_biletu_normalnego = 50.00,
	cena_biletu_ulgowego = 45.00
WHERE id_filmu = 8 OR id_sali = 1;


-- Delete

-- wszystkie rekordy z tabeli sale_kinowe_miejsca dla których id_sali jest równa 80
DELETE FROM sale_kinowe_miejsca
WHERE id_sali = 80;

--wszystkie rekordy dla sali o identyfikatorze 1
DELETE FROM sale_kinowe_miejsca
WHERE id_sali = 1;


--wszystkie seanse dla sali o id=1
DELETE FROM seanse
WHERE id_sali = 1;


-- usunięcie sali o id=1
DELETE FROM sale_kinowe
WHERE id = 1;


-- usuwanięcie seansów dla których id_filmu = 1 i cena biletu normalnego jest większa od 20
DELETE FROM seanse
WHERE id_filmu = 1 AND cena_biletu_normalnego > 20;




