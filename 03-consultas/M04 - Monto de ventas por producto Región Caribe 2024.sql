-- M04 Total de montos de ventas por producto en la Región Caribe en 2024
-- La vista no tiene regiones, es mejor revisar dicha tabla primero
SELECT * FROM regiones; 

-- La región caribe tiene el ID 4. 
SELECT 
	id_departamento, 
	nombre
FROM departamentos
WHERE codigo_region = 4;

-- Teniendo la subconsulta anterior entonces completamos 
SELECT
    producto,
    SUM(venta) AS total_ventas_2024
FROM vista_operaciones
WHERE LEFT(fecha, 4) = '2024'
  AND id_departamento IN (
        SELECT id_departamento
        FROM departamentos
        WHERE codigo_region = 4
      )
GROUP BY id_producto, producto
ORDER BY total_ventas_2024 DESC;



