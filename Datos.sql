INSERT INTO productos (nombre, descripcion, precio, categoria, ingredientes, disponible) VALUES
('Pizza Pollo', 'Pizza clásica con salsa de tomate, mozzarella y pollo.', 3500.00, 'pizza', 'tomate, mozzarella, albahaca, pollo', TRUE),
('Pizza Pepperoni', 'Pizza con abundante pepperoni y queso.', 3000.00, 'pizza', 'tomate, mozzarella, pepperoni', TRUE),
('Panzarotti de Queso', 'Panzarotti relleno de queso derretido.', 2500.00, 'panzarotti', 'masa, queso', TRUE),
('Bebida Cola', 'Bebida refrescante.', 1500.00, 'bebida', 'agua carbonatada, azúcar, cafeína', TRUE);


INSERT INTO adiciones (nombre, precio) VALUES
('Extra Queso', 1000.00),
('Salsa Picante', 2500.00),
('Aceitunas', 2000.00),
('Champiñones', 2500.00),
('Bacon', 1500.00),
('Pimientos', 1000.00);


INSERT INTO combos (nombre, descripcion, precio) VALUES
('Combo Familiar', '2 Pizzas grandes, 1 Panzarotti y 2 Bebidas.', 4000.00),
('Combo Duo', '1 Pizza mediana y 1 Bebida.', 3000.00),
('Combo Personal', '1 Panzarotti y 1 Bebida.', 2500.00);


INSERT INTO combo_productos (combo_id, producto_id) VALUES
(1, 1),  
(1, 2),  
(2, 2),  
(2, 4),  
(3, 3),  
(3, 4); 


INSERT INTO pedidos (tipo, total, estado, fecha) VALUES
('consumir', 25.00, 'completado', '2024-09-30 18:00:00'),
('recoger', 12.50, 'completado', '2024-09-29 12:00:00'),
('consumir', 18.00, 'completado', '2024-09-28 19:00:00'),
('recoger', 24.00, 'completado', '2024-09-27 17:00:00'),
('consumir', 30.00, 'pendiente', '2024-09-30 20:00:00'),
('recoger', 20.00, 'completado', '2024-09-26 16:00:00');


INSERT INTO pedido_productos (pedido_id, producto_id, cantidad) VALUES
(1, 1, 1),  
(1, 2, 1),
(2, 3, 1),
(3, 4, 2);  


INSERT INTO pedido_adiciones (pedido_producto_id, adicion_id) VALUES
(1, 1),  
(2, 3);  


INSERT INTO menu (producto_id, disponible) VALUES
(1, TRUE),  
(2, TRUE),
(3, TRUE),
(4, TRUE);  



-- 1. Productos más vendidos
SELECT p.nombre, SUM(pp.cantidad) AS total_vendido
FROM pedido_productos pp
JOIN productos p ON pp.producto_id = p.id
GROUP BY p.nombre
ORDER BY total_vendido DESC;

-- 2. Total de ingresos generados por cada combo
SELECT c.nombre, SUM(p.total) AS ingresos_totales
FROM pedidos p
JOIN pedido_productos pp ON pp.pedido_id = p.id
JOIN combo_productos cp ON pp.producto_id = cp.producto_id
JOIN combos c ON c.id = cp.combo_id
GROUP BY c.nombre;

-- 3. Pedidos realizados para recoger vs. comer en la pizzería
SELECT tipo, COUNT(*) AS total_pedidos
FROM pedidos
GROUP BY tipo;

-- 4. Adiciones más solicitadas en pedidos personalizados
SELECT a.nombre, COUNT(pa.adicion_id) AS total_adiciones
FROM pedido_adiciones pa
JOIN adiciones a ON pa.adicion_id = a.id
JOIN pedido_productos pp ON pa.pedido_producto_id = pp.id
GROUP BY a.nombre
ORDER BY total_adiciones DESC;

-- 5. Cantidad total de productos vendidos por categoría
SELECT p.categoria, SUM(pp.cantidad) AS total_vendido
FROM pedido_productos pp
JOIN productos p ON pp.producto_id = p.id
GROUP BY p.categoria;

-- 6. Promedio de pizzas pedidas por cliente
SELECT AVG(pizza_count) AS promedio_pizzas
FROM (
    SELECT COUNT(*) AS pizza_count
    FROM pedido_productos pp
    JOIN productos p ON pp.producto_id = p.id
    WHERE p.categoria = 'pizza'
    GROUP BY pp.pedido_id
) AS subquery;

