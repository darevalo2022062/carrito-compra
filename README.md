🛍️ Base de Datos para E-Commerce: Carrito de Compras 🛒
📌 Diagrama de Relaciones Esencial
mermaid
Copy
erDiagram
    CLIENTE ||--o{ ENCABEZADO_FACTURA : "Realiza"
    ENCABEZADO_FACTURA ||--|{ DETALLE_FACTURA : "Contiene"
    PRODUCTO ||--o{ DETALLE_FACTURA : "Incluido_en"
    CATEGORIA ||--o{ PRODUCTO : "Clasifica"
    PRODUCTO ||--o{ INVENTARIO : "Stock"
🏆 Estructura Detallada
👥 Tabla CLIENTE (cliente)
sql
Copy
CREATE TABLE cliente(
    id_cliente INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(254) NOT NULL,
    telefono VARCHAR(9) NOT NULL,  -- 📞 Formato: 9 dígitos
    email VARCHAR(100) NOT NULL,   -- ✉️ Único (índice aplicado)
    estado TINYINT NOT NULL DEFAULT(1),  -- 🔘 1=Activo, 0=Inactivo
    PRIMARY KEY(id_cliente)
);
Índice: CREATE UNIQUE INDEX idx_cliente_email ON cliente(email);

🏷️ Tabla PRODUCTO (producto)
sql
Copy
CREATE TABLE producto(
    id_producto INT UNSIGNED NOT NULL AUTO_INCREMENT,
    sku VARCHAR(15) NOT NULL UNIQUE,  -- 🏷️ Código único
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(200),
    id_categoria INT UNSIGNED NOT NULL,
    precio DECIMAL(8,2) NOT NULL CHECK (precio>0),  -- 💰 Validación positiva
    estado TINYINT NOT NULL DEFAULT(1),
    PRIMARY KEY (id_producto),
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)
);
📦 Tabla INVENTARIO (inventario)
sql
Copy
CREATE TABLE inventario(
    id_inventario INT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_producto INT UNSIGNED NOT NULL,
    cantidad INT UNSIGNED NOT NULL DEFAULT(1) CHECK(cantidad > 0),  -- 🚫 No negativos
    fecha_actualizacion DATETIME DEFAULT CURRENT_TIMESTAMP 
        ON UPDATE CURRENT_TIMESTAMP,  -- ⏰ Auto-actualizable
    estado TINYINT NOT NULL DEFAULT(1),
    ubicacion VARCHAR(100) NOT NULL,  -- 🗺️ Coordenadas de almacén
    PRIMARY KEY (id_inventario),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);
💳 Sistema de Facturación
📜 Encabezado Factura (encabezado_factura)
sql
Copy
CREATE TABLE encabezado_factura(
    id_encabezado_factura BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_cliente INT UNSIGNED NOT NULL,
    fecha_emision DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    nit VARCHAR(20) NOT NULL DEFAULT('CF'),  -- 🏢 NIT o "CF" (Consumidor Final)
    subtotal DECIMAL(8,2) NOT NULL,
    impuestos DECIMAL(8,2) NOT NULL,
    total DECIMAL(8,2) NOT NULL,
    estado ENUM('PAGADA', 'ANULADA', 'PENDIENTE') DEFAULT('PENDIENTE'),  -- 🟢/🔴/🟡
    PRIMARY KEY(id_encabezado_factura),
    FOREIGN KEY(id_cliente) REFERENCES cliente(id_cliente)
);
📝 Detalle Factura (detalle_factura)
sql
Copy
CREATE TABLE detalle_factura(
    id_detalle_factura BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_encabezado_factura BIGINT UNSIGNED NOT NULL,
    id_producto INT UNSIGNED NOT NULL,
    cantidad INT NOT NULL CHECK(cantidad > 0),
    precio DECIMAL(8,2) NOT NULL,
    descuento DECIMAL(8,2) DEFAULT(0.00),  -- 🎁 Descuentos opcionales
    subtotal DECIMAL(8,2) NOT NULL,
    PRIMARY KEY(id_detalle_factura),
    FOREIGN KEY (id_encabezado_factura) REFERENCES encabezado_factura(id_encabezado_factura),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);
🚀 Potencial de Integración con APIs
Componente DB	API Recomendada	Uso Potencial
cliente.email	Mailchimp	📧 Marketing por email
producto.descripcion	OpenAI	✍️ Generación automática de descripciones
inventario.cantidad	Twilio	📱 Alertas SMS por stock bajo
encabezado_factura.total	Stripe	💳 Procesamiento de pagos
💎 Gemas Ocultas del Diseño
Validación Automática

CHECK en precios y cantidades (nunca negativos)

ENUM para estados controlados

Registro Temporal

fecha_actualizacion auto-manejada en inventario

Identificadores Únicos

SKU para productos

Email único por cliente

Relaciones Sólidas

Claves foráneas con integridad referencial

📊 Consulta de Ejemplo: Reporte de Ventas
sql
Copy
-- 🏆 Top 3 productos más vendidos
SELECT p.nombre, SUM(df.cantidad) AS unidades_vendidas
FROM producto p
JOIN detalle_factura df ON p.id_producto = df.id_producto
JOIN encabezado_factura ef ON df.id_encabezado_factura = ef.id_encabezado_factura
WHERE ef.estado = 'PAGADA'
GROUP BY p.id_producto
ORDER BY unidades_vendidas DESC
LIMIT 3;
Salida Esperada:

Copy
1. Laptop Pro - 150 unidades
2. Smartphone X - 120 unidades
3. Tablet Lite - 95 unidades
🎨 Estilo Visual para el Repositorio
diff
Copy
# Paleta de colores sugerida
+ Azul DB: #2962FF (Títulos)
+ Verde Éxito: #00C853 (Éxito operaciones)
+ Rojo Error: #D50000 (Estado ANULADA)
+ Gris Texto: #616161 (Contenido normal)
Este diseño equilibra formalismo técnico con elementos visuales prácticos, manteniendo fidelidad al SQL original mientras sugiere posibilidades de expansión. 🚀