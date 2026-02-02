/*
File: yearly_business_summary.sql

Purpose:
Provides a yearly business performance summary combining:
- Vendor spend (procurement cost)
- Customer revenue
- Net profit / loss
- Profit margin %
- Revenue split by order type (Online vs Store Pickup)

Notes:
- MySQL does not support FULL OUTER JOIN natively
- FULL OUTER JOIN behavior is simulated using UNION of LEFT JOINs
- COALESCE is used to safely handle missing years across datasets
*/


WITH 

/* Total yearly spend on vendor purchases */
vendor_spend AS (
  SELECT 
    YEAR(i.invoice_date) AS year,
    ROUND(SUM(ii.item_price * ii.quantity_bought), 2) AS total_vendor_spend
  FROM invoices i
  JOIN invoice_items_details ii 
    ON i.invoice_id = ii.invoice_id
  GROUP BY YEAR(i.invoice_date)
),

/* Total yearly revenue from customer orders */
actual_revenue AS (
  SELECT 
    YEAR(o.order_date) AS year,
    ROUND(SUM(oi.unit_price * oi.quantity_to_buy), 2) AS total_customer_revenue
  FROM orders o
  JOIN order_items oi 
    ON o.order_id = oi.order_id
  GROUP BY YEAR(o.order_date)
),

/* Net profit = (selling price - vendor price) * quantity sold */
net_profit AS (
  SELECT 
    YEAR(o.order_date) AS year,
    ROUND(
      SUM((oi.unit_price - ii.item_price) * oi.quantity_to_buy), 
      2
    ) AS net_profit_or_loss
  FROM orders o
  JOIN order_items oi 
    ON o.order_id = oi.order_id
  JOIN invoice_items_details ii 
    ON oi.album_id = ii.album_id
  GROUP BY YEAR(o.order_date)
),

/* Revenue split by order type */
order_type_revenue AS (
  SELECT 
    YEAR(o.order_date) AS year,
    ROUND(
      SUM(CASE WHEN o.order_type_id = 1 
               THEN oi.unit_price * oi.quantity_to_buy ELSE 0 END), 
      2
    ) AS online_revenue,
    ROUND(
      SUM(CASE WHEN o.order_type_id = 2 
               THEN oi.unit_price * oi.quantity_to_buy ELSE 0 END), 
      2
    ) AS store_revenue
  FROM orders o
  JOIN order_items oi 
    ON o.order_id = oi.order_id
  GROUP BY YEAR(o.order_date)
)

/* FULL OUTER JOIN simulation – pass 1 */
SELECT 
  COALESCE(vs.year, ar.year, np.year, otr.year) AS year,
  COALESCE(vs.total_vendor_spend, 0) AS total_vendor_spend,
  COALESCE(ar.total_customer_revenue, 0) AS total_customer_revenue,
  COALESCE(np.net_profit_or_loss, 0) AS net_profit_or_loss,
  CASE 
    WHEN ar.total_customer_revenue > 0 
      THEN ROUND(
        (np.net_profit_or_loss / ar.total_customer_revenue) * 100, 
        2
      )
    ELSE 0
  END AS profit_margin_percent,
  COALESCE(otr.online_revenue, 0) AS online_revenue,
  COALESCE(otr.store_revenue, 0) AS store_revenue
FROM vendor_spend vs
LEFT JOIN actual_revenue ar 
  ON vs.year = ar.year
LEFT JOIN net_profit np 
  ON vs.year = np.year
LEFT JOIN order_type_revenue otr 
  ON vs.year = otr.year

UNION

/* FULL OUTER JOIN simulation – pass 2 */
SELECT 
  COALESCE(vs.year, ar.year, np.year, otr.year) AS year,
  COALESCE(vs.total_vendor_spend, 0) AS total_vendor_spend,
  COALESCE(ar.total_customer_revenue, 0) AS total_customer_revenue,
  COALESCE(np.net_profit_or_loss, 0) AS net_profit_or_loss,
  CASE 
    WHEN ar.total_customer_revenue > 0 
      THEN ROUND(
        (np.net_profit_or_loss / ar.total_customer_revenue) * 100, 
        2
      )
    ELSE 0
  END AS profit_margin_percent,
  COALESCE(otr.online_revenue, 0) AS online_revenue,
  COALESCE(otr.store_revenue, 0) AS store_revenue
FROM actual_revenue ar
LEFT JOIN vendor_spend vs 
  ON ar.year = vs.year
LEFT JOIN net_profit np 
  ON ar.year = np.year
LEFT JOIN order_type_revenue otr 
  ON ar.year = otr.year

ORDER BY year;
