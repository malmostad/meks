['Abchazien', 'Afghanistan', 'Albanien', 'Algeriet', 'Andorra', 'Angola', 'Antigua och Barbuda', 'Argentina', 'Armenien', 'Australien', 'Azerbajdzjan', 'Bahamas', 'Bahrain', 'Bangladesh', 'Barbados', 'Belgien', 'Belize', 'Benin', 'Bhutan', 'Bolivia', 'Bosnien och Hercegovina', 'Botswana', 'Brasilien', 'Brunei', 'Bulgarien', 'Burkina Faso', 'Burundi', 'Centralafrikanska republiken', 'Chile', 'Colombia', 'Costa Rica', 'Cypern', 'Nordcypern', 'Danmark', 'Djibouti', 'Dominica', 'Dominikanska republiken', 'Ecuador', 'Egypten', 'Ekvatorialguinea', 'Elfenbenskusten', 'El Salvador', 'Eritrea', 'Estland', 'Etiopien', 'Fijiöarna', 'Filippinerna', 'Finland', 'Franska republiken', 'Förenade Arabemiraten', 'Storbritannien och Nordirland', 'Gabonesiska republiken', 'Gambia', 'Georgien', 'Ghana', 'Grekland', 'Grenada', 'Guatemala', 'Guinea', 'Guinea-Bissau', 'Guyana', 'Haiti', 'Honduras', 'Indien', 'Indonesien', 'Irak', 'Iran', 'Irland', 'Island', 'Israel', 'Italienska republiken', 'Jamaica', 'Japan', 'Jemen', 'Jordanien', 'Kambodja', 'Kamerun', 'Kanada', 'Kap Verde', 'Kazakstan', 'Kenya', 'Kina', 'Kina', 'Kirgiziska republiken', 'Kiribati', 'Komorerna', 'Kongo', 'Kongo', 'Korea', 'Korea', 'Kosovo', 'Kroatien', 'Kuba', 'Kuwait', 'Laotiska folkets demokratiska republik', 'Lesotho', 'Lettland', 'Libanon', 'Liberia', 'Libyska folksocialistiska arab jamahiriya', 'Liechtenstein', 'Litauen', 'Luxemburg', 'Madagaskar', 'Makedonien', 'Malawi', 'Malaysia', 'Maldiverna', 'Mali', 'Malta', 'Marocko', 'Marshallöarna', 'Mauretanien', 'Mauritius', 'Mexikos förenta stater', 'Mikronesiens federerade stater', 'Moçambique', 'Moldavien', 'Monaco', 'Mongoliet', 'Montenegro', 'Myanmar', 'Nagorno-Karabach', 'Namibia', 'Nauru', 'Nederländerna', 'Nepal', 'Nicaragua', 'Niger', 'Nigeria', 'Norge', 'Nya Zeeland', 'Oman', 'Pakistan', 'Palau', 'Palestinska myndigheten', 'Panama', 'Papua Nya Guinea', 'Paraguay', 'Peru', 'Polen', 'Portugisiska repubiken', 'Qatar', 'Rumänien', 'Rwanda', 'Ryska federationen', 'Saint Kitts och Nevis', 'Saint Lucia', 'Saint Vincent och Grenadinerna', 'Salomonöarna', 'Samoa', 'San Marino', 'São Tomé och Príncipe', 'Saudiarabien', 'Schweiziska edsförbundet', 'Senegal', 'Serbien', 'Seychellerna', 'Sierra Leone', 'Singapore', 'Slovakiska republiken', 'Slovenien', 'Somalia', 'Somaliland', 'Spanien', 'Sri Lanka', 'Sudan', 'Surinam', 'Sverige', 'Swaziland', 'Sydafrika', 'Sydossetien', 'Sydsudan', 'Syriska arabrepubliken', 'Tadzjikistan', 'Taiwan (Republiken Kina)', 'Tanzania', 'Tchad', 'Thailand', 'Tjeckiska republiken', 'Togolesiska republiken', 'Tonga', 'Transnistriens moldaviska republik', 'Trinidad och Tobago', 'Tunisien', 'Turkiet', 'Turkmenistan', 'Tuvalu', 'Tyskland', 'Uganda', 'Ukraina', 'Ungern', 'Uruguay', 'USA', 'Uzbekistan', 'Vanuatu', 'Vatikanen', 'Venezuela', 'Vietnam', 'Vitryssland', 'Zambia', 'Zimbabwe', 'Österrike', 'Östtimor'].each do |c|
  Country.create(name: c)
