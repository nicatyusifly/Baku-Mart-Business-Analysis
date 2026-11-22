-- =====================================================================
-- BakuMart: Satis ve Musteri Analizi (SQL)
-- Verilenler bazasi : Oracle SQL (Oracle FreeSQL-de test olunub)
-- Cedvellər         : customers, orders, order_items, products, employees, departments
-- Dovr              : 01.01.2024 - 31.12.2025 (bu gun = 31.12.2025)
-- Netice            : ../results/bakumart_results.md
--
-- Terminler:
--   Net satis geliri = quantity * unit_price * (1 - discount)   (order_items cedvelinden)
--   Umumi menfeet    = satis geliri - quantity * cost_price
--   Marja            = umumi menfeet / satis geliri
--
-- Qeyd: "tamamlanmis" yazilan sorgularda yalniz status = 'Tamamlandı'
--       sifarisler goturulur. Digerlerinde status filtri yoxdur.
--
-- Mundericat
--   A. Esas suallar
--      1  Kateqoriya uzre orta marja (HAVING)
--      2  Top 10 musteri (JOIN, FETCH FIRST)
--      3  Hec vaxt sifaris vermemis musteriler (NOT EXISTS)
--      4  Hec vaxt satilmamis mehsullar (NOT EXISTS)
--      5  2025 ay uzre satis geliri (EXTRACT, GROUP BY)
--      6  Sifaris mebleg qruplari (CTE, CASE, window SUM)
--      7  Kateqoriyada top 3 mehsul (RANK)
--      8  Ayliq deyisme ve kumulyativ gelir (LAG)
--      9  Hele gonderilmemis sifarisler (NULL, tarix hesabi)
--      10 "Risk altinda" musteriler (MAX/MIN, CASE, HAVING)
--      11 Menecer uzre musteri ve sifaris sayi (COUNT DISTINCT)
--      12 Ilk sifaris ve kanal (ROW_NUMBER)
--   B. Elave biznes analizleri
--      13 2024 vs 2025: umumi muqayise (LAG)
--      14 2024 vs 2025: kateqoriya uzre (LAG PARTITION BY)
--      15 Kateqoriya uzre satis geliri ve umumi menfeet
--      16 Kanallar: satis geliri ve orta sifaris meblegi (AOV)
--      17 Kanallar uzre illik deyisme (LAG)
--      18 Musteri konsentrasiyasi (RANK)
-- =====================================================================

-- =====================================================
-- A. ESAS SUALLAR (1-12)
-- =====================================================

-- 1. Kateqoriya uzre mehsul sayi, orta qiymet, orta marja (yalniz >30%)
SELECT category,
       COUNT(*) AS mehsul_sayi,
       ROUND(AVG(unit_price)) AS orta_qiymet,
       ROUND(100 * AVG((unit_price - cost_price) / unit_price), 2) AS orta_marja
FROM products
GROUP BY category
HAVING 100 * AVG((unit_price - cost_price) / unit_price) > 30;

-- 2. Top 10 musteri ("Tamamlandi")
SELECT c.full_name, c.city,
       COUNT(DISTINCT o.order_id) AS sifaris_sayi,
       SUM(i.quantity * i.unit_price * (1 - i.discount)) AS umumi_mebleg
FROM customers c
JOIN orders o       ON c.customer_id = o.customer_id
JOIN order_items i  ON o.order_id = i.order_id
WHERE LOWER(o.status) = 'tamamlandı'
GROUP BY c.full_name, c.city
ORDER BY umumi_mebleg DESC
FETCH FIRST 10 ROWS ONLY;

-- 3. Hec vaxt sifaris vermemis musteriler
SELECT c.full_name, c.registration_date
FROM customers c
WHERE NOT EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id);

-- 4. Hec vaxt satilmamis mehsullar
SELECT p.product_name
FROM products p
WHERE NOT EXISTS (SELECT 1 FROM order_items i WHERE i.product_id = p.product_id);

