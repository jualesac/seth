/*
 * FECHA: 2019/10/06
 * AUTOR: Julio Alejandro Santos Corona
 * CORREO: jualesac@yahoo.com
 * TÍTULO: getPermisos.sql
 *
 * Descripción: Obtiene todos los permisos de un usuario para una ruta.
*/

DROP PROCEDURE IF EXISTS getPermisos;

DELIMITER //

CREATE PROCEDURE getPermisos(USUARI VARCHAR(7), RUTAA VARCHAR(150))
BEGIN
    SELECT
    `ruta`,
    `get`,
    `post`,
    `put`,
    `delete`
    FROM `mapa`
    WHERE
    `usuario` = BINARY("C268530")
    AND `ruta` REGEXP(CONCAT("^", RUTAA, "(/|#|\\?|)"));
END; //

DELIMITER ;
