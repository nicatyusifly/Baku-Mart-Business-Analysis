BEGIN
  FOR t IN (SELECT table_name FROM user_tables
            WHERE table_name IN ('ORDER_ITEMS','ORDERS','PRODUCTS','CUSTOMERS','EMPLOYEES','DEPARTMENTS')) LOOP
    EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS PURGE';
  END LOOP;
END;
/

-- 1. Cədvəllər
CREATE TABLE departments (
  dept_id     NUMBER PRIMARY KEY,
  dept_name   VARCHAR2(50 CHAR) NOT NULL,
  location    VARCHAR2(50 CHAR)
);

CREATE TABLE employees (
  emp_id      NUMBER PRIMARY KEY,
  first_name  VARCHAR2(50 CHAR) NOT NULL,
  last_name   VARCHAR2(50 CHAR) NOT NULL,
  job_title   VARCHAR2(60 CHAR),
  dept_id     NUMBER REFERENCES departments(dept_id),
  manager_id  NUMBER REFERENCES employees(emp_id),
  hire_date   DATE NOT NULL,
  salary      NUMBER(10,2) NOT NULL
);

CREATE TABLE customers (
  customer_id       NUMBER PRIMARY KEY,
  full_name         VARCHAR2(100 CHAR) NOT NULL,
  email             VARCHAR2(100 CHAR),
  phone             VARCHAR2(20 CHAR),
  city              VARCHAR2(50 CHAR),
  segment           VARCHAR2(30 CHAR),
  registration_date DATE
);

CREATE TABLE products (
  product_id    NUMBER PRIMARY KEY,
  product_name  VARCHAR2(100 CHAR) NOT NULL,
  category      VARCHAR2(50 CHAR) NOT NULL,
  sub_category  VARCHAR2(50 CHAR),
  unit_price    NUMBER(10,2) NOT NULL,
  cost_price    NUMBER(10,2) NOT NULL
);

CREATE TABLE orders (
  order_id        NUMBER PRIMARY KEY,
  customer_id     NUMBER NOT NULL REFERENCES customers(customer_id),
  emp_id          NUMBER REFERENCES employees(emp_id),
  order_date      DATE NOT NULL,
  ship_date       DATE,
  status          VARCHAR2(20 CHAR) CHECK (status IN ('Tamamlandı','Ləğv edildi','Qaytarıldı','Gözləmədə')),
  channel         VARCHAR2(20 CHAR),
  payment_method  VARCHAR2(20 CHAR)
);

CREATE TABLE order_items (
  order_item_id  NUMBER PRIMARY KEY,
  order_id       NUMBER NOT NULL REFERENCES orders(order_id),
  product_id     NUMBER NOT NULL REFERENCES products(product_id),
  quantity       NUMBER NOT NULL,
  unit_price     NUMBER(10,2) NOT NULL,   -- satış anındakı qiymət
  discount       NUMBER(4,2) DEFAULT 0    -- 0.10 = 10%
);

-- 2. Departamentlər
INSERT INTO departments VALUES (1, 'Rəhbərlik', 'Bakı');
INSERT INTO departments VALUES (2, 'Satış', 'Bakı');
INSERT INTO departments VALUES (3, 'IT', 'Bakı');
INSERT INTO departments VALUES (4, 'Maliyyə', 'Bakı');
INSERT INTO departments VALUES (5, 'Logistika', 'Sumqayıt');
INSERT INTO departments VALUES (6, 'Marketinq', 'Bakı');   -- işçisi yoxdur

