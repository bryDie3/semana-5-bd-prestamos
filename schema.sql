-- ==========================================
-- SEMANA 5: Modelo Relacional - Préstamos de Equipo Audiovisual
-- Esquema completo con restricciones
-- ==========================================

-- 1. Crear dominio para estado de préstamo
CREATE DOMAIN estado_prestamo AS VARCHAR(20)
    CHECK (VALUE IN ('activo', 'finalizado', 'cancelado', 'vencido'));

COMMENT ON DOMAIN estado_prestamo IS 'Estados válidos para un préstamo: activo, finalizado, cancelado, vencido.';

-- 2. Tabla PRESTATARIO
CREATE TABLE PRESTATARIO (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(150) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE PRESTATARIO IS 'Persona que solicita préstamos de equipo audiovisual.';
COMMENT ON COLUMN PRESTATARIO.id IS 'Identificador único del prestatario.';
COMMENT ON COLUMN PRESTATARIO.nombre IS 'Nombre completo del prestatario.';
COMMENT ON COLUMN PRESTATARIO.correo IS 'Correo electrónico único que identifica la cuenta del prestatario.';
COMMENT ON COLUMN PRESTATARIO.telefono IS 'Teléfono de contacto del prestatario.';

-- 3. Tabla EQUIPO
CREATE TABLE EQUIPO (
    codigo VARCHAR(20) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    descripcion TEXT,
    disponible BOOLEAN DEFAULT TRUE NOT NULL
);

COMMENT ON TABLE EQUIPO IS 'Equipos audiovisuales disponibles para préstamo.';
COMMENT ON COLUMN EQUIPO.codigo IS 'Código único del equipo.';
COMMENT ON COLUMN EQUIPO.nombre IS 'Nombre descriptivo del equipo.';
COMMENT ON COLUMN EQUIPO.categoria IS 'Categoría a la que pertenece el equipo (cámara, micrófono, trípode, etc.).';
COMMENT ON COLUMN EQUIPO.disponible IS 'Indica si el equipo está disponible para préstamo.';

-- 4. Tabla PRESTAMO
CREATE TABLE PRESTAMO (
    id SERIAL PRIMARY KEY,
    prestatario_id INT NOT NULL REFERENCES PRESTATARIO(id) ON DELETE CASCADE,
    fecha_prestamo DATE NOT NULL DEFAULT CURRENT_DATE,
    fecha_devolucion_prevista DATE NOT NULL,
    fecha_devolucion_real DATE,
    estado estado_prestamo NOT NULL DEFAULT 'activo'
);

COMMENT ON TABLE PRESTAMO IS 'Registro principal de un préstamo de equipos.';
COMMENT ON COLUMN PRESTAMO.id IS 'Identificador único del préstamo.';
COMMENT ON COLUMN PRESTAMO.prestatario_id IS 'Referencia al prestatario que realizó el préstamo.';
COMMENT ON COLUMN PRESTAMO.fecha_prestamo IS 'Fecha en que se realizó el préstamo.';
COMMENT ON COLUMN PRESTAMO.fecha_devolucion_prevista IS 'Fecha límite acordada para la devolución.';
COMMENT ON COLUMN PRESTAMO.fecha_devolucion_real IS 'Fecha real de devolución (NULL mientras el préstamo está activo).';
COMMENT ON COLUMN PRESTAMO.estado IS 'Estado actual del préstamo (activo, finalizado, cancelado, vencido).';

-- 5. Tabla DETALLE_PRESTAMO
CREATE TABLE DETALLE_PRESTAMO (
    id SERIAL PRIMARY KEY,
    prestamo_id INT NOT NULL REFERENCES PRESTAMO(id) ON DELETE CASCADE,
    equipo_codigo VARCHAR(20) NOT NULL REFERENCES EQUIPO(codigo),
    cantidad INT NOT NULL CHECK (cantidad > 0),
    observaciones TEXT
);

COMMENT ON TABLE DETALLE_PRESTAMO IS 'Detalle de equipos incluidos en cada préstamo. Un préstamo puede tener varios equipos.';
COMMENT ON COLUMN DETALLE_PRESTAMO.id IS 'Identificador único del detalle.';
COMMENT ON COLUMN DETALLE_PRESTAMO.prestamo_id IS 'Referencia al préstamo al que pertenece este detalle.';
COMMENT ON COLUMN DETALLE_PRESTAMO.equipo_codigo IS 'Referencia al equipo prestado.';
COMMENT ON COLUMN DETALLE_PRESTAMO.cantidad IS 'Cantidad de unidades del equipo prestadas. Debe ser mayor que cero.';
COMMENT ON COLUMN DETALLE_PRESTAMO.observaciones IS 'Observaciones adicionales sobre el equipo prestado.';

-- ==========================================
-- ÍNDICES PARA MEJORAR CONSULTAS
-- ==========================================
CREATE INDEX idx_prestamo_prestatario ON PRESTAMO(prestatario_id);
CREATE INDEX idx_prestamo_estado ON PRESTAMO(estado);
CREATE INDEX idx_detalle_prestamo ON DETALLE_PRESTAMO(prestamo_id);
CREATE INDEX idx_detalle_equipo ON DETALLE_PRESTAMO(equipo_codigo);
