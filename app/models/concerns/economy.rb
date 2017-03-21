module Economy
  extend ActiveSupport::Concern

  module ClassMethods
    def age_0_to_17(at_date = Date.today)
      where('date_of_birth <= ? and date_of_birth > ?', at_date - 0.years.ago.to_date, at_date - 18.years.ago.to_date)
    end

    def age_18_to_20(at_date = Date.today)
      where('date_of_birth <= ? and date_of_birth > ?', at_date - 18.years.ago.to_date, at_date - 20.years.ago.to_date)
    end
  end

  included do
    RATE_CATEGORIES = [
      { id: 1, name: 'Ankomstbarn',	age: '0–17',
        desc: 'Schablonen ska beräknas från och med inskrivningsdatum och avslutas samma dag som anvisningsdatum till en annan kommun än Malmö. Om anvisningsdatum och anvisningskommun saknas, avgörs schablonens avslut genom datum i raden "Avslutad".',
        comment: 'Ersättningen betalas ut efter ansökan, gäller enbart ankomstkommuner',
        conditions: age_0_to_17 },
      { id: 2, name: 'Ankomstbarn',	age: '18–20',
        desc: 'Schablonen uterblir från och med 18-års dagen.',
        comment: 'Från och med 18-års dagen räknas som vuxna, ingen ersättning till kommunen',
        conditions: age_18_to_20 },
      { id: 3, name: 'Anvisade',	age: '0–17',
        desc: 'Schablonen ska beräknas för barn som ej har fyllt 18 år samt från och med anvisningsdatum till Malmö och avslutas samma dag som står i kolumnen "Utskriven till Malmö". Om datum för "Utskriven till Malmö" är inte ifylld, då är det datum i raden "Avslutad" som avgör när schablonen upphör.',
        comment: 'Utbetalas per automatik till anvisningskommunen',
        conditions: age_0_to_17 },
      { id: 4, name: 'Anvisade',	age: '18–20',
        desc: 'Schablonen uterblir från och med 18-års dagen',
        comment: 'Från och med 18-års dagen räknas som vuxna, ingen ersättning till kommunen',
        conditions: age_18_to_20 },
      { id: 5, name: 'Anvisade',	age: '18–20',
        desc: 'Schablonen uterblir från och med 18-års dagen.',
        comment: 'Vid placering enligt LVU och för dem som har motsvarande vårdbehov, men som är placerade med stöd av SoL',
        conditions: age_18_to_20 },
      { id: 6, name: 'Barn med PUT',	age: '0–17',
        desc: 'Schablonen avser barn som ej har fyllt 18 år och har datum för "TUT startar" och "TUT slutar" ifyllda. Schablonen ska beräknas från och med dagen efter det datumet som står i raden "Utskriven till Malmö" och avslutas samma dag som barnet fyller 18 år eller det datum som står i raden "TUT slutar".',
        comment: 'Utbetalas per automatik till anvisningskommunen',
        conditions: age_0_to_17 },
      { id: 7, name: 'Barn med PUT',	age: '18–20',
        desc: 'Schablonen avser barn som har fyllt 18 år, men inte 21 år och har datum för "TUT startar" och "TUT slutar" ifyllda. Schablonen ska beräknas från och med dagen då barnet fyller 18 år och avslutas dagen innan barnet fyller 21 år eller det datumet som står i raden "TUT slutar".',
        comment: 'Utbetalas per automatik till anvisningskommunen eller den kommun som årendet flyttats över till',
        conditions: age_18_to_20 },
      { id: 8, name: 'Barn med PUT',	age: '18–20',
        desc: 'Schablonen avser barn som har fyllt 18 år, men inte 21 år och har datum för "TUT startar" och "TUT slutar" ifyllda. Schablonen ska beräknas från och med dagen då barnet fyller 18 år och avslutas dagen innan barnet fyller 21 år eller det datumet som står i raden "TUT slutar".',
        comment: 'Vid placering enligt LVU och för dem som har motsvarande vårdbehov, men som är placerade med stöd av SoL',
        conditions: age_18_to_20 },
      { id: 9, name: 'Barn med PUT',	age: '18–20',
        desc: 'Schablonen avser barn som har fyllt 18 år, men inte 21 år och har datum för "TUT startar" och "TUT slutar" ifyllda. Schablonen ska beräknas från och med dagen då barnet fyller 18 år och avslutas dagen innan barnet fyller 21 år eller det datumet som står i raden "TUT slutar".',
        comment: 'För barn som inte omfattas av någon av de andra ersättningarna ska kommunen söka försörjningsstöd',
        conditions: age_18_to_20 }
    ].freeze
  end
end
