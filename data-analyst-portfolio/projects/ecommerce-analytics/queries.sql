-- ============================================
-- E-COMMERCE CUSTOMER ANALYTICS - SQL QUERIES
-- ============================================
-- RFM Analysis, Cohort Analysis, Churn Prediction
-- Tables: orders, customers

-- ============================================
-- 1. RFM SEGMENTATION
-- ============================================

-- Basic RFM calculation
SELECT 
    c.customer_id,
    c.customer_name,
    COUNT(DISTINCT o.order_id) as frequency,
    SUM(o.amount) as monetary_value,
    DATEDIFF(CURDATE(), MAX(o.order_date)) as recency_days,
    ROUND(AVG(o.amount), 2) as avg_order_value,
    COUNT(DISTINCT DATE(o.order_date)) as purchase_days,
    MAX(o.order_date) as last_purchase_date,
    MIN(o.order_date) as first_purchase_date
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY monetary_value DESC;


-- RFM Segments with scoring
SELECT 
    customer_id,
    frequency,
    monetary_value,
    recency_days,
    CASE 
        WHEN recency_days <= 30 THEN 5
        WHEN recency_days <= 60 THEN 4
        WHEN recency_days <= 90 THEN 3
        WHEN recency_days <= 180 THEN 2
        ELSE 1
    END as R_score,
    CASE 
        WHEN frequency >= 20 THEN 5
        WHEN frequency >= 10 THEN 4
        WHEN frequency >= 5 THEN 3
        WHEN frequency >= 2 THEN 2
        ELSE 1
    END as F_score,
    CASE 
        WHEN monetary_value >= 2000 THEN 5
        WHEN monetary_value >= 1000 THEN 4
        WHEN monetary_value >= 500 THEN 3
        WHEN monetary_value >= 100 THEN 2
        ELSE 1
    END as M_score,
    CASE 
        WHEN monetary_value >= 2000 THEN 'VIP'
        WHEN monetary_value >= 1000 THEN 'High-Value'
        WHEN monetary_value >= 300 THEN 'Regular'
        WHEN monetary_value >= 50 THEN 'Low-Value'
        ELSE 'Dormant'
    END as segment
FROM (
    SELECT 
        c.customer_id,
        COUNT(DISTINCT o.order_id) as frequency,
        SUM(o.amount) as monetary_value,
        DATEDIFF(CURDATE(), MAX(o.order_date)) as recency_days
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id
) rfm_data
ORDER BY monetary_value DESC;


-- Segment distribution
SELECT 
    CASE 
        WHEN monetary_value >= 2000 THEN 'VIP'
        WHEN monetary_value >= 1000 THEN 'High-Value'
        WHEN monetary_value >= 300 THEN 'Regular'
        WHEN monetary_value >= 50 THEN 'Low-Value'
        ELSE 'Dormant'
    END as segment,
    COUNT(*) as customer_count,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM customers), 2) as segment_percentage,
    ROUND(SUM(monetary_value), 0) as total_revenue,
    ROUND(100.0 * SUM(monetary_value) / (SELECT SUM(amount) FROM orders), 2) as revenue_percentage,
    ROUND(AVG(monetary_value), 0) as avg_clv,
    ROUND(AVG(frequency), 1) as avg_frequency,
    ROUND(AVG(recency_days), 0) as avg_recency_days
FROM (
    SELECT 
        c.customer_id,
        COUNT(DISTINCT o.order_id) as frequency,
        SUM(o.amount) as monetary_value,
        DATEDIFF(CURDATE(), MAX(o.order_date)) as recency_days
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id
) rfm_data
GROUP BY segment
ORDER BY total_revenue DESC;


-- ============================================
-- 2. COHORT ANALYSIS
-- ============================================

