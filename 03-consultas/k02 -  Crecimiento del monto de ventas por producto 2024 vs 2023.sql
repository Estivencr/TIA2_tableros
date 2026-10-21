-- K02 Productos con incremento en el monto de ventas 2024 vs 2023
WITH montos_por_producto AS (
    SELECT
        id_producto,
        producto,
        SUM(CASE WHEN LEFT(fecha, 4) = '2023' THEN venta ELSE 0 END) AS monto_2023,
        SUM(CASE WHEN LEFT(fecha, 4) = '2024' THEN venta ELSE 0 END) AS monto_2024
    FROM vista_operaciones
    WHERE LEFT(fecha, 4) IN ('2023', '2024')
    GROUP BY id_producto, producto
)
SELECT
    producto,
    monto_2023,
    monto_2024,
    monto_2024 - monto_2023 AS aumento_monto,
    ROUND((monto_2024 - monto_2023) * 100.0 / NULLIF(monto_2023, 0), 2) AS crecimiento_porcentaje
FROM montos_por_producto
WHERE monto_2024 > monto_2023
ORDER BY crecimiento_porcentaje DESC NULLS LAST, id_producto;