-- 3. İşçilər (manager_id → eyni cədvəl)
INSERT INTO employees VALUES (1,  'Rəşad',   'Məmmədov',  'Baş direktor',          1, NULL, DATE '2018-03-01', 8500);
INSERT INTO employees VALUES (2,  'Leyla',   'Hüseynova', 'Satış direktoru',       2, 1,    DATE '2019-02-15', 6200);
INSERT INTO employees VALUES (3,  'Fərid',   'Quliyev',   'IT rəhbəri',            3, 1,    DATE '2019-06-10', 6000);
INSERT INTO employees VALUES (4,  'Aysel',   'Kərimova',  'Maliyyə rəhbəri',       4, 1,    DATE '2020-01-20', 5800);
INSERT INTO employees VALUES (5,  'Orxan',   'Əliyev',    'Logistika rəhbəri',     5, 1,    DATE '2020-09-01', 5000);
INSERT INTO employees VALUES (6,  'Tural',   'Abbasov',   'Satış meneceri',        2, 2,    DATE '2020-04-12', 3200);
INSERT INTO employees VALUES (7,  'Nigar',   'Rzayeva',   'Satış meneceri',        2, 2,    DATE '2021-01-18', 2900);
INSERT INTO employees VALUES (8,  'Kamran',  'Babayev',   'Satış meneceri',        2, 2,    DATE '2021-07-05', 2600);
INSERT INTO employees VALUES (9,  'Günay',   'Səfərova',  'Satış meneceri',        2, 2,    DATE '2022-02-14', 2400);
INSERT INTO employees VALUES (10, 'Murad',   'Nəsirov',   'Satış meneceri',        2, 2,    DATE '2022-08-22', 2300);
INSERT INTO employees VALUES (11, 'Səbinə',  'Cəfərova',  'Satış meneceri',        2, 2,    DATE '2023-03-01', 2100);
INSERT INTO employees VALUES (12, 'Elşən',   'Zeynalov',  'Satış meneceri',        2, 2,    DATE '2023-10-09', 1900);
INSERT INTO employees VALUES (13, 'Fidan',   'Orucova',   'Satış meneceri',        2, 2,    DATE '2023-12-01', 1800);
INSERT INTO employees VALUES (14, 'Vüsal',   'Vəliyev',   'Proqramçı',             3, 3,    DATE '2021-05-17', 3500);
INSERT INTO employees VALUES (15, 'Lalə',    'Mustafayeva','Data analitik',        3, 3,    DATE '2022-11-07', 3100);
INSERT INTO employees VALUES (16, 'Ramil',   'Bağırov',   'Mühasib',               4, 4,    DATE '2021-09-13', 2500);
INSERT INTO employees VALUES (17, 'Könül',   'Qasımova',  'Maliyyə analitiki',     4, 4,    DATE '2023-04-03', 2700);
INSERT INTO employees VALUES (18, 'Samir',   'İsmayılov', 'Anbar meneceri',        5, 5,    DATE '2020-12-01', 2200);
INSERT INTO employees VALUES (19, 'Anar',    'Həsənov',   'Kuryer',                5, 18,   DATE '2022-06-20', 1200);
INSERT INTO employees VALUES (20, 'Zəhra',   'Əhmədova',  'Təcrübəçi',             NULL, 2, DATE '2025-11-03', 900);

