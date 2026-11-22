# BakuMart – Biznes Analitik SQL Nəticələri

**Data:** 6 cədvəl, 2024–2025 dövrü, 40 müştəri, 600 sifariş, 1 200 sifariş sətri.

**Düstur:** Net məbləğ = `quantity * unit_price * (1 - discount)`. Bugünkü tarix: 31.12.2025.

**Terminlər:** Satış gəliri = endirimdən sonrakı satış məbləği. Ümumi mənfəət = satış gəliri − maya dəyəri. Marja = ümumi mənfəət / satış gəliri.

**Status:** 2, 5, 8 və 13–18-ci suallar yalnız "Tamamlandı" sifarişləri üzrədir. 6, 7, 10, 11 və 12-ci suallarda status filtri yoxdur.

## Əsas nəticələr

| Mövzu | Tapıntı |
|-------|---------|
| Böyümə | 2025-də satış gəliri +1.3% (421.5K → 426.8K), sifariş sayı −4.1% (271 → 260), satılan ədəd −4.9%. Artım qiymət artımından gəlir. Satış gəliri azalan yeganə kateqoriya Məişət texnikasıdır (−4.6%). |
| Müştəri konsentrasiyası | 8 müştəri tamamlanmış satış gəlirinin 50.4%-ni verir. |
| Churn | 7 müştəri 2025-in iyulundan sonra almır (ömürlük satış gəlirinin 8.8%-i). |
| Marja | Elektronika satış gəlirinin 41.6%-ni, ümumi mənfəətin 29.2%-ni verir (marja 15.2%). |
| Kanal | Mobil tətbiq satış gəlirinin 55.8%-ni verir, orta sifariş 2 687 AZN (mağazada 575 AZN). |

---

## 1. Orta marjası 30%-dən çox olan kateqoriyalar

| Kateqoriya | Məhsul sayı | Orta qiymət | Orta marja % |
|------------|------------:|------------:|-------------:|
| Ev və Mətbəx | 6 | 156 | 43.53 |
| İdman və Hobbi | 7 | 606 | 31.38 |

**Nəticə:** Yalnız 2 kateqoriya 30%-i keçir. Marja ilə qiymət tərsinə bağlıdır: ucuz məhsullarda marja yüksək, bahalı məhsullarda aşağıdır (Məişət texnikası 28.2%, Elektronika 23.4%).

## 2. Ən çox xərcləyən 10 müştəri ("Tamamlandı")

| # | Müştəri | Şəhər | Sifariş | Net məbləğ (AZN) |
|--:|---------|-------|--------:|-----------------:|
| 1 | Cavid Orucov | Sumqayıt | 33 | 79 910.09 |
| 2 | Aynur Məmmədova | Bakı | 35 | 68 548.99 |
| 3 | Toğrul Kərimov | bakı | 33 | 63 120.52 |
| 4 | Elvin Hüseynov | Gəncə | 35 | 59 935.59 |
| 5 | Azər Tikinti MMC | Bakı | 33 | 55 283.65 |
| 6 | Günəş Hotel | Qəbələ | 32 | 36 900.20 |
| 7 | Nərmin Vəliyeva | Bakı | 33 | 34 660.74 |
| 8 | Xəzər Logistik | Sumqayıt | 37 | 29 086.88 |
| 9 | Emil Bağırov | Bakı | 10 | 20 679.36 |
| 10 | Lalə Orucova | Bakı | 9 | 19 945.24 |

**Nəticə:** İlk 8 müştəri hər biri 32–37 sifariş verib, 9–10-cu yerdəkilər cəmi 9–10. Bu 8 müştəri satış gəlirinin yarısını verir (18-ci suala bax).

## 3. Heç vaxt sifariş verməmiş müştərilər

| Müştəri | Qeydiyyat tarixi |
|---------|------------------|
| Leyla Orucova | 2025-11-20 |
| Elvin Hüseynov | 2025-12-05 |
| Rövşən Vəliyev | 2025-12-18 |

**Nəticə:** Üçü də son 6 həftədə qeydiyyatdan keçib, yəni hələ ilk sifariş vaxtı gəlməyib.

## 4. Heç vaxt satılmamış məhsul

| Məhsul | Qiymət | Marja |
|--------|-------:|------:|
| Elektrik skuter E9 | 899 | 27.7% |

