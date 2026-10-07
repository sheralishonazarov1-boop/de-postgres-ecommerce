create table customers (
    customer_id bigint generated always as identity primary key,
    first_name varchar(100) not null,
    last_name varchar(100) not null,
    email varchar(255) not null unique,
    phone varchar(30),
    created_at timestamptz not null default current_timestamp
);

create table addresses (
    address_id bigint generated always as identity primary key,
    customer_id bigint not null,
    address_type varchar(30) not null,
    street varchar(255) not null,
    city varchar(100) not null,
    country varchar(100) not null,

    constraint fk_adresses_customer
        foreign key (customer_id)
        references customers(customer_id)
);

create table products (
    product_id bigint generated always as identity primary key,
    sku varchar(50) not null unique,
    name varchar(255) not null,
    price numeric(12, 2) not null,
    created_at timestamptz not null default current_timestamp,
    active boolean not null default true,

    constraint chk_product_price
        check (price >= 0)
);

create table categories (
    category_id bigint generated always as identity primary key,
    name varchar(100) not null unique
);

create table product_categories (
    product_id bigint not null,
    category_id bigint not null,

    primary key (product_id, category_id),

    constraint fk_product_categories_product
        foreign key (product_id)
        references products(product_id),

    constraint fk_product_categories_category
        foreign key (category_id)
        references categories(category_id)   
);

create table orders (
    order_id bigint generated always as identity primary key,
    customer_id bigint not null,
    status varchar(30) not null default 'pending',
    created_at timestamptz not null default current_timestamp,

    constraint fk_orders_customers
        foreign key (customer_id)
        references customers(customer_id)
);

create table order_items (
    order_item_id bigint generated always as identity primary key,
    order_id bigint not null,
    product_id bigint not null,
    quantity integer not null,
    unit_price numeric(12, 2) not null,

    constraint fk_order_items_order
        foreign key (order_id)
        references orders(order_id),

    constraint fk_order_items_product
        foreign key (product_id)
        references products(product_id),

    constraint chk_order_items_quantity
        check (quantity > 0),

    constraint chk_order_items_unit_price
        check (unit_price >= 0)
);

create table payments (
    payment_id bigint generated always as identity primary key,
    order_id bigint not null,
    amount numeric(12, 2) not null,
    status varchar(30) not null,
    payment_method varchar(30) not null,
    created_at timestamptz not null default current_timestamp,

    constraint fk_payments_order
        foreign key (order_id)
        references orders(order_id),

    constraint chk_payments_amount
        check (amount >= 0)
);


SELECT
    o.order_id,
    c.first_name,
    c.last_name,
    p.name AS product,
    oi.quantity,
    oi.unit_price,
    oi.quantity * oi.unit_price AS line_total
FROM orders o
JOIN customers c
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON oi.order_id = o.order_id
JOIN products p
    ON p.product_id = oi.product_id
ORDER BY o.order_id, oi.order_item_id;