-- 4. Müştərilər (bəzi məlumatlar qəsdən "çirkli"dir: boşluqlar, fərqli yazılış, NULL, dublikat)
INSERT INTO customers VALUES (1,  'Aynur Məmmədova',   'aynur.m@mail.az',     '+994501112233', 'Bakı',      'Fərdi',        DATE '2022-01-15');
INSERT INTO customers VALUES (2,  'Azər Tikinti MMC',  'info@azertikinti.az', '+994124445566', 'Bakı',      'Korporativ',   DATE '2022-02-03');
INSERT INTO customers VALUES (3,  'Cavid Orucov',      'cavid.o@gmail.com',   '+994552223344', 'Sumqayıt',  'Kiçik biznes', DATE '2022-02-20');
INSERT INTO customers VALUES (4,  'Günəş Hotel',       'office@gunesh.az',    '+994125556677', 'Qəbələ',    'Korporativ',   DATE '2022-03-11');
INSERT INTO customers VALUES (5,  'Elvin Hüseynov',    'elvin.h@mail.az',     '+994703334455', 'Gəncə',     'Fərdi',        DATE '2022-04-02');
INSERT INTO customers VALUES (6,  'Nərmin Vəliyeva',   'nermin.v@gmail.com',  '+994514445566', 'Bakı',      'Fərdi',        DATE '2022-04-25');
INSERT INTO customers VALUES (7,  'Toğrul Kərimov',    'togrul.k@mail.az',    '+994506667788', 'bakı',      'Kiçik biznes', DATE '2022-05-14');
INSERT INTO customers VALUES (8,  'Xəzər Logistik',    'sales@xezerlog.az',   '+994127778899', 'Sumqayıt',  'Korporativ',   DATE '2022-06-01');
INSERT INTO customers VALUES (9,  'Sevinc Abbasova',   'sevinc.a@gmail.com',  '+994558889900', 'Lənkəran',  'Fərdi',        DATE '2022-06-19');
INSERT INTO customers VALUES (10, 'İlkin Rzayev',      'ilkin.r@mail.az',     '+994709990011', 'Şəki',      'Fərdi',        DATE '2022-07-07');
INSERT INTO customers VALUES (11, 'Fidan Quliyeva',    'fidan.q@gmail.com',   NULL,            'Bakı',      'Fərdi',        DATE '2022-07-30');
INSERT INTO customers VALUES (12, 'Nihad Babayev',     NULL,                  '+994501230000', 'Mingəçevir','Fərdi',        DATE '2022-08-16');
INSERT INTO customers VALUES (13, 'Ülviyyə Səfərova',  'ulviyye.s@mail.az',   '+994552340000', 'Gəncə',     'Kiçik biznes', DATE '2022-09-02');
INSERT INTO customers VALUES (14, 'Anar Nəsirov',      'anar.n@gmail.com',    '+994703450000', 'Quba',      'Fərdi',        DATE '2022-09-21');
INSERT INTO customers VALUES (15, 'Mehriban Cəfərova', 'mehriban.c@mail.az',  '+994514560000', ' Bakı ',    'Fərdi',        DATE '2022-10-10');
INSERT INTO customers VALUES (16, 'Samir Zeynalov',    'samir.z@gmail.com',   '+994505670000', 'Naxçıvan',  'Fərdi',        DATE '2022-10-28');
INSERT INTO customers VALUES (17, 'Zirvə Mebel',       'info@zirvemebel.az',  '+994126780000', 'Gəncə',     'Korporativ',   DATE '2022-11-15');
INSERT INTO customers VALUES (18, 'Lalə Orucova',      'lale.o@mail.az',      '+994557890000', 'Bakı',      'Fərdi',        DATE '2022-12-03');
INSERT INTO customers VALUES (19, 'Rauf Vəliyev',      'rauf.v@gmail.com',    '+994708900000', 'Sumqayıt',  'Kiçik biznes', DATE '2022-12-22');
INSERT INTO customers VALUES (20, 'Gülnar Mustafayeva','gulnar.m@mail.az',    '+994519010000', 'Şirvan',    'Fərdi',        DATE '2023-01-09');
INSERT INTO customers VALUES (21, 'Emil Bağırov',      'emil.b@gmail.com',    '+994500120000', 'Bakı',      'Fərdi',        DATE '2023-01-27');
INSERT INTO customers VALUES (22, 'Kür Aqro MMC',      'office@kuraqro.az',   '+994121230000', 'BAKI',      'Korporativ',   DATE '2023-02-14');
INSERT INTO customers VALUES (23, 'Arzu Qasımova',     'arzu.q@mail.az',      '+994552340001', 'Lənkəran',  'Fərdi',        DATE '2023-03-04');
INSERT INTO customers VALUES (24, 'Vüqar İsmayılov',   'vuqar.i@gmail.com',   '+994703450001', 'Gəncə',     'Fərdi',        DATE '2023-03-23');
INSERT INTO customers VALUES (25, 'Şəbnəm Həsənova',   'shebnem.h@mail.az',   '+994514560001', 'Bakı',      'Kiçik biznes', DATE '2023-04-11');
INSERT INTO customers VALUES (26, 'Ramin Əhmədov',     'ramin.e@gmail.com',   '+994505670001', 'Quba',      'Fərdi',        DATE '2023-04-30');
INSERT INTO customers VALUES (27, 'Kənan Məmmədov',    NULL,                  NULL,            'Sumqayıt',  'Fərdi',        DATE '2023-05-18');
INSERT INTO customers VALUES (28, 'Bakı Kafe Şəbəkəsi','info@bakikafe.az',    '+994126780001', 'Bakı',      'Korporativ',   DATE '2023-06-06');
INSERT INTO customers VALUES (29, 'Aytən Əliyeva',     'ayten.e@mail.az',     '+994557890001', 'Şəki',      'Fərdi',        DATE '2023-06-25');
INSERT INTO customers VALUES (30, 'Orxan Hüseynov',    'orxan.h@gmail.com',   '+994708900001', 'Bakı',      'Fərdi',        DATE '2023-07-13');
INSERT INTO customers VALUES (31, 'Nurlan Kərimov',    'nurlan.k@mail.az',    '+994519010001', 'Mingəçevir','Fərdi',        DATE '2023-08-01');
INSERT INTO customers VALUES (32, 'Xədicə Rzayeva',    'xedice.r@gmail.com',  '+994500120001', 'Gəncə',     'Fərdi',        DATE '2023-08-20');
INSERT INTO customers VALUES (33, 'Elnur Babayev',     'elnur.b@mail.az',     '+994121230001', 'Naxçıvan',  'Kiçik biznes', DATE '2023-09-08');
INSERT INTO customers VALUES (34, 'Səadət Səfərova',   'seadet.s@gmail.com',  '+994552340002', 'Bakı',      'Fərdi',        DATE '2023-09-27');
INSERT INTO customers VALUES (35, 'Mübariz Nəsirov',   'mubariz.n@mail.az',   '+994703450002', 'Sumqayıt',  'Fərdi',        DATE '2023-10-16');
INSERT INTO customers VALUES (36, 'Pərvin Cəfərova',   'pervin.c@gmail.com',  '+994514560002', 'Lənkəran',  'Fərdi',        DATE '2023-11-04');
INSERT INTO customers VALUES (37, 'Tərlan Zeynalov',   'terlan.z@mail.az',    '+994505670002', 'Bakı',      'Fərdi',        DATE '2023-11-23');
-- Sifarişi olmayan müştərilər
INSERT INTO customers VALUES (38, 'Leyla Orucova',     'leyla.o@gmail.com',   '+994557890002', 'Quba',      'Fərdi',        DATE '2025-11-20');
INSERT INTO customers VALUES (39, '  Elvin Hüseynov ', 'ELVIN.H@mail.az',     '+994703334455', 'Gəncə',     'Fərdi',        DATE '2025-12-05');  -- dublikat (5 ilə)
INSERT INTO customers VALUES (40, 'Rövşən Vəliyev',    NULL,                  NULL,            NULL,        'Fərdi',        DATE '2025-12-18');