**Nəticə:** 24 ay ərzində bir dəfə də satılmayıb. Marjası normaldır, fikrimcə problem qiymətdə deyil, görünürlükdə və ya stokdadır.

## 5. 2025 – aylar üzrə tamamlanmış sifariş və satış gəliri

| Ay | Sifariş | Satış gəliri (AZN) |
|---:|--------:|-------------------:|
| 1 | 24 | 41 492 |
| 2 | 23 | 37 075 |
| 3 | 21 | 34 480 |
| 4 | 20 | 41 392 |
| 5 | 24 | 37 519 |
| 6 | 22 | 36 755 |
| 7 | 23 | 32 567 |
| 8 | 22 | 34 278 |
| 9 | 24 | **43 320** |
| 10 | 22 | 30 086 |
| 11 | 20 | 42 270 |
| 12 | 15 | 15 569 |

**Nəticə:** Ən güclü ay **sentyabr**, ən zəif tam ay **oktyabr**. Sifariş sayı aylar üzrə sabitdir (20–24), satış gəlirindəki fərq səbət dəyərindən gəlir. Dekabr az görünür, çünki 20–31 dekabr sifarişləri hələ tamamlanmayıb.

(Hər iki ili birlikdə hesablayanda ən güclü ay aprel, ən zəif ay oktyabr çıxır.) apreldə satışın yüksək olmasının səbəblərindən biri  bahar , novruz kampaniyları ilə əlaqəli ola bilər, həmçinin həmin ayda sifariş sayının demək olar eyni qalmasi ama orta sifariş məbləğinin dəyişməsinin səbəbi həmin ayda bayram ilə əlaqədar olaraq qiyməti yüksək olan məhsullara endirim tətbiq edilməsi , kampaniyalar verilməsi ola bilər

## 6. Sifarişlərin məbləğə görə qrupları

| Qrup | Sifariş sayı | Ümumi məbləğ (AZN) | Satış gəlirində pay |
|------|-------------:|-------------------:|--------------------:|
| Böyük (1500-dən çox) | 290 | 757 248 | 78.82% |
| Orta (300–1500) | 259 | 194 540 | 20.25% |
| Kiçik (300-dən az) | 51 | 8 899 | 0.93% |

**Nəticə:** Sifarişlərin 48%-i ("Böyük") satış gəlirinin təxminən 79%-ni verir. Kiçik sifarişlər satış gəlirinin 1%-dən azını təşkil edir.

böyük məbləğdə sifarişlər satış gəlirinin böyük bir hissəsini tutur və bu o deməkdirki  böyük sifarişlər verən müştərilərin itirilməsi gəlirdə ciddi azalmaya səbəb ola bilər (konsentrasiya yüksəkdir)

## 7. Hər kateqoriyada net satış gəlirinə görə top 3 məhsul

| Kateqoriya | # | Məhsul | Satış gəliri (AZN) |
|------------|--:|--------|-------------------:|
| Elektronika | 1 | Noutbuk ProBook 14 | 113 593 |
| | 2 | Noutbuk Student 15 | 92 447 |
| | 3 | Smartfon Nova S24 256GB | 87 971 |
| Məişət texnikası | 1 | Kondisioner 12000 BTU | 111 279 |
| | 2 | Paltaryuyan 8kq | 70 802 |
| | 3 | Soyuducu NoFrost 360L | 69 254 |
| İdman və Hobbi | 1 | Qaçış zolağı T500 | 61 092 |
| | 2 | Çadır 4 nəfərlik | 46 080 |
| | 3 | Velosiped Şəhər 28 | 42 483 |
| Ev və Mətbəx | 1 | Yataq dəsti 2 nəfərlik | 27 492 |
| | 2 | Elektrik çaydanı 1.7L | 14 675 |
| | 3 | Blender 1000W | 11 963 |

**Nəticə:** İki məhsul (ProBook və Kondisioner) ümumi satış gəlirinin təxminən 23%-ni verir.

**RANK və DENSE_RANK fərqi:**
- `RANK`: bərabər olanlara eyni yer verir və sonrakı nömrəni atlayır (1, 1, 3).
- `DENSE_RANK`: bərabər olanlara eyni yer verir, nömrəni atlamır (1, 1, 2).

## 8. 2025 aylıq satış gəliri, əvvəlki ay, artım % və kumulyativ satış gəliri

