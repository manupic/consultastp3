FALTA HACER EL 6, 11 Y 13
REVEER EL 7
CONTROLAR TODAS LAS CONSULTAS

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


-- 7. Listar las reservas donde todos los tipos de visita tienen la cantidad real de alumnos mayor en un 20% adicional a la cantidad reservada. REVEER
SELECT
    Reserva_idReserva
FROM 
    Reserva_tipo_visita
WHERE
    Tipo_visitas_idTipo_visitas IN (
        SELECT Tipo_visitas_idTipo_visitas
        FROM Reserva_tipo_visita
        WHERE Cantidad_Alumnos_Reales*1.20 > Cantidad_alumnos_reservados
    )

-- 8. Listar el nombre y el código de aquellas escuelas que hayan asistido el día en que se registró la mayor cantidad de alumnos reales.
SELECT
    idEscuela,
    Nombre
FROM
    Escuela
WHERE
    idEscuela IN(
        SELECT
            Escuela_idEscuela
        FROM
            Reserva
        WHERE dia = (SELECT
                    dia
                FROM Reserva
                GROUP BY
                    dia  
                ORDER BY
                    SUM(Cantidad_Alumnos_Reales)  DESC     
                LIMIT 1 
                )
    )

-- 9. Listar el código y nombre de las escuelas cuya fecha de reserva sea igual a la primera fecha de reserva realizada.
 SELECT
    idEscuela,
    Nombre
FROM
    Escuela
WHERE
    idEscuela IN (
        SELECT
            Escuela_idEscuela
        FROM
            Reserva
        WHERE
            dia = (SELECT
                    dia
                FROM Reserva
                ORDER BY
                    dia  
                LIMIT 1 
            )
    )

-- 10. Listar las escuelas que visitaron entre los años 2001 y en el 2002.
SELECT
    idEscuela,
    Nombre
FROM
    Escuela
WHERE
    idEscuela IN (
        SELECT
            Escuela_idEscuela
        FROM
            Reserva
        WHERE
            dia BETWEEN '01/01/2001' AND '31/12/2002'
    )

-- 11. Listar los guías que tuvieron más de 3 escuelas diferentes y una cantidad total real de alumnos mayor a 200.


-- 12. Listar los nombres y códigos de escuelas con gasto total de todas las visitas mayor a $1900.
SELECT
    idEscuela,
    Nombre
FROM
    Escuela
WHERE
    idEscuela IN (
        SELECT
            Escuela_idEscuela
        FROM
            Reserva
        WHERE
            idReserva IN (
                SELECT
                    Reserva_idReserva
                FROM
                    Reserva_tipo_visita
                WHERE 
                    SUM(Cantidad_Alumnos_Reales * arancel_por_alumno) > 1900
            )
    )

-- 13. Listar los guías que hayan tenido en solo un tipo de visita de una reserva en particular por lo menos el 45% del total de alumnos totales que esa persona atendió.

