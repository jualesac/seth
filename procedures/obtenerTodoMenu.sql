/*
 * FECHA: 2020/10/03
 * AUTOR: Julio Alejandro Santos Corona
 * CORREO: jualesac@yahoo.com
 * TÍTULO obtenerTodoMenu.sql
 *
 * Descripción: Obtiene el menu y el submenu inmediato
*/

DROP PROCEDURE IF EXISTS obtenerTodoMenu;

DELIMITER //

CREATE PROCEDURE obtenerTodoMenu(USSUARIO VARCHAR(7))
BEGIN
    SELECT
    `menu`.*,
    `funciones`.`nombre` AS `submenu`,
    CONCAT(`apps`.`ruta`, `funciones`.`ruta`) AS `rutasm`
    FROM `funciones`
    INNER JOIN `apps` ON `funciones`.`idApp` = `apps`.`idApp`
    INNER JOIN (
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
        AND `mapa`.`estatus` = 1
    ) `menu` ON CONCAT(`apps`.`ruta`, `funciones`.`ruta`) LIKE CONCAT(`menu`.`ruta`, "%")
    INNER JOIN `mapa` ON `funciones`.`idFuncion` = `mapa`.`idFuncion`
    WHERE
    `pVisible` = 1
    AND `mapa`.`usuario` = BINARY(USSUARIO)
    AND `mapa`.`estatus` = 1
    ORDER BY `menu`.`idApp`, `funciones`.`idFuncion`;
END; //

DELIMITER ;
