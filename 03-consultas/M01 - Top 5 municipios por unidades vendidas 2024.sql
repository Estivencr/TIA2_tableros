-- Los cinco municipios con mayor cantidad de gaseosas vendidas en 2024.

SELECT 
	municipio, 
	departamento, 
	sum(cantidad) as unidades_2024
FROM vista_operaciones
WHERE LEFT(fecha, 4) = '2024'
GROUP BY id_municipio, municipio, departamento
ORDER BY unidades_2024 DESC
LIMIT 5; 