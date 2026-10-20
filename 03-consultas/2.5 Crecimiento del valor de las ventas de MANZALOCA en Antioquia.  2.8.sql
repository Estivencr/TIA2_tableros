WITH datos AS (
    SELECT
        LEFT(fecha, 4) AS anio,
        SUBSTRING(fecha FROM 6 FOR 2) AS mes,
        producto,
        departamento,
        venta
    FROM public.vista_operaciones
    WHERE LEFT(fecha, 4) IN ('2023', '2024')
),
indicadores AS (
    SELECT
        '2.5 MANZALOCA en Antioquia' AS indicador,
        anio,
        venta
    FROM datos
    WHERE producto = 'MANZALOCA'
      AND departamento = 'Antioquia'

    UNION ALL

    SELECT
        '2.6 Ventas de mayo',
        anio,
        venta
    FROM datos
    WHERE mes = '05'

    UNION ALL

    SELECT
        '2.7 Ventas del primer trimestre',
        anio,
        venta
    FROM datos
    WHERE mes IN ('01', '02', '03')

    UNION ALL

    SELECT
        '2.8 Ventas del cuarto trimestre',
        anio,
        venta
    FROM datos
    WHERE mes IN ('10', '11', '12')
),
totales AS (
    SELECT
        indicador,
        SUM(CASE WHEN anio = '2023'
                 THEN venta ELSE 0 END) AS ventas_2023,
        SUM(CASE WHEN anio = '2024'
                 THEN venta ELSE 0 END) AS ventas_2024
    FROM indicadores
    GROUP BY indicador
)
SELECT
    indicador,
    ventas_2023,
    ventas_2024,
    ventas_2024 - ventas_2023 AS diferencia_ventas,
    ROUND(
        (ventas_2024 - ventas_2023) * 100.0
        / NULLIF(ventas_2023, 0),
        2
    ) AS crecimiento_porcentaje
FROM totales
ORDER BY indicador;