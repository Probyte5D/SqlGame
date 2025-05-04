-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema giocoocasql
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema giocoocasql
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `giocoocasql` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `giocoocasql` ;

-- -----------------------------------------------------
-- Table `giocoocasql`.`tipi`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `giocoocasql`.`tipi` (
  `ID_Tipo` INT NOT NULL AUTO_INCREMENT,
  `Nome_tipo` VARCHAR(25) NULL DEFAULT NULL,
  PRIMARY KEY (`ID_Tipo`))
ENGINE = InnoDB
AUTO_INCREMENT = 6
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `giocoocasql`.`caselle`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `giocoocasql`.`caselle` (
  `ID_Casella` INT NOT NULL AUTO_INCREMENT,
  `ID_Tipo` INT NOT NULL,
  PRIMARY KEY (`ID_Casella`),
  INDEX `ID_Tipo` (`ID_Tipo` ASC) VISIBLE,
  CONSTRAINT `caselle_ibfk_1`
    FOREIGN KEY (`ID_Tipo`)
    REFERENCES `giocoocasql`.`tipi` (`ID_Tipo`))
ENGINE = InnoDB
AUTO_INCREMENT = 21
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `giocoocasql`.`gioco_log`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `giocoocasql`.`gioco_log` (
  `ID_Log` INT NOT NULL AUTO_INCREMENT,
  `NomePlayer` VARCHAR(25) NOT NULL,
  `Posizione` INT NULL DEFAULT '0',
  `Nuova_Posizione` INT NULL DEFAULT '0',
  `TipoCasella` INT NULL DEFAULT '0',
  `NomeCasella` VARCHAR(25) NULL DEFAULT NULL,
  `Mossa_Player` INT NULL DEFAULT '0',
  `Punteggio` INT NULL DEFAULT '0',
  `Turno` INT NULL DEFAULT '0',
  `Result` VARCHAR(255) NOT NULL,
  `Esecuzione` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID_Log`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `giocoocasql`.`players`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `giocoocasql`.`players` (
  `ID_Player` INT NOT NULL AUTO_INCREMENT,
  `Nome` VARCHAR(25) NOT NULL,
  `Posizione` INT NULL DEFAULT '0',
  `Punteggio` INT NULL DEFAULT '0',
  `Turno` INT NULL DEFAULT '0',
  PRIMARY KEY (`ID_Player`),
  UNIQUE INDEX `Nome` (`Nome` ASC) VISIBLE,
  INDEX `idx_turno` (`Turno` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 8
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