-- Create cohort month for each customer (month of first purchase)
-- Cohort retention by month
WITH cohort_data AS (
    SELECT 
        c.customer_id,
        DATE_TRUNC('month', MIN(o.order_date)) as cohort_month,
        DATE_TRUNC('month', o.order_date) as order_month,
        DATEDIFF(
            YEAR_MONTH(DATE_TRUNC('month', o.order_date)),
            YEAR_MONTH(DATE_TRUNC('month', MIN(o.order_date)))
        ) as cohort_age
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, DATE_TRUNC('month', o.order_date)
)
SELECT 
    cohort_month,
    cohort_age,
    COUNT(DISTINCT customer_id) as customers_active
FROM cohort_data
GROUP BY cohort_month, cohort_age
ORDER BY cohort_month DESC, cohort_age;


-- Cohort retention rates (pivot view)
WITH cohort_data AS (
    SELECT 
        c.customer_id,
        DATE_TRUNC('month', MIN(o.order_date)) as cohort_month,
        DATEDIFF(
            YEAR_MONTH(DATE_TRUNC('month', o.order_date)),
            YEAR_MONTH(DATE_TRUNC('month', MIN(o.order_date)))
        ) as cohort_age
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, DATE_TRUNC('month', o.order_date)
)
SELECT 
    cohort_month,
    COUNT(DISTINCT CASE WHEN cohort_age = 0 THEN customer_id END) as month_0,
    COUNT(DISTINCT CASE WHEN cohort_age = 1 THEN customer_id END) as month_1,
    COUNT(DISTINCT CASE WHEN cohort_age = 2 THEN customer_id END) as month_2,
    COUNT(DISTINCT CASE WHEN cohort_age = 3 THEN customer_id END) as month_3,
    COUNT(DISTINCT CASE WHEN cohort_age = 4 THEN customer_id END) as month_4,
    COUNT(DISTINCT CASE WHEN cohort_age = 5 THEN customer_id END) as month_5,
    COUNT(DISTINCT CASE WHEN cohort_age = 6 THEN customer_id END) as month_6,
    COUNT(DISTINCT CASE WHEN cohort_age = 12 THEN customer_id END) as month_12
FROM cohort_data
GROUP BY cohort_month
ORDER BY cohort_month DESC;


-- Cohort retention percentages
WITH cohort_data AS (
    SELECT 
        c.customer_id,
        DATE_TRUNC('month', MIN(o.order_date)) as cohort_month,
        DATEDIFF(
            YEAR_MONTH(DATE_TRUNC('month', o.order_date)),
            YEAR_MONTH(DATE_TRUNC('month', MIN(o.order_date)))
        ) as cohort_age
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, DATE_TRUNC('month', o.order_date)
),
cohort_size AS (
    SELECT 
        cohort_month,
        COUNT(DISTINCT customer_id) as cohort_size
    FROM cohort_data
    WHERE cohort_age = 0
    GROUP BY cohort_month
)
SELECT 
    cd.cohort_month,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN cd.cohort_age = 0 THEN cd.customer_id END) / cs.cohort_size, 1) as month_0_pct,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN cd.cohort_age = 1 THEN cd.customer_id END) / cs.cohort_size, 1) as month_1_pct,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN cd.cohort_age = 2 THEN cd.customer_id END) / cs.cohort_size, 1) as month_2_pct,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN cd.cohort_age = 3 THEN cd.customer_id END) / cs.cohort_size, 1) as month_3_pct,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN cd.cohort_age = 6 THEN cd.customer_id END) / cs.cohort_size, 1) as month_6_pct,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN cd.cohort_age = 12 THEN cd.customer_id END) / cs.cohort_size, 1) as month_12_pct
FROM cohort_data cd
JOIN cohort_size cs ON cd.cohort_month = cs.cohort_month
GROUP BY cd.cohort_month, cs.cohort_size
ORDER BY cd.cohort_month DESC;


-- ============================================
-- 3. CHURN ANALYSIS
-- ============================================

