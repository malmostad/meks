['Abchazien', 'Afghanistan', 'Albanien', 'Algeriet', 'Andorra', 'Angola', 'Antigua och Barbuda', 'Argentina', 'Armenien', 'Australien', 'Azerbajdzjan', 'Bahamas', 'Bahrain', 'Bangladesh', 'Barbados', 'Belgien', 'Belize', 'Benin', 'Bhutan', 'Bolivia', 'Bosnien och Hercegovina', 'Botswana', 'Brasilien', 'Brunei', 'Bulgarien', 'Burkina Faso', 'Burundi', 'Centralafrikanska republiken', 'Chile', 'Colombia', 'Costa Rica', 'Cypern', 'Nordcypern', 'Danmark', 'Djibouti', 'Dominica', 'Dominikanska republiken', 'Ecuador', 'Egypten', 'Ekvatorialguinea', 'Elfenbenskusten', 'El Salvador', 'Eritrea', 'Estland', 'Etiopien', 'Fijiöarna', 'Filippinerna', 'Finland', 'Franska republiken', 'Förenade Arabemiraten', 'Storbritannien och Nordirland', 'Gabonesiska republiken', 'Gambia', 'Georgien', 'Ghana', 'Grekland', 'Grenada', 'Guatemala', 'Guinea', 'Guinea-Bissau', 'Guyana', 'Haiti', 'Honduras', 'Indien', 'Indonesien', 'Irak', 'Iran', 'Irland', 'Island', 'Israel', 'Italienska republiken', 'Jamaica', 'Japan', 'Jemen', 'Jordanien', 'Kambodja', 'Kamerun', 'Kanada', 'Kap Verde', 'Kazakstan', 'Kenya', 'Kina', 'Kina', 'Kirgiziska republiken', 'Kiribati', 'Komorerna', 'Kongo', 'Kongo', 'Korea', 'Korea', 'Kosovo', 'Kroatien', 'Kuba', 'Kuwait', 'Laotiska folkets demokratiska republik', 'Lesotho', 'Lettland', 'Libanon', 'Liberia', 'Libyska folksocialistiska arab jamahiriya', 'Liechtenstein', 'Litauen', 'Luxemburg', 'Madagaskar', 'Makedonien', 'Malawi', 'Malaysia', 'Maldiverna', 'Mali', 'Malta', 'Marocko', 'Marshallöarna', 'Mauretanien', 'Mauritius', 'Mexikos förenta stater', 'Mikronesiens federerade stater', 'Moçambique', 'Moldavien', 'Monaco', 'Mongoliet', 'Montenegro', 'Myanmar', 'Nagorno-Karabach', 'Namibia', 'Nauru', 'Nederländerna', 'Nepal', 'Nicaragua', 'Niger', 'Nigeria', 'Norge', 'Nya Zeeland', 'Oman', 'Pakistan', 'Palau', 'Palestinska myndigheten', 'Panama', 'Papua Nya Guinea', 'Paraguay', 'Peru', 'Polen', 'Portugisiska repubiken', 'Qatar', 'Rumänien', 'Rwanda', 'Ryska federationen', 'Saint Kitts och Nevis', 'Saint Lucia', 'Saint Vincent och Grenadinerna', 'Salomonöarna', 'Samoa', 'San Marino', 'São Tomé och Príncipe', 'Saudiarabien', 'Schweiziska edsförbundet', 'Senegal', 'Serbien', 'Seychellerna', 'Sierra Leone', 'Singapore', 'Slovakiska republiken', 'Slovenien', 'Somalia', 'Somaliland', 'Spanien', 'Sri Lanka', 'Sudan', 'Surinam', 'Sverige', 'Swaziland', 'Sydafrika', 'Sydossetien', 'Sydsudan', 'Syriska arabrepubliken', 'Tadzjikistan', 'Taiwan (Republiken Kina)', 'Tanzania', 'Tchad', 'Thailand', 'Tjeckiska republiken', 'Togolesiska republiken', 'Tonga', 'Transnistriens moldaviska republik', 'Trinidad och Tobago', 'Tunisien', 'Turkiet', 'Turkmenistan', 'Tuvalu', 'Tyskland', 'Uganda', 'Ukraina', 'Ungern', 'Uruguay', 'USA', 'Uzbekistan', 'Vanuatu', 'Vatikanen', 'Venezuela', 'Vietnam', 'Vitryssland', 'Zambia', 'Zimbabwe', 'Österrike', 'Östtimor'].each do |c|
  Country.create(name: c)
end

