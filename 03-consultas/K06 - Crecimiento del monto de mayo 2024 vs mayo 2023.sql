-- K06 Crecimiento del monto de mayo 2024 vs mayo 2023
WITH montos AS (
    SELECT
        SUM(CASE WHEN LEFT(fecha, 4) = '2023' THEN venta ELSE 0 END) AS monto_2023,
        SUM(CASE WHEN LEFT(fecha, 4) = '2024' THEN venta ELSE 0 END) AS monto_2024
    FROM vista_operaciones
    WHERE SUBSTRING(fecha FROM 6 FOR 2) = '05'          -- mayo
      AND LEFT(fecha, 4) IN ('2023', '2024')
)
SELECT
    monto_2023,
    monto_2024,
    monto_2024 - monto_2023 AS diferencia_monto,
    ROUND((monto_2024 - monto_2023) * 100.0 / NULLIF(monto_2023, 0), 2) AS crecimiento_porcentaje
FROM montos;