-- 5. Məhsullar (25 nömrəli məhsul heç vaxt satılmayıb)
INSERT INTO products VALUES (1,  'Smartfon Nova A15 128GB',     'Elektronika',      'Smartfon',      549,  450);
INSERT INTO products VALUES (2,  'Smartfon Nova S24 256GB',     'Elektronika',      'Smartfon',      1899, 1560);
INSERT INTO products VALUES (3,  'Noutbuk ProBook 14',          'Elektronika',      'Noutbuk',       1599, 1340);
INSERT INTO products VALUES (4,  'Noutbuk Student 15',          'Elektronika',      'Noutbuk',       999,  840);
INSERT INTO products VALUES (5,  'Planşet Tab 10',              'Elektronika',      'Planşet',       449,  390);
INSERT INTO products VALUES (6,  'Simsiz qulaqlıq Buds 2',      'Elektronika',      'Aksesuar',      129,  70);
INSERT INTO products VALUES (7,  'Smart saat Fit 5',            'Elektronika',      'Aksesuar',      199,  125);
INSERT INTO products VALUES (8,  'Soyuducu NoFrost 360L',       'Məişət texnikası', 'Böyük texnika', 1499, 1120);
INSERT INTO products VALUES (9,  'Paltaryuyan 8kq',             'Məişət texnikası', 'Böyük texnika', 999,  760);
INSERT INTO products VALUES (10, 'Kondisioner 12000 BTU',       'Məişət texnikası', 'İqlim',         1199, 850);
INSERT INTO products VALUES (11, 'Robot tozsoran R7',           'Məişət texnikası', 'Kiçik texnika', 699,  480);
INSERT INTO products VALUES (12, 'Mikrodalğalı soba 25L',       'Məişət texnikası', 'Kiçik texnika', 219,  150);
INSERT INTO products VALUES (13, 'Qab dəsti 12 parça',          'Ev və Mətbəx',     'Qab-qacaq',     189,  100);
INSERT INTO products VALUES (14, 'Armudu stəkan dəsti',         'Ev və Mətbəx',     'Qab-qacaq',     59,   30);
INSERT INTO products VALUES (15, 'Elektrik çaydanı 1.7L',       'Ev və Mətbəx',     'Kiçik texnika', 69,   42);
INSERT INTO products VALUES (16, 'Blender 1000W',               'Ev və Mətbəx',     'Kiçik texnika', 129,  80);
INSERT INTO products VALUES (17, 'Kofe maşını Espresso',        'Ev və Mətbəx',     'Kiçik texnika', 389,  240);
INSERT INTO products VALUES (18, 'Yataq dəsti 2 nəfərlik',      'Ev və Mətbəx',     'Tekstil',       99,   50);
INSERT INTO products VALUES (19, 'Qaçış zolağı T500',           'İdman və Hobbi',   'Fitness',       1299, 910);
INSERT INTO products VALUES (20, 'Hantel dəsti 20kq',           'İdman və Hobbi',   'Fitness',       119,  80);
INSERT INTO products VALUES (21, 'Velosiped Şəhər 28',          'İdman və Hobbi',   'Nəqliyyat',     599,  440);
INSERT INTO products VALUES (22, 'Çadır 4 nəfərlik',            'İdman və Hobbi',   'Kamp',          249,  150);
INSERT INTO products VALUES (23, 'Oyun konsolu PlayBox',        'İdman və Hobbi',   'Oyun',          999,  800);
INSERT INTO products VALUES (24, 'Nərd premium',                'İdman və Hobbi',   'Oyun',          79,   45);
INSERT INTO products VALUES (25, 'Elektrik skuter E9',          'İdman və Hobbi',   'Nəqliyyat',     899,  650);

