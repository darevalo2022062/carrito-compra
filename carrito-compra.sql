DROP DATABASE IF EXISTS carritoCompraDB;
CREATE DATABASE IF NOT EXISTS carritoCompraDB;
USE carritoCompraDB;

###TABLES
CREATE TABLE cliente(
	id_cliente INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(254) NOT NULL,
    telefono VARCHAR(9) NOT NULL,
    email VARCHAR(100) NOT NULL,
	estado TINYINT NOT NULL DEFAULT(1),
    PRIMARY KEY(id_cliente)
);

CREATE TABLE categoria(
	id_categoria INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(25) NOT NULL,
    estado TINYINT NOT NULL DEFAULT(1),
    PRIMARY KEY(id_categoria)
);

CREATE TABLE producto(
	id_producto INT UNSIGNED NOT NULL AUTO_INCREMENT,
    sku VARCHAR(15) NOT NULL UNIQUE,
	nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(200),
    id_categoria INT UNSIGNED NOT NULL,
    precio DECIMAL(8,2) NOT NULL CHECK (precio>0),
    estado TINYINT NOT NULL DEFAULT(1),
    PRIMARY KEY (id_producto),
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)
);

CREATE TABLE inventario(
	id_inventario INT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_producto INT UNSIGNED NOT NULL,
    cantidad INT UNSIGNED NOT NULL DEFAULT(1) CHECK(cantidad > 0),
    fecha_actualizacion DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    estado TINYINT NOT NULL DEFAULT(1),
    ubicacion VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_inventario),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

CREATE TABLE encabezado_factura(
	id_encabezado_factura BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_cliente INT UNSIGNED NOT NULL,
    fecha_emision DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    nit VARCHAR(20) NOT NULL DEFAULT('CF'),
    subtotal DECIMAL(8,2) NOT NULL,
    impuestos DECIMAL(8,2) NOT NULL,
    total DECIMAL(8,2) NOT NULL,
    estado ENUM('PAGADA', 'ANULADA', 'PENDIENTE') DEFAULT('PENDIENTE'),
    PRIMARY KEY(id_encabezado_factura),
    FOREIGN KEY(id_cliente) REFERENCES cliente(id_cliente)
);