| Ay | Satış gəliri | Əvvəlki ay | Artım % | Kumulyativ |
|---:|-------------:|-----------:|--------:|-----------:|
| 1 | 41 492 | | | 41 492 |
| 2 | 37 075 | 41 492 | −10.64 | 78 567 |
| 3 | 34 480 | 37 075 | −7.00 | 113 048 |
| 4 | 41 392 | 34 480 | +20.04 | 154 439 |
| 5 | 37 519 | 41 392 | −9.36 | 191 958 |
| 6 | 36 755 | 37 519 | −2.04 | 228 713 |
| 7 | 32 567 | 36 755 | −11.39 | 261 280 |
| 8 | 34 278 | 32 567 | +5.25 | 295 558 |
| 9 | 43 320 | 34 278 | +26.38 | 338 877 |
| 10 | 30 086 | 43 320 | −30.55 | 368 963 |
| 11 | 42 270 | 30 086 | +40.50 | 411 233 |
| 12 | 15 569 | 42 270 | −63.17 | 426 802 |

**Nəticə:** Fevral–martda azalma, aprelde sıçrayış (+20%), iyula qədər yenə azalma, sentyabrda yenidən sıçrayış (+26%). 2025-in ümumi satış gəliri 426 802 AZN-dir.

**Dekabr haqqında:** −63% real çöküş deyil. Dekabrda 26 sifarişdən 9-u hələ "Gözləmədə"dir (~18.8K AZN). Onlar tamamlansa, dekabr satış gəliri təxminən 34K olardı (təxminən −19%).

## 9. Hələ göndərilməmiş sifarişlər

| Sifariş | Tarix | Kanal | Gözləmə (gün) |
|--------:|-------|-------|--------------:|
| 1217 | 2025-12-20 | Mobil tətbiq | 11 |
| 1059 | 2025-12-22 | Mağaza | 9 |
| 1553 | 2025-12-25 | Mobil tətbiq | 6 |
| 1474 | 2025-12-26 | Vebsayt | 5 |
| 1395 | 2025-12-27 | Mağaza | 4 |
| 1316 | 2025-12-28 | Mobil tətbiq | 3 |
| 1237 | 2025-12-29 | Vebsayt | 2 |
| 1158 | 2025-12-30 | Mağaza | 1 |
| 1079 | 2025-12-31 | Mobil tətbiq | 0 |

**Nəticə:** 9 sifariş hələ göndərilməyib. Orta gözləmə 4.6 gündür, ən uzunu 11 gün (sifariş 1217). Hamısı son 12 gündədir, yəni gecikmə problemi görünmür.

**Qeyd:** Sorğuya yalnız `status = 'Gözləmədə'` olanları saldım. Göndərmə tarixi boş olan 35 sifariş də var, amma onlar ləğv edilib (bütün sifarişlərin 5.8%-i) və heç vaxt göndərilməyəcək. Onları saysaydım,gözləm günü yanlış görünərdi (orta 373 gün).

## 10. "Risk altında" müştərilər (son 120 gün sifarişsiz)

| ID | Müştəri | Seqment | Şəhər | Sifariş | Son sifariş | Sifarişsiz gün |
|---:|---------|---------|-------|--------:|-------------|---------------:|
| 31 | Nurlan Kərimov | Fərdi | Mingəçevir | 8 | 2025-05-23 | 222 |
| 32 | Xədicə Rzayeva | Fərdi | Gəncə | 8 | 2025-06-26 | 188 |
| 33 | Elnur Babayev | Kiçik biznes | Naxçıvan | 9 | 2025-05-11 | 234 |
| 34 | Səadət Səfərova | Fərdi | Bakı | 8 | 2025-06-27 | 187 |
| 35 | Mübariz Nəsirov | Fərdi | Sumqayıt | 8 | 2025-05-12 | 233 |
| 36 | Pərvin Cəfərova | Fərdi | Lənkəran | 8 | 2025-06-15 | 199 |
| 37 | Tərlan Zeynalov | Fərdi | Bakı | 7 | 2025-04-30 | 245 |

**Ortaq xüsusiyyətlər:**
- Hamısı 2024-ün əvvəlində ilk sifarişini verib, 2025-in aprel–iyununda sonuncunu edib və iyuldan sonra heç nə almayıb.
- Hər birinin 7–9 sifarişi var, yəni əvvəl aktiv müştərilər idi.
- 33 nömrəli müştəri istisna olmaqla hamısı Fərdi seqmentdəndir.
- 7 müştərinin 5-i Bakıdan kənardadır (iqtisadi amil və ya çatdırılma problemi ola bilər, bu, mənim fərziyyəmdir).