-- 5. 2025 ay uzre tamamlanmis sifaris sayi ve net satis geliri
SELECT TO_CHAR(o.order_date, 'MM') AS ay,
       COUNT(DISTINCT o.order_id) AS sifaris_sayi,
       ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount)), 2) AS net_satis_geliri
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE EXTRACT(YEAR FROM o.order_date) = 2025
  AND o.status = 'Tamamlandı'
GROUP BY TO_CHAR(o.order_date, 'MM')
ORDER BY ay;

-- 6. Sifaris mebleg qruplari ve satis gelirindeki pay
WITH sifaris_meblegi AS (
    SELECT order_id,
           SUM(quantity * unit_price * (1 - discount)) AS mebleg_total
    FROM order_items
    GROUP BY order_id
),
mebleg_qrupu AS (
    SELECT order_id, mebleg_total,
           CASE WHEN mebleg_total < 300  THEN 'Kicik'
                WHEN mebleg_total <= 1500 THEN 'Orta'
                ELSE 'Boyuk' END AS kateqoriya
    FROM sifaris_meblegi
)
SELECT kateqoriya,
       COUNT(order_id) AS sifaris_sayi,
       ROUND(SUM(mebleg_total), 2) AS total_mebleg,
       ROUND(100 * SUM(mebleg_total) / SUM(SUM(mebleg_total)) OVER (), 2) AS pay_faiz
FROM mebleg_qrupu
GROUP BY kateqoriya;

-- 7. Kateqoriya daxilinde top 3 mehsul (net satis gelirine gore)
WITH total_bycategory AS (
    SELECT p.category, p.product_name,
           SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) AS total_mebleg
    FROM order_items oi
    JOIN products p ON p.product_id = oi.product_id
    GROUP BY p.category, p.product_name
),
ranked AS (
    SELECT category, product_name, ROUND(total_mebleg) AS total_mebleg,
           RANK() OVER (PARTITION BY category ORDER BY total_mebleg DESC) AS rnk
    FROM total_bycategory
)
SELECT * FROM ranked WHERE rnk <= 3;

-- 8. 2025 ayliq satis geliri, evvelki ay, artim %, kumulyativ satis geliri
WITH aylar_uzre_satis AS (
    SELECT EXTRACT(MONTH FROM o.order_date) AS ay,
           SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) AS total_satis
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE EXTRACT(YEAR FROM o.order_date) = 2025
      AND o.status = 'Tamamlandı'
    GROUP BY EXTRACT(MONTH FROM o.order_date)
)
SELECT ay, ROUND(total_satis) AS total_satis,
       ROUND(LAG(total_satis) OVER (ORDER BY ay)) AS evvelki_ay,
       ROUND(100 * (total_satis - LAG(total_satis) OVER (ORDER BY ay))
             / LAG(total_satis) OVER (ORDER BY ay), 2) AS artim_tempi,
       ROUND(SUM(total_satis) OVER (ORDER BY ay)) AS running_total
FROM aylar_uzre_satis
ORDER BY ay;

-- 9. Hele gonderilmemis sifarisler ve gozleme muddeti
--     Yalniz 'Gozlemede' statusu goturulur: legv edilmis sifarisler hec vaxt gonderilmeyecek,
--     ona gore onlar ucun "gozleme gunu" menasizdir.
SELECT order_id, status, order_date, channel,
       DATE '2025-12-31' - order_date AS gozleme_gunu
FROM orders
WHERE ship_date IS NULL
  AND status = 'Gözləmədə'
ORDER BY order_date;

-- 10. Musteri: ilk/son sifaris, say, "Risk altinda" (>=120 gun)
SELECT c.customer_id, c.segment, c.city,
       COUNT(o.order_id) AS sifaris_sayi,
       MIN(o.order_date) AS ilk_sifaris,
       MAX(o.order_date) AS son_sifaris,
       DATE '2025-12-31' - MAX(o.order_date) AS kecen_gun,
       CASE WHEN DATE '2025-12-31' - MAX(o.order_date) >= 120
            THEN 'Risk altinda' ELSE 'Aktiv' END AS status
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.segment, c.city
HAVING DATE '2025-12-31' - MAX(o.order_date) >= 120;

