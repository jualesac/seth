/*
 * FECHA: 2020/08/30
 * AUTOR: Julio Alejandro Santos Corona
 * CORREO: jualesac@yahoo.com
 * TÍTULO: ruteo.sql
 *
 * Descripción: Contiene todos los permisos configurados de un usuario
*/

DROP VIEW IF EXISTS `ruteo`;

CREATE VIEW `ruteo` AS (
    SELECT
    *
    FROM (
        /*PERMISOS*/
        (
            SELECT
            `usuarios`.`idUsuario`,
            `apps`.`idApp`,
            `funciones`.`idFuncion`,
            `usuarios`.`usuario`,
            `apps`.`visible`,
            `funciones`.`pVisible`,
            `apps`.`nombre` AS `nombreApp`,
            `funciones`.`nombre` AS `nombreFunc`,
            CONCAT(`apps`.`ruta`, `funciones`.`ruta`) AS `ruta`,
            (IF(`permisos`.`estatus` IS NOT NULL AND `permisos`.`estatus` > 0, `permisos`.`get`, IF(`p1`.`estatus` * `c1`.`estatus` > 0, `c1`.`get`, IFNULL(`c2`.`get`, 0)))) AS `get`,
            (IF(`permisos`.`estatus` IS NOT NULL AND `permisos`.`estatus` > 0, `permisos`.`post`, IF(`p1`.`estatus` * `c1`.`estatus` > 0, `c1`.`post`, IFNULL(`c2`.`post`, 0)))) AS `post`,
            (IF(`permisos`.`estatus` IS NOT NULL AND `permisos`.`estatus` > 0, `permisos`.`put`, IF(`p1`.`estatus` * `c1`.`estatus` > 0, `c1`.`put`, IFNULL(`c2`.`put`, 0)))) AS `put`,
            (IF(`permisos`.`estatus` IS NOT NULL AND `permisos`.`estatus` > 0, `permisos`.`delete`, IF(`p1`.`estatus` * `c1`.`estatus` > 0, `c1`.`delete`, IFNULL(`c2`.`delete`, 0)))) AS `delete`,
            IF((`permisos`.`bloqueo` + IFNULL(`c1`.`bloqueo`, 0) + IFNULL(`c2`.`bloqueo`, 0)) > 0, 1, 0) AS `bloqueo`,
            IFNULL(`permisos`.`estatus`, 0) AS `ePmso`,
            IFNULL(`p1`.`estatus`, 1) * IFNULL(`c1`.`estatus`, 0) AS `ePfl`,
            IFNULL(`p2`.`estatus`, 1) * IFNULL(`c2`.`estatus`, 0) AS `eFijo`,
            `funciones`.`estatus` AS `eFunc`,
            `apps`.`estatus` AS `eApp`
            FROM `usuarios`
            INNER JOIN `permisos` ON `usuarios`.`idUsuario` = `permisos`.`idUsuario`
            INNER JOIN `funciones` ON `permisos`.`idFuncion` = `funciones`.`idFuncion`
            LEFT JOIN `configuracion` ON `usuarios`.`idUsuario` = `configuracion`.`idUsuario`
            LEFT JOIN `perfiles` `p1` ON `configuracion`.`idPerfil` = `p1`.`idPerfil`
            LEFT JOIN `pComponentes` `c1` ON (`configuracion`.`idPerfil` = `c1`.`idPerfil` AND `funciones`.`idFuncion` = `c1`.`idFuncion`)
            LEFT JOIN `perfiles` `p2` ON `p2`.`fijo` = 1
            LEFT JOIN `pComponentes` `c2` ON (`p2`.`idPerfil` = `c2`.`idPerfil` AND `funciones`.`idFuncion` = `c2`.`idFuncion`)
            INNER JOIN `apps` ON `funciones`.`idApp` = `apps`.`idApp`
        ) UNION ( /*PERFILES*/
            SELECT
            `usuarios`.`idUsuario`,
            `apps`.`idApp`,
            `funciones`.`idFuncion`,
            `usuarios`.`usuario`,
            `apps`.`visible`,
            `funciones`.`pVisible`,
            `apps`.`nombre` AS `nombreApp`,
            `funciones`.`nombre` AS `nombreFunc`,
            CONCAT(`apps`.`ruta`, `funciones`.`ruta`) AS `ruta`,
            (IF(`permisos`.`estatus` IS NOT NULL AND `permisos`.`estatus` > 0, `permisos`.`get`, IF(`p1`.`estatus` * `c1`.`estatus` > 0, `c1`.`get`, IFNULL(`c2`.`get`, 0)))) AS `get`,
            (IF(`permisos`.`estatus` IS NOT NULL AND `permisos`.`estatus` > 0, `permisos`.`post`, IF(`p1`.`estatus` * `c1`.`estatus` > 0, `c1`.`post`, IFNULL(`c2`.`post`, 0)))) AS `post`,
            (IF(`permisos`.`estatus` IS NOT NULL AND `permisos`.`estatus` > 0, `permisos`.`put`, IF(`p1`.`estatus` * `c1`.`estatus` > 0, `c1`.`put`, IFNULL(`c2`.`put`, 0)))) AS `put`,
            (IF(`permisos`.`estatus` IS NOT NULL AND `permisos`.`estatus` > 0, `permisos`.`delete`, IF(`p1`.`estatus` * `c1`.`estatus` > 0, `c1`.`delete`, IFNULL(`c2`.`delete`, 0)))) AS `delete`,
            IF((IFNULL(`permisos`.`bloqueo`, 0) + `c1`.`bloqueo` + IFNULL(`c2`.`bloqueo`, 0)) > 0, 1, 0) AS `bloqueo`,
            IFNULL(`permisos`.`estatus`, 0) AS `ePmso`,
            `p1`.`estatus` * `c1`.`estatus` AS `ePfl`,
            IFNULL(`p2`.`estatus`, 1) * IFNULL(`c2`.`estatus`, 0) AS `eFijo`,
            `funciones`.`estatus` AS `eFunc`,
            `apps`.`estatus` AS `eApp`
            FROM `usuarios`
            INNER JOIN `configuracion` ON `usuarios`.`idUsuario` = `configuracion`.`idUsuario`
            INNER JOIN `perfiles` `p1` ON (`configuracion`.`idPerfil` = `p1`.`idPerfil`)
            INNER JOIN `pComponentes` `c1` ON `p1`.`idPerfil` = `c1`.`idPerfil`
            INNER JOIN `funciones` ON `c1`.`idFuncion` = `funciones`.`idFuncion`
            LEFT JOIN `permisos` ON (`usuarios`.`idUsuario` = `permisos`.`idUsuario` AND `funciones`.`idFuncion` = `permisos`.`idFuncion`)
            LEFT JOIN `perfiles` `p2` ON `p2`.`fijo` = 1
            LEFT JOIN `pComponentes` `c2` ON (`p2`.`idPerfil` = `c2`.`idPerfil` AND `funciones`.`idFuncion` = `c2`.`idFuncion`)
            INNER JOIN `apps` ON `funciones`.`idApp` = `apps`.`idApp`
        ) UNION ( /*FIJOS*/
            SELECT
            `usuarios`.`idUsuario`,
            `apps`.`idApp`,
            `funciones`.`idFuncion`,
            `usuarios`.`usuario`,
            `apps`.`visible`,
            `funciones`.`pVisible`,
            `apps`.`nombre` AS `nombreApp`,
            `funciones`.`nombre` AS `nombreFunc`,
            CONCAT(`apps`.`ruta`, `funciones`.`ruta`) AS `ruta`,
            (IF(`permisos`.`estatus` IS NOT NULL AND `permisos`.`estatus` > 0, `permisos`.`get`, IF(`p1`.`estatus` * `c1`.`estatus` > 0, `c1`.`get`, IFNULL(`c2`.`get`, 0)))) AS `get`,
            (IF(`permisos`.`estatus` IS NOT NULL AND `permisos`.`estatus` > 0, `permisos`.`post`, IF(`p1`.`estatus` * `c1`.`estatus` > 0, `c1`.`post`, IFNULL(`c2`.`post`, 0)))) AS `post`,
            (IF(`permisos`.`estatus` IS NOT NULL AND `permisos`.`estatus` > 0, `permisos`.`put`, IF(`p1`.`estatus` * `c1`.`estatus` > 0, `c1`.`put`, IFNULL(`c2`.`put`, 0)))) AS `put`,
            (IF(`permisos`.`estatus` IS NOT NULL AND `permisos`.`estatus` > 0, `permisos`.`delete`, IF(`p1`.`estatus` * `c1`.`estatus` > 0, `c1`.`delete`, IFNULL(`c2`.`delete`, 0)))) AS `delete`,
            IF((IFNULL(`permisos`.`bloqueo`, 0) + IFNULL(`c1`.`bloqueo`, 0) + `c2`.`bloqueo`) > 0, 1, 0) AS `bloqueo`,
            IFNULL(`permisos`.`estatus`, 0) AS `ePmso`,
            IFNULL(`p1`.`estatus`, 1) * IFNULL(`c1`.`estatus`, 0) AS `ePfl`,
            `p2`.`estatus` * `c2`.`estatus` AS `eFijo`,
            `funciones`.`estatus` AS `eFunc`,
            `apps`.`estatus` AS `eApp`
            FROM `usuarios`
            INNER JOIN `perfiles` `p2` ON `p2`.`fijo` = 1
            INNER JOIN `pComponentes` `c2` ON `p2`.`idPerfil` = `c2`.`idPerfil`
            INNER JOIN `funciones` ON `c2`.`idFuncion` = `funciones`.`idFuncion`
            LEFT JOIN `configuracion` ON `usuarios`.`idUsuario` = `configuracion`.`idUsuario`
            LEFT JOIN `perfiles` `p1` ON `configuracion`.`idPerfil` = `p1`.`idPerfil`
            LEFT JOIN `pComponentes` `c1` ON (`p1`.`idPerfil` = `c1`.`idPerfil` AND `funciones`.`idFuncion` = `c1`.`idFuncion`)
            LEFT JOIN `permisos` ON (`usuarios`.`idUsuario` = `permisos`.`idUsuario` AND `funciones`.`idFuncion` = `permisos`.`idFuncion`)
            INNER JOIN `apps` ON `funciones`.`idApp` = `apps`.`idApp`
        )
    ) `menu`
);
