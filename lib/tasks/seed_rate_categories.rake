namespace :db do
  desc "Seed data for rate categories and legal codes"
  task seed_rate_categories: :environment do
    %w(SoL BoL LoL).each do |legal_code|
      LegalCode.create name: legal_code
    end

    [{ name: 'Ankomstbarn',	from_age: 0, to_age: 17,
        legal_code_id: 1, description: 'Lagrum SoL. Schablonen ska beräknas från och med inskrivningsdatum och avslutas samma dag som anvisningsdatum till en annan kommun.',
      },
      { name: 'Ankomstbarn',	from_age: 18, to_age: 20,
        legal_code_id: 1, description: 'Lagrum SoL. Schablonen uteblir från och med 18-års dagen.',
      },
      { name: 'Anvisade barn',	from_age: 0, to_age: 17,
        legal_code_id: 1, description: 'Lagrum SoL. Schablonen ska beräknas för barn som ej har fyllt 18 år samt från och med anvisningsdatum till Malmö och avslutas samma dag som  står i kolumnen "Utskriven till Malmö". Om datum för "Utskriven till Malmö" är inte ifylld, då är det datum i raden "Avslutad" som avgör när schablonen upphör.',
      },
      { name: 'Anvisade barn',	from_age: 18, to_age: 20,
        legal_code_id: 1, description: 'Lagrum SoL. Schablonen uterblir från och med 18-års dagen.',
      },
      { name: 'Barn med TUT',	from_age: 0, to_age: 17,
        legal_code_id: 1, description: 'Lagrum SoL. Schablonen avser barn som ej har fyllt 18 år och har datum för "TUT startar" och "TUT slutar" ifyllda. Schablonen ska beräknas från och med dagen efter det datumet som står i raden "Utskriven till Malmö" och avslutas samma dag som barnet fyller 18 år eller det datum som står i raden "TUT slutar".',
      },
      { name: 'Barn med TUT',	from_age: 18, to_age: 20,
        legal_code_id: 1, description: 'Lagrum SoL. Schablonen avser barn som har fyllt 18 år, men inte 21 år och har datum för "TUT startar" och "TUT slutar" ifyllda.  Schablonen ska beräknas från och med dagen då barnet fyller 18 år och avslutas dagen innan barnet fyller 21 år eller det datumet som står i raden "TUT slutar".',
      },
      { name: 'Barn med PUT',	from_age: 0, to_age: 17,
        legal_code_id: 1, description: 'Lagrum SoL. Schablonen avser barn som ej har fyllt 18 år. Schablonen ska beräknas från och med dagen efter det datumet som står i raden "Utskriven till Malmö". Schablonen avslutas samma dag som barnet fyller 18 år, dagen innan det datum som står i raden "Medborgarskap erhölls" eller om datum i raden "Avslutad" är ifylld.',
      },
      { name: 'Barn med PUT',	from_age: 18, to_age: 20,
        legal_code_id: 1, description: 'Lagrum SoL. Schablonen avser barn som har fyllt 18 år, men inte 21 år. Schablonen ska beräknas från och med dagen då barnet fyller 18 år och avslutas dagen innan barnet fyller 21 år, det datumet som står i raden "Avslutad" eller "Medborgarskap erhölls".',
       }
    ].each do |rate|
        RateCategory.create(rate)
    end
  end
end
