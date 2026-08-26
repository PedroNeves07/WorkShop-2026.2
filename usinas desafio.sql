
-- ==================== 1. CRIAR AS TABELAS ====================

-- Tabela REGIOES
CREATE TABLE REGIOES (
    id_regiao       INT PRIMARY KEY AUTO_INCREMENT,
    nome            VARCHAR(50)  NOT NULL,
    estado          VARCHAR(2)   NOT NULL,
    potencial       VARCHAR(20)  NOT NULL   -- Alto / Médio / Baixo
);

-- Tabela USINAS (chave estrangeira para REGIOES)
CREATE TABLE USINAS (
    id_usina        INT PRIMARY KEY AUTO_INCREMENT,
    nome            VARCHAR(50)  NOT NULL,
    tipo            VARCHAR(20)  NOT NULL,   -- Solar / Eólica / Hídrica
    capacidade_mw   DECIMAL(6,2) NOT NULL,
    id_regiao       INT NOT NULL,
    FOREIGN KEY (id_regiao) REFERENCES REGIOES(id_regiao)
);

-- Tabela GERACAO (chave estrangeira para USINAS)
CREATE TABLE GERACAO (
    id_geracao      INT PRIMARY KEY AUTO_INCREMENT,
    id_usina        INT NOT NULL,
    data_geracao    DATE NOT NULL,
    energia_mwh     DECIMAL(8,2) NOT NULL,
    FOREIGN KEY (id_usina) REFERENCES USINAS(id_usina)
);

-- ==================== 2. INSERIR DADOS ====================

-- 10 regiões
INSERT INTO REGIOES (nome, estado, potencial) VALUES
('Sertão Central', 'CE', 'Alto'),
('Litoral Sul', 'RS', 'Médio'),
('Vale do São Francisco', 'BA', 'Alto'),
('Planalto Central', 'GO', 'Médio'),
('Baixada Fluminense', 'RJ', 'Baixo'),
('Chapada Diamantina', 'BA', 'Alto'),
('Serra Gaúcha', 'RS', 'Médio'),
('Agreste Nordestino', 'PE', 'Alto'),
('Pantanal', 'MS', 'Baixo'),
('Amazônia Legal', 'PA', 'Médio');

-- 12 usinas
INSERT INTO USINAS (nome, tipo, capacidade_mw, id_regiao) VALUES
('Usina Sol Nascente', 'Solar', 150.00, 1),
('Usina Vento Forte', 'Eólica', 200.00, 2),
('Usina Rio Claro', 'Hídrica', 300.00, 3),
('Usina Cerrado Verde', 'Solar', 120.00, 4),
('Usina Baía Azul', 'Eólica', 90.00, 5),
('Usina Diamante', 'Solar', 180.00, 6),
('Usina Pampa Norte', 'Eólica', 210.00, 7),
('Usina Agreste Luz', 'Solar', 160.00, 8),
('Usina Pantanal Águas', 'Hídrica', 250.00, 9),
('Usina Amazônia Clara', 'Hídrica', 280.00, 10),
('Usina Sertão Ventos', 'Eólica', 175.00, 1),
('Usina Bahia Solar', 'Solar', 140.00, 3);

-- 15 registros de geração
INSERT INTO GERACAO (id_usina, data_geracao, energia_mwh) VALUES
(1, '2026-01-05', 320.50),
(2, '2026-01-05', 410.00),
(3, '2026-01-05', 600.75),
(4, '2026-01-06', 250.00),
(5, '2026-01-06', 180.30),
(6, '2026-01-06', 355.20),
(7, '2026-01-07', 420.00),
(8, '2026-01-07', 300.10),
(9, '2026-01-07', 480.60),
(10, '2026-01-08', 510.00),
(11, '2026-01-08', 330.40),
(12, '2026-01-08', 275.90),
(1, '2026-01-09', 340.00),
(3, '2026-01-09', 615.25),
(9, '2026-01-09', 470.00);

-- ==================== 4. EXECUTAR CONSULTAS ====================

-- 4.1 UPDATE: reajustar capacidade das usinas solares em 5%
UPDATE USINAS
SET capacidade_mw = capacidade_mw * 1.05
WHERE tipo = 'Solar';

-- 4.2 DELETE (exemplo alternativo, comentado — mantenha apenas um dos dois):
-- DELETE FROM GERACAO WHERE energia_mwh < 100;

-- 4.3 SELECT simples: listar todas as usinas eólicas
SELECT nome, capacidade_mw
FROM USINAS
WHERE tipo = 'Eólica';

-- 4.4 Funções agregadas (3 exemplos)
SELECT SUM(energia_mwh) AS total_gerado FROM GERACAO;
SELECT AVG(capacidade_mw) AS capacidade_media FROM USINAS;
SELECT COUNT(*) AS total_usinas FROM USINAS;

-- 4.5 GROUP BY e HAVING: usinas com geração total acima de 600 MWh
SELECT u.nome, SUM(g.energia_mwh) AS total_gerado
FROM USINAS u
JOIN GERACAO g ON u.id_usina = g.id_usina
GROUP BY u.nome
HAVING SUM(g.energia_mwh) > 600;

-- 4.6 JOIN entre tabelas: geração com nome da usina e da região
SELECT g.data_geracao, u.nome AS usina, r.nome AS regiao, g.energia_mwh
FROM GERACAO g
JOIN USINAS u ON g.id_usina = u.id_usina
JOIN REGIOES r ON u.id_regiao = r.id_regiao
ORDER BY g.data_geracao;

-- ==================== DESAFIO BÔNUS ====================
-- Região com a maior geração total de energia
SELECT r.nome AS regiao, SUM(g.energia_mwh) AS total_gerado
FROM REGIOES r
JOIN USINAS u ON r.id_regiao = u.id_regiao
JOIN GERACAO g ON u.id_usina = g.id_usina
GROUP BY r.nome
ORDER BY total_gerado DESC
LIMIT 1;
