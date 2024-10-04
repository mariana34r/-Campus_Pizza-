USE campus_pizza;

CREATE TABLE IF NOT EXISTS productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10, 2) NOT NULL,
    categoria ENUM('pizza', 'panzarotti', 'bebida', 'postre', 'otro') NOT NULL,
    disponible BOOLEAN DEFAULT TRUE,
    ingredientes VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS adiciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10, 2) NOT NULL
);

CREATE TABLE IF NOT EXISTS combos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10, 2) NOT NULL
);

CREATE TABLE IF NOT EXISTS combo_productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    combo_id INT NOT NULL,
    producto_id INT NOT NULL,
    FOREIGN KEY (combo_id) REFERENCES combos(id) ON DELETE CASCADE,
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    tipo ENUM('consumir', 'recoger') NOT NULL,
    total DECIMAL(10, 2) NOT NULL,
    estado ENUM('pendiente', 'completado', 'cancelado') DEFAULT 'pendiente'
);

CREATE TABLE IF NOT EXISTS pedido_productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id) ON DELETE CASCADE,
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS pedido_adiciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_producto_id INT NOT NULL,
    adicion_id INT NOT NULL,
    FOREIGN KEY (pedido_producto_id) REFERENCES pedido_productos(id) ON DELETE CASCADE,
    FOREIGN KEY (adicion_id) REFERENCES adiciones(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS menu (
    id INT AUTO_INCREMENT PRIMARY KEY,
    producto_id INT NOT NULL,
    disponible BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE
);
