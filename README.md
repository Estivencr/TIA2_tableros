# Tarea 4 · Tableros de Mando — Gaseosas Poderosas

¿De qué se trata?

La empresa Gaseosas Poderosas quiere saber cómo le fue en ventas comparando un año contra el anterior. Nuestro trabajo es:

Preparar los datos de ventas (limpios y completos).
Calcular métricas (cuánto se vendió) y KPI (qué tan bien nos fue comparado con el año anterior).
Diseñar un CMI (Cuadro de Mando Integral: el plan estratégico) y un Dashboard (los gráficos).
Montar el Dashboard en Metabase y Tableau Public.

---
 
## Estructura del repositorio
 
```
TIA2_tableros/
├── 00-referencia/      Instructivo, rúbrica, guías y anexos del profesor (solo lectura)
├── 01-datos/           Ventas 2023 y 2024 + nuestro ETL de limpieza
│   ├── operaciones-2023.sql
│   ├── script-base-datos-operaciones.sql   ← 2024 SUCIO (no cargar)
│   ├── etl_limpieza_2024.py                ← nuestro programa de limpieza
│   └── operaciones-2024-limpia.sql         ← 2024 LIMPIO (este sí se carga)
├── 02-base-de-datos/   Scripts para crear la base de datos
│   ├── script-base-datos-creacion.sql      ← crea las tablas y los 4 productos
│   ├── script-base-datos-vista.sql         ← crea vista_operaciones
│   ├── script-base-datos-valida-fecha.sql  ← consultas para revisar fechas
│   ├── algoritmo-etl.py                    ← ETL del profesor: llena departamentos y municipios
│   └── colombia-dane-departamentos.csv     ← datos que usa el ETL del profesor
├── 03-consultas/       Consultas SQL de métricas y KPI (pendiente)
├── 04-cmi-dashboard/   Hoja de cálculo del CMI y diseño del Dashboard (pendiente)
├── 05-capturas/        Pantallazos de Metabase y Tableau (pendiente)
└── 06-informe/         Informe en Word
```
 
---
## Qué necesitas instalado
 
- **PostgreSQL** y **pgAdmin**
- **Python 3**
- Librerías para el ETL:
```
  pip install psycopg2 pandas
```
 
---

## Cómo armar la base de datos (paso a paso)
 
1. **Crear la base de datos** en pgAdmin con el nombre exacto `bigdata` (el ETL busca ese nombre).
2. **Crear las tablas:** abrir el *Query Tool* sobre `bigdata` y ejecutar `02-base-de-datos/script-base-datos-creacion.sql`.
3. **Llenar departamentos y municipios:** ejecutar `algoritmo-etl.py` desde la carpeta `02-base-de-datos/`.
   Antes, abre el archivo y pon **tu** usuario y contraseña de PostgreSQL (líneas ~50-54).
4. **Cargar las ventas:** ejecutar en el *Query Tool*:
   - `01-datos/operaciones-2023.sql`
   - `01-datos/operaciones-2024-limpia.sql`
5. **Crear la vista:** ejecutar `02-base-de-datos/script-base-datos-vista.sql`.
6. **Verificar:**
```sql
   SELECT COUNT(*) FROM operaciones;        -- debe dar 20000
   SELECT COUNT(*) FROM vista_operaciones;  -- debe dar 20000
```
   Si la vista da menos de 20.000, hay ventas con algún código (departamento, municipio o producto) que no existe en las tablas.

## EL etl_limpieza_2024.py
Es para corregir los errores de operaciones-2024.sql (fechas malas, id_malos y datos sucios)
Para ejecutarlo, desde la carpeta `01-datos/`:
 
```
python etl_limpieza_2024.py
```
 
Lee `script-base-datos-operaciones.sql` y genera `operaciones-2024-limpia.sql`.