CREATE TABLE detalle_factura(
	id_detalle_factura BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_encabezado_factura BIGINT UNSIGNED NOT NULL,
    id_producto INT UNSIGNED NOT NULL,
    cantidad INT NOT NULL CHECK(cantidad > 0),
    precio DECIMAL(8,2) NOT NULL,
    descuento DECIMAL(8,2) DEFAULT(0.00),
    subtotal DECIMAL(8,2) NOT NULL,
    PRIMARY KEY(id_detalle_factura),
    FOREIGN KEY (id_encabezado_factura) REFERENCES encabezado_factura(id_encabezado_factura),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

### Índices
CREATE UNIQUE INDEX idx_cliente_email ON cliente(email);

### Inserts
INSERT INTO cliente (nombre, direccion, telefono, email) VALUES
('David Arévalo', 'Manzana K 11-12 z3 Escuintla', '50600091', 'darevalod@miumg.edu.gt'),
('Carlos Velásquez', '5av 7ma calle z3 Ciudad de Guatemala', '12336557', 'CarlosVe0@hotmail.com'),
('Miguel Gaspi', 'Residencial 15, San Miguel Petapa', '47851236', 'miguelgaspi2@gmail.com'),
('Max Verstappen', 'Avenida Los Pilotos 22, Zona 10, Ciudad de Guatemala', '56324789', 'max_versta@redbull.com'),
('Eduardo Russell', 'Colonia Los Olivos, San Cristobal, Guatemala', '55239876', 'eduardo.russell99@yahoo.com');

INSERT INTO categoria (nombre) VALUES
('Gadgets'),
('Hardware'),
('Electrónicos'),
('Laptops'),
('Periféricos');

-- Gadgets
INSERT INTO producto (sku, nombre, descripcion, id_categoria, precio) VALUES
('GAD001', 'Smartwatch X100', 'Reloj inteligente con pantalla táctil, monitoreo de salud, resistencia al agua.', 1, 150.00),
('GAD002', 'Auriculares Bluetooth JBL', 'Auriculares inalámbricos con cancelación de ruido y micrófono incorporado.', 1, 80.00),
('GAD003', 'Cámara Deportiva GoPro 10', 'Cámara resistente al agua con capacidad de grabación 4K, ideal para deportes extremos.', 1, 350.00),
('GAD004', 'Lámpara LED Inteligente', 'Lámpara controlada por aplicación móvil con ajuste de brillo y color.', 1, 40.00);

-- Hardware
INSERT INTO producto (sku, nombre, descripcion, id_categoria, precio) VALUES
('HW001', 'Placa Base ASUS Z590', 'Placa base compatible con procesadores Intel de 10ª y 11ª generación, soporte para PCIe 4.0.', 2, 200.00),
('HW002', 'Tarjeta Gráfica NVIDIA GTX 1660', 'Tarjeta gráfica de alto rendimiento para juegos y edición de video, 6GB de VRAM.', 2, 250.00),
('HW003', 'Disco Duro SSD Samsung 500GB', 'Disco duro sólido con velocidad de lectura de 550 MB/s, ideal para mejorar el rendimiento del sistema.', 2, 75.00),
('HW004', 'Fuente de Poder Corsair 650W', 'Fuente de poder certificada 80+ Bronze, ideal para PCs de alto rendimiento.', 2, 60.00);

-- Electrónicos
INSERT INTO producto (sku, nombre, descripcion, id_categoria, precio) VALUES
('ELEC001', 'Smart TV LG 55" 4K', 'Televisor LED con resolución 4K, soporte para HDR y acceso a aplicaciones de streaming.', 3, 450.00),
('ELEC002', 'Altavoces Bluetooth JBL', 'Altavoces portátiles con sonido de alta calidad, conexión Bluetooth y batería de 10 horas.', 3, 120.00),
('ELEC003', 'Proyector Epson 3500 Lumens', 'Proyector de alta definición con 3500 lúmenes de brillo, ideal para presentaciones y cine en casa.', 3, 350.00),
('ELEC004', 'Radio Despertador Sony', 'Radio despertador con puerto USB y pantalla LED, ideal para el hogar.', 3, 40.00);

-- Laptops
INSERT INTO producto (sku, nombre, descripcion, id_categoria, precio) VALUES
('LAP001', 'Laptop Dell Inspiron 15', 'Laptop con procesador Intel Core i7, 16GB RAM, 512GB SSD, pantalla Full HD.', 4, 750.00),
('LAP002', 'MacBook Air 2020', 'Laptop ultradelgada con procesador M1, 8GB RAM, 256GB SSD, pantalla Retina.', 4, 1000.00),
('LAP003', 'HP Pavilion x360', 'Laptop convertible 2 en 1 con pantalla táctil, procesador Intel Core i5, 8GB RAM.', 4, 600.00),
('LAP004', 'Lenovo ThinkPad X1 Carbon', 'Laptop empresarial ligera, procesador Intel Core i7, 16GB RAM, 1TB SSD.', 4, 1200.00);

-- Periféricos
INSERT INTO producto (sku, nombre, descripcion, id_categoria, precio) VALUES
('PERF001', 'Teclado Mecánico Razer', 'Teclado mecánico retroiluminado con switches mecánicos, ideal para gamers.', 5, 120.00),
('PERF002', 'Mouse Logitech G502', 'Mouse gaming ergonómico con sensores de alta precisión y botones programables.', 5, 50.00),
('PERF003', 'Webcam Logitech C920', 'Webcam Full HD con micrófono incorporado, ideal para videollamadas y streaming.', 5, 80.00),
('PERF004', 'Auriculares Corsair HS60', 'Auriculares con sonido surround, micrófono ajustable, y diseño cómodo.', 5, 60.00);

-- Inventario para Gadgets
INSERT INTO inventario (id_producto, cantidad, ubicacion) VALUES
(1, 50, 'Almacén'),
(2, 120, 'Web'),
(3, 30, 'Almacén'),
(4, 75, 'Web');

-- Inventario para Hardware
INSERT INTO inventario (id_producto, cantidad, ubicacion) VALUES
(5, 40, 'Almacén'),
(6, 20, 'Web'),
(7, 100, 'Almacén'),
(8, 60, 'Web');

-- Inventario para Electrónicos
INSERT INTO inventario (id_producto, cantidad, ubicacion) VALUES
(9, 15, 'Almacén'),
(10, 50, 'Web'),
(11, 10, 'Almacén'),
(12, 200, 'Web');

-- Inventario para Laptops
INSERT INTO inventario (id_producto, cantidad, ubicacion) VALUES
(13, 25, 'Almacén'),
(14, 10, 'Web'),
(15, 40, 'Almacén'),
(16, 15, 'Web');

-- Inventario para Periféricos
INSERT INTO inventario (id_producto, cantidad, ubicacion) VALUES
(17, 150, 'Almacén'),
(18, 200, 'Web'),
(19, 100, 'Almacén'),
(20, 50, 'Web');

############################ FACTURAS ##################################
-- Encabezados de facturas
INSERT INTO encabezado_factura (id_cliente, fecha_emision, nit, subtotal, impuestos, total, estado) VALUES
(1, '2025-04-01 14:23:00', 'CF', 150.00, 18.00, 168.00, 'ANULADA'),
(2, '2025-04-02 10:45:00', '296328472', 320.00, 38.40, 358.40, 'PENDIENTE'),
(3, '2025-04-02 16:30:00', 'CF', 500.00, 60.00, 560.00, 'PAGADA'),
(4, '2025-04-03 09:15:00', '785422230', 225.00, 27.00, 252.00, 'PAGADA');

-- Detalles de facturas
INSERT INTO detalle_factura (id_encabezado_factura, id_producto, cantidad, precio, descuento, subtotal) VALUES
(1, 1, 1, 50.00, 5.00, 45.00),  -- Factura 1: Smartwatch X100
(1, 2, 2, 30.00, 3.00, 54.00),  -- Factura 1: Auriculares Bluetooth
(2, 3, 1, 100.00, 10.00, 90.00), -- Factura 2: Cámara Deportiva GoPro 10
(2, 4, 1, 75.00, 0.00, 75.00),  -- Factura 2: Lámpara LED Inteligente
(3, 5, 2, 60.00, 0.00, 120.00), -- Factura 3: Placa Base ASUS Z590
(3, 6, 1, 80.00, 8.00, 72.00),  -- Factura 3: Tarjeta Gráfica NVIDIA GTX 1660
(4, 7, 1, 100.00, 10.00, 90.00), -- Factura 4: Disco Duro SSD Samsung 500GB
(4, 8, 1, 50.00, 5.00, 45.00);  -- Factura 4: Fuente de Poder Corsair 650W

### SELECTs
SELECT * FROM cliente;
SELECT * FROM categoria;
SELECT * FROM producto;
SELECT * FROM inventario;
SELECT * FROM encabezado_factura;
SELECT * FROM detalle_factura;

