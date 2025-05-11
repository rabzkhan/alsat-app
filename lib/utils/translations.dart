const Map<String, Map<String, String>> estateTypeTranslations = {
  "Apartment": {
    "en": "Apartment",
    "tr": "Kwartira",
    "ru": "Квартира",
  },
  "Elite": {
    "en": "Elite",
    "tr": "Elitka",
    "ru": "Элитная",
  },
  "Half-Elite": {
    "en": "Half-Elite",
    "tr": "Ýarym elitka",
    "ru": "Полуэлитная",
  },
  "Cottage": {
    "en": "Cottage",
    "tr": "Plan jaý/ Kottej",
    "ru": "Коттедж",
  },
  "Villa": {
    "en": "Villa",
    "tr": "Daça",
    "ru": "Вилла",
  },
};

const Map<String, Map<String, String>> estateDealTypeTranslations = {
  "Cosmetic": {
    "en": "Cosmetic",
    "tr": "Kosmetiçeski",
    "ru": "Косметический",
  },
  "Government": {
    "en": "Government",
    "tr": "Döwlet remont",
    "ru": "Государственный",
  },
  "Euro": {
    "en": "Euro",
    "tr": "Ýewro remont",
    "ru": "Евроремонт",
  },
  "Designer": {
    "en": "Designer",
    "tr": "Dizaýnerski",
    "ru": "Дизайнерский",
  },
  "Regular": {
    "en": "Regular",
    "tr": "Ýönekeý remont",
    "ru": "Обычный",
  },
};
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
    "tr": "Wnedorožnik",
    "ru": "Внедорожник",
  },
  "Hatchback": {
    "en": "Hatchback",
    "tr": "Heçbek",
    "ru": "Хэтчбек",
  },
  "Crossover": {
    "en": "Crossover",
    "tr": "Krossower",
    "ru": "Кроссовер",
  },
  "Van": {
    "en": "Van",
    "tr": "Furgon",
    "ru": "Фургон",
  },
  "Pickup": {
    "en": "Pickup",
    "tr": "Pikap",
    "ru": "подобрать",
  },
};
final Map<String, Map<String, String>> transmissionTranslations = {
  "Manual": {
    "en": "Manual",
    "tr": "Mehaniki",
    "ru": "Механика",
  },
  "Auto": {
    "en": "Automatic",
    "tr": "Awtomatiki",
    "ru": "Автомат",
  },
  "Tiptronic": {
    "en": "Tiptronic",
    "tr": "Tiptronik",
    "ru": "Типтроник",
  },
};
final Map<String, Map<String, String>> colorTranslations = {
  "White": {"tr": "Ak", "ru": "Белый"},
  "Silver": {"tr": "Kümüş", "ru": "Серебристый"},
  "Gold": {"tr": "Altynsöw", "ru": "Золотой"},
  "Black": {"tr": "Gara", "ru": "Чёрный"},
  "Vinous": {"tr": "Goýy gyzyl", "ru": "Бордовый"},
  "Beige": {"tr": "Bež", "ru": "Бежевый"},
  "Bronze": {"tr": "Bürünç", "ru": "Бронзовый"},
  "Blue": {"tr": "Gök", "ru": "Синий"},
  "Light Blue": {"tr": "Açyk gök", "ru": "Голубой"},
  "Dark Blue": {"tr": "Goýy gök", "ru": "Тёмно-синий"},
  "Yellow": {"tr": "Sary", "ru": "Жёлтый"},
  "Green": {"tr": "Ýaşyl", "ru": "Зелёный"},
  "Brown": {"tr": "Goňur", "ru": "Коричневый"},
  "Red": {"tr": "Gyzyl", "ru": "Красный"},
  "Metallic": {"tr": "Metallik", "ru": "Металлик"},
  "Wet Asphalt": {"tr": "Mokry asfalt", "ru": "Мокрый асфальт"},
  "Orange": {"tr": "Mämişi", "ru": "Оранжевый"},
  "Cherry": {"tr": "Ülje", "ru": "Вишнёвый"},
  "Grey": {"tr": "Çal", "ru": "Серый"},
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
