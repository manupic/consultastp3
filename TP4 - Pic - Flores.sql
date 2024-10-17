-- 1.Listar las escuelas cuyos domicilios sean de calles que empiecen con A, indicando nombre, domicilio y teléfono. Hacer una versión en la que aparezcan sólo las que tienen teléfono, y hacer otra en la que aparezca solo las escuelas con domicilio en calles que empiecen con A y que no tienen ningún teléfono.

SELECT E.Nombre, E.calle_escuela, concat(Te.codigo_area,'-',Te.nro) as Telefono
FROM Escuela E 
INNER JOIN Telefono_Escuela Te
ON E.idEscuela = Te.Escuela_idEscuela
WHERE E.Nombre LIKE 'A%';

SELECT E.Nombre, E.calle_escuela
FROM Escuela E
LEFT JOIN Telefono_Escuela Te
ON E.idEscuela = Te.Escuela_idEscuela
WHERE E.Nombre LIKE 'A%' AND Te.nro IS NULL;

-- 2. Listar las reservas mostrando dia, nombre de escuela, cantidad de alumnos de reserva y el nombre del guía.
SELECT R.dia, E.Nombre, RTV.Cant_alumnos_reservada, G.nombre
FROM (
    (Escuela E INNER JOIN Reserva R ON E.idEscuela = R.Escuela_idEscuela) 
    INNER JOIN Reserva_tipo_vista RTV ON R.idReserva = RTV.Reserva_idReserva
    )
INNER JOIN Guia G 
ON RTV.guia_idGuia = G.idGuia
WHERE MONTH(dia) = 9 AND YEAR(dia) = 2024;

-- 3. Listar las reservas, la cantidad total real de alumnos y el valor total (cantidad x arancel con iva incluido).

-- 4. Listar las reservas y los nombres de escuelas con valor total mayor a 2.500.
SELECT R.idReserva, E.Nombre, RTV.Cant_alumnos_reservada, SUM(RTV.Arancel_por_alumno * RTV.cant_alumnos_real) AS Total
FROM (Escuela E INNER JOIN Reserva R ON E.idEscuela = R.Escuela_idEscuela) 
INNER JOIN Reserva_tipo_vista RTV ON R.idReserva = RTV.Reserva_idReserva
WHERE YEAR(dia) = 2024
GROUP BY 
    R.idReserva, 
    E.Nombre
HAVING
    SUM(RTV.Arancel_por_alumno * RTV.cant_alumnos_real) > 2500;

-- 5. Listar las escuelas que fueron atendidas alguna vez por el guía “Cristina Zaluzi”.

-- 6. Listar las escuelas que realizaron más de una visita para el mismo día.
SELECT R.idReserva, E.Nombre, RTV.Cant_alumnos_reservada, R.dia, COUNT(RTV.Tipo_visita_idVisita) AS Cantidad_Visitas
FROM (Escuela E INNER JOIN Reserva R ON E.idEscuela = R.Escuela_idEscuela) 
INNER JOIN Reserva_tipo_vista RTV ON R.idReserva = RTV.Reserva_idReserva
WHERE YEAR(dia) = 2024
GROUP BY 
    R.idReserva, E.nombre, R.dia
HAVING
    COUNT(RTV.Tipo_visita_idVisita) > 1;

-- 7. Listar los nombres de los guías y la cantidad de visitas para aquellos con más de 10 visitas de 100 personas.

-- 8. Listar las reservas, el día, la cantidad total de alumnos por tipo de visita, el nombre de la escuela y el nombre del guía.
SELECT 
    R.idReserva, 
    R.dia, 
    RTV.TipoVisita_idTipoVisita, 
    SUM(RTV.Cant_alumnos_reservada), 
    E.Nombre, 
    G.Nombre
FROM (
    (Escuela E INNER JOIN Reserva R ON E.idEscuela = R.Escuela_idEscuela) 
    INNER JOIN Reserva_tipo_vista RTV ON R.idReserva = RTV.Reserva_idReserva
    )
INNER JOIN Guia G 
ON RTV.guia_idGuia = G.idGuia
GROUP BY
    R.idReserva,
    R.dia,
    RTV.TipoVisita_idTipoVisita,
    E.Nombre,
    G.Nombre;

-- 9. Listar los tipos de visita (Codigo y Descripción) que han sido asignadas más de 5 veces.

-- 10. Listar los Guias (Apellido y Nombre) que no han sido nunca asignados a una reserva
SELECT G.Nombre, G.Apellido
FROM Reserva_Tipo_Visita RTV 
RIGHT JOIN Guia G
ON RTV.guia_idGuia = G.idGuia
WHERE RTV.idReserva IS NULL

-- 11. Listar los Guias (Apellido y Nombre) con visitas de escuelas cuyo nombre no comience con “E”

-- 12. Listar las escuelas (Nombre) que tengan visitas en donde la cantidad de alumnos reservada sea igual a la cantidad de alumnos reales asistentes.
SELECT 
    E.Nombre, 
    R.id_Reserva, 
    SUM(RTV.Cantidad_alumnos_Reales) AS Reales, 
    SUM(RTV.Cantidad_alumnos_Reservada) AS Reservadas
FROM (Escuela E INNER JOIN Reserva R ON E.idEscuela = R.Escuela_idEscuela) 
INNER JOIN Reserva_tipo_vista RTV ON R.idReserva = RTV.Reserva_idReserva
GROUP BY
    E.Nombre,
    R.id_Reserva
HAVING
    SUM(RTV.Cantidad_alumnos_Reales) = SUM(RTV.Cantidad_alumnos_Reservada)

-- 13.	Realizar la Union de las consultas: 
-- Nombres de las escuelas con reservas antes de las 9:00 h
-- Apellidos de los guías cuyos nombres comiencen con ‘V’ 
-- Ordenar el resultado en forma descendente

-- 14. Listar los Nombres y Teléfonos de las Escuelas que concurrieron a la visita: ‘Los Mamuts en Familia’
SELECT E.Nombre, Te.codigo_area, Te.nro
FROM (((
    Escuela E INNER JOIN Reserva R ON E.idEscuela = R.Escuela_idEscuela) 
    INNER JOIN Reserva_tipo_vista RTV ON R.idReserva = RTV.Reserva_idReserva)
    INNER JOIN TipoVisita TV ON RTV.TipoVisita_idTipoVisita = TV.idTipoVisita
    )
INNER JOIN Telefono_Escuela Te 
ON Te.Escuela_idEscuela = E.idEscuela
WHERE TV.Descripcion LIKE '%Los Mamuts en Familia%'

-- 15. Listar para cada grado (sin importar de cual escuela) cual fue la última vez que hicieron una visita

-- 16. Insertar en una nueva tabla llamada Guia_Performance los datos del Guia y las sumas de las cantidades reservadas y reales del año 2003.
INSERT INTO Guia_Performance
SELECT 
    G.id_guia,
    G.Nombre,
    SUM(RTV.Cantidad_alumnos_Reservada) AS Reservas,
    SUM(RTV.Cantidad_alumnos_Reales) AS Reales
FROM (Reserva R INNER JOIN Reserva_tipo_vista RTV ON R.idReserva = RTV.Reserva_idReserva)
INNER JOIN Guia G 
ON RTV.guia_idGuia = G.idGuia
WHERE YEAR(R.dia) = 2023
GROUP BY
    G.id_guia,
    G.Nombre
