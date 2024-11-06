-- 1. Listar los tipos de visita que fueron guiadas alguna vez por Cristina Zaluzi.
SELECT DISTINCT
    RTV.Tipo_visitas_idTipo_visitas
FROM
    Reserva_tipo_visita RTV
WHERE
    RTV.guia_idguia = (
        SELECT G.idguia
        FROM guia G
        WHERE G.nombre = 'Cristina Zaluzi'
    );

-- 2. Listar los códigos de escuelas que poseen una cantidad total real de alumnos que visitaron el parque, mayor a 400.
SELECT DISTINCT
    R.Escuela_idEscuela
FROM
    Reserva R
WHERE
    R.idReserva IN (
        SELECT RTV.Reserva_idReserva
        FROM Reserva_tipo_visita RTV
        GROUP BY RTV.Reserva_idReserva
        HAVING SUM(RTV.Cantidad_Alumnos_Reales) > 400
    );

-- 3. Listar los nombres de escuela que visitaron en 2001 pero no lo hicieron en el 2002.
SELECT
    E.Nombre
FROM
    Escuela E
WHERE
    E.idEscuela EXISTS (
        SELECT R.Escuela_idEscuela
        FROM Reserva R
        WHERE R.dia BETWEEN '01/01/2001' AND '31/12/2001'
    ) AND NOT EXISTS (
        SELECT R2.Escuela_idEscuela
        FROM Reserva R2
        WHERE R2.dia BETWEEN '01/01/2002' AND '31/12/2002'
    );

-- 4. Listar los guías (codigo, nombre y apellido) que fueron asignados a más de 10 tipos de visita distintos y con una cantidad total real de alumnos que guiaron, mayor a 200. LISTO
SELECT
    G.idguia,
    G.nombre
FROM 
    guia G
WHERE
    G.idguia IN (
        SELECT DISTINCT
            RTV.guia_idguia
        FROM Reserva_tipo_visita RTV
        GROUP BY RTV.guia_idguia
        HAVING
            COUNT(DISTINCT RTV.Tipo_visitas_idTipo_visitas) > 10
            AND SUM(RTV.antidad_Alumnos_Reales) > 200
    );

-- 5. Listar las escuelas que poseen más de 4 reservas con más de 3 tipos de visitas para cada reserva. LISTO
SELECT 
    R.Escuela_idEscuela
FROM 
    Reserva R
WHERE 
    R.idReserva IN (
        SELECT RTV.Reserva_idReserva
        FROM Reserva_tipo_visita RTV
        GROUP BY RTV.Reserva_idReserva
        HAVING COUNT(DISTINCT RTV.Tipo_visitas_idTipo_visitas) > 3
    )
GROUP BY R.Escuela_idEscuela
HAVING COUNT(R.idReserva) > 4;

-- 6. Listar el nombre, apellido y código de aquellos guías que, en alguna visita de una reserva en particular, hayan atendido por lo menos al 40% de los alumnos totales guiados en todas sus visitas.
SELECT RTV.guia_idguia
FROM Reserva_tipo_visita RTV
WHERE RTV.guia_idguia IN 
        (SELECT RTV1.guia_idguia
            FROM Reserva_tipo_visita as RTV1
            GROUP BY RTV1.guia_idguia
            HAVING SUM(cantidad_alumnos_reales) * 0.40 < ANY 
                (SELECT RTV2.cantidad_alumnos_reales
                FROM Reserva_tipo_visita as RTV2
                WHERE RTV2.guia_idguia = RTV1.guia_idguia)
        );

-- 7. Listar las reservas donde todos los tipos de visita tienen la cantidad real de alumnos mayor en un 20% adicional a la cantidad reservada. LISTO
SELECT
    RTV.Reserva_idReserva
FROM 
    Reserva_tipo_visita RTV
GROUP BY 
    RTV.Reserva_idReserva
HAVING 
    COUNT(*) = (
        SELECT COUNT(*)
        FROM Reserva_tipo_visita RTV2
        WHERE RTV2.Reserva_idReserva = RTV.Reserva_idReserva
        AND RTV2.Cantidad_Alumnos_Reales > RTV2.Cantidad_alumnos_reservados * 1.20
    );

-- 8. Listar el nombre y el código de aquellas escuelas que hayan asistido el día en que se registró la mayor cantidad de alumnos reales. LISTO
SELECT
    E.idEscuela,
    E.Nombre
