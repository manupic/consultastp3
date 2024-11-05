-- 1. Listar los tipos de visita que fueron guiadas alguna vez por Cristina Zaluzi.
SELECT DISTINCT
    Tipo_visitas_idTipo_visitas
FROM
    Reserva_tipo_visita
WHERE
    guia_idguia IN (
        SELECT idguia
        FROM guia
        WHERE nombre = 'Cristina Zaluzi'
    );

-- 2. Listar los códigos de escuelas que poseen una cantidad total real de alumnos que visitaron el parque, mayor a 400.
SELECT DISTINCT
    Escuela_idEscuela
FROM
    Reserva
WHERE
    idReserva IN (
        SELECT Reserva_idReserva
        FROM Reserva_tipo_visita
        GROUP BY Reserva_idReserva
        HAVING SUM(Cantidad_Alumnos_Reales) > 400
    );

-- 3. Listar los nombres de escuela que visitaron en 2001 pero no lo hicieron en el 2002.
SELECT
    Nombre
FROM
    Escuela
WHERE
    idEscuela IN (
        SELECT Escuela_idEscuela
        FROM Reserva
        WHERE dia BETWEEN '01/01/2001' AND '31/12/2001'
    ) AND idEscuela NOT IN (
        SELECT Escuela_idEscuela
        FROM Reserva
        WHERE dia BETWEEN '01/01/2002' AND '31/12/2002'
    );

-- 4. Listar los guías (codigo, nombre y apellido) que fueron asignados a más de 10 tipos de visita distintos y con una cantidad total real de alumnos que guiaron, mayor a 200.
SELECT
    idguia,
    nombre
FROM 
    guia
WHERE
    idguia IN (
        SELECT DISTINCT
            guia_idguia
        FROM Reserva_tipo_visita
        GROUP BY guia_idguia
        HAVING
            COUNT(Tipo_visitas_idTipo_visitas) > 10
            AND SUM(Cantidad_Alumnos_Reales) > 200
    );

-- 5. Listar las escuelas que poseen más de 4 reservas con más de 3 tipos de visitas para cada reserva.
SELECT 
    Escuela_idEscuela
FROM 
    Reserva
WHERE 
    idReserva IN (
        SELECT Reserva_idReserva
        FROM Reserva_tipo_visita
        GROUP BY Reserva_idReserva
        HAVING COUNT(Tipo_visitas_idTipo_visitas) > 3
    )
GROUP BY Escuela_idEscuela
HAVING COUNT(idReserva) > 4;

-- 6. Listar el nombre, apellido y código de aquellos guías que, en alguna visita de una reserva en particular, hayan atendido por lo menos al 40% de los alumnos totales guiados en todas sus visitas.


-- 7. Listar las reservas donde todos los tipos de visita tienen la cantidad real de alumnos mayor en un 20% adicional a la cantidad reservada.

