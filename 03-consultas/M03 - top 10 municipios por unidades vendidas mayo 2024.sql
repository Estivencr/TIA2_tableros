-- M03 los 10 municipios con mayores cantidades de unidades vendidas en mayo de 2024

SELECT 
	municipio, 
	departamento, 
	SUM(cantidad) AS unidades_mayo_2024
FROM vista_operaciones
WHERE LEFT(fecha, 7) = '2024-05'
GROUP BY id_municipio, municipio, departamento
ORDER BY unidades_mayo_2024 DESC
LIMIT 10; 