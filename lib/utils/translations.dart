const Map<String, Map<String, String>> bodyTypeTranslations = {
  "Coupe": {
    "en": "Coupe",
    "tr": "Kupe",
    "ru": "Купе",
  },
  "Sedan": {
    "en": "Sedan",
    "tr": "Sedan",
    "ru": "Седан",
  },
  "Suv": {
    "en": "SUV",
    "tr": "Uly awtoulag",
    "ru": "Внедорожник",
  },
  "Hatchback": {
    "en": "Hatchback",
    "tr": "Hetçbek",
    "ru": "Хэтчбек",
  },
  "Crossover": {
    "en": "Crossover",
    "tr": "Krossover",
    "ru": "Кроссовер",
  },
  "Van": {
    "en": "Van",
    "tr": "Wen",
    "ru": "Фургон",
  },
};
final Map<String, Map<String, String>> transmissionTranslations = {
  "Manual": {
    "en": "Manual",
    "tr": "El bilen dolandyrylýan",
    "ru": "Механика",
  },
  "Auto": {
    "en": "Automatic",
    "tr": "Awtomatiki",
    "ru": "Автомат",
  },
  "Tiptronic": {
    "en": "Tiptronic",
    "tr": "Tiptronic",
    "ru": "Типтроник",
  },
};

const Map<String, Map<String, String>> provinceTranslations = {
  'Ashgabat': {'en': 'Ashgabat', 'tr': 'Aşgabat', 'ru': 'Ашхабад'},
  'Arkadag': {'en': 'Arkadag', 'tr': 'Arkadag', 'ru': 'Аркадаг'},
  'Ahal': {'en': 'Ahal', 'tr': 'Ahal', 'ru': 'Ахал'},
  'Dashoguz': {'en': 'Dashoguz', 'tr': 'Daşoguz', 'ru': 'Дашогуз'},
  'Mary': {'en': 'Mary', 'tr': 'Mary', 'ru': 'Мары'},
  'Lebap': {'en': 'Lebap', 'tr': 'Lebap', 'ru': 'Лебап'},
  'Balkan': {'en': 'Balkan', 'tr': 'Balkan', 'ru': 'Балкан'},
};

const Map<String, Map<String, String>> cityTranslations = {
  // Ashgabat
  'Parahat 1': {'en': 'Parahat 1', 'tr': 'Parahat 1', 'ru': 'Парахат 1'},
  'Parahat 2': {'en': 'Parahat 2', 'tr': 'Parahat 2', 'ru': 'Парахат 2'},
  'Parahat 3': {'en': 'Parahat 3', 'tr': 'Parahat 3', 'ru': 'Парахат 3'},
  'Parahat 4': {'en': 'Parahat 4', 'tr': 'Parahat 4', 'ru': 'Парахат 4'},
  'Mir 7': {'en': 'Mir 7', 'tr': 'Mir 7', 'ru': 'Мир 7'},
  'Mir 2': {'en': 'Mir 2', 'tr': 'Mir 2', 'ru': 'Мир 2'},
  'Choganly': {'en': 'Choganly', 'tr': 'Çoganly', 'ru': 'Чоганлы'},

  // Arkadag
  'Gurtly': {'en': 'Gurtly', 'tr': 'Gurtly', 'ru': 'Гуртлы'},
  'Dushak': {'en': 'Dushak', 'tr': 'Duşak', 'ru': 'Душак'},

  // Ahal
  'Anau': {'en': 'Anau', 'tr': 'Änew', 'ru': 'Аннау'},
  'Baharly': {'en': 'Baharly', 'tr': 'Bäherden', 'ru': 'Бахарлы'},
  'Tejen': {'en': 'Tejen', 'tr': 'Tejen', 'ru': 'Теджен'},
  'Kaka': {'en': 'Kaka', 'tr': 'Kaka', 'ru': 'Кака'},

  // Mary
  'Bayramali': {'en': 'Bayramali', 'tr': 'Baýramaly', 'ru': 'Байрамали'},
  'Tagtabazar': {'en': 'Tagtabazar', 'tr': 'Tagtabazar', 'ru': 'Тагтабазар'},
  'Yoloten': {'en': 'Yoloten', 'tr': 'Ýolöten', 'ru': 'Йолотень'},
  'Murgap': {'en': 'Murgap', 'tr': 'Murgap', 'ru': 'Мургап'},
  'Turkmenabat': {'en': 'Turkmenabat', 'tr': 'Türkmenabat', 'ru': 'Туркменабат'},
  'Mary City': {'en': 'Mary City', 'tr': 'Mary şäheri', 'ru': 'город Мары'},

  // Lebap
  'Atamyrat': {'en': 'Atamyrat', 'tr': 'Atamyrat', 'ru': 'Атамырат'},
  'Darganata': {'en': 'Darganata', 'tr': 'Darganata', 'ru': 'Дарганата'},
  'Gazojak': {'en': 'Gazojak', 'tr': 'Gazojak', 'ru': 'Газоджак'},
  'Hojambaz': {'en': 'Hojambaz', 'tr': 'Hojambaz', 'ru': 'Ходжамбаз'},
  'Sayat': {'en': 'Sayat', 'tr': 'Saýat', 'ru': 'Саят'},

  // Dashoguz
  'Andalyp': {'en': 'Andalyp', 'tr': 'Andalyp', 'ru': 'Андасып'},
  'Gubadag': {'en': 'Gubadag', 'tr': 'Gubadag', 'ru': 'Губадаг'},
  'Shabat': {'en': 'Shabat', 'tr': 'Şabat', 'ru': 'Шабат'},
  'Boldumsaz': {'en': 'Boldumsaz', 'tr': 'Boldumsaz', 'ru': 'Болдумсаз'},
  'Gurbansoltan eje adyndaky': {
    'en': 'Gurbansoltan eje adyndaky',
    'tr': 'Gurbansoltan eje adyndaky',
    'ru': 'имени Гурбансолтан-эдже',
  },

  // Balkan
  'Balkanabat': {'en': 'Balkanabat', 'tr': 'Balkanabat', 'ru': 'Балканабат'},
  'Turkmenbashi': {'en': 'Turkmenbashi', 'tr': 'Türkmenbaşy', 'ru': 'Туркменбаши'},
  'Bereket': {'en': 'Bereket', 'tr': 'Bereket', 'ru': 'Берекет'},
  'Etrek': {'en': 'Etrek', 'tr': 'Etrek', 'ru': 'Этрек'},
  'Magtymguly': {'en': 'Magtymguly', 'tr': 'Magtymguly', 'ru': 'Махтумкули'},
};
