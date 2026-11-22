# BakuMart: Satış və Müştəri Analizi (SQL)

Pərakəndə satış datası üzərində **Oracle SQL** ilə yazılmış 18 biznes sorğusu və onların nəticələri. Layihədə satış dinamikası, müştəri riski, mənfəətlilik və kanal analizi aparılıb.

**Texnologiya:** Oracle SQL (Oracle FreeSQL) · `JOIN`, `CTE`, `CASE`, window funksiyalar (`RANK`, `LAG`, `ROW_NUMBER`), `NOT EXISTS`

## Əsas tapıntılar

- **Artım qiymətdən gəlir.** 2025-də satış gəliri +1.3% artıb (421.5K → 426.8K AZN), sifariş sayı −4.1%, satılan ədəd −4.9% azalıb. Marja 19.75%-dən 23.4%-ə yüksəlib. Satış gəliri azalan yeganə kateqoriya Məişət texnikasıdır (−4.6%).
- **Kanallar.** Mobil tətbiq satış gəlirinin 55.8%-ni verir, orta sifariş məbləği mağazadan 4.7 dəfə yüksəkdir. Vebsayt yeganə azalan kanaldır (gəlir −0.7%, sifariş −5.4%).
- **Müştəri riski.** 7 müştəri (aktiv bazanın 19%-i) 120+ gündür sifariş vermir. 8 müştəri satış gəlirinin 50.4%-ni verir.
- **Mənfəətlilik.** Elektronika satış gəlirinin 41.6%-ni, ümumi mənfəətin isə yalnız 29.2%-ni verir (marja 15.2%).
- **Data keyfiyyəti.** Dekabrdakı −63% "düşüş" "Gözləmədə" sifarişlərdən qaynaqlanan artefaktdır. Ləğv edilmiş sifarişlər gözləmə müddətini 373 günə şişirdir (real: 4.6 gün). Dublikat müştəri qeydi də var.

Bütün nəticələr və şərhlər: [`results/bakumart_results.md`](results/bakumart_results.md)

## Data

Sintetik (təlim üçün hazırlanmış) pərakəndə satış datası, 01.01.2024 – 31.12.2025.

| Cədvəl | Sətir | Təsvir |
|--------|------:|--------|
| `customers` | 40 | Müştərilər (şəhər, seqment, qeydiyyat tarixi) |
| `orders` | 600 | Sifarişlər (tarix, status, kanal, ödəniş növü) |
| `order_items` | 1 200 | Sifariş sətirləri (say, satış qiyməti, endirim) |
| `products` | 25 | Məhsullar (kateqoriya, satış qiyməti, maya dəyəri) |
| `employees` | 20 | İşçilər (vəzifə, menecer, maaş) |
| `departments` | 6 | Departamentlər |

Datada bilərəkdən "çirkli" hallar var: dublikat müştəri, şəhər adlarının fərqli yazılışı, boş e-poçt/telefon, satılmamış məhsul, işçisi olmayan departament və churn müştərilər.

**Hesablama düsturları:**
- Net satış gəliri = `quantity * unit_price * (1 - discount)`
- Ümumi mənfəət = satış gəliri − `quantity * cost_price`
- Marja = ümumi mənfəət / satış gəliri
- Bugünkü tarix: `31.12.2025`

## Repo strukturu

```
bakumart-sql-analysis/
├── README.md
├── data/
│   └── bakumart_sql_dataset.sql     # cədvəllər və data (CREATE + INSERT)
├── sql/
│   └── bakumart_queries.sql         # 18 sorğu
└── results/
    └── bakumart_results.md          # nəticə cədvəlləri və şərhlər
```

## Necə işlətməli

1. Oracle FreeSQL-də (və ya istənilən Oracle bazasında) yeni sessiya aç.
2. `data/bakumart_sql_dataset.sql` skriptini işlət. Sonda sətir sayları yoxlanılır: 6, 20, 40, 25, 600, 1 200.
3. `sql/bakumart_queries.sql` faylındakı sorğuları ardıcıl işlət.

Sorğular Oracle sintaksisindədir (`FETCH FIRST`, `DATE '2025-12-31'`, `TO_CHAR`). Başqa bazada kiçik dəyişikliklər lazım ola bilər.

## Sorğuların siyahısı

