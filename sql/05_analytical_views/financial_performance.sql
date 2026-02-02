/* ============================================================
   YEARLY FINANCIAL PERFORMANCE ANALYSIS
   ------------------------------------------------------------
   This section analyzes business-level financial metrics
   derived from customer orders (revenue) and vendor invoices
   (spend), and computes yearly net profit.
   ============================================================ */


/* ------------------------------------------------------------
   1. Total Revenue Per Year
   ------------------------------------------------------------
   Calculates yearly revenue generated from customer orders
   based on unit selling price and quantity sold.
   ------------------------------------------------------------ */
SELECT 
    YEAR(o.order_date) AS year,
    ROUND(SUM(oi.unit_price * oi.quantity_to_buy), 2) AS total_revenue
FROM 
    orders o
JOIN 
    order_items oi ON o.order_id = oi.order_id
GROUP BY 
    YEAR(o.order_date)
ORDER BY 
    year;


/* ------------------------------------------------------------
   2. Total Vendor Spend Per Year
   ------------------------------------------------------------
   Calculates yearly procurement spend using invoice data
   based on vendor item price and quantity purchased.
   ------------------------------------------------------------ */
SELECT 
    YEAR(i.invoice_date) AS year,
    ROUND(SUM(ii.item_price * ii.quantity_bought), 2) AS total_spend
FROM 
    invoices i
JOIN 
    invoice_items_details ii ON i.invoice_id = ii.invoice_id
GROUP BY 
    YEAR(i.invoice_date)
ORDER BY 
    year;


/* ------------------------------------------------------------
   3. Net Profit Per Year
   ------------------------------------------------------------
   Combines yearly revenue and vendor spend to compute
   net profit (Revenue − Spend) for each year.
   ------------------------------------------------------------ */
SELECT 
    rev.year,
    ROUND(rev.total_revenue, 2) AS total_revenue,
    ROUND(spend.total_spend, 2) AS total_spend,
    ROUND(rev.total_revenue - spend.total_spend, 2) AS net_profit
FROM (
    SELECT 
        YEAR(o.order_date) AS year,
        SUM(oi.unit_price * oi.quantity_to_buy) AS total_revenue
    FROM 
        orders o
    JOIN 
        order_items oi ON o.order_id = oi.order_id
    GROUP BY 
        YEAR(o.order_date)
) rev
JOIN (
    SELECT 
        YEAR(i.invoice_date) AS year,
        SUM(ii.item_price * ii.quantity_bought) AS total_spend
    FROM 
        invoices i
    JOIN 
        invoice_items_details ii ON i.invoice_id = ii.invoice_id
    GROUP BY 
        YEAR(i.invoice_date)
) spend
ON 
    rev.year = spend.year
ORDER BY 
    rev.year;