end

['akan', 'amhariska', 'arabiska', 'assamesiska', 'azerbajdzjanska (azeriska)', 'baluchi', 'bengali', 'burmesiska', 'cebuano', 'chhattisgarhi', 'chittagoniska', 'deccan (dakhni)', 'dhundari', 'engelska', 'franska', 'fula', 'grekiska', 'gujarati', 'haitisk kreol', 'hausa', 'hiligaynon', 'hindi', 'hmong', 'igbo', 'ilocano', 'indonesiska', 'italienska', 'japanska', 'javanesiska', 'kannada', 'kazakiska', 'khmer', 'kinesiska', 'kinesiska)', 'konkani', 'koreanska', 'kurdiska', 'maduresiska', 'malagassiska', 'malayalam', 'marathi', 'marvari', 'minkinesiska', 'mòoré', 'nederländska', 'nepali', 'nyanja (Chichewa)', 'oriya', 'oromo', 'pashto', 'persiska', 'polska', 'portugisiska', 'punjabi', 'quechua', 'rumänska', 'rundi', 'rwanda', 'ryska', 'serbokroatiska', 'shona', 'sindhi', 'singalesiska', 'siraiki', 'somaliska', 'spanska', 'sundanesiska', 'svenska', 'sylheti', 'tagalog', 'tamil', 'telugu', 'thai', 'tjeckiska', 'turkiska', 'turkmeniska', 'tyska', 'uiguriska', 'ukrainska', 'ungerska', 'urdu (del av hindustani)', 'uzbekiska', 'vietnamesiska', 'vitryska', 'xhosa', 'yoruba', 'zhuang', 'zulu'].each do |l|
  Language.create(name: l.humanize)
end

