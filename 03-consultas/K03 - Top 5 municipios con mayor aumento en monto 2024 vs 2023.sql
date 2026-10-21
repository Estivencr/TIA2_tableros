-- K03 - Top 5 municipios con mayor aumento en monto 2024 vs 2023

WITH montos_por_municipio AS (
    SELECT
        id_municipio,
        municipio,
        departamento,
        SUM(CASE WHEN LEFT(fecha, 4) = '2023' THEN venta ELSE 0 END) AS monto_2023,
        SUM(CASE WHEN LEFT(fecha, 4) = '2024' THEN venta ELSE 0 END) AS monto_2024
    FROM vista_operaciones
    WHERE LEFT(fecha, 4) IN ('2023', '2024')
    GROUP BY id_municipio, municipio, departamento
)
SELECT
    municipio,
    departamento,
    monto_2023,
    monto_2024,
    monto_2024 - monto_2023 AS aumento_monto,
    ROUND((monto_2024 - monto_2023) * 100.0 / NULLIF(monto_2023, 0), 2) AS crecimiento_porcentaje
FROM montos_por_municipio
WHERE monto_2023 > 0
  AND monto_2024 > monto_2023
ORDER BY aumento_monto DESC
LIMIT 5;
