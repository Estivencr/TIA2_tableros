-- M06 - Unidades vendidas por mes 2024

SELECT
    LEFT(fecha, 7) AS mes,
    SUM(cantidad) AS total_unidades
FROM vista_operaciones
WHERE LEFT(fecha, 4) = '2024'
GROUP BY LEFT(fecha, 7)
ORDER BY mes;