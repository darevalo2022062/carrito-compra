# 🛍️ Base de Datos para E-Commerce - Carrito de Compras

## 📚 Estructura Completa en SQL

```sql
-- ✨ CREACIÓN DE LA BASE DE DATOS
DROP DATABASE IF EXISTS carritoCompraDB;
CREATE DATABASE IF NOT EXISTS carritoCompraDB;
USE carritoCompraDB;

-- 👥 TABLA CLIENTES
CREATE TABLE cliente(
    id_cliente INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(254) NOT NULL,
    telefono VARCHAR(9) NOT NULL,
    email VARCHAR(100) NOT NULL,
    estado TINYINT NOT NULL DEFAULT(1),
    PRIMARY KEY(id_cliente)
);

-- 🏷️ TABLA CATEGORÍAS
CREATE TABLE categoria(
    id_categoria INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(25) NOT NULL,
    estado TINYINT NOT NULL DEFAULT(1),
    PRIMARY KEY(id_categoria)
);

-- 🛒 TABLA PRODUCTOS
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

-- 📦 TABLA INVENTARIO
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

-- 🧾 TABLA FACTURAS
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

-- 📝 TABLA DETALLE FACTURAS
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

-- 🔍 ÍNDICE PARA BÚSQUEDAS RÁPIDAS
CREATE UNIQUE INDEX idx_cliente_email ON cliente(email);

erDiagram
    CLIENTE ||--o{ ENCABEZADO_FACTURA : "realiza"
    ENCABEZADO_FACTURA ||--|{ DETALLE_FACTURA : "contiene"
    PRODUCTO ||--o{ DETALLE_FACTURA : "incluido_en"
    CATEGORIA ||--o{ PRODUCTO : "clasifica"
    PRODUCTO ||--o{ INVENTARIO : "stock"


💡 Ejemplo de Consultas Útiles
-- 🏆 TOP 5 PRODUCTOS MÁS VENDIDOS
SELECT p.nombre, SUM(df.cantidad) AS unidades_vendidas
FROM producto p
JOIN detalle_factura df ON p.id_producto = df.id_producto
GROUP BY p.id_producto
ORDER BY unidades_vendidas DESC
LIMIT 5;

-- 📅 VENTAS POR MES
SELECT 
    DATE_FORMAT(f.fecha_emision, '%Y-%m') AS mes,
    SUM(f.total) AS ventas_totales
FROM encabezado_factura f
WHERE f.estado = 'PAGADA'
GROUP BY mes
ORDER BY mes;

-- 🔔 PRODUCTOS CON STOCK BAJO
SELECT p.nombre, i.cantidad
FROM producto p
JOIN inventario i ON p.id_producto = i.id_producto
WHERE i.cantidad < 10 AND p.estado = 1;
