CREATE DATABASE `seth` CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

USE `seth`;

CREATE TABLE `estatus`(
    `idEstatus` SMALLINT(3) NOT NULL,
    `estatus` VARCHAR(30) NOT NULL,
    PRIMARY KEY(`idEstatus`)
) ENGINE=InnoDB CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

CREATE TABLE `usuarios`(
    `idUsuario` INT(11) NOT NULL AUTO_INCREMENT,
    `idEstatus` SMALLINT(3) NOT NULL,
    `nombres` VARCHAR(50) NOT NULL,
    `aPaterno` VARCHAR(50) NOT NULL,
    `aMaterno` VARCHAR(50) NOT NULL,
    `correo` VARCHAR(50) NOT NULL,
    `usuario` VARCHAR(7) NOT NULL DEFAULT "",
    `contrasena` varchar(100) NOT NULL,
    PRIMARY KEY(`idUsuario`)
) ENGINE=InnoDB CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

CREATE TABLE `configuracion`(
    `idUsuario` INT(11) NOT NULL,
    `idArea` INT(11) NULL,
    `idPerfil` INT(11) NULL,
    `cumpleanos` VARCHAR(7) NULL,
	`extension` INT(8) NULL,
	`piso` TINYINT(2) NULL,
	`sector` VARCHAR(4) NULL,
	`modulo` SMALLINT(8) NULL
) ENGINE=InnoDB CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

CREATE TABLE `historial`(
    `idHistorial` INT(11) NOT NULL AUTO_INCREMENT,
    `idUsuario` INT(11) NOT NULL,
    `idArea`INT(11) NULL,
    `idEstatus` SMALLINT(3) NOT NULL,
    `fecha` DATETIME NOT NULL,
    PRIMARY KEY(`idHistorial`)
) ENGINE=InnoDB CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

/*CREATE TABLE `log`(
    `usuario` VARCHAR(7) NOT NULL,
    `ip` VARCHAR(15) NOT NULL,
    `ruta` VARCHAR(200) NOT NULL,
    `verbo` VARCHAR(6) NOT NULL,
    `fecha` DATETIME NOT NULL
) ENGINE=MyISAM CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;*/

CREATE TABLE `log`(
    `usuario` VARCHAR(7) NOT NULL,
    `ip` VARCHAR(15) NOT NULL,
    `ruta` VARCHAR(200) NOT NULL,
    `verbo` VARCHAR(6) NOT NULL,
    `fecha` DATETIME NOT NULL
) ENGINE=ARCHIVE CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

CREATE TABLE `areas`(
    `idArea` INT(11) NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(50) NOT NULL,
    PRIMARY KEY(`idArea`)
) ENGINE=InnoDB CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

CREATE TABLE `perfiles`(
    `idPerfil` INT(11) NOT NULL AUTO_INCREMENT,
    `idArea` INT(11) NOT NULL,
    `nombre` VARCHAR(50) NOT NULL DEFAULT "",
    `fijo` BOOLEAN NOT NULL DEFAULT FALSE,
    `estatus` BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY(`idPerfil`)
) ENGINE=InnoDB CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

CREATE TABLE `pComponentes`(
    `idComponente` INT(11) NOT NULL AUTO_INCREMENT,
    `idPerfil` INT(11) NOT NULL,
    `idFuncion` INT(11) NOT NULL,
    `get` BOOLEAN NOT NULL DEFAULT FALSE,
    `post` BOOLEAN NOT NULL DEFAULT FALSE,
    `put` BOOLEAN NOT NULL DEFAULT FALSE,
    `delete` BOOLEAN NOT NULL DEFAULT FALSE,
    `estatus` BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY(`idComponente`)
) ENGINE=InnoDB CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

CREATE TABLE `permisos`(
    `idPermiso` INT(11) NOT NULL AUTO_INCREMENT,
    `idUsuario` INT(11) NOT NULL,
    `idFuncion` INT(11) NOT NULL,
    `get` BOOLEAN NOT NULL DEFAULT FALSE,
    `post` BOOLEAN NOT NULL DEFAULT FALSE,
    `put` BOOLEAN NOT NULL DEFAULT FALSE,
    `delete` BOOLEAN NOT NULL DEFAULT FALSE,
    `estatus` BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY(`idPermiso`)
) ENGINE=InnoDB CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

CREATE TABLE `funciones`(
    `idFuncion` INT(11) NOT NULL AUTO_INCREMENT,
    `idApp` INT(11) NOT NULL,
    `pVisible` INTEGER(2) NOT NULL DEFAULT 0,
    `nombre` VARCHAR(50) NOT NULL DEFAULT "",
    `ruta` VARCHAR(100) NOT NULL DEFAULT "",
    `estatus` BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY(`idFuncion`)
) ENGINE=InnoDB CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

