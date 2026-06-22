-- ============================================
-- COMMON DATA ANALYSIS QUERIES
-- ============================================

-- ============================================
-- 1. GENERAL DATA EXPLORATION
-- ============================================

-- Count records by table
SELECT 
    'customers' as table_name,
    COUNT(*) as record_count
FROM customers
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'products', COUNT(*) FROM products;


-- Date range of data
SELECT 
    'Orders' as data_source,
    MIN(order_date) as earliest_date,
    MAX(order_date) as latest_date,
    COUNT(*) as total_records
FROM orders
UNION ALL
SELECT 'Customers', MIN(created_at), MAX(created_at), COUNT(*)
FROM customers;


-- ============================================
-- 2. DATA QUALITY CHECKS
-- ============================================

-- Check for nulls
SELECT 
    'customer_id' as column_name,
    COUNT(CASE WHEN customer_id IS NULL THEN 1 END) as null_count
FROM orders
UNION ALL
SELECT 'order_date', COUNT(CASE WHEN order_date IS NULL THEN 1 END) FROM orders
UNION ALL
SELECT 'amount', COUNT(CASE WHEN amount IS NULL THEN 1 END) FROM orders;


-- Check for duplicates
SELECT 
    order_id,
    COUNT(*) as count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;


-- Validate data ranges
SELECT 
    'Amount' as check_type,
    MIN(amount) as min_value,
    MAX(amount) as max_value,
    ROUND(AVG(amount), 2) as avg_value,
    ROUND(STDDEV(amount), 2) as stddev
FROM orders
UNION ALL
SELECT 'Customer Count', COUNT(DISTINCT customer_id), NULL, NULL, NULL
FROM orders;


-- ============================================
-- 3. SUMMARY STATISTICS
-- ============================================

-- Overall business metrics
SELECT 
    COUNT(DISTINCT customer_id) as total_customers,
    COUNT(DISTINCT order_id) as total_orders,
    COUNT(*) as total_line_items,
    SUM(amount) as total_revenue,
    ROUND(AVG(amount), 2) as avg_order_value,
    ROUND(SUM(amount) / COUNT(DISTINCT customer_id), 2) as avg_customer_value,
    MIN(order_date) as first_order_date,
    MAX(order_date) as latest_order_date
FROM orders;


-- Revenue by month
SELECT 
    DATE_TRUNC('month', order_date) as month,
    COUNT(DISTINCT order_id) as orders,
    COUNT(DISTINCT customer_id) as unique_customers,
    SUM(amount) as revenue,
    ROUND(AVG(amount), 2) as avg_order_value
FROM orders
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY month DESC;


-- ============================================
-- 4. PERCENTILE ANALYSIS
-- ============================================

-- Order value percentiles
SELECT 
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY amount) as percentile_25,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY amount) as median,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY amount) as percentile_75,
    PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY amount) as percentile_90,
    PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY amount) as percentile_95,
    PERCENTILE_CONT(0.99) WITHIN GROUP (ORDER BY amount) as percentile_99
FROM orders;


-- Customer spending percentiles
WITH customer_spending AS (
    SELECT 
        customer_id,
        SUM(amount) as total_spent
    FROM orders
    GROUP BY customer_id
)
SELECT 
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_spent) as percentile_25,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY total_spent) as median,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_spent) as percentile_75,
    PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY total_spent) as percentile_90,
    PERCENTILE_CONT(0.99) WITHIN GROUP (ORDER BY total_spent) as percentile_99
FROM customer_spending;


-- ============================================
-- 5. PARETO ANALYSIS (80/20 RULE)
-- ============================================

-- Revenue distribution by customer
WITH customer_revenue AS (
    SELECT 
        customer_id,
        SUM(amount) as customer_revenue,
        SUM(SUM(amount)) OVER () as total_revenue
    FROM orders
    GROUP BY customer_id
),
ranked_customers AS (
    SELECT 
        customer_id,
        customer_revenue,
        total_revenue,
        SUM(customer_revenue) OVER (
            ORDER BY customer_revenue DESC
        ) as cumulative_revenue,
        ROUND(100.0 * SUM(customer_revenue) OVER (
            ORDER BY customer_revenue DESC
        ) / total_revenue, 2) as cumulative_pct
    FROM customer_revenue
)
SELECT 
    customer_id,
    customer_revenue,
    cumulative_pct,
    CASE 
        WHEN cumulative_pct <= 20 THEN 'Top 20%'
        WHEN cumulative_pct <= 40 THEN '21-40%'
        WHEN cumulative_pct <= 60 THEN '41-60%'
        WHEN cumulative_pct <= 80 THEN '61-80%'
        ELSE '81-100%'
    END as revenue_tier
FROM ranked_customers
ORDER BY customer_revenue DESC
LIMIT 20;


-- ============================================
-- 6. TIME-BASED ANALYSIS
-- ============================================

-- Days between purchases (repeat customer behavior)
WITH purchase_dates AS (
    SELECT 
        customer_id,
        order_date,
        LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) as prev_order_date,
        DATEDIFF(order_date, LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date)) as days_between_purchases
    FROM orders
)
SELECT 
    ROUND(AVG(days_between_purchases), 0) as avg_days_between_purchases,
    MIN(days_between_purchases) as min_days_between,
    MAX(days_between_purchases) as max_days_between,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY days_between_purchases) as median_days
FROM purchase_dates
WHERE days_between_purchases IS NOT NULL;


-- Customer lifecycle (first to last purchase)
SELECT 
    customer_id,
    MIN(order_date) as first_purchase,
    MAX(order_date) as last_purchase,
    DATEDIFF(MAX(order_date), MIN(order_date)) as customer_lifespan_days,
    COUNT(DISTINCT order_date) as purchase_occasions
FROM orders
GROUP BY customer_id
ORDER BY customer_lifespan_days DESC;


-- ============================================
-- 7. GROWTH ANALYSIS
-- ============================================

-- Month-over-month growth
WITH monthly_revenue AS (
    SELECT 
        DATE_TRUNC('month', order_date) as month,
        SUM(amount) as revenue
    FROM orders
    GROUP BY DATE_TRUNC('month', order_date)
)
SELECT 
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month) as prev_month_revenue,
    ROUND(revenue - LAG(revenue) OVER (ORDER BY month), 2) as revenue_change,
    ROUND(100.0 * (revenue - LAG(revenue) OVER (ORDER BY month)) / 
          LAG(revenue) OVER (ORDER BY month), 2) as growth_percentage
FROM monthly_revenue
ORDER BY month DESC;


-- Customer acquisition growth
SELECT 
    DATE_TRUNC('month', created_at) as signup_month,
    COUNT(*) as new_customers,
    SUM(COUNT(*)) OVER (ORDER BY DATE_TRUNC('month', created_at)) as cumulative_customers
FROM customers
GROUP BY DATE_TRUNC('month', created_at)
ORDER BY signup_month DESC;
