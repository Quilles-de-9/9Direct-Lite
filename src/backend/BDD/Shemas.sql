CREATE TABLE categories (
  id smallint PRIMARY KEY,
  nom varchar(50) NOT NULL
);

CREATE TABLE clubs (
  id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nom varchar(150) NOT NULL,
  abbreviation varchar(15),
  date_creation timestamptz NOT NULL DEFAULT now(),
  note smallint CHECK (note >= 0 AND note <= 100)
);

CREATE TABLE joueurs (
  id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nom varchar(120) NOT NULL,
  prenom varchar(120) NOT NULL,
  date_naissance date,
  club_id integer REFERENCES clubs(id) ON DELETE SET NULL,
  categorie_id smallint NOT NULL REFERENCES categories(id)
);

CREATE TABLE tirs (
  id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  date_debut timestamptz NOT NULL,
  date_fin timestamptz,
  lieu varchar(200)
);

CREATE INDEX idx_tirs_date_debut ON tirs(date_debut);

CREATE TABLE resultats (
  id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  joueur_id integer NOT NULL REFERENCES joueurs(id) ON DELETE CASCADE,
  tir_id integer NOT NULL REFERENCES tirs(id) ON DELETE CASCADE,
  date_saisie timestamptz NOT NULL DEFAULT now(),
  total_7 integer,
  total_12 integer,
  CONSTRAINT resultats_unicite_joueur_tir UNIQUE (joueur_id, tir_id),
  CONSTRAINT total_7_nonneg CHECK (total_7 IS NULL OR total_7 >= 0),
  CONSTRAINT total_12_nonneg CHECK (total_12 IS NULL OR total_12 >= 0)
);

CREATE INDEX idx_resultats_joueur ON resultats(joueur_id);
CREATE INDEX idx_resultats_tir ON resultats(tir_id);
