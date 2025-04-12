# 🛒 Base de Datos - Sistema de Carrito de Compras UMG 🧠🔴

Este proyecto define la estructura de una base de datos relacional para un sistema de carrito de compras. Diseñado con MySQL, incluye tablas bien normalizadas para clientes, productos, facturación e inventario.

---




## 🧱 Estructura de la Base de Datos

La base de datos se llama `carritoCompraDB` y contiene las siguientes tablas:

<details>
<summary>🧍‍♂️ Details</summary>

```sql
CREATE TABLE cliente (
  id_cliente INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL,
  direccion VARCHAR(254) NOT NULL,
  telefono VARCHAR(9) NOT NULL,
  email VARCHAR(100) NOT NULL,
  estado TINYINT NOT NULL DEFAULT(1),
  PRIMARY KEY(id_cliente)
);
```
</details> <details> <summary>🗂️ Categoría</summary>

```sql
CREATE TABLE categoria (
  id_categoria INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(25) NOT NULL,
  estado TINYINT NOT NULL DEFAULT(1),
  PRIMARY KEY(id_categoria)
);
```
</details> <details> <summary>📦 Producto</summary>

```sql
CREATE TABLE producto (
  id_producto INT UNSIGNED NOT NULL AUTO_INCREMENT,
  sku VARCHAR(15) NOT NULL UNIQUE,
  nombre VARCHAR(100) NOT NULL,
  descripcion VARCHAR(200),
  id_categoria INT UNSIGNED NOT NULL,
  precio DECIMAL(8,2) NOT NULL CHECK (precio > 0),
  estado TINYINT NOT NULL DEFAULT(1),
  PRIMARY KEY(id_producto),
  FOREIGN KEY(id_categoria) REFERENCES categoria(id_categoria)
);
```
</details> <details> <summary>🏪 Inventario</summary>
  
```sql
CREATE TABLE inventario (
  id_inventario INT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_producto INT UNSIGNED NOT NULL,
  cantidad INT UNSIGNED NOT NULL DEFAULT(1) CHECK(cantidad > 0),
  fecha_actualizacion DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  estado TINYINT NOT NULL DEFAULT(1),
  ubicacion VARCHAR(100) NOT NULL,
  PRIMARY KEY(id_inventario),
  FOREIGN KEY(id_producto) REFERENCES producto(id_producto)
);
  ```
</details> <details> <summary>🧾 Encabezado de Factura</summary>

```sql
CREATE TABLE encabezado_factura (
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
```
</details> <details> <summary>🧮 Detalle de Factura</summary>

```sql
CREATE TABLE detalle_factura (
  id_detalle_factura BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_encabezado_factura BIGINT UNSIGNED NOT NULL,
  id_producto INT UNSIGNED NOT NULL,
  cantidad INT NOT NULL CHECK(cantidad > 0),
  precio DECIMAL(8,2) NOT NULL,
  descuento DECIMAL(8,2) DEFAULT(0.00),
  subtotal DECIMAL(8,2) NOT NULL,
  PRIMARY KEY(id_detalle_factura),
  FOREIGN KEY(id_encabezado_factura) REFERENCES encabezado_factura(id_encabezado_factura),
  FOREIGN KEY(id_producto) REFERENCES producto(id_producto)
);
```
## 📌 Índices
CREATE UNIQUE INDEX idx_cliente_email ON cliente(email);

## 🚀 Inicio Rápido
DROP DATABASE IF EXISTS carritoCompraDB;
CREATE DATABASE IF NOT EXISTS carritoCompraDB;
USE carritoCompraDB;
-- Ejecutar luego las sentencias de creación de tablas

## 🤝 Colaboración
¿Tienes ideas para mejorar la base de datos o su visualización? ¡Los PR son bienvenidos! ✨

## 🧠 Autor
Desarrollado como parte de un proyecto académico / práctico para modelado de datos relacionales enfocado en e-commerce.

¡Gracias por visitar y explorar! 🎉
