-- M07 - Participación de cada producto en el monto 2024
SELECT 
	r.nombre as region,
	SUM(vo.venta) AS monto_2024
FROM vista_operaciones vo
JOIN departamentos d ON d.id_departamento = vo.id_departamento
JOIN regiones r ON r.id_region = d.codigo_region
WHERE LEFT(vo.fecha, 4) = '2024'
GROUP BY r.id_region, r.nombre
ORDER BY monto_2024 DESC;