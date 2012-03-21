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
	quantidade int not null,
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

INSERT INTO transacoes VALUES (0, 1, 1, 2.2, 5, 0, NULL, GETDATE())
INSERT INTO transacoes VALUES (1, 2, 1, 2.5, 5, 0, 1, GETDATE())
INSERT INTO transacoes VALUES (1, 2, 1, 2.6, 5, 0, 1, GETDATE())
INSERT INTO transacoes VALUES (0, 1, 2, 3.3, 4, 0, NULL, GETDATE())
INSERT INTO transacoes VALUES (1, 2, 2, 5.1, 4, 0, 4, GETDATE())
INSERT INTO transacoes VALUES (1, 2, 2, 4.6, 4, 0, 4, GETDATE())


GO
CREATE VIEW PrecoMedioAcao AS 
SELECT a.nome AS [NOME AÇÃO], avg (t.oferta) AS [MEDIA DE OFERTA]
	FROM acoes AS a
		join transacoes AS t ON a.cod = t.acao
		GROUP BY a.nome		
		
SELECT * FROM minhasacoes	



-- Procedure

use bolsavalores
GO
CREATE PROCEDURE MelhorOrdemCompra (@Transacao_Referente int, @CodAcao int,@Quantidade int, @CodVendedor int)
AS

declare @CodTransacao int
declare @MaiorOferta int 
declare @CodComprador int


--Pegando maior Oferta
set @MaiorOferta = (select oferta=MAX(oferta) from transacoes where tipo=1 and transacao_referente=@transacao_referente)

-- Cod Transação de maior Oferta
set @CodTransacao = 3

--AJUDA COMO PEDO O COD DA TRANSAÇÃO TA DANTO ERRO AKI
--set @CodTransacao = (SELECT cod
--					from transacoes 
--						where tipo=1 and transacao_referente=@transacao_referente and oferta=@MaiorOferta
--						GROUP BY cod)



--Fechando Situação da Compra x Venda
update transacoes set situacao=1 where cod=@CodTransacao

--Decrementaando quantidade de ações vendedor
set @CodComprador = (select usuario from transacoes where cod=@CodTransacao)

update minhasacoes set quantidade=quantidade-@Quantidade where  usuario=@CodVendedor and acao=@CodAcao
update minhasacoes set quantidade=quantidade+@Quantidade where  usuario=@CodComprador and acao=@CodAcao




SELECT * from transacoes
SELECT * from minhasacoes

drop procedure MelhorOrdemCompra

go
exec  MelhorOrdemCompra 1,1,5,1