| # | Mövzu (nəticəyə keçid) | Texnika |
|--:|------------------------|---------|
| 1 | [Kateqoriya üzrə orta marja](results/bakumart_results.md#1-orta-marjası-30-dən-çox-olan-kateqoriyalar) | `GROUP BY`, `HAVING` |
| 2 | [Ən çox xərcləyən 10 müştəri](results/bakumart_results.md#2-ən-çox-xərcləyən-10-müştəri-tamamlandı) | `JOIN`, `SUM`, `FETCH FIRST` |
| 3 | [Heç vaxt sifariş verməmiş müştərilər](results/bakumart_results.md#3-heç-vaxt-sifariş-verməmiş-müştərilər) | `NOT EXISTS` |
| 4 | [Heç vaxt satılmamış məhsullar](results/bakumart_results.md#4-heç-vaxt-satılmamış-məhsul) | `NOT EXISTS` |
| 5 | [2025 aylıq satış gəliri](results/bakumart_results.md#5-2025--aylar-üzrə-tamamlanmış-sifariş-və-satış-gəliri) | `EXTRACT`, `GROUP BY` |
| 6 | [Sifariş məbləği qrupları](results/bakumart_results.md#6-sifarişlərin-məbləğə-görə-qrupları) | `CTE`, `CASE`, window `SUM` |
| 7 | [Kateqoriyada top 3 məhsul](results/bakumart_results.md#7-hər-kateqoriyada-net-satış-gəlirinə-görə-top-3-məhsul) | `RANK` |
| 8 | [Aylıq dəyişmə və kumulyativ gəlir](results/bakumart_results.md#8-2025-aylıq-satış-gəliri-əvvəlki-ay-artım--və-kumulyativ-satış-gəliri) | `LAG`, running total |
| 9 | [Hələ göndərilməmiş sifarişlər](results/bakumart_results.md#9-hələ-göndərilməmiş-sifarişlər) | `NULL`, tarix hesabı |
| 10 | ["Risk altında" müştərilər](results/bakumart_results.md#10-risk-altında-müştərilər-son-120-gün-sifarişsiz) | `MAX/MIN`, `CASE`, `HAVING` |
| 11 | [Menecer üzrə müştəri və sifariş sayı](results/bakumart_results.md#11-satış-meneceri-üzrə-fərqli-müştəri-və-sifariş-sayı) | `COUNT DISTINCT` |
| 12 | [İlk sifariş və kanal](results/bakumart_results.md#12-hər-müştərinin-ilk-sifarişi-və-kanal) | `ROW_NUMBER` |
| 13 | [2024 vs 2025: ümumi müqayisə](results/bakumart_results.md#13-2024-vs-2025-ümumi-müqayisə) | `LAG`, `CTE` |
| 14 | [2024 vs 2025: kateqoriya üzrə](results/bakumart_results.md#14-2024-vs-2025-kateqoriya-üzrə-müqayisə) | `LAG PARTITION BY` |
| 15 | [Kateqoriya üzrə satış gəliri və ümumi mənfəət](results/bakumart_results.md#15-kateqoriya-üzrə-satış-gəliri-və-ümumi-mənfəət) | `JOIN`, `SUM` |
| 16 | [Kanallar: satış gəliri və orta sifariş məbləği](results/bakumart_results.md#16-kanallar) | `JOIN`, `GROUP BY` |
| 17 | [Kanallar üzrə illik dəyişmə](results/bakumart_results.md#17-kanallar-üzrə-satış-gəlirinin-illik-dəyişməsi-2024--2025) | `LAG PARTITION BY` |
| 18 | [Müştəri konsentrasiyası](results/bakumart_results.md#18-müştəri-konsentrasiyası) | `RANK`, `CASE` |

## Qeydlər

- **Status filtri.** "Tamamlandı" yazılan sorğularda yalnız tamamlanmış sifarişlər götürülür. 6, 7, 10, 11 və 12-ci sorğularda status filtri yoxdur.
- **Fərziyyələr.** Nəticə faylında "fərziyyə" kimi qeyd olunan şərhlər datadan birbaşa çıxmır, əlavə yoxlama tələb edir.
- **Sintetik data.** Nəticələr real bazar məlumatı deyil, təlim datası üzərində aparılmış analizdir.
