-- ¿Qué se cuenta o qué se suma? 
-- ¿ ¿Por qué agrupamos, en qué?
-- ¿Se requiere filtrar?
-- ¿Cómo se ordena? 

-- 5 departamentos con menor monto de venta en 2024
SELECT 
	departamento, 
	SUM(venta) as monto_2024
FROM vista_operaciones
WHERE LEFT(fecha, 4) = '2024'
GROUP BY id_departamento, departamento
ORDER BY monto_2024 ASC
LIMIT 5; 