-- 11. Satis meneceri uzre ferqli musteri ve sifaris sayi
SELECT e.first_name,
       COUNT(DISTINCT o.customer_id) AS musteri_sayi,
       COUNT(o.order_id) AS sifaris_sayi
FROM employees e
LEFT JOIN orders o ON e.emp_id = o.emp_id
WHERE e.job_title = 'Satış meneceri'
GROUP BY e.first_name
ORDER BY sifaris_sayi DESC, musteri_sayi DESC;

-- 12a. Her musterinin ilk sifarisi
WITH sifaris_tarixi AS (
    SELECT customer_id, order_id, order_date, channel, payment_method,
           ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date, order_id) AS rn
    FROM orders
)
SELECT customer_id, order_id, order_date, channel, payment_method
FROM sifaris_tarixi
WHERE rn = 1;

-- 12b. Ilk alisin en cox hansi kanaldan olduğu
WITH sifaris_tarixi AS (
    SELECT customer_id, channel,
           ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date, order_id) AS rn
    FROM orders
)
SELECT channel, COUNT(*) AS musteri_sayi
FROM sifaris_tarixi
WHERE rn = 1
GROUP BY channel
ORDER BY musteri_sayi DESC;

-- =====================================================
-- B. ELAVE BIZNES ANALIZLERI (13-18)
-- =====================================================

-- 13. 2024 vs 2025: umumi muqayise (tamamlanmis sifarisler)
--     sifaris sayi, satilan eded, satis geliri, orta sifaris meblegi ve marja: il uzre ve evvelki ile ferq %
WITH t AS (
    SELECT EXTRACT(YEAR FROM o.order_date) AS il,
           o.order_id,
           oi.quantity,
           oi.quantity * oi.unit_price * (1 - oi.discount) AS satis_geliri,
           oi.quantity * p.cost_price AS maya
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p     ON p.product_id = oi.product_id
    WHERE o.status = 'Tamamlandı'
),
y AS (
    SELECT il,
           COUNT(DISTINCT order_id) AS sifaris_sayi,
           SUM(quantity)            AS satilan_eded,
           SUM(satis_geliri)       AS satis_geliri,
           SUM(satis_geliri) / COUNT(DISTINCT order_id) AS orta_sifaris,
           100 * (SUM(satis_geliri) - SUM(maya)) / SUM(satis_geliri) AS marja
    FROM t
    GROUP BY il
)
SELECT il,
       sifaris_sayi,
       ROUND(100 * (sifaris_sayi - LAG(sifaris_sayi) OVER (ORDER BY il))
             / LAG(sifaris_sayi) OVER (ORDER BY il), 2) AS sifaris_deyisme_pct,
       satilan_eded,
       ROUND(100 * (satilan_eded - LAG(satilan_eded) OVER (ORDER BY il))
             / LAG(satilan_eded) OVER (ORDER BY il), 2) AS eded_deyisme_pct,
       ROUND(satis_geliri) AS satis_geliri,
       ROUND(100 * (satis_geliri - LAG(satis_geliri) OVER (ORDER BY il))
             / LAG(satis_geliri) OVER (ORDER BY il), 2) AS satis_geliri_deyisme_pct,
       ROUND(orta_sifaris) AS orta_sifaris,
       ROUND(100 * (orta_sifaris - LAG(orta_sifaris) OVER (ORDER BY il))
             / LAG(orta_sifaris) OVER (ORDER BY il), 2) AS orta_sifaris_deyisme_pct,
       ROUND(marja, 2) AS marja,
       ROUND(marja - LAG(marja) OVER (ORDER BY il), 2) AS marja_ferq_faiz_bendi
FROM y
ORDER BY il;

