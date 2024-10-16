/* 1.Listar las escuelas cuyos domicilios sean de calles que empiecen con A, indicando nombre, domicilio y teléfono. Hacer una versión en la que aparezcan sólo las que tienen teléfono, y hacer otra en la que aparezca solo las escuelas con domicilio en calles que empiecen con A y que no tienen ningún teléfono. */

SELECT E.Nombre, E.calle_escuela, concat(Te.codigo_area,'-',Te.nro) as Telefono
FROM Escuela E 
INNER JOIN Telefono_Escuela Te
ON E.idEscuela = Te.Escuela_idEscuela
WHERE E.Nombre LIKE 'A%';

/* 2. Listar las reservas mostrando dia, nombre de escuela, cantidad de alumnos de reserva y el nombre del guía. */

/* 3. Listar las reservas, la cantidad total real de alumnos y el valor total (cantidad x arancel con iva incluido). */
