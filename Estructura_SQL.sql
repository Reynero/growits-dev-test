/*****************************************CREACION DE TABLASA************************************/
create TABLE cliente(
    id int not null PRIMARY KEY AUTO_INCREMENT,
    name varchar(60) not null,
    lastname varchar(60) not null,
    ci varchar(30) not null,
    gender char 
);

create table producto(
    id int not null PRIMARY KEY AUTO_INCREMENT,
    name varchar(60) not null,
    type varchar(40),
    available boolean
);

create table detalle_pedido(
    id int not null PRIMARY KEY AUTO_INCREMENT,
    description varchar(150) not null,
    invoice_num varchar(50),
    cost int
);

create table pedido(
    id int not null PRIMARY KEY AUTO_INCREMENT,
    name varchar(50) not null,
    done boolean,
    order_date date,
    client_id int,
    order_details_id int,
    FOREIGN KEY (client_id) REFERENCES cliente(id),
    FOREIGN KEY (order_details_id) REFERENCES detalle_pedido(id)
);

create table producto_pedido(
    product_id int,
    order_id int,
    PRIMARY KEY (product_id, order_id),/*composite primary key */
    FOREIGN KEY (product_id) REFERENCES producto(id),
    FOREIGN KEY (order_id) REFERENCES pedido(id)
);

/*************************************POBLACION DE TABLAS*****************************************/
INSERT INTO cliente (name, lastname, ci, gender)
VALUES 
("reynero", "torrico", "5656565sc", "V"),
("jorge", "perez", "5656565sc", "V"),
("david", "torrico", "5656565sc", "V"),
("maria", "morales", "5656565sc", "M"),
("luciana", "gonzales", "5656565sc", "M"),
("laura", "orellanos", "5656565sc", "M"),
("pepe", "mujica", "5656565sc", "V"),
("adriana", "terceros", "5656565sc", "M"),
("adolf", "hitler", "5656565sc", "V"),
("abraham", "lincoln", "5656565sc", "V");

INSERT INTO producto (name, type, available)
VALUES 
("pantalones", "merch", true),
("camisa", "merch", false),
("chompa", "merch", true),
("album #1", "musica", true),
("album #2", "musica", true),
("album #3", "musica", true),
("zapatos", "merch", true),
("vodka", "colab_bebida", true),
("album #4", "musica", true),
("album #5", "musica", true);

INSERT INTO detalle_pedido (description, invoice_num, cost) VALUES
('Music Album - Rock Classics', 1001, 15.99),
('Merch - Band T-Shirt', 1002, 25.00),
('Product Collaboration - Limited Edition Vinyl', 1003, 35.50),
('Music Album - Jazz Vibes', 1004, 12.99),
('Merch - Hoodie', 1005, 45.00),
('Product Collaboration - Exclusive Poster', 1006, 20.00),
('Music Album - Pop Hits', 1007, 14.99),
('Merch - Cap', 1008, 18.00),
('Product Collaboration - Collectors Edition CD', 1009, 30.00),
('Music Album - Indie Favorites', 1010, 10.99);


INSERT INTO pedido (name, done, order_date, client_id, order_details_id) 
VALUES
('Order1', true, '2024-10-01', 9, 1),
('Order2', false, '2024-11-02', 2, 2),
('Order3', true, '2024-01-03', 6, 3),
('Order4', false, '2024-01-04', 4, 4),
('Order5', true, '2024-05-05', 5, 5),
('Order6', false, '2024-08-06', 1, 6),
('Order7', true, '2024-08-07', 2, 7),
('Order8', false, '2024-08-08', 3, 8),
('Order9', true, '2024-09-09', 7, 9),
('Order10', false, '2024-11-10', 10, 10);

INSERT INTO producto_pedido (product_id, order_id) VALUES
(5, 1),
(2, 1),
(3, 2),
(4, 3),
(5, 3),
(1, 4),
(2, 5),
(8, 6),
(4, 7),
(5, 8),
(5, 9),
(5, 10);

/*ACA ESTAMOS SOLICITANDO QUE SOLO NOS MUESTRE LOS ID DE LOS CLIENTES QUE TIENEN MAS PEDIDOS 
BAJO SU MISMO ID

LA FUNCION DEL CODIGO JUEGA CON LA FECHA DE TAL MANERA QUE RESTA 6 MESES DE LA FECHA ACTUAL Y LO
COMPARA CON LAS FECHAS DE LOS PEDIDOS

LOS PEDIDOS CON FECHA MAYOR A LA FECHA ACTUAL MENOS 6 MESES

ADEMAS ESTAMOS CONTANDO TOOOS LOS PEDIDOS Y AGRUPANDOLOS PARA UNA MEJOR VISUALIZACION DE LOS DATOS*/
SELECT client_id, COUNT(*) AS order_count
FROM pedido
WHERE order_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY client_id
ORDER BY order_count DESC;


/*NUEVAMENTE ESTAMOS HACIENDO UN JUEGO CON LA FECHA PERO ESTA VEZ CONTANDO LA CANTIDAD DE PEDIDOS
QUE TIENE CADA PRODUCTO DE LA TABLA PRODUCTO_PEDIDO

EL LIMIT 1 NOS LIMITA A MOSTRAR SOLO EL MAYOR RESULTADO*/
SELECT pp.product_id, COUNT(*) AS quantity_sold
FROM producto_pedido pp
JOIN pedido p ON pp.order_id = p.id
WHERE p.order_date >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
GROUP BY pp.product_id
ORDER BY quantity_sold DESC
LIMIT 1;

/*ESTA SOLICITUD SOLO NECESITA UNA COMPARACION DONDE EL ID DEL CLIENTE NO APAREZCA EN LA TABLA DE PEDIDOS
CONTANDO TABIEN QUE SEGUIMOS MANIPULANDO LA FECHA, EN ESTE CASO, MENOS 1 ANHO*/
SELECT c.*
FROM cliente c
LEFT JOIN pedido p ON c.id = p.client_id AND p.order_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
WHERE p.client_id IS NULL;

/*EN ESTA OCASION ESTAMOS HACIENDO UNA COMPARACION DE LA AGRUPACION DE CADA PEDIDO CON 
UN COSTO MAYOR A 5000 HACIENDO UN JOIN DE CADA PEDIDO CON SU DETALLE*/
SELECT p.*, dp.cost
FROM pedido p
JOIN detalle_pedido dp ON p.order_details_id = dp.id
GROUP BY p.id
HAVING dp.cost > 5000;

/*EN EL EJERCICIO SE UTILIZO ESTE MANEJO DE INDICES YA QUE SE OBSERVO QUE LOS REQUERIMIENTOS
SOLICITAN MUCHA MANIPULACION DE LA COLUMA DE FECHAS, POR LO TANTO, APLICACNDO UN INDICE SOBRE 
ESTA COLUMNA AUMENTARIA SUSTANCIALMENTE LA EFICIENCIA DE CADA SOLICITUD (QUERY)*/
CREATE INDEX date_index ON pedido (order_date);


