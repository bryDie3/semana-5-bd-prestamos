# Semana 5: Modelo Relacional - Préstamos de Equipo Audiovisual

## Propósito

Transformar un conjunto de datos desordenado en un modelo relacional completo en PostgreSQL, implementar restricciones que protejan las reglas del negocio y demostrar su funcionamiento mediante pruebas válidas e inválidas.

## Estructura del repositorio

```
semana-5-modelo-relacional/
├── README.md
├── compose.yaml
├── .env.example
├── .gitignore
├── modelo.mmd
├── schema.sql
├── seed.sql
└── validation.sql
```

## Requisitos

- Docker Desktop o Docker Engine
- Docker Compose (incluido en Docker Desktop)
- Cliente de PostgreSQL (opcional, para consultas manuales)

## Cómo crear el archivo local de ambiente

1. Copie el archivo `.env.example` como `.env`:
   ```bash
   cp .env.example .env
   ```

2. Edite `.env` si necesita cambiar credenciales o puertos. Valores por defecto:
   ```env
   POSTGRES_USER=postgres
   POSTGRES_PASSWORD=postgres
   POSTGRES_DB=prestamos_audiovisuales
   POSTGRES_PORT=5432
   ```

## Cómo iniciar PostgreSQL

1. Inicie el contenedor con Docker Compose:
   ```bash
   docker compose up -d
   ```

2. Verifique que el contenedor esté en ejecución:
   ```bash
   docker compose ps
   ```

3. El script `schema.sql` se ejecuta automáticamente al iniciar el contenedor gracias al volumen montado en `/docker-entrypoint-initdb.d/`.

## Orden para ejecutar los scripts

Los scripts se ejecutan automáticamente en orden al crear el contenedor:

1. `schema.sql` - Crea tablas, restricciones, dominios e índices.
2. `seed.sql` - Inserta datos válidos de prueba.
3. `validation.sql` - Ejecuta pruebas intencionalmente inválidas (verá errores esperados).

Si desea ejecutarlos manualmente:

```bash
docker compose exec postgres psql -U postgres -d prestamos_audiovisuales -f /docker-entrypoint-initdb.d/01-schema.sql
docker compose exec postgres psql -U postgres -d prestamos_audiovisuales -f /docker-entrypoint-initdb.d/02-seed.sql
docker compose exec postgres psql -U postgres -d prestamos_audiovisuales -f /docker-entrypoint-initdb.d/03-validation.sql
```

## Cómo comprobar la base y el usuario activos

1. Conéctese a PostgreSQL:
   ```bash
   docker compose exec postgres psql -U postgres -d prestamos_audiovisuales
   ```

2. Verifique las tablas:
   ```sql
   \dt
   ```

3. Verifique la versión de PostgreSQL:
   ```sql
   SELECT version();
   ```

4. Verifique el usuario activo:
   ```sql
   SELECT current_user;
   ```

## Decisiones importantes del modelo

### Entidades y relaciones

- **PRESTATARIO**: Almacena la información de las personas que solicitan préstamos. El correo es único.
- **EQUIPO**: Almacena los equipos audiovisuales disponibles. El código es único.
- **PRESTAMO**: Registro principal de un préstamo. Pertenece a un prestatario.
- **DETALLE_PRESTAMO**: Tabla intermedia que permite un préstamo con múltiples equipos.

### Restricciones aplicadas

| Regla de negocio | Restricción implementada |
|------------------|--------------------------|
| Correo no repetido | `UNIQUE` en `PRESTATARIO.correo` |
| Código de equipo único | `PRIMARY KEY` en `EQUIPO.codigo` |
| Cantidad mayor que cero | `CHECK (cantidad > 0)` en `DETALLE_PRESTAMO` |
| Estado válido | Dominio `estado_prestamo` con valores: activo, finalizado, cancelado, vencido |
| Campos obligatorios | `NOT NULL` en columnas requeridas |
| Integridad referencial | `FOREIGN KEY` con `ON DELETE CASCADE` |
| Fecha real opcional | Columna nullable para préstamos activos |

### Transformación del modelo original

El archivo plano original repetía datos del prestatario y del equipo en cada fila, generando:
- **Anomalías de inserción**: No se podía registrar un préstamo sin repetir datos.
- **Anomalías de actualización**: Cambiar el correo requería modificar múltiples filas.
- **Anomalías de eliminación**: Borrar una fila podía perder información parcial del préstamo.

El modelo relacional resuelve estas anomalías normalizando las entidades.