**Biznes təsiri:** Bu 7 müştəri churn müştərilərdir və aktiv bazanın 19%-idir. 2024-də 48.9K, 2025-də 35.6K AZN gətirib . Bu müştərilərə özəl kampaniyalar verib geri gətirmək olar

## 11. Satış meneceri üzrə fərqli müştəri və sifariş sayı

| Menecer | Fərqli müştəri | Sifariş |
|---------|---------------:|--------:|
| Tural | 37 | 172 |
| Nigar | 37 | 120 |
| Elşən | 28 | 52 |
| Günay | 27 | 52 |
| Fidan | 28 | 51 |
| Kamran | 27 | 51 |
| Murad | 27 | 51 |
| Səbinə | 27 | 51 |

**Rəqəmlər niyə fərqlidir?** Bir müştəri eyni menecerə bir neçə dəfə sifariş verə bilər. Bu halda müştəri sayı bir dəfə artır, sifariş sayı isə hər dəfə artır. Bərabər olsaydı, hər müştəri yalnız bir dəfə sifariş vermiş olardı.

**Nəticə:** Tural (28.7%) və Nigar (20.0%) sifarişlərin 48.7%-ni aparır, qalan 6 menecer hər biri ~51–52 sifariş edir. İş yükü qeyri-bərabərdir.

## 12. Hər müştərinin ilk sifarişi və kanal

| Kanal | İlk alış edən müştəri | Pay |
|-------|----------------------:|----:|
| Mobil tətbiq | 19 | 51.4% |
| Mağaza | 11 | 29.7% |
| Vebsayt | 7 | 18.9% |

**Nəticə:** Müştərilərin yarısından çoxu ilk alışını mobil tətbiqdən edib, vebsayt ən zəif kanaldır.

---

## Əlavə biznes analizləri (tamamlanmış sifarişlər)

### 13. 2024 vs 2025: ümumi müqayisə

| Göstərici | 2024 | 2025 | Dəyişmə |
|-----------|-----:|-----:|--------:|
| Sifariş sayı | 271 | 260 | **−4.06%** |
| Satılan ədəd | 1 134 | 1 078 | **−4.94%** |
| Satış gəliri (AZN) | 421 451 | 426 802 | **+1.27%** |
| Orta sifariş məbləği (AZN) | 1 555 | 1 642 | +5.55% |
| Marja | 19.75% | 23.40% | +3.65 faiz bəndi |

**Nəticə:** Satışın həcmi azalıb (sifariş −4.1%, satılan ədəd −4.9%), amma satış gəliri +1.3% artıb. Fərq qiymətdən gəlir: 2025-də məhsul qiymətləri 2024-dən təxminən 5% yüksəkdir, orta sifariş məbləği də +5.6% artıb. Yəni satış gəlirinin artımını tələb yox, qiymət yaradıb. Marja da buna görə yüksəlib.

### 14. 2024 vs 2025: kateqoriya üzrə müqayisə

| Kateqoriya | Sifariş 2024 → 2025 | Dəyişmə | Satılan ədəd 2024 → 2025 | Dəyişmə | Satış gəliri 2024 → 2025 (AZN) | Dəyişmə |
|------------|--------------------:|--------:|-------------------------:|--------:|-------------------------------:|--------:|
| Elektronika | 146 → 143 | −2.05% | 337 → 328 | −2.67% | 171 903 → 180 664 | **+5.10%** |
| Ev və Mətbəx | 124 → 123 | −0.81% | 363 → 352 | −3.03% | 34 101 → 35 196 | **+3.21%** |
| İdman və Hobbi | 122 → 119 | −2.46% | 250 → 231 | −7.60% | 82 138 → 83 798 | **+2.02%** |
| Məişət texnikası | 103 → 94 | −8.74% | 184 → 167 | −9.24% | 133 309 → 127 144 | **−4.62%** |

*Bir sifarişdə bir neçə kateqoriya ola bilər, ona görə kateqoriya sifariş sayları ümumi saya bərabər deyil.*

