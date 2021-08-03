/*
 * FECHA:2020/08/31
 * AUTOR: Julio Alejandro Santos Corona
 * CORREO: jualesac@yahoo.com
 * TÍTULO: mapa.sql
 *
 * Descripción: Vista que arroja el mapa completo de rutas con permisos y estatus heredados
*/

DROP VIEW IF EXISTS `mapa`;

CREATE VIEW `mapa` AS (
    SELECT
    `index`.`idUsuario`,
    `index`.`idFuncion`,
    `ruteo`.`usuario`,
    `index`.`ruta`,
    `ruteo`.`ruta` AS `rutaMadre`,
    `get`,
    `post`,
    `put`,
    `delete`,
    `bloqueo`,
    (IF(`ePmso` > 0, `ePmso`, IF(`ePfl` > 0, `ePfl`, `eFijo`)) * `eFunc` * `eApp`) * `index`.`estatus` AS `estatus`
    FROM (
        SELECT
        `idUsuario`,
        `idFuncion`,
        `ruta`,
        `largo`,
        MIN(`estatus`) AS `estatus`
        FROM (
            SELECT
            `idUsuario`,
            `funciones`.`idFuncion`,
            CONCAT(`b`.`ruta`, `funciones`.`ruta`) AS `ruta`,
            MAX(LENGTH(`ruteo`.`ruta`)) AS `largo`,
            MIN(`funciones`.`estatus` * `a`.`estatus` * `b`.`estatus` * `f`.`estatus`) AS `estatus`
            FROM `apps` `a`
            INNER JOIN `apps` `b` ON `b`.`ruta` LIKE CONCAT(`a`.`ruta`, "%")
            INNER JOIN `funciones` ON `b`.`idApp` = `funciones`.`idApp`
            INNER JOIN `ruteo` ON CONCAT(`b`.`ruta`, `funciones`.`ruta`) LIKE CONCAT(`ruteo`.`ruta`, "%")
            INNER JOIN (
                SELECT
                `b`.`ruta`,
                MIN(`f1`.`estatus`) AS `estatus`
                FROM `funciones` `f1`
                INNER JOIN `apps` `a1` ON `f1`.`idApp` = `a1`.`idApp`
                INNER JOIN (
                    SELECT
                    CONCAT(`a2`.`ruta`, `f2`.`ruta`) AS `ruta`
                    FROM `funciones` `f2`
                    INNER JOIN `apps` `a2` ON `f2`.`idApp` = `a2`.`idApp`
                ) `b` ON `b`.`ruta` LIKE CONCAT(`a1`.`ruta`, `f1`.`ruta`, "%")
                GROUP BY `b`.`ruta`
            ) `f` ON CONCAT(`b`.`ruta`, `funciones`.`ruta`) = `f`.`ruta`
            GROUP BY `idUsuario`, CONCAT(`b`.`ruta`, `funciones`.`ruta`), `funciones`.`estatus` * `a`.`estatus` * `b`.`estatus`
        ) `m` GROUP BY `idUsuario`, `idFuncion`, `ruta`, `largo`
    ) `index`
    INNER JOIN `ruteo` ON (`index`.`idUsuario` = `ruteo`.`idUsuario` AND `index`.`ruta` LIKE CONCAT(`ruteo`.`ruta`, "%") AND LENGTH(`ruteo`.`ruta`) = `index`.`largo`)
);
