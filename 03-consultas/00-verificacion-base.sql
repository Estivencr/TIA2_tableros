SELECT 'departamentos' AS tabla, COUNT(*) AS registros FROM departamentos
UNION ALL SELECT 'municipios',  COUNT(*) FROM municipios
UNION ALL SELECT 'regiones',    COUNT(*) FROM regiones
UNION ALL SELECT 'productos',   COUNT(*) FROM productos
UNION ALL SELECT 'operaciones', COUNT(*) FROM operaciones;

SELECT LEFT(fecha, 4) AS anio,
       COUNT(*) AS registros,
       MIN(id_registro) AS primer_id,
       MAX(id_registro) AS ultimo_id
FROM operaciones
GROUP BY LEFT(fecha, 4)
ORDER BY anio;

SELECT
  COUNT(*) FILTER (WHERE fecha !~ '^\d{4}-\d{2}-\d{2}$')                          AS fechas_malas,
  COUNT(*) FILTER (WHERE cantidad <= 0)                                           AS cantidades_malas,
  COUNT(*) FILTER (WHERE id_producto NOT IN (1, 2, 3, 4))                         AS productos_malos,
  COUNT(*) FILTER (WHERE LEFT(id_municipio::text, 4) <> id_departamento::text)    AS departamentos_malos
FROM operaciones;


SELECT
  COUNT(*) FILTER (WHERE d.id_departamento IS NULL) AS ventas_sin_departamento,
  COUNT(*) FILTER (WHERE m.id_municipio IS NULL)    AS ventas_sin_municipio
FROM operaciones o
LEFT JOIN departamentos d ON d.id_departamento = o.id_departamento
LEFT JOIN municipios    m ON m.id_municipio    = o.id_municipio;

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'operaciones'
ORDER BY ordinal_position;

SELECT table_name
FROM information_schema.views
WHERE table_schema = 'public';

SELECT LEFT(fecha, 4) AS anio, COUNT(*) AS registros,
       COUNT(id_region) AS con_region
FROM operaciones
GROUP BY LEFT(fecha, 4)
ORDER BY anio;

SELECT (SELECT COUNT(*) FROM operaciones)       AS en_tabla,
       (SELECT COUNT(*) FROM vista_operaciones) AS en_vista;