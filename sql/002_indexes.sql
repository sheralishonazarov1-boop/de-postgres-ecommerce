-- Supports customer order history and its requested ordering.
CREATE INDEX IF NOT EXISTS idx_orders_customer_created_at
ON orders (customer_id, created_at DESC);

-- Supports finding addresses for a customer.
CREATE INDEX IF NOT EXISTS idx_addresses_customer_id
ON addresses (customer_id);

-- Supports retrieving all items of an order.
CREATE INDEX IF NOT EXISTS idx_order_items_order_id
ON order_items (order_id);

-- Supports finding orders/items involving a product.
CREATE INDEX IF NOT EXISTS idx_order_items_product_id
ON order_items (product_id);

-- Supports finding payments for an order.
CREATE INDEX IF NOT EXISTS idx_payments_order_id
ON payments (order_id);

-- Supports finding products that belong to a category.
CREATE INDEX IF NOT EXISTS idx_product_categories_category_id
ON product_categories (category_id);