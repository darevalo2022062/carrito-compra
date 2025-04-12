markdown
Copy
# 🛒 Base de Datos para E-Commerce - Carrito de Compras

## 📚 Estructura de la Base de Datos

```sql
-- ✨ Creación de la base de datos
DROP DATABASE IF EXISTS carritoCompraDB;
CREATE DATABASE IF NOT EXISTS carritoCompraDB;
USE carritoCompraDB;
🔍 Diagrama Entidad-Relación
mermaid
Copy
erDiagram
    CLIENTE ||--o{ FACTURA : "realiza"
    FACTURA ||--|{ DETALLE_FACTURA : "contiene"
    PRODUCTO ||--o{ DETALLE_FACTURA : "incluido_en"
    CATEGORIA ||--o{ PRODUCTO : "clasifica"
    PRODUCTO ||--o{ INVENTARIO : "stock"
📦 Tablas Principales
👥 Clientes
sql
Copy
CREATE TABLE cliente(
    id_cliente INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(254) NOT NULL,
    telefono VARCHAR(9) NOT NULL,
    email VARCHAR(100) NOT NULL,
    estado TINYINT NOT NULL DEFAULT(1),
    PRIMARY KEY(id_cliente)
);
🏷 Categorías
sql
Copy
CREATE TABLE categoria(
    id_categoria INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(25) NOT NULL,
    estado TINYINT NOT NULL DEFAULT(1),
    PRIMARY KEY(id_categoria)
);
🛍️ Productos
sql
Copy
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
📊 Sistema de Inventario
sql
Copy
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
💰 Módulo de Facturación
🧾 Encabezado Factura
sql
Copy
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
📝 Detalle Factura
sql
Copy
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
🔍 Índices Optimizados
sql
Copy
CREATE UNIQUE INDEX idx_cliente_email ON cliente(email);
🎨 Estilo Visual
Componente	Color	Icono
Clientes	#FF6B6B	👥
Productos	#4ECDC4	🛍️
Facturas	#FFD166	🧾
Inventario	#51E898	📊
💡 Ejemplo de Consulta
sql
Copy
-- Obtener productos más vendidos
SELECT p.nombre, SUM(df.cantidad) AS total_vendido
FROM producto p
JOIN detalle_factura df ON p.id_producto = df.id_producto
GROUP BY p.id_producto
ORDER BY total_vendido DESC
LIMIT 5;
💡 Tip: Esta estructura permite fácil integración con sistemas de pago y logística
