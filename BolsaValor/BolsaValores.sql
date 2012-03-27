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
	tipo varchar(60) not null
	primary key (cod)
)

CREATE INDEX ixnome ON acoes (nome)
CREATE INDEX ixabreviacao ON acoes (abreviacao)

INSERT INTO acoes values ('Acao Santo Agostinho', 'FASA', 'TIPO')
INSERT INTO acoes values ('Acao Montes Claros', 'MOC', 'TIPO')

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
	transacaoOrigem int,
	data datetime,
	primary key (cod),
	foreign key (usuario)
		references usuarios (cod),
	foreign key (acao)
		references acoes (cod),
	foreign key (transacaoOrigem)
		references transacoes (cod)
)

INSERT INTO transacoes VALUES (0, 1, 1, 2.2, 5, 0, NULL, GETDATE())
INSERT INTO transacoes VALUES (1, 2, 1, 2.5, 5, 0, 1, GETDATE())
INSERT INTO transacoes VALUES (1, 2, 1, 2.6, 5, 0, 1, GETDATE())
INSERT INTO transacoes VALUES (0, 1, 2, 3.3, 4, 0, NULL, GETDATE())
INSERT INTO transacoes VALUES (1, 2, 2, 5.1, 4, 0, 4, GETDATE())
INSERT INTO transacoes VALUES (1, 2, 2, 4.6, 4, 0, 4, GETDATE())


-- Preço medio ação Aberta(Ofertada)
CREATE VIEW PrecoMedioAcaoAberta AS 
SELECT acao, avg (oferta) AS [MEDIA DE OFERTA]
	FROM transacoes
		WHERE tipo=1 and situacao=0 and datepart(dd,data)=DATEPART(DD,GETDATE())
		GROUP BY acao			

-- Preço medio ação Fechada
CREATE VIEW PrecoMedioAcaoFechada AS 
SELECT acao, avg (oferta) AS [MEDIA DE OFERTA]
	FROM transacoes
		WHERE tipo=1 and situacao=1 and datepart(dd,data)=DATEPART(DD,GETDATE())
		GROUP BY acao			

select * from PrecoMedioAcaoFechada



-- Procedure

use bolsavalores
GO
CREATE PROCEDURE fechaLeilao (@ordeVenda int)
AS

declare @maxOferta decimal(8,2) = (select MAX(oferta) from transacoes where tipo=1 and transacaoOrigem=4 )

declare @ordeCompra int
--set @ordeCompra = (select cod from transacoes where transacaoOrigem=@ordeVenda having MAX(oferta) and MIN(DATE))
set @ordeCompra = (select min(cod) from transacoes where transacaoOrigem=@ordeVenda and oferta=@maxOferta)
				
				update transacoes set situacao=1 where cod in (@ordeVenda, @ordeCompra)
				
				declare @vendedor int
				declare @comprador int
				declare @quantidade int
				
				set @vendedor = (select usuario from transacoes where cod=@ordeVenda)
				set @comprador = (select usuario from transacoes where cod=@ordeCompra)
				declare @acao varchar
				set @acao = (select acao from transacoes where cod=@ordeCompra)
				set @quantidade =(select quantidade from transacoes where cod=@ordeVenda)
				select * from minhasacoes
				update minhasacoes 
							set quantidade=quantidade-@quantidade
								from minhasacoes 
									where usuario = @vendedor and acao=@acao
								
				update minhasacoes 
						set quantidade=quantidade+@quantidade
							where usuario=@vendedor and acao=@acao
										
select * from transacoes
select * from minhasacoes

exec fechaLeilao 3

select * from transacoes
select * from minhasacoes

