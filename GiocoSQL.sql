-- ***************************************************** DATABASE *******************************************************
DROP DATABASE IF EXISTS giocoOca;
CREATE DATABASE giocoOca;
USE giocoOca;

CREATE TABLE Players
(
	ID_Player INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(25) NOT NULL UNIQUE,
    Posizione INT DEFAULT 0,
	Punteggio INT DEFAULT 0,  
    Turno INT DEFAULT 0,
	INDEX idx_turno (Turno) -- indice automatico
    );
    
CREATE TABLE Tipi
(
	ID_Tipo INT PRIMARY KEY AUTO_INCREMENT,
    Nome_tipo VARCHAR(25)
    );
    
CREATE TABLE Caselle
(
	ID_Casella INT PRIMARY KEY AUTO_INCREMENT,
    ID_Tipo INT NOT NULL,
    FOREIGN KEY (ID_Tipo) REFERENCES Tipi(ID_Tipo)
	);

CREATE TABLE gioco_log
( 	
	ID_Log INT PRIMARY KEY AUTO_INCREMENT,
	NomePlayer VARCHAR(25) NOT NULL, 
    Posizione INT DEFAULT 0, 
    Nuova_Posizione INT DEFAULT 0,
	TipoCasella VARCHAR(25),
    NomeCasella VARCHAR(25),
    Mossa_Player INT DEFAULT 0,
    Punteggio INT DEFAULT 0, 
    Turno INT DEFAULT 0, 
    Result VARCHAR(255) NOT NULL,
	Esecuzione TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- creare tabella log nome posizione nuova posizione punteggio turno result

INSERT INTO Players (Nome) VALUES
('Player1'),
('Player2'),
('Player3'),
('Player4'),
('Player5'),
('Player6'),
('Player7');

INSERT INTO Tipi (Nome_tipo) Values
('Normale'),
('Penalità'),
('Oca'),
('Premio'),
('Fine');

INSERT INTO Caselle (ID_Tipo) Values
(1),(1),(3),(2),(4),(1),(1),(2),(3),(1),(2),(3),
(1),(1),(1),(2),(3),(4),(4),(5),(1),(1),(1),(1) ;

-- *********************************************************GIOCO*****************************************************************

USE giocoOca;
DROP PROCEDURE IF EXISTS Turnazione;

DELIMITER //
CREATE PROCEDURE Turnazione()
BEGIN

SET SQL_SAFE_UPDATES = 0;
SET @turno = 0;

UPDATE Players
SET turno = @turno := @turno + 1 
ORDER BY RAND();

SET SQL_SAFE_UPDATES = 1;
END; //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE gioco() 
BEGIN
	
	DECLARE v_mossa INT DEFAULT 0; -- per tirare i dadi
	DECLARE v_posizione INT DEFAULT 0;  -- per la posizione del giocatore attuale
    DECLARE v_nuovaposizione INT DEFAULT 0 ; -- posizione di arrivo del giocatore
    DECLARE v_IDTipo INT; -- per il tipo di casella
    DECLARE v_nomeCasella VARCHAR(25);
    DECLARE v_ID_Player INT ; -- PER L'id del giocatore
    DECLARE v_Turno_Player INT DEFAULT 0 ; -- PER il turno del giocatore
    DECLARE v_Nome_Player VARCHAR(25);
    DECLARE v_GiocatoriAttivi INT DEFAULT 0;
    DECLARE v_numCaselle INT ;
    DECLARE v_Punti INT DEFAULT 0;
    DECLARE v_Classifica INT DEFAULT 0;
    DECLARE v_Giocatori INT DEFAULT 0;
    DECLARE v_TurnoGioco INT DEFAULT 0;
    DECLARE v_RESULT VARCHAR(255);

   
    SET v_Giocatori = (SELECT COUNT(*) FROM Players);
    SET v_GiocatoriAttivi = v_Giocatori;
    SET v_numCaselle = (SELECT COUNT(*) FROM Caselle);
 
   
	CALL Turnazione();
	
    
	 Loop_Gioco:  WHILE v_GiocatoriAttivi > 0  DO -- il gioco va avanti fino a quando ci sono giocatori 	
    
		IF v_Turno_Player = v_Giocatori THEN
			SET v_Turno_Player = 0;
        END IF;
        
		SET v_TurnoGioco = v_Turno_Player;
        SET v_Nome_Player = NULL;
      
	        SELECT ID_Player, Nome, posizione, Punteggio, Turno
            INTO v_ID_Player, v_Nome_Player, v_posizione, v_Classifica, v_Turno_Player
            FROM Players
            WHERE Punteggio = 0 AND Turno > v_TurnoGioco
            ORDER BY Turno 
            LIMIT 1;
            
		IF v_Nome_Player IS NULL THEN
    SET v_RESULT = 'Nessun giocatore trovato per questo turno';
    INSERT INTO gioco_Log (NomePlayer, Posizione, Nuova_Posizione, TipoCasella, NomeCasella, Mossa_Player, Punteggio, Turno, Result)
    VALUES (NULL, v_posizione, v_nuovaposizione, v_IDTipo, v_nomeCasella, v_mossa, v_Classifica, v_Turno_Player, v_RESULT);
    ITERATE Loop_Gioco;
END IF;

 


		SET v_mossa = FLOOR(RAND() * 6) + 1;
		-- setta una nuova posizione con la mossa
        

		SET v_nuovaposizione = v_posizione + v_mossa;
        
		IF v_nuovaposizione <= v_numCaselle THEN -- continuo il gioco
		
			SELECT Caselle.ID_Tipo, Tipi.Nome_tipo 
				INTO v_IDTipo, v_nomeCasella
				FROM Caselle
				JOIN Tipi ON Caselle.ID_Tipo = Tipi.ID_Tipo
				WHERE Caselle.ID_Casella = v_nuovaposizione;

			CASE
				WHEN v_IDTipo = 1 THEN -- Casella normale
					SET v_RESULT = CONCAT('Giocatore ', v_Nome_Player, ', Nuova posizione: ', v_nuovaposizione);

				WHEN v_IDTipo = 2 THEN -- Casella Penalità (tornare alla posizione precedente - mossa annullata)
					SET v_nuovaposizione = v_posizione;
					SET v_RESULT = CONCAT('Giocatore ', v_Nome_Player, ' con penalità, rimane nella sua posizione ', v_nuovaposizione);
				
				WHEN v_IDTipo = 3 THEN -- Casella Oca
					SET v_nuovaposizione = v_nuovaposizione + v_mossa;
					SET v_RESULT = CONCAT('Giocatore ', v_Nome_Player , ' con Oca, raddoppia e si posiziona su ', v_nuovaposizione);
				
				WHEN v_IDTipo = 4 THEN -- Casella Premio
					SET v_nuovaposizione = v_nuovaposizione + 3;
					SET v_RESULT = CONCAT('Giocatore ', v_Nome_Player, ' con Premio, avanza di 3 posizioni fino a ', v_nuovaposizione);
				
				WHEN v_IDTipo = 5 THEN -- Casella Fine
					SET v_RESULT = CONCAT('Giocatore ', v_Nome_Player, ' ha raggiunto la casella finale');
					
				ELSE
					SET v_RESULT = ('Tipo di casella non riconosciuto');
			END CASE;
			
		ELSE
			-- Se la nuova posizione è oltre la casella finale, posiziona il giocatore alla casella finale
			SET v_nuovaposizione = v_numCaselle;
			SET v_RESULT = CONCAT('Giocatore ', v_Nome_Player, ' ha superato la casella finale, posizionato sulla casella finale');
		END IF;
        

        
        IF v_nuovaposizione = v_numCaselle THEN
			-- Il giocatore ha raggiunto la casella finale, quindi ha vinto
			SET v_GiocatoriAttivi = v_GiocatoriAttivi - 1;
			SET v_Punti = v_Punti + 1;
			SET v_Classifica = v_Punti;
            SET v_RESULT = CONCAT(v_RESULT, ' ed ha vinto!');
        END IF;
        
		UPDATE Players
			SET Posizione = v_nuovaposizione, Punteggio = v_Classifica
			WHERE Turno = v_Turno_Player;
        
        IF v_GiocatoriAttivi = 0 THEN
			SET v_RESULT = CONCAT(v_RESULT, ' Il gioco è finito.');
		END IF;

        INSERT INTO gioco_Log (NomePlayer, Posizione, Nuova_Posizione, TipoCasella, NomeCasella, Mossa_Player, Punteggio, Turno, Result)
			VALUES (v_Nome_Player, v_posizione, v_nuovaposizione, v_IDTipo, v_nomeCasella, v_mossa, v_Classifica, v_Turno_Player, v_RESULT);
        
		SET v_IDTipo = NULL;
        SET v_nomeCasella = NULL;

    END WHILE;

	SELECT * FROM gioco_Log;
    SELECT * FROM Players ORDER BY Punteggio;

END; //
DELIMITER ;

CALL gioco();