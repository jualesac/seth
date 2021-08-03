/*
 * FECHA: 2020/09/06
 * AUTOR: Julio Alejandro Santos Corona
 * CORREO: jualesac@yahoo.com
 * TÍTULO: permiso.sql
 *
 * Descripción: permiso.sql
*/

DROP PROCEDURE IF EXISTS permiso;

DELIMITER //

/*CREATE PROCEDURE permiso(IIDUSUARIO INT(11), RRUTA VARCHAR(200), VERBO VARCHAR(6)) /*En caso de utilizar el idUsuario*/
CREATE PROCEDURE permiso(USSUARIO VARCHAR(7), RRUTA VARCHAR(200), VERBO VARCHAR(6))
permiso:BEGIN
    DECLARE IIDFUNCION INT(11) DEFAULT 0;
    DECLARE UURL VARCHAR(200) DEFAULT "";
    DECLARE GGET TINYINT(1) DEFAULT 0;
    DECLARE PPOST TINYINT(1) DEFAULT 0;
    DECLARE PPUT TINYINT(1) DEFAULT 0;
    DECLARE DDELETE TINYINT(1) DEFAULT 0;
    DECLARE BBLOQUEO TINYINT(1) DEFAULT 0;
    DECLARE EESTATUS TINYINT(1) DEFAULT 1;

    DECLARE MMAPA CURSOR FOR (
        SELECT
        `idFuncion`,
        `ruta`,
        `get`,
        `post`,
        `put`,
        `delete`,
        `bloqueo`,
        `estatus`
        FROM `mapa`
        WHERE
        /*`idUsuario` = IIDUSUARIO /*Activar si se va a utilizar el idUsuario*/
        `usuario` = BINARY(USSUARIO)
        AND REGEXP_REPLACE(RRUTA, "/$", "") REGEXP(`ruta`)
        ORDER BY `ruta` DESC
        LIMIT 1
    );
    DECLARE EXIT HANDLER FOR NOT FOUND
    BEGIN
        SELECT 403 AS state, "Usuario no localizado o punto de acceso desconocido." AS message;
    END;

    OPEN MMAPA;
        FETCH MMAPA INTO IIDFUNCION, UURL, GGET, PPOST, PPUT, DDELETE, BBLOQUEO, EESTATUS;
    CLOSE MMAPA;

    /*-- VALIDACIONES --*/
    IF (BBLOQUEO = 1 AND EESTATUS = 1) THEN
        SELECT 403 AS state, "Permiso denegado." AS message;
        LEAVE permiso;
    END IF;

    IF(REGEXP_REPLACE(RRUTA, "/$", "") NOT REGEXP CONCAT(UURL, "$") AND EESTATUS = 1) THEN
        SELECT 200 AS state, "Permiso no requerido." AS message;
        LEAVE permiso;
    END IF;

    IF(EESTATUS = 0) THEN
        SELECT 503 AS state, "Recurso deshabilitado." AS message;
        LEAVE permiso;
    END IF;

    IF((VERBO = "GET" AND GGET = 0) OR (VERBO = "POST" AND PPOST = 0) OR (VERBO = "PUT" AND PPUT = 0) OR (VERBO = "DELETE" AND DDELETE = 0)) THEN
        SELECT 403 AS state, "Permiso denegado." AS message;
        LEAVE permiso;
    END IF;

    SELECT 200 AS state, "Permitido." AS message;
END; //

DELIMITER ;
