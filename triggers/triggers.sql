/*
 * FECHA: 2020/08/27
 * AUTOR: Julio Alejandro Santos Corona
 * CORREO: jualesac@yahoo.com
 * TÍTULO: acctualizaVerbo.sql
 *
 * Descripción: Revisa que no se dupliquen los permisos configurados
*/

/*
 * ESTOS TRIGGERS DEBEN SER UTILIZADOS SÓLO EN CASO DE QUE SEA IMPOSIBLE MANTENER LOS
 * ÍNDICES CONFIUGURADOS EN LA ESTRUCTURA DE LA BASE DE DATOS, DE LO CONTRARIO NO ES
 * NECESARIO CARGARLOS.
*/

/**********************/
/* TABLA PCOMPONENTES */
/**********************/

DROP TRIGGER IF EXISTS updatepComponentes;

DELIMITER //

CREATE TRIGGER updatepComponentes BEFORE UPDATE ON `pComponentes` FOR EACH ROW
BEGIN
    IF((SELECT COUNT(*) FROM `pComponentes` WHERE `idPerfil` = NEW.`idPerfil` AND `idFuncion` = NEW.`idFuncion`) > 0) THEN
        SIGNAL SQLSTATE "10000" SET MESSAGE_TEXT="El perfil ya cuenta con la función.";
    END IF;
END; //

DELIMITER ;

DROP TRIGGER IF EXISTS insertpComponentes;

DELIMITER //

CREATE TRIGGER insertpComponentes BEFORE INSERT ON `pComponentes` FOR EACH ROW
BEGIN
    IF((SELECT COUNT(*) FROM `pComponentes` WHERE `idPerfil` = NEW.`idPerfil` AND `idFuncion` = NEW.`idFuncion`) > 0) THEN
        SIGNAL SQLSTATE "10000" SET MESSAGE_TEXT="El perfil ya cuenta con la función.";
    END IF;
END; //

DELIMITER ;

/******************/
/* TABLA PERMISOS */
/******************/

DROP TRIGGER IF EXISTS updatePermisos;

DELIMITER //

CREATE TRIGGER updatePermisos BEFORE UPDATE ON `permisos` FOR EACH ROW
BEGIN
    IF((SELECT COUNT(*) FROM `permisos` WHERE `idUsuario` = NEW.`idUsuario` AND `idFuncion` = NEW.`idFuncion`) > 0) THEN
        SIGNAL SQLSTATE "10000" SET MESSAGE_TEXT="El usuario ya cuenta con la función.";
    END IF;
END; //

DELIMITER ;

DROP TRIGGER IF EXISTS insertPermisos;

DELIMITER //

CREATE TRIGGER insertPermisos BEFORE UPDATE ON `permisos` FOR EACH ROW
BEGIN
    IF((SELECT COUNT(*) FROM `permisos` WHERE `idUsuario` = NEW.`idUsuario` AND `idFuncion` = NEW.`idFuncion`) > 0) THEN
        SIGNAL SQLSTATE "10000" SET MESSAGE_TEXT="El usuario ya cuenta con la función.";
    END IF;
END; //

DELIMITER ;

/*******************/
/* TABLA FUNCIONES */
/*******************/

DROP TRIGGER IF EXISTS updateFunciones;

DELIMITER //

CREATE TRIGGER updateFunciones BEFORE UPDATE ON `funciones` FOR EACH ROW
BEGIN
    IF((SELECT COUNT(*) FROM `funciones` WHERE `idApp` = NEW.`idApp` AND `ruta` = NEW.`ruta`) > 0) THEN
        SIGNAL SQLSTATE "10000" SET MESSAGE_TEXT="La aplicación ya cuenta con la función.";
    END IF;
END; //

DELIMITER ;

DROP TRIGGER IF EXISTS insertFunciones;

DELIMITER //

CREATE TRIGGER insertFunciones BEFORE INSERT ON `funciones` FOR EACH ROW
BEGIN
    IF((SELECT COUNT(*) FROM `funciones` WHERE `idApp` = NEW.`idApp` AND `ruta` = NEW.`ruta`) > 0) THEN
        SIGNAL SQLSTATE "10000" SET MESSAGE_TEXT="La aplicación ya cuenta con la función.";
    END IF;
END; //

DELIMITER ;

/******/
/*APPS*/
/******/

DROP TRIGGER IF EXISTS updateApps;

DELIMITER //

CREATE TRIGGER updateApps BEFORE UPDATE ON `apps` FOR EACH ROW
BEGIN
    IF((SELECT COUNT(*) FROM `apps` WHERE `ruta` = NEW.`ruta`) > 0) THEN
        SIGNAL SQLSTATE "10000" SET MESSAGE_TEXT="La aplicación ya se encuentra dada de alta.";
    END IF;
END; //

DELIMITER ;

DROP TRIGGER IF EXISTS insertApps;

DELIMITER //

CREATE TRIGGER insertApps BEFORE INSERT ON `apps` FOR EACH ROW
BEGIN
    IF((SELECT COUNT(*) FROM `funciones` WHERE `ruta` = NEW.`ruta`) > 0) THEN
        SIGNAL SQLSTATE "10000" SET MESSAGE_TEXT="La aplicación ya se encuentra dada de alta.";
    END IF;
END; //

DELIMITER ;
