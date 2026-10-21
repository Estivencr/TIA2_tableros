-- M07 - Participación de cada producto en el monto 2024

SELECT
    producto,
    SUM(venta) AS monto_2024,
    ROUND(SUM(venta) * 100.0 / (SELECT 
        SUM(venta) AS total_ventas_2024
        FROM vista_operaciones
        WHERE LEFT(fecha, 4) = '2024'), 2) AS participacion_pct
FROM vista_operaciones
WHERE LEFT(fecha, 4) = '2024'
GROUP BY id_producto, producto
ORDER BY participacion_pct DESC;