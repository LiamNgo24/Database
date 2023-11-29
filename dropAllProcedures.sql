DELIMITER $$

CREATE PROCEDURE DropProcedures()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE drop_command VARCHAR(255);
    DECLARE cur CURSOR FOR 
        SELECT CONCAT('DROP PROCEDURE IF EXISTS `', routine_name, '`;') 
        FROM information_schema.routines 
        WHERE routine_type = 'PROCEDURE' 
        AND routine_schema = 'REPMS'; -- replace with your database name
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO drop_command;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SET @s = drop_command;
        PREPARE stmt FROM @s;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END LOOP;

    CLOSE cur;
END$$

DELIMITER ;
