🎨✨ Base de Datos de Carrito de Compras - Diseño Elegante ✨🎨
🌟 Diagrama de Relaciones Visual
mermaid
Copy
flowchart TD
    A[🛒 Cliente] -->|compra| B[🧾 Factura]
    B --> C[📦 Detalle Factura]
    C --> D[📱 Producto]
    D --> E[🗃️ Categoría]
    D --> F[📊 Inventario]
    style A fill:#FFD700,stroke:#000
    style B fill:#87CEFA,stroke:#000
    style C fill:#98FB98,stroke:#000
    style D fill:#FFA07A,stroke:#000
    style E fill:#DDA0DD,stroke:#000
    style F fill:#FF6347,stroke:#000
🎀 Estructura con Estilo
👨‍💼 Tabla CLIENTE (cliente)
sql
Copy
/* ˗ˏˋ ★ ✧  CLIENTES  ✧ ★ ˎˊ˗ */
CREATE TABLE cliente(
    id_cliente    INT UNSIGNED NOT NULL AUTO_INCREMENT,  -- 🆔 ID único
    nombre        VARCHAR(100) NOT NULL,                 -- 👤 Nombre completo
    direccion     VARCHAR(254) NOT NULL,                 -- 🏠 Ubicación física
    telefono      VARCHAR(9)   NOT NULL,                 -- 📞 Contacto (9 dígitos)
    email         VARCHAR(100) NOT NULL,                 -- ✉️ Email (único)
    estado        TINYINT      NOT NULL DEFAULT(1),      -- 🔘 1=Activo | 0=Inactivo
    PRIMARY KEY(id_cliente)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
🏷️ Tabla PRODUCTO (producto)
sql
Copy
/* ˗ˏˋ ★ ✧  PRODUCTOS  ✧ ★ ˎˊ˗ */
CREATE TABLE producto(
    id_producto   INT UNSIGNED NOT NULL AUTO_INCREMENT,  -- 🆔 ID único
    sku           VARCHAR(15)  NOT NULL UNIQUE,          -- 🏷️ Código SKU
    nombre        VARCHAR(100) NOT NULL,                 -- 📛 Nombre producto
    descripcion   VARCHAR(200),                          -- 📝 Descripción detallada
    id_categoria  INT UNSIGNED NOT NULL,                 -- 🏷️ Categoría ID
    precio        DECIMAL(8,2) NOT NULL CHECK (precio>0),-- 💵 Precio (>0)
    estado        TINYINT      NOT NULL DEFAULT(1),      -- 🔘 1=Disponible
    PRIMARY KEY (id_producto),
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
📦 Tabla INVENTARIO (inventario)
sql
Copy
/* ˗ˏˋ ★ ✧  INVENTARIO  ✧ ★ ˎˊ˗ */
CREATE TABLE inventario(
    id_inventario      INT UNSIGNED NOT NULL AUTO_INCREMENT,  -- 🆔 ID único
    id_producto        INT UNSIGNED NOT NULL,                 -- 🔗 Producto ID
    cantidad           INT UNSIGNED NOT NULL DEFAULT(1) 
                          CHECK(cantidad > 0),               -- 🔢 Stock disponible
    fecha_actualizacion DATETIME DEFAULT CURRENT_TIMESTAMP 
                          ON UPDATE CURRENT_TIMESTAMP,        -- 📅 Auto-actualizable
    estado             TINYINT NOT NULL DEFAULT(1),           -- 🔘 1=Disponible
    ubicacion          VARCHAR(100) NOT NULL,                 -- 🗺️ Ubicación física
    PRIMARY KEY (id_inventario),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
💎 Sistema de Facturación Elegante
🧾 Encabezado Factura (encabezado_factura)
sql
Copy
/* ˗ˏˋ ★ ✧  FACTURAS  ✧ ★ ˎˊ˗ */
CREATE TABLE encabezado_factura(
    id_encabezado_factura BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, -- 🆔 ID único
    id_cliente            INT UNSIGNED NOT NULL,                   -- 👤 Cliente ID
    fecha_emision         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 📅 Fecha
    nit                   VARCHAR(20) NOT NULL DEFAULT('CF'),      -- 🏢 NIT/CF
    subtotal              DECIMAL(8,2) NOT NULL,                   -- 💰 Subtotal
    impuestos             DECIMAL(8,2) NOT NULL,                   -- 🏛️ Impuestos
    total                 DECIMAL(8,2) NOT NULL,                   -- 💵 Total
    estado                ENUM('PAGADA', 'ANULADA', 'PENDIENTE') 
                              DEFAULT('PENDIENTE'),                -- 🔴🟢🟡 Estado
    PRIMARY KEY(id_encabezado_factura),
    FOREIGN KEY(id_cliente) REFERENCES cliente(id_cliente)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
📝 Detalle Factura (detalle_factura)
sql
Copy
/* ˗ˏˋ ★ ✧  DETALLES FACTURA  ✧ ★ ˎˊ˗ */
CREATE TABLE detalle_factura(
    id_detalle_factura    BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, -- 🆔 ID único
    id_encabezado_factura BIGINT UNSIGNED NOT NULL,                -- 🔗 Factura ID
    id_producto           INT UNSIGNED NOT NULL,                   -- 🛍️ Producto ID
    cantidad              INT NOT NULL CHECK(cantidad > 0),         -- 🔢 Cantidad
    precio                DECIMAL(8,2) NOT NULL,                   -- 💲 Precio unitario
    descuento             DECIMAL(8,2) DEFAULT(0.00),              -- 🎁 Descuento
    subtotal              DECIMAL(8,2) NOT NULL,                   -- 💰 Subtotal línea
    PRIMARY KEY(id_detalle_factura),
    FOREIGN KEY (id_encabezado_factura) REFERENCES encabezado_factura(id_encabezado_factura),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
🎯 Índice Especial
sql
Copy
/* ✨ ÍNDICE PARA BÚSQUEDAS RÁPIDAS ✨ */
CREATE UNIQUE INDEX idx_cliente_email ON cliente(email) 
    COMMENT 'Índice para búsqueda por email';
🌈 Paleta de Colores para Documentación
Elemento	Color Hexadecimal	Muestra
Títulos	#FF6B6B	<span style="color:#FF6B6B">Texto</span>
Claves	#4ECDC4	<span style="color:#4ECDC4">Texto</span>
Comentarios	#A5A5A5	<span style="color:#A5A5A5">Texto</span>
Éxito	#51E898	<span style="color:#51E898">Texto</span>
Advertencia	#FFD166	<span style="color:#FFD166">Texto</span>
Este diseño combina claridad técnica con elementos visuales atractivos, manteniendo la integridad del código SQL original mientras lo hace visualmente más agradable y organizado. 🎨💻
