/* Ej 1 */
INSERT INTO Escuela(domicilio, nombre, email)
VALUES ('Acuña 52', 'UTN FRRA Rafaela', 'frra@gmail.com');


/* Ej 2*/
INSERT INTO Guia(nombre)
VALUES('Jorge Perez');
/* Ej 3*/
INSERT INTO Escuela(domicilio, nombre)
SELECT domicilio, nombre
FROM Escuela
WHERE idEscuela = 1;

/* Ej 4 */
DELETE FROM Telefono_Escuela;

INSERT INTO Telefono_Escuela(codigoArea, nro, Escuela_idEscuela)
VALUES ('1111', '1111',SELECT idEscuela FROM Escuela);

/* Ej 5 */
UPDATE Telefono_Escuela SET nro = '5445-3223' WHERE idEscuela = 1;

/* Ej 6 */
UPDATE Reserva SET dia='23-12-2018' WHERE idReserva = 1;

/* Ej 7 */
UPDATE Reserva_Tipo_Visita SET arancelPorAlumno = arancelPorAlumno - 2 WHERE cantidadAlumnosReservados >= 10;

/* Ej 8 */

UPDATE Reserva_Tipo_Visita SET Guia_idGuia = 2 WHERE Guia_idGuia = 1;

/* Ej 9 */

DELETE FROM Reserva_Tipo_Visita WHERE cantidadAlumnosReservados < 10;

/* Ej 10 */
DELETE FROM Guia WHERE nombre IS NULL;

/* Ej 11 */
SELECT idGuia, nombre
FROM Guia
WHERE nombre LIKE %'Bernardo'%;


