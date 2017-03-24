module Economy
  extend ActiveSupport::Concern

  module ClassMethods
    def age_0_to_17(at_date = Date.today)
      where('date_of_birth <= ? and date_of_birth > ?', at_date - 0.years.ago.to_date, at_date - 18.years.ago.to_date)
    end

    def age_18_to_20(at_date = Date.today)
      where('date_of_birth <= ? and date_of_birth > ?', at_date - 18.years.ago.to_date, at_date - 20.years.ago.to_date)
    end

    def legal_code_sol
      where(legal_code: { name: 'SoL' })
    end
  end

  included do
    RATE_CATEGORIES = [
      { name: 'Ankomstbarn',	from_age: 0, to_age: 17,
        legal_code_id: 1, description: 'Lagrum SoL. Schablonen ska beräknas från och med inskrivningsdatum och avslutas samma dag som anvisningsdatum till en annan kommun.',
        conditions: [age_0_to_17, legal_code_sol] },
      { name: 'Ankomstbarn',	from_age: 18, to_age: 20,
        legal_code_id: 1, description: 'Lagrum SoL. Schablonen uteblir från och med 18-års dagen.',
        conditions: [age_18_to_20, legal_code_sol] },
      { name: 'Anvisade barn',	from_age: 0, to_age: 17,
        legal_code_id: 1, description: 'Lagrum SoL. Schablonen ska beräknas för barn som ej har fyllt 18 år samt från och med anvisningsdatum till Malmö och avslutas samma dag som  står i kolumnen "Utskriven till Malmö". Om datum för "Utskriven till Malmö" är inte ifylld, då är det datum i raden "Avslutad" som avgör när schablonen upphör.',
        conditions: [age_0_to_17, legal_code_sol] },
      { name: 'Anvisade barn',	from_age: 18, to_age: 20,
        legal_code_id: 1, description: 'Lagrum SoL. Schablonen uterblir från och med 18-års dagen.',
        conditions: [age_18_to_20, legal_code_sol] },
      { name: 'Barn med TUT',	from_age: 0, to_age: 17,
        legal_code_id: 1, description: 'Lagrum SoL. Schablonen avser barn som ej har fyllt 18 år och har datum för "TUT startar" och "TUT slutar" ifyllda. Schablonen ska beräknas från och med dagen efter det datumet som står i raden "Utskriven till Malmö" och avslutas samma dag som barnet fyller 18 år eller det datum som står i raden "TUT slutar".',
        conditions: [age_0_to_17, legal_code_sol] },
      { name: 'Barn med TUT',	from_age: 18, to_age: 20,
        legal_code_id: 1, description: 'Lagrum SoL. Schablonen avser barn som har fyllt 18 år, men inte 21 år och har datum för "TUT startar" och "TUT slutar" ifyllda.  Schablonen ska beräknas från och med dagen då barnet fyller 18 år och avslutas dagen innan barnet fyller 21 år eller det datumet som står i raden "TUT slutar".',
        conditions: [age_18_to_20, legal_code_sol] },
      { name: 'Barn med PUT',	from_age: 0, to_age: 17,
        legal_code_id: 1, description: 'Lagrum SoL. Schablonen avser barn som ej har fyllt 18 år. Schablonen ska beräknas från och med dagen efter det datumet som står i raden "Utskriven till Malmö". Schablonen avslutas samma dag som barnet fyller 18 år, dagen innan det datum som står i raden "Medborgarskap erhölls" eller om datum i raden "Avslutad" är ifylld.',
        conditions: [age_0_to_17, legal_code_sol] },
      { name: 'Barn med PUT',	from_age: 18, to_age: 20,
        legal_code_id: 1, description: 'Lagrum SoL. Schablonen avser barn som har fyllt 18 år, men inte 21 år. Schablonen ska beräknas från och med dagen då barnet fyller 18 år och avslutas dagen innan barnet fyller 21 år, det datumet som står i raden "Avslutad" eller "Medborgarskap erhölls".',
        conditions: [age_18_to_20, legal_code_sol] }
    ].freeze
  end
end