['Ale kommun', 'Alingsås kommun', 'Alvesta kommun', 'Aneby kommun', 'Arboga kommun', 'Arjeplogs kommun', 'Arvidsjaurs kommun', 'Arvika kommun', 'Askersunds kommun', 'Avesta kommun', 'Bengtsfors kommun', 'Bergs kommun', 'Bjurholms kommun', 'Bjuvs kommun', 'Bodens kommun', 'Bollebygds kommun', 'Bollnäs kommun', 'Borgholms kommun', 'Borlänge kommun', 'Borås kommun', 'Botkyrka kommun', 'Boxholms kommun', 'Bromölla kommun', 'Bräcke kommun', 'Burlövs kommun', 'Båstads kommun', 'Dals-Eds kommun', 'Danderyds kommun', 'Degerfors kommun', 'Dorotea kommun', 'Eda kommun', 'Ekerö kommun', 'Eksjö kommun', 'Emmaboda kommun', 'Enköpings kommun', 'Eskilstuna kommun', 'Eslövs kommun', 'Essunga kommun', 'Fagersta kommun', 'Falkenbergs kommun', 'Falköpings kommun', 'Falu kommun', 'Filipstads kommun', 'Finspångs kommun', 'Flens kommun', 'Forshaga kommun', 'Färgelanda kommun', 'Gagnefs kommun', 'Gislaveds kommun', 'Gnesta kommun', 'Gnosjö kommun', 'Gotlands kommun', 'Grums kommun', 'Grästorps kommun', 'Gullspångs kommun', 'Gällivare kommun', 'Gävle kommun', 'Göteborgs kommun', 'Götene kommun', 'Habo kommun', 'Hagfors kommun', 'Hallsbergs kommun', 'Hallstahammars kommun', 'Halmstads kommun', 'Hammarö kommun', 'Haninge kommun', 'Haparanda kommun', 'Heby kommun', 'Hedemora kommun', 'Helsingborgs kommun', 'Herrljunga kommun', 'Hjo kommun', 'Hofors kommun', 'Huddinge kommun', 'Hudiksvalls kommun', 'Hultsfreds kommun', 'Hylte kommun', 'Håbo kommun', 'Hällefors kommun', 'Härjedalens kommun', 'Härnösands kommun', 'Härryda kommun', 'Hässleholms kommun', 'Höganäs kommun', 'Högsby kommun', 'Hörby kommun', 'Höörs kommun', 'Jokkmokks kommun', 'Järfälla kommun', 'Jönköpings kommun', 'Kalix kommun', 'Kalmar kommun', 'Karlsborgs kommun', 'Karlshamns kommun', 'Karlskoga kommun', 'Karlskrona kommun', 'Karlstads kommun', 'Katrineholms kommun', 'Kils kommun', 'Kinda kommun', 'Kiruna kommun', 'Klippans kommun', 'Knivsta kommun', 'Kramfors kommun', 'Kristianstads kommun', 'Kristinehamns kommun', 'Krokoms kommun', 'Kumla kommun', 'Kungsbacka kommun', 'Kungsörs kommun', 'Kungälvs kommun', 'Kävlinge kommun', 'Köpings kommun', 'Laholms kommun', 'Landskrona kommun', 'Laxå kommun', 'Lekebergs kommun', 'Leksands kommun', 'Lerums kommun', 'Lessebo kommun', 'Lidingö kommun', 'Lidköpings kommun', 'Lilla Edets kommun', 'Lindesbergs kommun', 'Linköpings kommun', 'Ljungby kommun', 'Ljusdals kommun', 'Ljusnarsbergs kommun', 'Lomma kommun', 'Ludvika kommun', 'Luleå kommun', 'Lunds kommun', 'Lycksele kommun', 'Lysekils kommun', 'Malmö kommun', 'Malmö kommun, Srf', 'Malmö kommun, Innerstaden', 'Malmö kommun, Norr', 'Malmö kommun, Söder', 'Malmö kommun, Väster', 'Malmö kommun, Öster', 'Malung-Sälens kommun', 'Malå kommun', 'Mariestads kommun', 'Marks kommun', 'Markaryds kommun', 'Melleruds kommun', 'Mjölby kommun', 'Mora kommun', 'Motala kommun', 'Mullsjö kommun', 'Munkedals kommun', 'Munkfors kommun', 'Mölndals kommun', 'Mönsterås kommun', 'Mörbylånga kommun', 'Nacka kommun', 'Nora kommun', 'Norbergs kommun', 'Nordanstigs kommun', 'Nordmalings kommun', 'Norrköpings kommun', 'Norrtälje kommun', 'Norsjö kommun', 'Nybro kommun', 'Nykvarns kommun', 'Nyköpings kommun', 'Nynäshamns kommun', 'Nässjö kommun', 'Ockelbo kommun', 'Olofströms kommun', 'Orsa kommun', 'Orusts kommun', 'Osby kommun', 'Oskarshamns kommun', 'Ovanåkers kommun', 'Oxelösunds kommun', 'Pajala kommun', 'Partille kommun', 'Perstorps kommun', 'Piteå kommun', 'Ragunda kommun', 'Robertsfors kommun', 'Ronneby kommun', 'Rättviks kommun', 'Sala kommun', 'Salems kommun', 'Sandvikens kommun', 'Sigtuna kommun', 'Simrishamns kommun', 'Sjöbo kommun', 'Skara kommun', 'Skellefteå kommun', 'Skinnskattebergs kommun', 'Skurups kommun', 'Skövde kommun', 'Smedjebackens kommun', 'Sollefteå kommun', 'Sollentuna kommun', 'Solna kommun', 'Sorsele kommun', 'Sotenäs kommun', 'Staffanstorps kommun', 'Stenungsunds kommun', 'Stockholms kommun', 'Storfors kommun', 'Storumans kommun', 'Strängnäs kommun', 'Strömstads kommun', 'Strömsunds kommun', 'Sundbybergs kommun', 'Sundsvalls kommun', 'Sunne kommun', 'Surahammars kommun', 'Svalövs kommun', 'Svedala kommun', 'Svenljunga kommun', 'Säffle kommun', 'Säters kommun', 'Sävsjö kommun', 'Söderhamns kommun', 'Söderköpings kommun', 'Södertälje kommun', 'Sölvesborgs kommun', 'Tanums kommun', 'Tibro kommun', 'Tidaholms kommun', 'Tierps kommun', 'Timrå kommun', 'Tingsryds kommun', 'Tjörns kommun', 'Tomelilla kommun', 'Torsby kommun', 'Torsås kommun', 'Tranemo kommun', 'Tranås kommun', 'Trelleborgs kommun', 'Trollhättans kommun', 'Trosa kommun', 'Tyresö kommun', 'Täby kommun', 'Töreboda kommun', 'Uddevalla kommun', 'Ulricehamns kommun', 'Umeå kommun', 'Upplands Väsby kommun', 'Upplands-Bro kommun', 'Uppsala kommun', 'Uppvidinge kommun', 'Vadstena kommun', 'Vaggeryds kommun', 'Valdemarsviks kommun', 'Vallentuna kommun', 'Vansbro kommun', 'Vara kommun', 'Varbergs kommun', 'Vaxholms kommun', 'Vellinge kommun', 'Vetlanda kommun', 'Vilhelmina kommun', 'Vimmerby kommun', 'Vindelns kommun', 'Vingåkers kommun', 'Vårgårda kommun', 'Vänersborgs kommun', 'Vännäs kommun', 'Värmdö kommun', 'Värnamo kommun', 'Västerviks kommun', 'Västerås kommun', 'Växjö kommun', 'Ydre kommun', 'Ystads kommun', 'Åmåls kommun', 'Ånge kommun', 'Åre kommun', 'Årjängs kommun', 'Åsele kommun', 'Åstorps kommun', 'Åtvidabergs kommun', 'Älmhults kommun', 'Älvdalens kommun', 'Älvkarleby kommun', 'Älvsbyns kommun', 'Ängelholms kommun', 'Öckerö kommun', 'Ödeshögs kommun', 'Örebro kommun', 'Örkelljunga kommun', 'Örnsköldsviks kommun', 'Östersunds kommun', 'Österåkers kommun', 'Östhammars kommun', 'Östra Göinge kommun', 'Överkalix kommun', 'Övertorneå kommun'].each do |m|
  Municipality.create(name: m)
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