FROM
    Escuela E
WHERE
    E.idEscuela IN (
        SELECT
            R.Escuela_idEscuela
        FROM 
            Reserva R
        WHERE
            R.dia = (
                SELECT 
                    R2.dia
                FROM (
                    SELECT 
                        R2.dia,
                        SUM(RTV2.Cantidad_Alumnos_Reales) AS Total_Alumnos
                    FROM 
                        Reserva R2
                    INNER JOIN Reserva_tipo_visita RTV2 
                    ON R2.idReserva = RTV2.Reserva_idReserva
                    GROUP BY 
                        R2.dia
                    ORDER BY 
                        Total_Alumnos DESC
                    LIMIT 1
                ) AS MaxDia
            )
    );


-- 9. Listar el código y nombre de las escuelas cuya fecha de reserva sea igual a la primera fecha de reserva realizada. LISTO
SELECT
    E.idEscuela,
    E.Nombre
FROM
    Escuela E
WHERE
    E.idEscuela IN (
        SELECT
            R.Escuela_idEscuela
        FROM
            Reserva R
        WHERE
            R.dia = (
                SELECT MIN(R2.dia)  -- Obtener la fecha mínima
                FROM Reserva R2
				WHERE R2.Escuela_idEscuela = R.Escuela_idEscuela
            )
    );

-- 10. Listar las escuelas que visitaron entre los años 2001 y en el 2002. LISTO
SELECT
    E.idEscuela,
    E.Nombre
FROM
    Escuela E
WHERE
    E.idEscuela EXISTS (
                    SELECT
                        R.Escuela_idEscuela
                    FROM
                        Reserva R
                    WHERE
                        R.dia BETWEEN '01/01/2001' AND '31/12/2001'
                ) AND EXISTS (
                        SELECT
                            R.Escuela_idEscuela
                        FROM
                            Reserva R
                        WHERE
                            R.dia BETWEEN '01/01/2002' AND '31/12/2002'
                    )

-- 11. Listar los guías que tuvieron más de 3 escuelas diferentes y una cantidad total real de alumnos mayor a 200. LISTO
    SELECT
        RTV1.guia_idguia
    FROM
        Reserva_tipo_visita RTV1
    JOIN
        Reserva R ON RTV1.Reserva_idReserva = R.idReserva
    GROUP BY
        RTV1.guia_idguia
    HAVING
        COUNT(DISTINCT R.Escuela_idEscuela) > 3
        AND SUM(RTV1.Cantidad_Alumnos_Reales) > 200

-- 12. Listar los nombres y códigos de escuelas con gasto total de todas las visitas mayor a $1900. LISTO
SELECT
    E.idEscuela,
    E.Nombre
FROM
    Escuela E
WHERE
    E.idEscuela IN (
        SELECT
            R.Escuela_idEscuela
        FROM
            Reserva R
        WHERE
            R.idReserva IN (
                SELECT
                    RTV.Reserva_idReserva
                FROM
                    Reserva_tipo_visita RTV
                GROUP BY
                    RTV.Reserva_idReserva
                HAVING
                    SUM(RTV.Cantidad_Alumnos_Reales * RTV.arancel_por_alumno) > 1900
            )
    );

-- 13. Listar los guías que hayan tenido en solo un tipo de visita de una reserva en particular por lo menos el 45% del total de alumnos totales que esa persona atendió. LISTO
SELECT *
FROM Guia G
WHERE 
    G.idguia IN (
        SELECT Re_tipo1.guia_idguia
        FROM Reserva_tipo_visita Re_tipo1
        INNER JOIN Reserva Re1 ON Re_tipo1.Reserva_idReserva = Re1.idReserva
        WHERE YEAR(Re1.dia) = 2024
        GROUP BY 
            Re_tipo1.guia_idguia, Re_tipo1.tipo_visita
        HAVING 
            SUM(Re_tipo1.Cantidad_Alumnos_Reales) >= (
                SELECT SUM(Re_tipo2.Cantidad_Alumnos_Reales) * 0.45
                FROM Reserva_tipo_visita Re_tipo2
                WHERE Re_tipo2.guia_idguia = Re_tipo1.guia_idguia
                AND YEAR(Re1.dia) = 2024
            )
            AND COUNT(DISTINCT Re_tipo1.tipo_visita) = 1
    );