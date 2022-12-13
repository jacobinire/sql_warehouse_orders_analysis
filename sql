-- This SQL script demonstrates my learning from the Google data analytics certificate on Coursera.

-- Purpose : Identify the orders fulfillment of each warehouses 
-- Constructing complex query by using subqueries (CASE, HAVING, ELSE)

SELECT 
  warehouse.warehouse_id,
  CONCAT(warehouse.state,':',warehouse.warehouse_alias) AS warehouse_name,
  COUNT(orders.order_id) AS number_of_orders,
  (SELECT
    COUNT(*)
    FROM Warehouse_orders.Orders AS orders)
  AS total_orders,
  CASE
    WHEN COUNT (orders.order_id)/ (SELECT COUNT(*) FROM Warehouse_orders.Orders AS orders)<=0.20
    THEN 'Fulfilled 0-20% of Orders'
    WHEN COUNT (orders.order_id)/ (SELECT COUNT(*) FROM Warehouse_orders.Orders AS orders)>0.20
    AND COUNT (orders.order_id)/ (SELECT COUNT(*) FROM Warehouse_orders.Orders AS orders)<=0.60
    THEN 'Fulfilled 21%-60% of Orders'
  ELSE 'Fulfilled more than 60% of Orders'
  END AS fulfillment_summary
FROM
  Warehouse_orders.Warehouse AS warehouse
LEFT JOIN
  Warehouse_orders.Orders AS orders
ON
  orders.warehouse_id = warehouse.warehouse_id
GROUP BY
  warehouse.warehouse_id,
  warehouse_name
HAVING
  COUNT(orders.order_id) > 0
