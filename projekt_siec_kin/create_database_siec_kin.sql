CREATE TABLE kina (
	id SERIAL PRIMARY KEY,
	nazwa_kina varchar(30) NOT NULL,
	miejscowosc varchar(60) NOT NULL,
	ulica varchar(100),
	kod_pocztowy char(6) NOT NULL,
	data_otwarcia DATE NOT NULL,
	data_zamkniecia DATE
);

CREATE TABLE filmy(
	id SERIAL PRIMARY KEY,
	tytul_filmu varchar(300) NOT NULL,
	czas_trwania int NOT NULL, --czas trwania podany w minutach
	rok_produkcji int,
	opis_filmu text,
	obsada text,
	wersja_jezykowa char(2), -- kody języków np. PL, EN, RU itd.
	napisy_pl boolean DEFAULT true, 
	jakosc_filmu varchar(10), -- 1080p, 2160p itd.
	gatunek varchar(50),
	ograniczenia_wiekowe varchar(5), -- 7+, 12+ itd.
	koszt_licencji numeric(10, 2), 
	dostepny_od DATE NOT NULL,
	dostepny_do DATE NOT NULL	
);

CREATE TABLE klienci (
	id serial PRIMARY KEY,
	login varchar(50) NOT NULL,
	email varchar(100) NOT NULL,
	data_utworzenia DATE NOT NULL DEFAULT NOW(), 
	imie varchar(40),
	nazwisko varchar(40)
);

CREATE TABLE sale_kinowe(
	id serial PRIMARY KEY,
	nazwa_sali varchar(50) NOT NULL,
	pietro varchar(5),
	ilosc_miejsc int NOT NULL,
	jakosc_ekranu varchar(10),
	id_kina int REFERENCES kina(id) 
);

CREATE TABLE sale_kinowe_miejsca(
	id serial PRIMARY KEY,
	numer_miejsca varchar(4) NOT NULL, 
	rzad varchar(4) NOT NULL,
	id_sali int NOT NULL,
	CONSTRAINT id_sali_fkey FOREIGN KEY (id_sali)
		REFERENCES sale_kinowe(id) 
);

CREATE TABLE seanse(
	id serial PRIMARY KEY,
	id_filmu int NOT NULL REFERENCES filmy(id),
	id_sali int NOT NULL  REFERENCES sale_kinowe(id),
	data_seansu date NOT NULL,
	godzina_seansu time NOT NULL,
	cena_biletu_normalnego numeric(5,2) NOT NULL,
	cena_biletu_ulgowego numeric(5,2) NOT NULL
);

CREATE TABLE rezerwacje(
	id serial PRIMARY KEY,
	id_seansu int NOT NULL REFERENCES seanse(id),
	id_miejca int NOT NULL REFERENCES sale_kinowe_miejsca(id),
	czy_oplacona boolean DEFAULT false,
	data_zakupu date,
	godzina_zakupu time,
	miejsce_zakupu varchar(20) NOT NULL,
	id_klienta int REFERENCES klienci(id)
);