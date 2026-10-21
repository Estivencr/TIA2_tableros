-- K04 Los 5 departamentos del Caribe con peor desempeño en unidades de NARANJITA 2024 vs 2023
-- Criterio: menor crecimiento porcentual (compara de forma justa departamentos de distinto tamaño)
WITH unidades_por_departamento AS (
    SELECT
        id_departamento,
        departamento,
        SUM(CASE WHEN LEFT(fecha, 4) = '2023' THEN cantidad ELSE 0 END) AS unidades_2023,
        SUM(CASE WHEN LEFT(fecha, 4) = '2024' THEN cantidad ELSE 0 END) AS unidades_2024
    FROM vista_operaciones
    WHERE id_producto = 4                      -- NARANJITA
      AND id_departamento IN (
            SELECT id_departamento FROM departamentos WHERE codigo_region = 4   -- Región Caribe
          )
      AND LEFT(fecha, 4) IN ('2023', '2024')
    GROUP BY id_departamento, departamento
)
SELECT
    departamento,
    unidades_2023,
    unidades_2024,
    unidades_2024 - unidades_2023 AS diferencia_unidades,
    ROUND((unidades_2024 - unidades_2023) * 100.0 / NULLIF(unidades_2023, 0), 2) AS crecimiento_porcentaje
FROM unidades_por_departamento
WHERE unidades_2023 > 0
ORDER BY crecimiento_porcentaje ASC, id_departamento
LIMIT 5;