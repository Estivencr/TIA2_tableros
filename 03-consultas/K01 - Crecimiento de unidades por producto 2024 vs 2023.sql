WITH ventas_por_producto AS (
   SELECT
       id_producto,
       producto,
       SUM(
           CASE
               WHEN LEFT(fecha, 4) = '2023' THEN cantidad
               ELSE 0
           END
       ) AS unidades_2023,
       SUM(
           CASE
               WHEN LEFT(fecha, 4) = '2024' THEN cantidad
               ELSE 0
           END
       ) AS unidades_2024
   FROM public.vista_operaciones
   WHERE LEFT(fecha, 4) IN ('2023', '2024')
   GROUP BY id_producto, producto
)
SELECT
   producto,
   unidades_2023,
   unidades_2024,
   unidades_2024 - unidades_2023 AS aumento_unidades,
   ROUND(
       (unidades_2024 - unidades_2023) * 100.0
       / NULLIF(unidades_2023, 0),
       2
   ) AS crecimiento_porcentaje
FROM ventas_por_producto
WHERE unidades_2024 > unidades_2023
ORDER BY
   (unidades_2024 - unidades_2023) * 100.0
   / NULLIF(unidades_2023, 0) DESC NULLS LAST,
   id_producto;