CREATE TABLE `apps`(
    `idApp` INT(11) NOT NULL AUTO_INCREMENT,
    `idArea` INT(11) NOT NULL,
    `visible` BOOLEAN NOT NULL DEFAULT TRUE,
    `nombre` VARCHAR(50) NOT NULL DEFAULT "",
    `ruta` VARCHAR(100) NOT NULL DEFAULT "",
    `estatus` BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY(`idApp`)
) ENGINE=InnoDB CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

/*ÍNDICES*/
ALTER TABLE `usuarios` ADD INDEX `indx_idEstatus`(`idEstatus`);
ALTER TABLE `usuarios` ADD UNIQUE `indx_usuario`(`usuario`);
ALTER TABLE `usuarios` ADD UNIQUE `indx_correo`(`correo`);

ALTER TABLE `configuracion` ADD UNIQUE `indx_idUsuario`(`idUsuario`);
ALTER TABLE `configuracion` ADD INDEX `indx_idArea`(`idArea`);
ALTER TABLE `configuracion` ADD INDEX `indx_idPerfil`(`idPerfil`);

ALTER TABLE `pComponentes` ADD INDEX `indx_idPerfil`(`idPerfil`);
ALTER TABLE `pComponentes` ADD INDEX `indx_idFuncion`(`idFuncion`);

ALTER TABLE `permisos` ADD INDEX `indx_idUsuario`(`idUsuario`);
ALTER TABLE `permisos` ADD INDEX `indx_idFuncion`(`idFuncion`);

ALTER TABLE `funciones` ADD INDEX `indx_idApp`(`idApp`);

ALTER TABLE `historial` ADD INDEX `indx_idUsuario`(`idUsuario`);
ALTER TABLE `historial` ADD INDEX `indx_idArea`(`idArea`);
ALTER TABLE `historial` ADD INDEX `indx_idEstatus`(`idEstatus`);

ALTER TABLE `perfiles` ADD INDEX `indx_idArea`(`idArea`);

ALTER TABLE `apps` ADD INDEX `indx_idArea`(`idArea`);

--Unique: En caso de no tener posiblidad de usar índices, utilice triggers
ALTER TABLE `pComponentes` ADD UNIQUE `indx_idPerfil_idFuncion`(`idPerfil`, `idFuncion`);
ALTER TABLE `permisos` ADD UNIQUE `indx_idUsuario_idFuncion`(`idUsuario`, `idFuncion`);
ALTER TABLE `funciones` ADD UNIQUE `indx_idApp_ruta`(`idApp`, `ruta`);
ALTER TABLE `apps` ADD UNIQUE `indx_ruta`(`ruta`);

/*LLAVES*/
ALTER TABLE `usuarios` ADD CONSTRAINT `fk_usuarios_idEstatus` FOREIGN KEY(`idEstatus`) REFERENCES `estatus`(`idEstatus`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `configuracion` ADD CONSTRAINT `fk_configuracion_idUsuario` FOREIGN KEY(`idUsuario`) REFERENCES `usuarios`(`idUsuario`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE `configuracion` ADD CONSTRAINT `fk_configuracion_idArea` FOREIGN KEY(`idArea`) REFERENCES `areas`(`idArea`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE `configuracion` ADD CONSTRAINT `fk_configuracion_idPerfil` FOREIGN KEY(`idPerfil`) REFERENCES `perfiles`(`idPerfil`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `pComponentes` ADD CONSTRAINT `fk_pComponentes_idPerfil` FOREIGN KEY(`idPerfil`) REFERENCES `perfiles`(`idPerfil`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE `pComponentes` ADD CONSTRAINT `fk_pComponentes_idFuncion` FOREIGN KEY(`idFuncion`) REFERENCES `funciones`(`idFuncion`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `permisos` ADD CONSTRAINT `fk_permisos_idUsuario` FOREIGN KEY(`idUsuario`) REFERENCES `usuarios`(`idUsuario`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE `permisos` ADD CONSTRAINT `fk_permisos_idFuncion` FOREIGN KEY(`idFuncion`) REFERENCES `funciones`(`idFuncion`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `funciones` ADD CONSTRAINT `fk_funciones_idApp` FOREIGN KEY(`idApp`) REFERENCES `apps`(`idApp`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `historial` ADD CONSTRAINT `fk_historial_idUsuario` FOREIGN KEY(`idUsuario`) REFERENCES `usuarios`(`idUsuario`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE `historial` ADD CONSTRAINT `fk_historial_idArea` FOREIGN KEY(`idArea`) REFERENCES `areas`(`idArea`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE `historial` ADD CONSTRAINT `fk_historial_idEstatus` FOREIGN KEY(`idEstatus`) REFERENCES `estatus`(`idEstatus`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `perfiles` ADD CONSTRAINT `fk_perfiles_idArea` FOREIGN KEY(`idArea`) REFERENCES `areas`(`idArea`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `apps` ADD CONSTRAINT `fk_apps_idArea` FOREIGN KEY(`idArea`) REFERENCES `areas`(`idArea`) ON DELETE CASCADE ON UPDATE CASCADE;
