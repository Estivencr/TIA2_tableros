UPDATE operaciones o
SET id_region = d.codigo_region
FROM departamentos d
WHERE d.id_departamento = o.id_departamento
  AND o.id_region IS NULL;

UPDATE operaciones
SET modificado = false
WHERE modificado IS NULL;