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
        desc: 'Lagrum SoL. Schablonen ska beräknas från och med inskrivningsdatum och avslutas samma dag som anvisningsdatum till en annan kommun.',
        conditions: [age_0_to_17, legal_code_sol] },
      { id: 2, name: 'Ankomstbarn',	age: '18–20',
        desc: 'Lagrum SoL. Schablonen uteblir från och med 18-års dagen.',
        conditions: [age_18_to_20, legal_code_sol] },
      { id: 3, name: 'Anvisade barn',	age: '0–17',
        desc: 'Lagrum SoL. Schablonen ska beräknas för barn som ej har fyllt 18 år samt från och med anvisningsdatum till Malmö och avslutas samma dag som  står i kolumnen "Utskriven till Malmö". Om datum för "Utskriven till Malmö" är inte ifylld, då är det datum i raden "Avslutad" som avgör när schablonen upphör.',
        conditions: [age_0_to_17, legal_code_sol] },
      { id: 4, name: 'Anvisade barn',	age: '18–20',
        desc: 'Lagrum SoL. Schablonen uterblir från och med 18-års dagen.',
        conditions: [age_18_to_20, legal_code_sol] },
      { id: 5, name: 'Barn med TUT',	age: '0–17',
        desc: 'Lagrum SoL. Schablonen avser barn som ej har fyllt 18 år och har datum för "TUT startar" och "TUT slutar" ifyllda. Schablonen ska beräknas från och med dagen efter det datumet som står i raden "Utskriven till Malmö" och avslutas samma dag som barnet fyller 18 år eller det datum som står i raden "TUT slutar".',
        conditions: [age_0_to_17, legal_code_sol] },
      { id: 6, name: 'Barn med TUT',	age: '18–20',
        desc: 'Lagrum SoL. Schablonen avser barn som har fyllt 18 år, men inte 21 år och har datum för "TUT startar" och "TUT slutar" ifyllda.  Schablonen ska beräknas från och med dagen då barnet fyller 18 år och avslutas dagen innan barnet fyller 21 år eller det datumet som står i raden "TUT slutar".',
        conditions: [age_18_to_20, legal_code_sol] },
      { id: 7, name: 'Barn med PUT',	age: '0–17',
        desc: 'Lagrum SoL. Schablonen avser barn som ej har fyllt 18 år. Schablonen ska beräknas från och med dagen efter det datumet som står i raden "Utskriven till Malmö". Schablonen avslutas samma dag som barnet fyller 18 år, dagen innan det datum som står i raden "Medborgarskap erhölls" eller om datum i raden "Avslutad" är ifylld.',
        conditions: [age_0_to_17, legal_code_sol] },
      { id: 8, name: 'Barn med PUT',	age: '18–20',
        desc: 'Lagrum SoL. Schablonen avser barn som har fyllt 18 år, men inte 21 år. Schablonen ska beräknas från och med dagen då barnet fyller 18 år och avslutas dagen innan barnet fyller 21 år, det datumet som står i raden "Avslutad" eller "Medborgarskap erhölls".',
        conditions: [age_18_to_20, legal_code_sol] }
    ].freeze
  end
end
