-- Trigger 1: Após a inserção de um novo veículo, registra a ação em um log.
DELIMITER $$
CREATE TRIGGER after_insert_veiculo
AFTER INSERT ON veiculo
FOR EACH ROW
BEGIN
    INSERT INTO log_veiculos (acao, descricao)
    VALUES ('Inserção de Veículo', CONCAT('Veículo ID: ', NEW.idveiculo, ' inserido em ', NOW()));
END;
$$
DELIMITER ;

-- Trigger 2: Antes da atualização de um modelo de veículo, verifica se o ano modelo é válido.
DELIMITER $$
CREATE TRIGGER before_update_modelo_veiculo
BEFORE UPDATE ON modelo_veiculo
FOR EACH ROW
BEGIN
    IF NEW.ano_modelo < YEAR(NOW()) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ano modelo inválido';
    END IF;
END;
$$
DELIMITER ;

-- Trigger 3: Após a exclusão de um motorista, registra a ação em um log.
DELIMITER $$
CREATE TRIGGER after_delete_motorista
AFTER DELETE ON motorista
FOR EACH ROW
BEGIN
    INSERT INTO log_motoristas (acao, descricao)
    VALUES ('Exclusão de Motorista', CONCAT('Motorista ID: ', OLD.idmotorista, ' excluído em ', NOW()));
END;
$$
DELIMITER ;

-- Trigger 4: Antes da atualização de um registro de entrega, verifica se a distância é maior que 0.
DELIMITER $$
CREATE TRIGGER before_update_entrega
BEFORE UPDATE ON controle_entrega_abastecimento
FOR EACH ROW
BEGIN
    IF NEW.distancia_km <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Distância inválida';
    END IF;
END;
$$
DELIMITER ;

-- Trigger 5: Após a inserção de um posto de abastecimento, registra a ação em um log.
DELIMITER $$
CREATE TRIGGER after_insert_posto_abastecimento
AFTER INSERT ON posto_abastecimento
FOR EACH ROW
BEGIN
    INSERT INTO log_postos_abastecimento (acao, descricao)
    VALUES ('Inserção de Posto de Abastecimento', CONCAT('Posto ID: ', NEW.idposto_abastecimento, ' inserido em ', NOW()));
END;
$$
DELIMITER ;

-- Trigger 6: Antes da atualização de um registro de controle de entrega, verifica se o odômetro é maior que o valor anterior.
DELIMITER $$
CREATE TRIGGER before_update_entrega_odometro
BEFORE UPDATE ON controle_entrega_abastecimento
FOR EACH ROW
BEGIN
    IF NEW.odometro_km <= OLD.odometro_km THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Odômetro inválido';
    END IF;
END;
$$
DELIMITER ;

-- Trigger 7: Após a exclusão de um fabricante de veículo, registra a ação em um log.
DELIMITER $$
CREATE TRIGGER after_delete_fabricante_veiculo
AFTER DELETE ON fabricante_veiculo
FOR EACH ROW
BEGIN
    INSERT INTO log_fabricantes_veiculo (acao, descricao)
    VALUES ('Exclusão de Fabricante de Veículo', CONCAT('Fabricante ID: ', OLD.idfabricante_veiculo, ' excluído em ', NOW()));
END;
$$
DELIMITER ;

-- Trigger 8: Antes da atualização de um registro de modelo de veículo, verifica se o tipo de veículo é válido.
DELIMITER $$
CREATE TRIGGER before_update_modelo_veiculo_tipo
BEFORE UPDATE ON modelo_veiculo
FOR EACH ROW
BEGIN
    IF NEW.tipo_veiculo NOT IN ('Sedan', 'SUV', 'Caminhão') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tipo de veículo inválido';
    END IF;
END;
$$
DELIMITER ;

-- Trigger 9: Após a inserção de um tipo de combustível, registra a ação em um log.
DELIMITER $$
CREATE TRIGGER after_insert_tipo_combustivel
AFTER INSERT ON tipo_combustivel
FOR EACH ROW
BEGIN
    INSERT INTO log_tipo_combustivel (acao, descricao)
    VALUES ('Inserção de Tipo de Combustível', CONCAT('Tipo de Combustível ID: ', NEW.idtipo_combustivel, ' inserido em ', NOW()));
END;
$$
DELIMITER ;

-- Trigger 10: Antes da exclusão de um veículo, verifica se o veículo está em uso em entregas.
DELIMITER $$
CREATE TRIGGER before_delete_veiculo_uso_entregas
BEFORE DELETE ON veiculo
FOR EACH ROW
BEGIN
    DECLARE veiculo_em_uso INT;
    SELECT COUNT(*) INTO veiculo_em_uso FROM controle_entrega_abastecimento WHERE veiculo_idveiculo = OLD.idveiculo;
    
    IF veiculo_em_uso > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Não é possível excluir o veículo, pois está em uso em entregas.';
    END IF;
END;
$$
DELIMITER ;

