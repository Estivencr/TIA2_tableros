-- K05 Crecimiento del monto de MANZALOCA en Antioquia 2024 vs 2023
WITH montos AS (
    SELECT
        SUM(CASE WHEN LEFT(fecha, 4) = '2023' THEN venta ELSE 0 END) AS monto_2023,
        SUM(CASE WHEN LEFT(fecha, 4) = '2024' THEN venta ELSE 0 END) AS monto_2024
    FROM vista_operaciones
    WHERE id_producto = 2              -- MANZALOCA
      AND id_departamento = 5705       -- Antioquia
      AND LEFT(fecha, 4) IN ('2023', '2024')
)
SELECT
    monto_2023,
    monto_2024,
    monto_2024 - monto_2023 AS diferencia_monto,
    ROUND((monto_2024 - monto_2023) * 100.0 / NULLIF(monto_2023, 0), 2) AS crecimiento_porcentaje
FROM montos;