-- 6. Sifarişlər: 600 sifariş, 2024-01-01 – 2025-12-31 (deterministik generasiya)
INSERT INTO orders (order_id, customer_id, emp_id, order_date, ship_date, status, channel, payment_method)
SELECT 1000 + lv,
       -- 31–37 nömrəli müştərilər 2025-ci ilin iyulundan sonra alış etmir (churn)
       CASE WHEN base_cust BETWEEN 31 AND 37 AND od >= DATE '2025-07-01'
            THEN MOD(lv, 8) + 1 ELSE base_cust END,
       CASE WHEN MOD(lv, 5) = 0 THEN 6
            WHEN MOD(lv, 7) = 0 THEN 7
            ELSE 6 + MOD(lv * 3, 8) END,
       od,
       CASE WHEN st IN ('Tamamlandı','Qaytarıldı') THEN od + MOD(lv, 6) + 1 END,
       st,
       CASE MOD(lv, 3) WHEN 0 THEN 'Vebsayt' WHEN 1 THEN 'Mobil tətbiq' ELSE 'Mağaza' END,
       CASE MOD(lv, 4) WHEN 0 THEN 'Nağd' WHEN 1 THEN 'Taksit' ELSE 'Kart' END
FROM (
  SELECT lv, base_cust, od,
         CASE WHEN MOD(lv, 17) = 0 THEN 'Ləğv edildi'
              WHEN MOD(lv, 23) = 0 THEN 'Qaytarıldı'
              WHEN od >= DATE '2025-12-20' THEN 'Gözləmədə'
              ELSE 'Tamamlandı' END AS st
  FROM (
    SELECT LEVEL AS lv,
           CASE WHEN MOD(LEVEL, 3) = 0 THEN MOD(LEVEL, 8) + 1
                ELSE MOD(LEVEL * 7, 37) + 1 END AS base_cust,
           DATE '2024-01-01' + MOD(LEVEL * 37, 731) AS od
    FROM dual CONNECT BY LEVEL <= 600
  )
);

-- 7. Sifariş sətirləri: hər sifarişdə 1–3 məhsul
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price, discount)
SELECT ROW_NUMBER() OVER (ORDER BY o.order_id, n.n),
       o.order_id,
       p.product_id,
       CASE WHEN p.unit_price < 300 THEN MOD(o.order_id + n.n, 4) + 1
            ELSE MOD(o.order_id + n.n, 2) + 1 END,
       ROUND(p.unit_price * CASE WHEN o.order_date < DATE '2025-01-01' THEN 0.95 ELSE 1 END, 2),
       CASE MOD(o.order_id * n.n, 10) WHEN 0 THEN 0.20 WHEN 1 THEN 0.10 WHEN 2 THEN 0.05 ELSE 0 END
FROM orders o
CROSS JOIN (SELECT LEVEL AS n FROM dual CONNECT BY LEVEL <= 3) n
JOIN products p ON p.product_id = MOD(o.order_id * 7 + n.n * 11, 24) + 1
WHERE n.n <= MOD(o.order_id, 3) + 1;

COMMIT;
