/*
 * FECHA: 2020/08/27
 * AUTOR: Julio Alejandro Santos Corona
 * CORREO: jualesac@yahoo.com
 * TÍTULO: obtenerMenu.sql
 *
 * Descripción: Procedimiento que obtiene los menus activos para el usuario
*/

DROP PROCEDURE IF EXISTS obtenerMenu;

DELIMITER //

/*CREATE PROCEDURE obtenerMenu(IIDUSUARIO INT(11)) /*Utilizar si se utilizará el idUsuario*/
CREATE PROCEDURE obtenerMenu(USSUARIO VARCHAR(7))
BEGIN
    SELECT DISTINCT
    `apps`.`idApp`,
    `apps`.`nombre`,
    `apps`.`ruta`
    FROM `apps`
    INNER JOIN `mapa` ON `mapa`.`ruta` LIKE CONCAT(`apps`.`ruta`, "%")
    WHERE
    `apps`.`visible` = 1
    /*AND `idUsuario` = IIDUSUARIO /*Activar si se va a utilizar el idUsuario*/
    AND `usuario` = BINARY(USSUARIO)
    AND `mapa`.`bloqueo` = 0
    AND `mapa`.`estatus` = 1;
END; //

DELIMITER ;
