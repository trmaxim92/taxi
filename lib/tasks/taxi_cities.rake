namespace :taxi do
  desc "Rewrite city SEO content for Yandex Taxi / TaksoPark Cosmo"
  task seed_cities: :environment do
    city_payloads = [
      { slug: "ufa", name: "Уфа", region: "Республика Башкортостан", prep: "в Уфе", genitive: "Уфы", dative: "Уфе", featured: true, sort_order: 10,
        note: "На странице публикуем проверенные особенности работы в Республике Башкортостан: применимые региональные требования, порядок оформления и особенности допуска автомобилей." },
      { slug: "moskva", name: "Москва", region: "Москва", prep: "в Москве", genitive: "Москвы", dative: "Москве", featured: true, sort_order: 20,
        note: "В Москве дополнительно сверяйте актуальные городские требования к перевозчикам и допуску автомобиля к тарифу." },
      { slug: "sankt-peterburg", name: "Санкт-Петербург", region: "Санкт-Петербург", prep: "в Санкт-Петербурге", genitive: "Санкт-Петербурга", dative: "Санкт-Петербургу", featured: true, sort_order: 30,
        note: "В Санкт-Петербурге спрос и доступность заказов зависят от района и времени суток — график выбираете сами." },
      { slug: "kazan", name: "Казань", region: "Республика Татарстан", prep: "в Казани", genitive: "Казани", dative: "Казани", featured: true, sort_order: 40,
        note: "В Казани перед подключением проверьте соответствие автомобиля тарифу и подготовьте комплект документов." },
      { slug: "ekaterinburg", name: "Екатеринбург", region: "Свердловская область", prep: "в Екатеринбурге", genitive: "Екатеринбурга", dative: "Екатеринбургу", featured: true, sort_order: 50,
        note: "В Екатеринбурге помогаем с заявкой, проверкой авто и стартом в Яндекс Про на собственном автомобиле." },
      { slug: "novosibirsk", name: "Новосибирск", region: "Новосибирская область", prep: "в Новосибирске", genitive: "Новосибирска", dative: "Новосибирску", featured: true, sort_order: 60,
        note: "В Новосибирске подключение водителей доступно при соответствии автомобиля и документов требованиям сервиса." },
      { slug: "nizhniy-novgorod", name: "Нижний Новгород", region: "Нижегородская область", prep: "в Нижнем Новгороде", genitive: "Нижнего Новгорода", dative: "Нижнему Новгороду", featured: true, sort_order: 70,
        note: "В Нижнем Новгороде сопровождаем подключение: заявка, документы и выход на линию через Яндекс Про." },
      { slug: "samara", name: "Самара", region: "Самарская область", prep: "в Самаре", genitive: "Самары", dative: "Самаре", featured: false, sort_order: 80,
        note: "В Самаре уточняйте доступность тарифа для вашей модели и год выпуска перед регистрацией." },
      { slug: "rostov-na-donu", name: "Ростов-на-Дону", region: "Ростовская область", prep: "в Ростове-на-Дону", genitive: "Ростова-на-Дону", dative: "Ростову-на-Дону", featured: false, sort_order: 90,
        note: "В Ростове-на-Дону можно оставить заявку на подключение и получить помощь по документам и автомобилю." },
      { slug: "krasnodar", name: "Краснодар", region: "Краснодарский край", prep: "в Краснодаре", genitive: "Краснодара", dative: "Краснодару", featured: true, sort_order: 100,
        note: "В Краснодаре условия зависят от тарифа, района и времени суток — детали уточняйте при подключении." },
      { slug: "voronezh", name: "Воронеж", region: "Воронежская область", prep: "в Воронеже", genitive: "Воронежа", dative: "Воронежу", featured: false, sort_order: 110,
        note: "В Воронеже публикуем страницу при доступном подключении водителей на собственном автомобиле." },
      { slug: "perm", name: "Пермь", region: "Пермский край", prep: "в Перми", genitive: "Перми", dative: "Перми", featured: false, sort_order: 120,
        note: "В Перми помогаем с заявкой и стартом: собственный автомобиль, документы и регистрация в Яндекс Про." },
      { slug: "chelyabinsk", name: "Челябинск", region: "Челябинская область", prep: "в Челябинске", genitive: "Челябинска", dative: "Челябинску", featured: false, sort_order: 130,
        note: "В Челябинске сверяйте допуск автомобиля к тарифу и подготовьте документы для оформления деятельности." },
      { slug: "kirov", name: "Киров", region: "Кировская область", prep: "в Кирове", genitive: "Кирова", dative: "Кирову", featured: false, sort_order: 140,
        note: "В Кирове страница публикуется только при подтверждённой возможности подключения водителей." },
      { slug: "saransk", name: "Саранск", region: "Республика Мордовия", prep: "в Саранске", genitive: "Саранска", dative: "Саранску", featured: false, sort_order: 150,
        note: "В Саранске можно оставить заявку в Таксопарк Космо и уточнить порядок подключения на своём авто." }
    ]

    city_payloads.each do |payload|
      city = City.find_or_initialize_by(slug: payload[:slug])
      prep = payload[:prep]
      unique_text = <<~TEXT.strip
        Хотите выполнять заказы Яндекс Такси #{prep}? Таксопарк Космо предлагает подключение водителей на собственных автомобилях.

        Перед регистрацией необходимо проверить соответствие автомобиля выбранному тарифу и подготовить документы для оформления деятельности.

        #{payload[:note]}
      TEXT

      city.assign_attributes(
        name: payload[:name],
        region: payload[:region],
        name_in_prepositional: prep,
        name_genitive: payload[:genitive],
        name_dative: payload[:dative],
        is_featured: payload[:featured],
        sort_order: payload[:sort_order],
        country: "RU",
        short_description: "Подключение водителей Яндекс Такси #{prep} через Таксопарк Космо. Работа на собственном автомобиле, условия сотрудничества и регистрация.",
        unique_text: unique_text,
        connection_available: true,
        published: true,
        is_indexable: true,
        delivery_methods: nil,
        connection_conditions: <<~TEXT.strip,
          Условия сотрудничества #{prep}:
          • комиссия парка — 2% с заказа;
          • банковская комиссия при выводе — 1%;
          • работа через Яндекс Про;
          • самостоятельный выбор времени выхода на линию.

          Как подключиться #{prep}:
          1. Оставьте заявку.
          2. Получите консультацию менеджера.
          3. Уточните требования к автомобилю.
          4. Подготовьте необходимые документы.
          5. Пройдите регистрацию и активацию профиля.
        TEXT
        work_features: payload[:note],
        seo_title: "Подключение к Яндекс Такси #{prep} — Таксопарк Космо",
        seo_description: "Подключение водителей Яндекс Такси #{prep} через Таксопарк Космо. Работа на собственном автомобиле, условия сотрудничества и регистрация.",
        h1: "Подключение к Яндекс Такси #{prep}",
        robots_meta: "index,follow",
        faq_items: [
          { "question" => "Можно ли подключиться #{prep} на своём автомобиле?", "answer" => "Да, если подключение доступно в городе, а автомобиль соответствует требованиям выбранного тарифа." },
          { "question" => "Какая комиссия парка #{prep}?", "answer" => "Комиссия Таксопарка Космо составляет 2% с выполненного заказа." },
          { "question" => "Сколько составляет банковская комиссия при выводе?", "answer" => "1% при выводе средств." },
          { "question" => "Как оставить заявку?", "answer" => "Заполните форму на странице. Менеджер свяжется с вами и расскажет о порядке подключения." }
        ],
        content_updated_at: Time.current
      )
      city.save!
      puts "City taxi: #{city.slug}"
    end

    puts "taxi:seed_cities complete (#{city_payloads.size})"
  end
end
