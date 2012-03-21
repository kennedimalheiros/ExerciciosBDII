CREATE DATABASE bolsavalores

USE bolsavalores

CREATE TABLE usuarios (
	cod int identity(1,1),
	nome varchar(60) not null,
	saldo decimal(8,2) not null,
	primary key (cod)
)

CREATE INDEX ixnome ON usuarios (nome)

INSERT INTO usuarios values ('Maria',233.22)
INSERT INTO usuarios values ('Isabela',3233.23)


CREATE TABLE acoes (
	cod int identity(1,1),
	nome varchar(60) not null,
	abreviacao varchar(10) not null,
	primary key (cod)
)

CREATE INDEX ixnome ON acoes (nome)
CREATE INDEX ixabreviacao ON acoes (abreviacao)

INSERT INTO acoes values ('Acao Santo Agostinho', 'FASA')
INSERT INTO acoes values ('Acao Montes Claros', 'MOC')

SELECT * FROM acoes


CREATE TABLE minhasacoes (
	usuario int not null,
	acao int not null,
	quantidade int not null,
	primary key (usuario, acao),
	foreign key (usuario)
		references usuarios (cod),
	foreign key (acao)
		references acoes (cod)
)


INSERT INTO minhasacoes values (1, 1, 22)
INSERT INTO minhasacoes values (1, 2, 3)
INSERT INTO minhasacoes values (2, 1, 11)

CREATE TABLE transacoes (
	cod int identity(1,1),
	tipo  bit not null,	
	usuario int not null,
	acao int not null,
	oferta decimal (8,2) not null,
	situacao bit not null,
	transacao_referente int,
	data datetime,
	primary key (cod),
	foreign key (usuario)
		references usuarios (cod),
	foreign key (acao)
		references acoes (cod),
	foreign key (transacao_referente)
		references transacoes (cod)
)

INSERT INTO transacoes VALUES (0, 1, 1, 2.2, 0, NULL, GETDATE())
INSERT INTO transacoes VALUES (1, 2, 1, 2.5, 0, 1, GETDATE())
INSERT INTO transacoes VALUES (1, 2, 1, 2.6, 0, 1, GETDATE())
INSERT INTO transacoes VALUES (0, 1, 2, 3.3, 0, NULL, GETDATE())
INSERT INTO transacoes VALUES (1, 2, 2, 5.1, 0, NULL, GETDATE())
INSERT INTO transacoes VALUES (1, 2, 2, 4.6, 0, NULL, GETDATE())


CREATE VIEW PrecoMedioAcao
AS
SELECT a.nome AS [NOME A��O], avg (t.oferta) AS [MEDIA DE OFERTA]
	FROM acoes AS a
		join transacoes AS t ON a.cod = t.acao
		GROUP BY a.nome
		
SELECT * FROM PrecoMedioAcao		
