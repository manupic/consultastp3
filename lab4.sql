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
WHERE nombre LIKE '%Bernardo%';

/* Ej 12 */
SELECT idReserva, dia, hora
FROM Reserva
WHERE dia > '03-01-2004';

/* Ej 13 */
SELECT Reserva_idReserva, SUM(cantidadAlumnosReservados)
FROM Reserva_Tipo_Visita
GROUP BY Reserva_idReserva;

/* Ej 14 */
SELECT Reserva_idReserva, cantidadAlumnosReservados
FROM Reserva_Tipo_Visita
WHERE cantidadAlumnosReservados > 20;

/* Ej 15 Muestre las reservas realizadas en las cuales la inasistencia a las visitas sea mayor a 5 */
SELECT Reserva_idReserva
FROM Reserva_Tipo_Visita
WHERE (cantidadAlumnosReservados - cantidadAlumnosReales) > 5;

/* Ej 16 Obtenga la cantidad de escuelas que visitarán el parque después del '30/6/2018' */


/* Ej 20 */
UPDATE Telefono_Escuela SET nro =  CONCAT('9', nro);

/*Ej 21 */

UPDATE Reserva SET dia = dia + 1
WHERE dia >= '12-10-2024';

/* Ej 22*/
SELECT TOP 1 *
FROM Reserva
ORDER BY idReserva DESC

/* Ej 23 */
SELECT nombre, COUNT(idGuia) as cantidad_apellidos_repetidos
FROM Guia
GROUP BY nombre
HAVING COUNT(idGuia) > 1


/* Ej 24 */

SELECT COUNT(idReserva) as CantidadReservas, dia
FROM Reserva
GROUP BY (dia)

/* Ej 25 */

SELECT AVG(cantidadAlumnosReservados) as prom_alum_reservados, 
	AVG(cantidadAlumnosReales) as prom_alum_reales, 
	(AVG(cantidadAlumnosReservados) - AVG(cantidadAlumnosReales))  as diferencia_promedios
FROM Reserva_Tipo_Visita

/* Ej 26*/
SELECT Guia_idGuia, COUNT (Tipo_Visita_idTipoVisitas) as cantidad_visitas
FROM Reserva_Tipo_Visita
GROUP BY Guia_idGuia
HAVING COUNT(Tipo_Visita_idTipoVisitas) > 3;


/* Ejemplo de JOIN */
SELECT dia
FROM Reserva_Tipo_Visita RTV join Reserva R on R.idReserva = RTV.Reserva_idReserva
GROUP BY dia

/* USAR TOP YA Q ESTE DEVUELVE LA TUPLA, A DIFERENCIA DEL MAX QUE DEVUELVE EL 
	MAXIMO VALOR Y NO RETORNA LOS DEMAS CAMPOS DE ESA TUPLA*/