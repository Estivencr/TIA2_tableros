-- -- M05 Total de cantidades vendidas por producto en la Región Centro Sur (2023 y 2024 de forma separada)

SELECT
    producto,
    LEFT(fecha, 4) AS anio,
    SUM(cantidad) AS total_unidades
FROM vista_operaciones
WHERE id_departamento IN (
        SELECT id_departamento
        FROM departamentos
        WHERE codigo_region = 3
      )
GROUP BY id_producto, producto, LEFT(fecha, 4)
ORDER BY producto, anio;