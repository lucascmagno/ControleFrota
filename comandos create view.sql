-- View 1: Visualização dos veículos disponíveis
CREATE VIEW veiculos_disponiveis AS
SELECT v.idveiculo, v.modelo_veiculo_idmodelo_veiculo, v.cor, v.num_portas
FROM veiculo v
WHERE NOT EXISTS (
    SELECT 1
    FROM controle_entrega_abastecimento c
    WHERE c.veiculo_idveiculo = v.idveiculo
);

-- View 2: Visualização dos motoristas com CNH
CREATE VIEW motoristas_com_cnh AS
SELECT m.idmotorista, m.nome_motorista, m.data_nascimento
FROM motorista m
WHERE m.cnh IS NOT NULL;

-- View 3: Visualização dos postos de abastecimento por bandeira
CREATE VIEW postos_por_bandeira AS
SELECT p.bandeira, COUNT(*) AS quantidade
FROM posto_abastecimento p
GROUP BY p.bandeira;

-- View 4: Visualização das cidades com mais motoristas
CREATE VIEW cidades_com_mais_motoristas AS
SELECT c.desc_cidade, COUNT(m.idmotorista) AS quantidade_motoristas
FROM cidade c
LEFT JOIN motorista m ON c.idcidade = m.idbairro_cid_uf
GROUP BY c.desc_cidade
ORDER BY quantidade_motoristas DESC;

-- View 5: Visualização dos modelos de veículo e seus fabricantes
CREATE VIEW modelos_e_fabricantes AS
SELECT m.nome_modelo, f.nome_fabricante
FROM modelo_veiculo m
JOIN fabricante_veiculo f ON m.fabricante_veiculo_idfabricante_veiculo = f.idfabricante_veiculo;

-- View 6: Visualização dos tipos de combustível disponíveis
CREATE VIEW tipos_de_combustivel AS
SELECT DISTINCT tc.nome_combustivel
FROM veiculo_tipo_combustivel vtc
JOIN tipo_combustivel tc ON vtc.combustivel_idtipo_combustivel = tc.idtipo_combustivel;

-- View 7: Visualização dos estados com mais cidades
CREATE VIEW estados_com_mais_cidades AS
SELECT e.desc_estado, COUNT(c.idcidade) AS quantidade_cidades
FROM estado e
LEFT JOIN cidade c ON e.idestado = c.estado_idestado
GROUP BY e.desc_estado
ORDER BY quantidade_cidades DESC;

-- View 8: Visualização dos postos de abastecimento com maior número de abastecimentos
CREATE VIEW postos_com_mais_abastecimentos AS
SELECT pa.nome_posto_abastecimento, COUNT(cea.idcontrole_entrega_abastecimento) AS quantidade_abastecimentos
FROM posto_abastecimento pa
LEFT JOIN controle_entrega_abastecimento cea ON pa.idposto_abastecimento = cea.idposto_abastecimento
GROUP BY pa.nome_posto_abastecimento
ORDER BY quantidade_abastecimentos DESC;

-- View 9: Visualização dos bairros e cidades
CREATE VIEW bairros_e_cidades AS
SELECT bcu.desc_bairro, c.desc_cidade, e.desc_estado
FROM bairro_cid_uf bcu
JOIN cidade c ON bcu.cidade_idcidade = c.idcidade
JOIN estado e ON c.estado_idestado = e.idestado;

-- View 10: Visualização das entregas com informações de veículo e motorista
CREATE VIEW entregas_com_info AS
SELECT cea.idcontrole_entrega_abastecimento, m.nome_motorista, v.modelo_veiculo_idmodelo_veiculo, cea.data_hora_saida
FROM controle_entrega_abastecimento cea
JOIN motorista m ON cea.motorista_idmotorista = m.idmotorista
JOIN veiculo v ON cea.veiculo_idveiculo = v.idveiculo;
