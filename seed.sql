-- ==========================================
-- SEMANA 5: Datos válidos de prueba
-- ==========================================

-- Prestatarios (2)
INSERT INTO PRESTATARIO (nombre, correo, telefono) VALUES
    ('María González López', 'maria.gonzalez@universidad.edu', '+52-555-0101'),
    ('Carlos Ramírez Torres', 'carlos.ramirez@universidad.edu', '+52-555-0102');

-- Equipos (4)
INSERT INTO EQUIPO (codigo, nombre, categoria, descripcion, disponible) VALUES
    ('CAM-001', 'Cámara Canon EOS R5', 'Cámara', 'Cámara réflex digital 4K con lente 24-70mm', TRUE),
    ('MIC-001', 'Micrófono Rode NT-USB', 'Micrófono', 'Micrófono condensador USB para podcast y streaming', TRUE),
    ('TRI-001', 'Trípode Manfrotto 190X', 'Trípode', 'Trípode de aluminio profesional con cabeza fluida', TRUE),
    ('PRO-001', 'Proyector Epson PowerLite', 'Proyector', 'Proyector portátil 3000 lúmenes HDMI', TRUE);

-- Préstamos (3)
INSERT INTO PRESTAMO (prestatario_id, fecha_prestamo, fecha_devolucion_prevista, estado) VALUES
    (1, '2024-01-15', '2024-01-20', 'activo'),
    (1, '2024-01-10', '2024-01-17', 'finalizado'),
    (2, '2024-01-18', '2024-01-25', 'activo');

-- Actualizar préstamo finalizado con fecha real de devolución
UPDATE PRESTAMO SET fecha_devolucion_real = '2024-01-16' WHERE id = 2;

-- Detalles de préstamo (5)
INSERT INTO DETALLE_PRESTAMO (prestamo_id, equipo_codigo, cantidad, observaciones) VALUES
    (1, 'CAM-001', 1, 'Incluye lente 50mm adicional'),
    (1, 'MIC-001', 2, 'Se entrega con cables y filtros'),
    (2, 'TRI-001', 1, NULL),
    (3, 'PRO-001', 1, 'Incluye cable HDMI y control remoto'),
    (3, 'CAM-001', 1, 'Solicitado para grabación de evento');

-- Verificar datos insertados
SELECT 'Prestatarios:' AS seccion, COUNT(*) AS total FROM PRESTATARIO
UNION ALL
SELECT 'Equipos:', COUNT(*) FROM EQUIPO
UNION ALL
SELECT 'Préstamos:', COUNT(*) FROM PRESTAMO
UNION ALL
SELECT 'Detalles:', COUNT(*) FROM DETALLE_PRESTAMO;
