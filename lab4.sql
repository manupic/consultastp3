/********************* 
  EJERCICIOS: INSERT
*********************/

/* 1. Inserte una nueva escuela. */
INSERT INTO Escuela(domicilio, nombre, email)
VALUES ('Acuña 52', 'UTN FRRA Rafaela', 'frra@gmail.com');

/* 2. Agregue un nuevo guía a la base. */
INSERT INTO Guia(nombre)
VALUES('Jorge Perez');

/* 3. Inserte los datos de una escuela existente (nombre y domicilio) pero con un nuevo código. */
INSERT INTO Escuela(domicilio, nombre)
SELECT domicilio, nombre
FROM Escuela
WHERE idEscuela = 1;

/* 4. Borre todos los teléfonos que se encuentren en la tabla telefono_Escuela e inserte para todas las escuelas cargadas el teléfono 1111-1111. */
DELETE FROM Telefono_Escuela;

INSERT INTO Telefono_Escuela(codigoArea, nro, Escuela_idEscuela)
VALUES ('1111', '1111',(SELECT idEscuela FROM Escuela));

/********************* 
  EJERCICIOS: UPDATE
*********************/

/* 5. Actualice el teléfono de una de las escuelas por el número 5445-3223. */
UPDATE Telefono_Escuela SET nro = '5445-3223' WHERE idEscuela = 1;

/* 6. Actualice la fecha de una reserva que usted seleccione por 23/12/2018 */
UPDATE Reserva SET dia='23-12-2018' WHERE idReserva = 1;

/* 7. Debe realizarse un descuento en el arancel por alumno de $2 para todas las reservas de más de 10 alumnos. */
UPDATE Reserva_Tipo_Visita SET arancelPorAlumno = arancelPorAlumno - 2 WHERE cantidadAlumnosReservados >= 10;

/* 8. Actualice el código de guía de las reservas que tengan asignado al guía 1 por el guía 2. */
UPDATE Reserva_Tipo_Visita SET Guia_idGuia = 2 WHERE Guia_idGuia = 1;

/********************* 
  EJERCICIOS: DELETE
*********************/

/* 9. Borre todas las reservas con menos de 10 Alumnos. */
DELETE FROM Reserva_Tipo_Visita WHERE cantidadAlumnosReservados < 10;

/* 10. Elimine a todos los guías que no tengan cargado su nombre. */
DELETE FROM Guia WHERE nombre IS NULL;

/********************* 
  EJERCICIOS: SELECT
*********************/

/* 11. Obtenga un listado de todos los guías de nombre Bernardo. */
SELECT idGuia, nombre
FROM Guia
WHERE nombre LIKE '%Bernardo%';

/* 12. Se desea obtener la cantidad de reservas con fecha mayor a 3/1/2004. */
SELECT idReserva, dia, hora
FROM Reserva
WHERE dia > '03-01-2004';

/* 13. Se necesita conocer la cantidad total de alumnos reservados para cada reserva (agrupadas por reservas). */
SELECT Reserva_idReserva, SUM(cantidadAlumnosReservados)
FROM Reserva_Tipo_Visita
GROUP BY Reserva_idReserva;

/* 14. Liste todas las reservas que posee una cantidad total de alumnos reservados mayor a 20. */
SELECT Reserva_idReserva, SUM(cantidadAlumnosReservados)
FROM Reserva_Tipo_Visita
GROUP BY Reserva_idReserva
HAVING SUM(cantidadAlumnosReservados) > 20;

/* 15. Muestre las reservas realizadas en las cuales la inasistencia a las visitas sea mayor a 5. */
SELECT Reserva_idReserva
FROM Reserva_Tipo_Visita
WHERE (cantidadAlumnosReservados - cantidadAlumnosReales) > 5;

/* 16. Obtenga la cantidad de escuelas que visitarán el parque después del '30/6/2018'. */
SELECT COUNT(idReserva) 
FROM Reserva 
WHERE dia > '30-06-2018'

/********************* 
  EJERCICIOS: VARIOS
*********************/

/* 17. Insertar un nuevo guía con el número inmediato consecutivo al máximo existente. */
INSERT INTO Guia
values((SELECT Max(id_Guia) + 1 From Guia), 'Jorginho', 'Perezinho')

/* 18. Insertar un nuevo tipo de visita con el número inmediato consecutivo al máximo existente sin utilizar subconsultas. */
INSERT INTO Tipo_Visita
values ('Visita 3', 50)

/* 19. Insertar los datos de la tabla escuela en una nueva tabla, borre los datos de la tabla escuela. En la nueva tabla realice una actualización de los códigos de escuela incrementándolos en uno. Posteriormente reinsértelos en la tabla escuela y vuelva a la normalidad los códigos. */
--Crear una nueva tabla 
CREATE TABLE Nueva_tabla_escuela(
	idEscuela INTEGER,
	domicilio VARCHAR (50),
	nombre VARCHAR (50) UNIQUE,
	email VARCHAR (50)
);
-- Insertar datos en la nueva tabla
INSERT INTO Nueva_tabla_escuela (idEscuela, domicilio, nombre, email)
SELECT idEscuela, domicilio, nombre, email FROM Escuela;
-- Borrar datos de la tabla Escuela
TRUNCATE TABLE Escuela;
-- Actualizar códigos de escuela en 1
UPDATE Nueva_tabla_escuela
SET idEscuela = idEscuela + 1;
-- Reinsertar datos en la tabla Escuela
INSERT INTO Escuela (idEscuela, domicilio, nombre, email)
SELECT idEscuela, domicilio, nombre, email FROM Nueva_tabla_escuela;


/* 20. Las compañías telefónicas han decidido (por falta de números telefónicos!!), que todas las líneas deben agregar un 9 como primer número. Realice la actualización correspondiente en los teléfonos de las escuelas. */
UPDATE Telefono_Escuela SET nro =  CONCAT('9', nro);

/* 21. Debido a un feriado inesperado, las fechas de las visitas deben posponerse por un día. */
UPDATE Reserva SET dia = dia + 1
WHERE dia >= '12-10-2024';

/* 22. Obtener los datos de la última reserva existente. */
SELECT TOP 1 *
FROM Reserva
ORDER BY idReserva DESC

/* 23. Obtener los apellidos de los guías que se encuentren repetidos. */
SELECT nombre, COUNT(idGuia) as cantidad_apellidos_repetidos
FROM Guia
GROUP BY nombre
HAVING COUNT(idGuia) > 1

/* 24. Obtener un listado con la cantidad de reservas por fecha. */
SELECT COUNT(idReserva) as CantidadReservas, dia
FROM Reserva
GROUP BY (dia)

/* 25. Obtener el promedio de alumnos asistentes, reservados y la diferencia entre estos promedios. */
SELECT AVG(cantidadAlumnosReservados) as prom_alum_reservados, 
	AVG(cantidadAlumnosReales) as prom_alum_reales, 
	(AVG(cantidadAlumnosReservados) - AVG(cantidadAlumnosReales))  as diferencia_promedios
FROM Reserva_Tipo_Visita

/* 26. Obtener los guías que tengan más de 3 visitas */
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