['partner', 'man', 'hustru', 'syster', 'bror', 'mamma', 'pappa', 'kusin', 'morbror', 'farbror', 'faster', 'moster', 'annan släkting', 'annan', 'samma person'].each do |name|
  TypeOfRelationship.create(name: name)
end

locales = Rails.configuration.i18n.available_locales
(0...1000).each do
  I18n.locale = locales[rand(locales.size)]
  r = Refugee.create(
    name: Faker::Name.name.gsub(/(Prof.|Dr.|PhD.|Mgr.|Sr.)/, '').strip,
    gender_id: rand(Gender.count) + 1,
    country_ids: [rand(Country.count) + 1],
    language_ids: [rand(Language.count) + 1],
    registered: Faker::Date.between(1.year.ago, Date.today),
    special_needs: rand(2),
    comment: Faker::Lorem.paragraph
  )

  (rand(3)).times do
    DossierNumber.create(refugee_id: r.id, name: Faker::Number.number(10))
  end

  (rand(3)).times do
    Ssn.create(refugee_id: r.id, name: Faker::Time.between(DateTime.now - 18.year, DateTime.now - 4.year).to_s.gsub('-', '')[0..7])
  end

  # Assign and deassing refugees to homes
  moved_out_at = DateTime.now
  rand(0..5).downto(1).each do |t|
    if r.placements.present?
      moved_in_at = r.placements.last.moved_out_at + 1.days
    else
      moved_in_at = (rand(100*t-50..100*t)).days.ago
    end
    moved_out_at = moved_in_at + (rand(2..100)).days

    r.placements.create(
      home_id: rand(Home.count) + 1,
      moved_in_at: moved_in_at,
      moved_out_at: moved_out_at,
      moved_out_reason_id: rand(MovedOutReason.count) + 1,
      comment: Faker::Lorem.paragraph
    )
  end

  # Make most refugees still assigned to a home
  if r.id % 4 > 0
    r.placements.create(
      home_id: rand(Home.count) + 1,
      moved_in_at: moved_out_at + 1.days
    )
  end
end