['akan', 'amhariska', 'arabiska', 'assamesiska', 'azerbajdzjanska (azeriska)', 'baluchi', 'bengali', 'burmesiska', 'cebuano', 'chhattisgarhi', 'chittagoniska', 'deccan (dakhni)', 'dhundari', 'engelska', 'franska', 'fula', 'grekiska', 'gujarati', 'haitisk kreol', 'hausa', 'hiligaynon', 'hindi', 'hmong', 'igbo', 'ilocano', 'indonesiska', 'italienska', 'japanska', 'javanesiska', 'kannada', 'kazakiska', 'khmer', 'kinesiska', 'kinesiska)', 'konkani', 'koreanska', 'kurdiska', 'maduresiska', 'malagassiska', 'malayalam', 'marathi', 'marvari', 'minkinesiska', 'mòoré', 'nederländska', 'nepali', 'nyanja (Chichewa)', 'oriya', 'oromo', 'pashto', 'persiska', 'polska', 'portugisiska', 'punjabi', 'quechua', 'rumänska', 'rundi', 'rwanda', 'ryska', 'serbokroatiska', 'shona', 'sindhi', 'singalesiska', 'siraiki', 'somaliska', 'spanska', 'sundanesiska', 'svenska', 'sylheti', 'tagalog', 'tamil', 'telugu', 'thai', 'tjeckiska', 'turkiska', 'turkmeniska', 'tyska', 'uiguriska', 'ukrainska', 'ungerska', 'urdu (del av hindustani)', 'uzbekiska', 'vietnamesiska', 'vitryska', 'xhosa', 'yoruba', 'zhuang', 'zulu'].each do |l|
  Language.create(name: l.humanize)
end

['Familjehem', 'Institution', 'Jour', 'Utsluss', 'Stödboende'].each do |ht|
  TypeOfHousing.create(name: ht)
end

['Egna (SrF)', 'Externa'].each do |hot|
  OwnerType.create(name: hot)
end

['Inga behov', 'Flickor', 'Yngre', 'Speciella behov'].each do |htg|
  TargetGroup.create(name: htg)
end

['Villa Vånga', 'Tempo', 'Villa poppel', 'Tempo', 'Jourhem', 'Maglarp 1', 'Maglarp 2', 'Maglarp 2', 'Humania', 'Duvan', 'Maglarp 1', 'Maglarp 2', 'Maglarp 2', 'Maglarp 1', 'Maglarp 1', 'Maglarp 2', 'Aleris T'].each do |h|
  Home.create(
    name: h,
    postal_town: 'Malmö',
    type_of_housing_ids: [rand(TypeOfHousing.count) + 1],
    target_group_ids: [rand(TargetGroup.count) + 1],
    owner_type_ids: [rand(OwnerType.count) + 1],
    seats: rand(100) + 1
  )
end

['Kvinna', 'Man'].each do |s|
  Gender.create(name: s)
end

['Avskriven', 'Avvek', 'Avisad', '18 år'].each do |name|
  MovedOutReason.create(name: name)
end


(0...250).each do
  r = Refugee.create(
    name: Faker::Name.name,
    gender_id: rand(Gender.count) + 1,
    country_ids: [rand(Country.count) + 1],
    language_ids: [rand(Language.count) + 1],
    registered: Faker::Date.between(1.year.ago, Date.today),
    special_needs: rand(2),
    comment: Faker::Lorem.paragraph
  )

  (rand(2)).times do
    DossierNumber.create(refugee_id: r.id, name: Faker::Number.number(10))
  end

  (rand(2)).times do
    Ssn.create(refugee_id: r.id, name: Faker::Time.between(DateTime.now - 18.year, DateTime.now - 4.year).to_s.gsub('-', '')[0..7])
  end

  # Assign and deassing refugees to homes
  moved_out_at = DateTime.now
  rand(0..5).downto(1).each do |t|
    if r.assignments.present?
      moved_in_at = r.assignments.last.moved_out_at + 1.days
    else
      moved_in_at = (rand(100*t-50..100*t)).days.ago
    end
    moved_out_at = moved_in_at + (rand(2..100)).days

    r.assignments.create(
      home_id: rand(Home.count) + 1,
      moved_in_at: moved_in_at,
      moved_out_at: moved_out_at,
      moved_out_reason_id: rand(MovedOutReason.count) + 1,
      comment: Faker::Lorem.paragraph
    )
  end

  # Make most refugees still assigned to a home
  if r.id % 4 > 0
    r.assignments.create(
      home_id: rand(Home.count) + 1,
      moved_in_at: moved_out_at + 1.days
    )
  end
end
