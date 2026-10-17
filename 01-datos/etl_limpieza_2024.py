import re 

ARCHIVO = "operaciones-2024.sql"

filas = []

with open(ARCHIVO, encoding="utf-8") as archivo:
    for linea in archivo:
        if linea.startswith("INSERT INTO"):
            valores = re.search(r"VALUES \((.*)\)", linea).group(1)
            partes = [p.strip().strip("'") for p in valores.split(",")]
            filas.append(partes)

print("Registros leídos: ", len(filas))

for fila in filas[:3]:
    print(fila)
## fechas ---------------------------------------------------------------------------------------------------
## Para el formato de las fechas
formato_fecha = re.compile(r"(\d{4})-(\d{2})-(\d{2})")

fechas_malas = []
for fila in filas:
    fecha = fila[4]  # id, departamento, municipio, producto, fecha, cantidad, estado
    if not formato_fecha.match(fecha):
        fechas_malas.append(fila)

print("\nRegistros con fechas incorrectas: ", len(fechas_malas))
for fila in fechas_malas:
    print(fila)

## Corregir las fechas que estan mal, se dividiran en diferentes casos
def normalizar_fecha(fecha):
    partes = fecha.split("-")

    # Paso 1: ¿dónde está el año?
    if partes[0].endswith("24"):       # año al principio: 2024, 024 o 24
        mes, dia = partes[1], partes[2]
    else:                              # año al final → convención colombiana día-mes
        dia, mes = partes[0], partes[1]

    # Paso 2: ningún mes pasa de 12; si pasa, en realidad es el día
    if int(mes) > 12:
        mes, dia = dia, mes

    # Paso 3: armar la fecha con el año completo y ceros a la izquierda
    return f"2024-{mes.zfill(2)}-{dia.zfill(2)}"

# Corregir las fechas malas
for fila in fechas_malas:
    fila[4] = normalizar_fecha(fila[4])

# Verificación final: volver a buscar fechas malas en TODAS las filas
fechas_malas_restantes = [fila for fila in filas if not formato_fecha.match(fila[4])]
print("\nFechas malas después de corregir:", len(fechas_malas_restantes))


## -------------------------------------------Cantidades-------------------------------------------------
## Para validar las cantidades 
cantidades_malas = []
for fila in filas:
    cantidad = fila[5]
    try:
        cantidad_num = int(cantidad)
        if cantidad_num <= 0:
            cantidades_malas.append(fila)
    except ValueError:
        cantidades_malas.append(fila)

print("\nCantidades malas:", len(cantidades_malas))
for fila in cantidades_malas:
    print(fila)

## corregir cantidades negativas
for fila in cantidades_malas:
    fila[5] = str(abs(int(fila[5])))  # Convertir la cantidad a positiva

## corregir cantidades en ceros
sumas = {}
conteos = {}

for fila in filas:
    municipio = fila[2]
    cantidad = int(fila[5])
    if cantidad > 0:
        sumas[municipio] = sumas.get(municipio, 0) + cantidad
        conteos[municipio] = conteos.get(municipio, 0) + 1

for fila in cantidades_malas:
    municipio = fila[2]
    if fila[5] == "0" and municipio in sumas and conteos[municipio] > 0:
        promedio = sumas[municipio] // conteos[municipio]
        fila[5] = str(promedio)  # Asignar el promedio calculado


print("\nCantidades Malas Corregidas:", len(cantidades_malas))
for fila in cantidades_malas:
    print(fila)


## -------------------------------------------Id_producto-------------------------------------------------
## Para validar id_producto
productos_malos = []
productos_validos = {"1", "2", "3", "4"} # Ejemplo de productos válidos

for fila in filas:
    id_producto = fila[3]
    if id_producto not in productos_validos:
        productos_malos.append(fila)

print("\nProductos malos:", len(productos_malos))
for fila in productos_malos:
    print(fila)

## corregir los productos en ceros
for fila in productos_malos:
    if fila[2] == "5705108": # Regla de negocio: en Támesis (5705108) solo se vende NARANJITA (4).
        fila[3] = "4"  # Asignar un producto válido por defecto

print("\nProductos malos corregidos:", len(productos_malos))
for fila in productos_malos:
    print(fila)


## -------------------------------------------Id_departamento-------------------------------------------------
## Valida que el id_departamento este correcto, id_departamento contiene el id_municipio.
id_departamentos_malos = []
for fila in filas:
    id_departamento = fila[1]
    id_municipio = fila[2]
    if not id_municipio.startswith(id_departamento):
        id_departamentos_malos.append(fila)

print("\nDepartamentos malos:", len(id_departamentos_malos))
for fila in id_departamentos_malos:
    print(fila)

## Corregir los id_departamentos malos
for fila in id_departamentos_malos:
    id_municipio = fila[2] # id, departamento, municipio, producto, fecha, cantidad, estado
    fila[1] = id_municipio[:4]  # Asumiendo que los primeros cuatro dígitos del id_municipio son el id_departamento

print("\nDepartamentos malos Corregidos:", len(id_departamentos_malos))
for fila in id_departamentos_malos:
    print(fila)


## -------------------------------------------Verificación final----------------------------------------------
print("\n=== VERIFICACIÓN FINAL (todas las filas) ===")
print("Fechas malas:       ", sum(1 for f in filas if not formato_fecha.match(f[4])))
print("Cantidades <= 0:    ", sum(1 for f in filas if int(f[5]) <= 0))
print("Productos inválidos:", sum(1 for f in filas if f[3] not in productos_validos))
print("Departamentos malos:", sum(1 for f in filas if not f[2].startswith(f[1])))
print("Total de filas:     ", len(filas))


## ------------------------------------------- Guardar los datos limpios ----------------------------------------------
with open("operaciones-2024-limpia.sql", "w", encoding="utf-8") as salida:
    for f in filas:
        salida.write(
            "INSERT INTO public.operaciones "
            "(id_registro, id_departamento, id_municipio, id_producto, fecha, cantidad, estado) "
            f"VALUES ({f[0]}, {f[1]}, {f[2]}, {f[3]}, '{f[4]}', {f[5]}, '{f[6]}');\n"
        )

print("\nArchivo limpio creado: operaciones-2024-limpia.sql")