-- 14. 2024 vs 2025: kateqoriya uzre muqayise (tamamlanmis sifarisler)
--     Qeyd: bir sifarisde bir nece kateqoriya ola biler, ona gore kateqoriya sifaris saylari cemlenmir
WITH t AS (
    SELECT EXTRACT(YEAR FROM o.order_date) AS il,
           p.category,
           o.order_id,
           oi.quantity,
           oi.quantity * oi.unit_price * (1 - oi.discount) AS satis_geliri
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p     ON p.product_id = oi.product_id
    WHERE o.status = 'Tamamlandı'
),
y AS (
    SELECT category, il,
           COUNT(DISTINCT order_id) AS sifaris_sayi,
           SUM(quantity)            AS satilan_eded,
           SUM(satis_geliri)       AS satis_geliri
    FROM t
    GROUP BY category, il
)
SELECT category, il,
       sifaris_sayi,
       ROUND(100 * (sifaris_sayi - LAG(sifaris_sayi) OVER (PARTITION BY category ORDER BY il))
             / LAG(sifaris_sayi) OVER (PARTITION BY category ORDER BY il), 2) AS sifaris_deyisme_pct,
       satilan_eded,
       ROUND(100 * (satilan_eded - LAG(satilan_eded) OVER (PARTITION BY category ORDER BY il))
             / LAG(satilan_eded) OVER (PARTITION BY category ORDER BY il), 2) AS eded_deyisme_pct,
       ROUND(satis_geliri) AS satis_geliri,
       ROUND(100 * (satis_geliri - LAG(satis_geliri) OVER (PARTITION BY category ORDER BY il))
             / LAG(satis_geliri) OVER (PARTITION BY category ORDER BY il), 2) AS satis_geliri_deyisme_pct
FROM y
ORDER BY category, il;

-- 15. Kateqoriya uzre satis geliri, umumi menfeet ve marja (tamamlanmis)
SELECT p.category,
       ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount))) AS satis_geliri,
       ROUND(SUM(oi.quantity * (oi.unit_price * (1 - oi.discount) - p.cost_price))) AS umumi_menfeet,
       ROUND(100 * SUM(oi.quantity * (oi.unit_price * (1 - oi.discount) - p.cost_price))
             / SUM(oi.quantity * oi.unit_price * (1 - oi.discount)), 1) AS marja
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p     ON p.product_id = oi.product_id
WHERE o.status = 'Tamamlandı'
GROUP BY p.category
ORDER BY umumi_menfeet DESC;

-- 16. Kanal uzre sifaris, satis geliri ve orta sifaris meblegi (AOV)
SELECT o.channel,
       COUNT(DISTINCT o.order_id) AS sifaris_sayi,
       ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount))) AS satis_geliri,
       ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) / COUNT(DISTINCT o.order_id)) AS aov
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Tamamlandı'
GROUP BY o.channel
ORDER BY satis_geliri DESC;

-- 17. Kanallar uzre 2024 vs 2025 satis geliri deyisimi (tamamlanmis sifarisler)
WITH channels AS (
    SELECT EXTRACT(YEAR FROM o.order_date) AS il,
           o.channel,
           SUM(oi.unit_price * oi.quantity * (1 - oi.discount)) AS total_satis
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status = 'Tamamlandı'
    GROUP BY o.channel, EXTRACT(YEAR FROM o.order_date)
)
SELECT il, channel,
       ROUND(total_satis) AS total_satis,
       ROUND(LAG(total_satis) OVER (PARTITION BY channel ORDER BY il)) AS evvelki_il,
       ROUND(100 * (total_satis - LAG(total_satis) OVER (PARTITION BY channel ORDER BY il))
             / LAG(total_satis) OVER (PARTITION BY channel ORDER BY il), 2) AS artim_faiz
FROM channels
ORDER BY channel, il;

-- 18. Ilk 8 musterinin tamamlanmis satis gelirindeki payi
WITH m AS (
    SELECT o.customer_id,
           SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) AS satis_geliri
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status = 'Tamamlandı'
    GROUP BY o.customer_id
),
r AS (
    SELECT customer_id, satis_geliri, RANK() OVER (ORDER BY satis_geliri DESC) AS rnk FROM m
)
SELECT ROUND(100 * SUM(CASE WHEN rnk <= 8 THEN satis_geliri END) / SUM(satis_geliri), 1) AS top8_pay_faiz
FROM r;