**Nəticə:**
- Dörd kateqoriyanın hamısında satılan ədəd azalıb, yəni həcm bütün sahələrdə aşağı düşüb.
- Satış gəliri 3 kateqoriyada artıb, bu artım qiymət artımının hesabınadır.
- **Məişət texnikası** yeganə kateqoriyadır ki, satış gəliri azalıb (−4.6%). Orada həm sifariş (−8.7%), həm ədəd (−9.2%) ən çox düşüb və qiymət artımı bunu kompensasiya etməyib. İlk baxılmalı sahə budur.
- **Elektronika** ən yaxşı nəticəni göstərir (+5.1% satış gəliri), bu da ən bahalı məhsulların qiymət artımından gəlir.

### 15. Kateqoriya üzrə satış gəliri və ümumi mənfəət

| Kateqoriya | Satış gəliri | Ümumi mənfəət | Marja | Mənfəətdə pay |
|------------|-------------:|--------------:|------:|--------------:|
| Məişət texnikası | 260 453 | 57 553 | 22.1% | 31.4% |
| Elektronika | 352 567 | 53 457 | 15.2% | 29.2% |
| İdman və Hobbi | 165 936 | 44 346 | 26.7% | 24.2% |
| Ev və Mətbəx | 69 297 | 27 749 | 40.0% | 15.2% |
| **Cəmi** | **848 253** | **183 105** | **21.6%** | 100% |

**Nəticə:** Elektronika satış gəlirinin 41.6%-ni, ümumi mənfəətin yalnız 29.2%-ni verir. Ev və Mətbəx satış gəlirinin 8.2%-ni, ümumi mənfəətin 15.2%-ni verir. Elektronika alanlara Ev və Mətbəx məhsullarının əlavə satışı marjanı artıra bilər.

### 16. Kanallar

| Kanal | Sifariş | Satış gəliri | Orta sifariş |
|-------|--------:|-------------:|-------------:|
| Mobil tətbiq | 176 | 472 982 | 2 687 |
| Vebsayt | 179 | 273 992 | 1 531 |
| Mağaza | 176 | 101 279 | 575 |

**Nəticə:** Sifariş sayı kanallar arasında demək olar ki, bərabərdir, amma satış gəliri fərqlənir. ola bilərki müştərilər böyük məbləğli alışlarda daha çox mobil tətbiqə üstünlük verir

### 17. Kanallar üzrə satış gəlirinin illik dəyişməsi (2024 → 2025)

| Kanal | 2024 satış gəliri | 2025 satış gəliri | Dəyişmə | Sifariş 2024 → 2025 | Orta sifariş 2024 → 2025 |
|-------|------------------:|------------------:|--------:|--------------------:|-------------------------:|
| Mobil tətbiq | 233 852 | 239 131 | **+2.26%** | 89 → 87 (−2.2%) | 2 628 → 2 749 (+4.6%) |
| Mağaza | 50 121 | 51 158 | **+2.07%** | 90 → 86 (−4.4%) | 557 → 595 (+6.8%) |
| Vebsayt | 137 479 | 136 513 | **−0.70%** | 92 → 87 (−5.4%) | 1 494 → 1 569 (+5.0%) |

**Nəticə:**
- Mobil tətbiq və mağaza kiçik artım göstərir (təxminən +2%), vebsayt isə yeganə azalan kanaldır (−0.7%).
- Hər üç kanalda sifariş sayı azalıb, satış gəliri isə orta sifariş məbləğinin artması (+4.6% – +6.8%) hesabına qorunub. Bu, ümumi mənzərə ilə üst-üstə düşür: artım qiymətdən gəlir.
- Vebsaytda sifariş itkisi ən böyükdür (−5.4%). Vebsayt həm də ən zəif yeni müştəri cəlb edən kanaldır (12-ci sual, ilk alışın 18.9%-i). Bu kanala diqqət lazımdır.
- Kanalların payı demək olar ki, dəyişməyib: mobil 55.5% → 56.0%, vebsayt 32.6% → 32.0%, mağaza 11.9% → 12.0%.

### 18. Müştəri konsentrasiyası

İlk 8 müştəri tamamlanmış satış gəlirinin **50.4%-ni** verir (2024-də 47.2%, 2025-də 53.5%). Yəni asılılıq artır.

---

## Tövsiyələr

1. **Churn:** 7 risk altındakı müştəri üçün geri qaytarma kampaniyası, xüsusilə regionlarda.
2. **Konsentrasiya:** İlk 8 müştəridən asılılığı azaltmaq üçün yeni müştəri cəlb etmək.
3. **Marja:** Elektronikada endirim siyasətinə baxmaq, Ev və Mətbəx üzrə əlavə satışı gücləndirmək.
