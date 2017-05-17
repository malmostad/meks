namespace :db do
  desc "Seed data for rate categories and legal codes"
  task seed_rate_categories: :environment do
    %w(SoL BoL LoL).each do |legal_code|
      LegalCode.create name: legal_code
    end

    lc_id = LegalCode.where(name: 'SoL').first.id

    [{ name: 'Ankomstbarn', from_age: 0, to_age: 17,
        legal_code_id: lc_id, description: 'Lagrum SoL. Schablonen ska beräknas från och med inskrivningsdatum och avslutas samma dag som anvisningsdatum till en annan kommun.',
        rate: { amount: 3_000, start_date: '2017-01-01', end_date: '2017-12-31' }
      },
      { name: 'Ankomstbarn', from_age: 18, to_age: 20,
        legal_code_id: lc_id, description: 'Lagrum SoL. Schablonen uteblir från och med 18-års dagen.',
        rate: { amount: 0, start_date: '2017-01-01', end_date: '2017-12-31' }
      },
      { name: 'Anvisade barn', from_age: 0, to_age: 17,
        legal_code_id: lc_id, description: 'Lagrum SoL. Schablonen ska beräknas för barn som ej har fyllt 18 år samt från och med anvisningsdatum till Malmö och avslutas samma dag som  står i kolumnen "Utskriven till Malmö". Om datum för "Utskriven till Malmö" är inte ifylld, då är det datum i raden "Avslutad" som avgör när schablonen upphör.',
        rate: { amount: 1_350, start_date: '2017-01-01', end_date: '2017-12-31' }
      },
      { name: 'Anvisade barn', from_age: 18, to_age: 20,
        legal_code_id: lc_id, description: 'Lagrum SoL. Schablonen uterblir från och med 18-års dagen.',
        rate: { amount: 0, start_date: '2017-01-01', end_date: '2017-12-31' }
      },
      { name: 'Barn med TUT', from_age: 0, to_age: 17,
        legal_code_id: lc_id, description: 'Lagrum SoL. Schablonen avser barn som ej har fyllt 18 år och har datum för "TUT startar" och "TUT slutar" ifyllda. Schablonen ska beräknas från och med dagen efter det datumet som står i raden "Utskriven till Malmö" och avslutas samma dag som barnet fyller 18 år eller det datum som står i raden "TUT slutar".',
        rate: { amount: 1_350, start_date: '2017-01-01', end_date: '2017-12-31' }
      },
      { name: 'Barn med TUT', from_age: 18, to_age: 20,
        legal_code_id: lc_id, description: 'Lagrum SoL. Schablonen avser barn som har fyllt 18 år, men inte 21 år och har datum för "TUT startar" och "TUT slutar" ifyllda.  Schablonen ska beräknas från och med dagen då barnet fyller 18 år och avslutas dagen innan barnet fyller 21 år eller det datumet som står i raden "TUT slutar".',
      },
      { name: 'Barn med PUT', from_age: 0, to_age: 17,
        legal_code_id: lc_id, description: 'Lagrum SoL. Schablonen avser barn som ej har fyllt 18 år. Schablonen ska beräknas från och med dagen efter det datumet som står i raden "Utskriven till Malmö". Schablonen avslutas samma dag som barnet fyller 18 år, dagen innan det datum som står i raden "Medborgarskap erhölls" eller om datum i raden "Avslutad" är ifylld.',
        rate: { amount: 1_350, start_date: '2017-01-01', end_date: '2017-12-31' }
      },
      { name: 'Barn med PUT', from_age: 18, to_age: 20,
        legal_code_id: lc_id, description: 'Lagrum SoL. Schablonen avser barn som har fyllt 18 år, men inte 21 år. Schablonen ska beräknas från och med dagen då barnet fyller 18 år och avslutas dagen innan barnet fyller 21 år, det datumet som står i raden "Avslutad" eller "Medborgarskap erhölls".',
        rate: { amount: 750, start_date: '2017-01-01', end_date: '2017-12-31' }
       }
    ].each do |rc|
      rate = rc[:rate]
      rc.except! :rate
      r = RateCategory.create!(rc)
      r.rates << Rate.new(rate) if rate.present?
      r.save!
    end
  end
end