-- 7. Total de ventas por día de la semana
SELECT DAYNAME(fecha) AS dia_semana, SUM(total) AS total_ventas
FROM pedidos
GROUP BY dia_semana;

-- 8. Cantidad de panzarottis vendidos con extra queso
SELECT SUM(pp.cantidad) AS total_panzarottis_con_extra
FROM pedido_productos pp
JOIN pedido_adiciones pa ON pp.id = pa.pedido_producto_id
JOIN adiciones a ON pa.adicion_id = a.id
WHERE pp.producto_id = (SELECT id FROM productos WHERE nombre = 'Panzarotti de Queso')
AND a.nombre = 'Extra Queso';


-- 9. Pedidos que incluyen bebidas como parte de un combo
SELECT COUNT(DISTINCT pp.pedido_id) AS total_pedidos_con_bebidas
FROM pedido_productos pp
JOIN productos p ON pp.producto_id = p.id
WHERE p.categoria = 'bebida';

-- 10. Clientes que han realizado más de 5 pedidos en el último mes
SELECT COUNT(DISTINCT p.id) AS total_clientes
FROM pedidos p
WHERE p.fecha >= DATE_SUB(NOW(), INTERVAL 1 MONTH)
GROUP BY p.id
HAVING COUNT(*) > 5;

-- 11. Ingresos totales generados por productos no elaborados (bebidas, postres, etc.)
SELECT SUM(total) AS ingresos_no_elaborados
FROM pedidos p
JOIN pedido_productos pp ON p.id = pp.pedido_id
JOIN productos prod ON pp.producto_id = prod.id
WHERE prod.categoria IN ('bebida', 'postre');

-- 12. Promedio de adiciones por pedido
SELECT AVG(adiciones_count) AS promedio_adiciones
FROM (
    SELECT COUNT(*) AS adiciones_count
    FROM pedido_adiciones pa
    GROUP BY pa.pedido_producto_id
) AS subquery;

-- 13. Total de combos vendidos en el último mes
SELECT COUNT(*) AS total_combos_vendidos
FROM pedidos p
JOIN pedido_productos pp ON p.id = pp.pedido_id
WHERE pp.producto_id IN (SELECT producto_id FROM combo_productos);

-- 14. Clientes con pedidos tanto para recoger como para consumir en el lugar
SELECT COUNT(DISTINCT cliente_id) AS total_clientes
FROM pedidos
WHERE tipo IN ('recoger', 'consumir')
GROUP BY cliente_id;

-- 15. Total de productos personalizados con adiciones
SELECT COUNT(*) AS total_personalizados
FROM pedido_productos pp
LEFT JOIN pedido_adiciones pa ON pp.id = pa.pedido_producto_id
GROUP BY pp.pedido_id
HAVING COUNT(pa.adicion_id) > 0;

-- 16. Pedidos con más de 3 productos diferentes
SELECT COUNT(DISTINCT pedido_id) AS total_pedidos
FROM (
    SELECT pedido_id
    FROM pedido_productos
    GROUP BY pedido_id
    HAVING COUNT(DISTINCT producto_id) > 3
) AS subquery;

-- 17. Promedio de ingresos generados por día
SELECT AVG(dia_ingresos.total_dia) AS promedio_ingresos
FROM (
    SELECT DATE(fecha) AS dia, SUM(total) AS total_dia
    FROM pedidos
    GROUP BY dia
) AS dia_ingresos;

-- 18. Clientes que han pedido pizzas con adiciones en más del 50% de sus pedidos
SELECT COUNT(DISTINCT pedido_id) AS total_clientes
FROM pedido_productos pp
JOIN pedido_adiciones pa ON pp.id = pa.pedido_producto_id
JOIN productos p ON pp.producto_id = p.id
WHERE p.categoria = 'pizza'
GROUP BY pp.pedido_id
HAVING COUNT(pa.adicion_id) > COUNT(pp.id) / 2;

-- 19. Porcentaje de ventas provenientes de productos no elaborados
SELECT (SUM(CASE WHEN p.categoria IN ('bebida', 'postre') THEN pp.cantidad ELSE 0 END) / SUM(pp.cantidad)) * 100 AS porcentaje_no_elaborados
FROM pedido_productos pp
JOIN productos p ON pp.producto_id = p.id;

-- 20. Día de la semana con mayor número de pedidos para recoger
SELECT DAYNAME(fecha) AS dia_semana, COUNT(*) AS total_pedidos
FROM pedidos
WHERE tipo = 'recoger'
GROUP BY dia_semana
ORDER BY total_pedidos DESC
LIMIT 1;