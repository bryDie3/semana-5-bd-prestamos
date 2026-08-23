-- ==========================================
-- SEMANA 5: Pruebas intencionalmente inválidas
-- ==========================================
-- Cada prueba está comentada para explicar la regla que se espera validar.
-- Si la restricción funciona correctamente, todas estas consultas fallarán.

-- ==========================================
-- PRUEBA 1: Violación de UNIQUE (correo de prestatario)
-- Regla: El correo de un prestatario identifica una cuenta y no puede repetirse.
-- ==========================================
INSERT INTO PRESTATARIO (nombre, correo, telefono)
VALUES ('Pedro Sánchez Ruiz', 'maria.gonzalez@universidad.edu', '+52-555-0103');
-- ERROR ESPERADO: duplicate key value violates unique constraint "prestatario_correo_key"

-- ==========================================
-- PRUEBA 2: Violación de CHECK (cantidad > 0)
-- Regla: La cantidad prestada debe ser mayor que cero.
-- ==========================================
INSERT INTO DETALLE_PRESTAMO (prestamo_id, equipo_codigo, cantidad, observaciones)
VALUES (1, 'TRI-001', 0, 'Cantidad cero no permitida');
-- ERROR ESPERADO: new row for relation "detalle_prestamo" violates check constraint "detalle_prestamo_cantidad_check"

-- ==========================================
-- PRUEBA 3: Violación de FOREIGN KEY (referencia inexistente)
-- Regla: Cada detalle de préstamo debe referenciar un préstamo y un equipo existentes.
-- ==========================================
INSERT INTO DETALLE_PRESTAMO (prestamo_id, equipo_codigo, cantidad, observaciones)
VALUES (999, 'CAM-001', 1, 'Préstamo 999 no existe');
-- ERROR ESPERADO: insert or update on table "detalle_prestamo" violates foreign key constraint "detalle_prestamo_prestamo_id_fkey"

-- ==========================================
-- PRUEBA ADICIONAL: Violación de dominio de estado
-- Regla: El estado debe limitarse a valores válidos definidos.
-- ==========================================
INSERT INTO PRESTAMO (prestatario_id, fecha_prestamo, fecha_devolucion_prevista, estado)
VALUES (1, '2024-02-01', '2024-02-05', 'pendiente');
-- ERROR ESPERADO: invalid input value for enum estado_prestamo: "pendiente"
