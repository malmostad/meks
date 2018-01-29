# Beräkning av belopp för förväntad schablon

Beräkningen av belopp för förväntad schablon görs genom att ta reda på i vilket tidsintervall varje barn uppfyller villkoren för respektive schablonkategori inom det valda rapportintervall. Därefter beräknas antalet dagar som varje schablonbelopp inom de erhållna schablonkategori-intervallen för barnet gäller. Schablonbeloppen multipliceras med antal dagar de gäller inom respektive schablonkategori-intervall.

De barn som får en förväntad schablon på 0 kronor har alltså inte uppfyllt något av schablonvillkoren under någon av de dagar som ingår i rapportintervallet.

Exempel:

* Valt rapportintervall är 2017-11-01––2018-02-28.
* Ett barn har under det intervallet uppfyllt villkoren för "Anvisade barn 0–17 år" under perioden 2017-12-15––2018-01-12 vilket är 29 dagar.
* Under den perioden har schablonkategorin "Anvisade barn 0–17 år" haft två schablonkostnader:
  * 1467 kr under perioden 2017-12-15--2017-12-31 vilket är 17 dagar. 1467 * 17 = 24939 kr.
  * 1322 kr under perioden 2018-01-01--2018-01-12 vilket är 12 dagar. 1322 * 12 = 15864 kr.
* Samma barn har i rapportintervallet uppfyllt villkoren för "PUT-barn 0–17 år" under 2018-01-13––2018-02-28 vilket är 47 dagar. Schablonkategorin "PUT-barn 0–17 år" har under det intervallet haft en schablonkostnad:
  * 1285 kr.  1285 * 47 = 60395 kr.

Schablonkostnaden för barnet under rapportintervallet är 24939 + 15864 + 60395 = 101198. I fältet förväntad schablon i Excelarket finns nu formeln =(1467*17 + 1322*12 + 1285*47) och beloppet 101198 visas.

Detta är en rad i Excelarket. Samma beräkningsmodell görs för varje barn, dvs. på varje rad i arket.


## Beräkning av antal dagar i respektive schablonkategori

För att beräkna hur många dagar inom valt rapportintervall som ett barn uppfyller villkoren för varje schablonkategori används datumet då barnet nått minimiåldern (0 år eller 18 år) samt inte är äldre än maxåldern (17 år + 1 år - 1 dag eller 20 år + 1 år - 1 dag). Utöver det används ett antal datum som är specifika för varje schablonkategori och anges nedan. När man fått fram ett från-datum och ett till-datum för respektive schablonkategori har man tidsintervallet som barnet uppfyller villkoren för schablonkategorin. Datum som inte är angivna i en akt ignoreras. Tidsintervall där erhållet från-datum inträffar efter till-datumet ignoreras.

## Ankomstbarn 0–17 år

Måste:
* inte ha datum medborgarskap
* ha inskrivningsdatum idag eller tidigare

Från-datum, det senaste av:
* rapportintervallets från-datum
* datumet när barnet uppnått minimiålder
* inskrivningsdatum

Till-datum, det tidigaste av:
* rapportintervallets till-datum
* datumet när barnet uppnått maxålder + 1 år - 1 dag
* avslutsdatum
* anvisningsdatum
* TUT startar
* PUT startar
* medborgarskap

## Anvisad

Måste:
* ha ”Anvisningsdatum till Malmö” idag eller tidigare, dvs. ha:
  - municipality_placement_migrationsverket_at
  - in_our_municipality

Från-datum, det senaste av:
* rapportintervallets från-datum
* datumet när barnet uppnått minimiålder
* utskriven till Malmö
* anvisningsdatum

Till-datum, det tidigaste av:
* rapportintervallets till-datum
* datumet när barnet uppnått maxålder + 1 år - 1 dag
* avslutad


## TUT

Måste:
* ha datum för TUT startar
* ha datum för TUT slutar
* ha TUT som är längre än 12 månader
* ha Utskriven till Malmö

Från-datum, det senaste av:
* rapportintervallets från-datum
* datumet när barnet uppnått minimiålder
* utskriven till Malmö
* startdatum för TUT

Till-datum, det tidigaste av:
* rapportintervallets till-datum
* datumet när barnet uppnått maxålder + 1 år - 1 dag
* avslutsdatum för TUT
* datum för PUT
* avslutsdatum


## PUT

Måste:
* Ha PUT
* Ha Utskriven till Malmö
* inte ha medborgarskap

Från-datum, det senaste av:
* rapportintervallets från-datum
* datumet när barnet uppnått minimiålder
* startdatum för PUT
* utskriven till Malmö

Till-datum, det tidigaste av:
* rapportintervallets till-datum
* datumet när barnet uppnått maxålder + 1 år - 1 dag
* medborgarskap
* avslutsdatum