-- Customers at risk of churn (inactive 90+ days)
SELECT 
    customer_id,
    customer_name,
    DATEDIFF(CURDATE(), MAX(order_date)) as days_inactive,
    COUNT(DISTINCT order_id) as total_purchases,
    SUM(amount) as total_spent,
    ROUND(AVG(amount), 2) as avg_order_value,
    MAX(order_date) as last_purchase_date,
    CASE 
        WHEN DATEDIFF(CURDATE(), MAX(order_date)) > 180 THEN 'Churned'
        WHEN DATEDIFF(CURDATE(), MAX(order_date)) > 90 THEN 'At Risk'
        WHEN DATEDIFF(CURDATE(), MAX(order_date)) > 60 THEN 'Attention Needed'
        ELSE 'Active'
    END as churn_status,
    CASE 
        WHEN SUM(amount) >= 2000 THEN 'VIP'
        WHEN SUM(amount) >= 1000 THEN 'High-Value'
        WHEN SUM(amount) >= 300 THEN 'Regular'
        ELSE 'Low-Value'
    END as customer_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY days_inactive DESC;


-- Churn rate by inactivity threshold
SELECT 
    CASE 
        WHEN DATEDIFF(CURDATE(), MAX(order_date)) > 180 THEN '180+ days'
        WHEN DATEDIFF(CURDATE(), MAX(order_date)) > 120 THEN '120-180 days'
        WHEN DATEDIFF(CURDATE(), MAX(order_date)) > 90 THEN '90-120 days'
        WHEN DATEDIFF(CURDATE(), MAX(order_date)) > 60 THEN '60-90 days'
        WHEN DATEDIFF(CURDATE(), MAX(order_date)) > 30 THEN '30-60 days'
        ELSE '< 30 days'
    END as inactivity_period,
    COUNT(*) as customers,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(DISTINCT customer_id) FROM customers), 2) as pct_of_base,
    ROUND(SUM(CASE WHEN COUNT(DISTINCT order_id) >= 2 THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0), 3) as retention_rate
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY inactivity_period
ORDER BY MAX(DATEDIFF(CURDATE(), MAX(order_date))) DESC;


-- ============================================
-- 4. PRODUCT AFFINITY & CROSS-SELL
-- ============================================

-- Products frequently bought together (association rules)
SELECT 
    oi1.product_id as product_a,
    oi2.product_id as product_b,
    COUNT(DISTINCT oi1.order_id) as times_bought_together,
    ROUND(100.0 * COUNT(DISTINCT oi1.order_id) / (
        SELECT COUNT(DISTINCT order_id) FROM order_items WHERE product_id = oi1.product_id
    ), 2) as affinity_percentage
FROM order_items oi1
JOIN order_items oi2 ON oi1.order_id = oi2.order_id AND oi1.product_id < oi2.product_id
GROUP BY oi1.product_id, oi2.product_id
HAVING COUNT(DISTINCT oi1.order_id) >= 10
ORDER BY times_bought_together DESC;


-- Average order value by product combination
SELECT 
    p1.product_name,
    p2.product_name,
    COUNT(DISTINCT o.order_id) as frequency,
    ROUND(AVG(o.amount), 2) as avg_order_value
FROM orders o
JOIN order_items oi1 ON o.order_id = oi1.order_id
JOIN order_items oi2 ON o.order_id = oi2.order_id AND oi1.product_id < oi2.product_id
JOIN products p1 ON oi1.product_id = p1.product_id
JOIN products p2 ON oi2.product_id = p2.product_id
GROUP BY p1.product_name, p2.product_name
HAVING COUNT(DISTINCT o.order_id) >= 5
ORDER BY frequency DESC;


-- ============================================
-- 5. CUSTOMER LIFETIME VALUE (CLV)
-- ============================================

