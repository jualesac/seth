/*
 * FECHA: 2020/08/29
 * AUTOR: Julio Alejandro Santos Corona
 * CORREO: jualesac@yahoo.com
 * TÍTULO: obtenerSubmenu.sql
 *
 * Descripción: Proceso para obtener los submenus
*/

DROP PROCEDURE IF EXISTS obtenerSubmenu;

DELIMITER //

/*CREATE PROCEDURE obtenerSubmenu(IIDUSUARIO INT(11), IIDAPP INT(11), PPLANO INT(2)) /*En caso de utilizar el idUsuario*/
CREATE PROCEDURE obtenerSubmenu(USSUARIO VARCHAR(7), IIDAPP INT(11), PPLANO INT(2))
BEGIN
    SELECT DISTINCT
    `usuario`,
    `a`.`idApp`,
    `funciones`.`idFuncion`,
    `funciones`.`nombre`,
    `mapa`.`ruta`
    FROM `apps` `a`
    INNER JOIN `apps` `b` ON `b`.`ruta` LIKE CONCAT(`a`.`ruta`, "%")
    INNER JOIN `funciones` ON `b`.`idApp` = `funciones`.`idApp`
    INNER JOIN `mapa` ON CONCAT(`b`.`ruta`, `funciones`.`ruta`) = `mapa`.`ruta`
    WHERE
    `a`.`idApp` = IIDAPP
    AND `pVisible` = PPLANO
    /*AND `idUsuario` = IIDUSUARIO /*Activar si se va a utilizar el idUsuario*/
    AND `usuario` = BINARY(USSUARIO)
    AND `mapa`.`estatus` = 1;
END; //

DELIMITER ;
