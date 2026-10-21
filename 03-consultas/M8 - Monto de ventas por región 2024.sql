-- M08 - Monto de ventas por región 2024
SELECT 
    r.nombre as region,
    SUM(venta) AS monto_2024
FROM vista_operaciones vo
JOIN departamentos d ON d.id_departamento = vo.id_departamento
JOIN regiones r ON r.id_region = d.codigo_region
WHERE LEFT(fecha, 4) = '2024'
GROUP BY region
ORDER BY monto_2024 DESC;