-- CLV by customer segment
SELECT 
    CASE 
        WHEN SUM(o.amount) >= 2000 THEN 'VIP'
        WHEN SUM(o.amount) >= 1000 THEN 'High-Value'
        WHEN SUM(o.amount) >= 300 THEN 'Regular'
        WHEN SUM(o.amount) >= 50 THEN 'Low-Value'
        ELSE 'Dormant'
    END as segment,
    COUNT(*) as customers,
    ROUND(SUM(o.amount), 0) as total_revenue,
    ROUND(AVG(o.amount), 0) as avg_clv,
    ROUND(MAX(o.amount), 0) as max_clv,
    ROUND(MIN(o.amount), 0) as min_clv,
    ROUND(STDDEV(o.amount), 0) as clv_stddev
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY segment
ORDER BY total_revenue DESC;


-- CLV forecast (based on historical trends)
SELECT 
    c.customer_id,
    SUM(o.amount) as historical_clv,
    ROUND(AVG(o.amount), 2) as avg_transaction,
    COUNT(DISTINCT o.order_id) as lifetime_purchases,
    DATEDIFF(MAX(o.order_date), MIN(o.order_date)) as customer_lifespan_days,
    ROUND(COUNT(DISTINCT o.order_id) / NULLIF(DATEDIFF(MAX(o.order_date), MIN(o.order_date)), 0), 2) as purchases_per_day,
    ROUND(SUM(o.amount) / NULLIF(DATEDIFF(MAX(o.order_date), MIN(o.order_date)), 0), 2) as revenue_per_day,
    ROUND(
        SUM(o.amount) + 
        (ROUND(COUNT(DISTINCT o.order_id) / NULLIF(DATEDIFF(MAX(o.order_date), MIN(o.order_date)), 0), 2) * 365 *
         ROUND(AVG(o.amount), 2)),
        0
    ) as projected_annual_clv
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
ORDER BY projected_annual_clv DESC;


-- ============================================
-- 6. REPEAT PURCHASE ANALYSIS
-- ============================================

-- Customer purchase frequency distribution
SELECT 
    purchase_count,
    COUNT(*) as customers,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(DISTINCT customer_id) FROM customers), 2) as percentage,
    ROUND(SUM(total_spent) / NULLIF(COUNT(*), 0), 0) as avg_clv_segment
FROM (
    SELECT 
        c.customer_id,
        COUNT(DISTINCT o.order_id) as purchase_count,
        SUM(o.amount) as total_spent
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id
) customer_purchases
GROUP BY purchase_count
ORDER BY purchase_count;


-- Single-purchase vs. repeat customers
SELECT 
    CASE 
        WHEN purchase_count = 1 THEN 'One-Time'
        WHEN purchase_count BETWEEN 2 AND 5 THEN '2-5 Purchases'
        WHEN purchase_count BETWEEN 6 AND 10 THEN '6-10 Purchases'
        ELSE '10+ Purchases'
    END as customer_type,
    COUNT(*) as customers,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(DISTINCT customer_id) FROM customers), 2) as percentage,
    SUM(total_spent) as segment_revenue,
    ROUND(AVG(total_spent), 0) as avg_clv
FROM (
    SELECT 
        c.customer_id,
        COUNT(DISTINCT o.order_id) as purchase_count,
        SUM(o.amount) as total_spent
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id
) customer_purchases
GROUP BY customer_type
ORDER BY avg_clv DESC;


-- ============================================
-- 7. SUMMARY METRICS
-- ============================================

-- High-level KPIs
SELECT 
    COUNT(DISTINCT customer_id) as total_customers,
    COUNT(DISTINCT order_id) as total_orders,
    SUM(amount) as total_revenue,
    ROUND(SUM(amount) / COUNT(DISTINCT customer_id), 2) as avg_clv,
    ROUND(SUM(amount) / COUNT(DISTINCT order_id), 2) as avg_order_value,
    ROUND(COUNT(DISTINCT order_id) / NULLIF(COUNT(DISTINCT customer_id), 0), 2) as avg_orders_per_customer
FROM orders;


-- Customer acquisition and retention trend
SELECT 
    DATE_TRUNC('month', order_date) as month,
    COUNT(DISTINCT customer_id) as active_customers,
    COUNT(DISTINCT order_id) as orders,
    ROUND(SUM(amount), 0) as revenue
FROM orders
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY month DESC;
