# Base de datos Campus_Pizza 🍕 

## Tabla de contenido 
| Indice | Título  |
|--|--|
| 1. | [Descripción_del_proyecto](#Descripción_del_proyecto) |
| 2. | [Estructura_de_la_Base_de_Datos](#Estructura_de_la_Base_de_Datos) |
| 3. | [Requerimientos](#Requerimientos) |
| 4. | [Consultas](#Consultas) |
| 5. | [Autores](#Autores) |



# Descripción del Proyecto 🚀
Esta base de datos sobre los Campus_Pizza incluye Gestión de Productos: Registro completo de pizzas, panzarottis, bebidas, postres y otros productos no elaborados.
Gestión de Adiciones: Permitir a los clientes agregar adiciones (extra queso, salsas, etc.) a sus productos.
Gestión de Combos: Manejar combos que incluyen múltiples productos a un precio especial.
Gestión de Pedidos: Registro de pedidos para consumir en la pizzería o para recoger, con opción de personalización mediante adiciones.
Gestión del Menú: Definir y actualizar el menú con las opciones disponibles.

# Imagen de la base de datos Campus_Pizza 🏠:

![image](https://github.com/user-attachments/assets/c77d091b-fb67-4f8f-a171-1a41cda12824)

# Estructura de la Base de Datos 📺:
La base de datos consta de las siguientes tablas:

## 1.Productos:

![image](https://github.com/user-attachments/assets/3637f135-d567-4af0-9457-3f91e2c10de8)

## 2.Adiciones:

![image](https://github.com/user-attachments/assets/390b2fdb-7710-4b53-8fbd-40a7631ff3d0)

## 3.Combos:

![image](https://github.com/user-attachments/assets/a55b1053-5b0a-47dd-9854-5e2a2f27d032)

## 4.Combo_Producto:

![image](https://github.com/user-attachments/assets/baa68267-0bda-40cb-9908-e0149a1f6e0a)

## 5.Pedidos:

![image](https://github.com/user-attachments/assets/561b0db2-b3ea-466b-9aa0-33fd1cb96361)

## 6.Pedidos_Productos:

![image](https://github.com/user-attachments/assets/1025cc1a-3abe-4061-8c35-1dbed5ca054a)

## 7.Pedido_Adiciones:

![image](https://github.com/user-attachments/assets/d7942092-e56d-4049-aebe-b447e22d4d65)

## 8.Menu:

![image](https://github.com/user-attachments/assets/82eb4ef9-b335-411a-9052-b1209534cefb)


# Requerimientos 🛋️:

### Gestión de Productos: 
Registro completo de pizzas, panzarottis, bebidas, postres y otros productos no elaborados. Se debe tener en cuenta los ingredientes que poseen los productos.

### Gestión de Adiciones: 
Permitir a los clientes agregar adiciones (extra queso, salsas, etc.) a sus productos.

### Gestión de Combos: 
Manejar combos que incluyen múltiples productos a un precio especial.

### Gestión de Pedidos: 
Registro de pedidos para consumir en la pizzería o para recoger, con opción de personalización mediante adiciones.

### Gestión del Menú: 
Definir y actualizar el menú con las opciones disponibles.

## Consultas 🎉:


## 1. Productos más vendidos
SELECT p.nombre, SUM(pp.cantidad) AS total_vendido
FROM pedido_productos pp
JOIN productos p ON pp.producto_id = p.id
GROUP BY p.nombre
ORDER BY total_vendido DESC;

## 2. Total de ingresos generados por cada combo
SELECT c.nombre, SUM(p.total) AS ingresos_totales
FROM pedidos p
JOIN pedido_productos pp ON pp.pedido_id = p.id
JOIN combo_productos cp ON pp.producto_id = cp.producto_id
JOIN combos c ON c.id = cp.combo_id
GROUP BY c.nombre;

## 3. Pedidos realizados para recoger vs. comer en la pizzería
SELECT tipo, COUNT(*) AS total_pedidos
FROM pedidos
GROUP BY tipo;

## 4. Adiciones más solicitadas en pedidos personalizados
SELECT a.nombre, COUNT(pa.adicion_id) AS total_adiciones
FROM pedido_adiciones pa
JOIN adiciones a ON pa.adicion_id = a.id
JOIN pedido_productos pp ON pa.pedido_producto_id = pp.id
GROUP BY a.nombre
ORDER BY total_adiciones DESC;

## 5. Cantidad total de productos vendidos por categoría
SELECT p.categoria, SUM(pp.cantidad) AS total_vendido
FROM pedido_productos pp
JOIN productos p ON pp.producto_id = p.id
GROUP BY p.categoria;

## 6. Promedio de pizzas pedidas por cliente
SELECT AVG(pizza_count) AS promedio_pizzas
FROM (
    SELECT COUNT(*) AS pizza_count
    FROM pedido_productos pp
    JOIN productos p ON pp.producto_id = p.id
    WHERE p.categoria = 'pizza'
    GROUP BY pp.pedido_id
) AS subquery;

## 7. Total de ventas por día de la semana
SELECT DAYNAME(fecha) AS dia_semana, SUM(total) AS total_ventas
FROM pedidos
GROUP BY dia_semana;

## 8. Cantidad de panzarottis vendidos con extra queso
SELECT SUM(pp.cantidad) AS total_panzarottis_con_extra
FROM pedido_productos pp
JOIN pedido_adiciones pa ON pp.id = pa.pedido_producto_id
JOIN adiciones a ON pa.adicion_id = a.id
WHERE pp.producto_id = (SELECT id FROM productos WHERE nombre = 'Panzarotti de Queso')
AND a.nombre = 'Extra Queso';


## 9. Pedidos que incluyen bebidas como parte de un combo
SELECT COUNT(DISTINCT pp.pedido_id) AS total_pedidos_con_bebidas
FROM pedido_productos pp
JOIN productos p ON pp.producto_id = p.id
WHERE p.categoria = 'bebida';

## 10. Clientes que han realizado más de 5 pedidos en el último mes
SELECT COUNT(DISTINCT p.id) AS total_clientes
FROM pedidos p
WHERE p.fecha >= DATE_SUB(NOW(), INTERVAL 1 MONTH)
GROUP BY p.id
HAVING COUNT(*) > 5;

## 11. Ingresos totales generados por productos no elaborados (bebidas, postres, etc.)
SELECT SUM(total) AS ingresos_no_elaborados
FROM pedidos p
JOIN pedido_productos pp ON p.id = pp.pedido_id
JOIN productos prod ON pp.producto_id = prod.id
WHERE prod.categoria IN ('bebida', 'postre');

## 12. Promedio de adiciones por pedido
SELECT AVG(adiciones_count) AS promedio_adiciones
FROM (
    SELECT COUNT(*) AS adiciones_count
    FROM pedido_adiciones pa
    GROUP BY pa.pedido_producto_id
) AS subquery;

## 13. Total de combos vendidos en el último mes
SELECT COUNT(*) AS total_combos_vendidos
FROM pedidos p
JOIN pedido_productos pp ON p.id = pp.pedido_id
WHERE pp.producto_id IN (SELECT producto_id FROM combo_productos);

## 14. Clientes con pedidos tanto para recoger como para consumir en el lugar
SELECT COUNT(DISTINCT cliente_id) AS total_clientes
FROM pedidos
WHERE tipo IN ('recoger', 'consumir')
GROUP BY cliente_id;

## 15. Total de productos personalizados con adiciones
SELECT COUNT(*) AS total_personalizados
FROM pedido_productos pp
LEFT JOIN pedido_adiciones pa ON pp.id = pa.pedido_producto_id
GROUP BY pp.pedido_id
HAVING COUNT(pa.adicion_id) > 0;

## 16. Pedidos con más de 3 productos diferentes
SELECT COUNT(DISTINCT pedido_id) AS total_pedidos
FROM (
    SELECT pedido_id
    FROM pedido_productos
    GROUP BY pedido_id
    HAVING COUNT(DISTINCT producto_id) > 3
) AS subquery;

## 17. Promedio de ingresos generados por día
SELECT AVG(dia_ingresos.total_dia) AS promedio_ingresos
FROM (
    SELECT DATE(fecha) AS dia, SUM(total) AS total_dia
    FROM pedidos
    GROUP BY dia
) AS dia_ingresos;

## 18. Clientes que han pedido pizzas con adiciones en más del 50% de sus pedidos
SELECT COUNT(DISTINCT pedido_id) AS total_clientes
FROM pedido_productos pp
JOIN pedido_adiciones pa ON pp.id = pa.pedido_producto_id
JOIN productos p ON pp.producto_id = p.id
WHERE p.categoria = 'pizza'
GROUP BY pp.pedido_id
HAVING COUNT(pa.adicion_id) > COUNT(pp.id) / 2;

## 19. Porcentaje de ventas provenientes de productos no elaborados
SELECT (SUM(CASE WHEN p.categoria IN ('bebida', 'postre') THEN pp.cantidad ELSE 0 END) / SUM(pp.cantidad)) * 100 AS porcentaje_no_elaborados
FROM pedido_productos pp
JOIN productos p ON pp.producto_id = p.id;

## 20. Día de la semana con mayor número de pedidos para recoger
SELECT DAYNAME(fecha) AS dia_semana, COUNT(*) AS total_pedidos
FROM pedidos
WHERE tipo = 'recoger'
GROUP BY dia_semana
ORDER BY total_pedidos DESC
LIMIT 1;

## Autores👤:

-[Mariana Rueda](https://github.com/mariana34r)
