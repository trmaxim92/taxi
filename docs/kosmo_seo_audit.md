# SEO-аудит kosmo-taxi.ru (таксопарк Космо)

Дата: 2026-11-14  
Объект: https://kosmo-taxi.ru/  
Принцип: не переписывать с нуля; сохранить дизайн, стек и работающие функции.

## Вердикт

Сайт технически поднят (HTTPS, коммерческие URL 200, CMS-страницы и форма есть), но **к полноценной SEO/конверсионной готовности не готов**:

| Зона | Статус |
|---|---|
| Главная (taxi UI) | Частично — есть блоки, есть неподтверждённые формулировки |
| Каталог авто | Пустой (0 опубликованных), фильтры только по тексту |
| Города | 15 indexable, но SEO-тексты всё ещё про **Яндекс Еду / курьеров** |
| Коммерческие страницы | Есть 4 основных; нет `/tarify/`, `/yandex-pro/` |
| Юр. достоверность | Ориентиры 21+/3 года с мягкой атрибуцией; юр. реквизиты есть |
| Формы | Работают (honeypot, rate-limit, UTM); контакты/self_register пустые |
| ТехSEO | Canonical/sitemap в целом ок; **robots.txt указывает на park-dostavka.ru** |

---

## Live-проверка (факт)

HTTP 200: `/`, `/kak-ustroitsya/`, `/usloviya-raboty/`, `/rabota-na-svoem-avto/`, `/trebovaniya-k-voditelyam/`, `/avtomobili-dlya-taksi/`, `/goroda/`, `/kontakty/`, sitemap*.xml.

Production DB (на момент аудита):

- `City.indexable` = **15**
- `Vehicle.published` / `indexable` = **0**
- Примеры title городов: «Работа курьером в Яндекс Еде в …»
- FAQ `page_scope=home` = 8 (подмешиваются на коммерческие страницы)

`robots.txt` (отдаётся из `public/robots.txt`, перекрывает Rails-контроллер):

```text
Sitemap: https://park-dostavka.ru/sitemap.xml
```

---

## 1. Главная страница

### Проблемы
| # | Проблема | Причина | Исправление | Файлы |
|---|---|---|---|---|
| 1.1 | Фраза «Тысячи водителей уже работают с нами» | Маркетинговый хардкод без источника | Убрать или заменить на проверяемую формулировку | `app/views/home/index.html.erb` |
| 1.2 | Мало SEO-плотности под «работа в Яндекс Такси» | Короткие блоки, мало перелинковки | Расширить текстовые секции + ссылки на коммерческие URL | `home/index.html.erb`, при необходимости `Page` home body |
| 1.3 | Нет блока с условиями сотрудничества **Космо** (комиссии/выплаты — только общие слова) | Условия оставлены под admin, на главной не выведены | Добавить блок «Условия с парком Космо» с редактируемыми фактами из `SiteSetting`/`Page` | `home/index.html.erb`, `SiteSetting`, `usloviya-raboty` |
| 1.4 | Блок «свой авто» есть, но можно усилить без выдумок | — | Раскрыть требования/проверку авто + ссылка в каталог | `home/index.html.erb` |
| 1.5 | В шапке бренд «Яндекс Такси», а парк «Космо» только в тексте | Наследие taxi-shell | Показать Космо как парк (не ломая визуальный язык) + сохранить дисклеймер | `layouts/application.html.erb` |
| 1.6 | Нет ссылок на `/rabota-cherez-park/`, тарифы, Яндекс Про | Маршрутов tarify/yandex-pro нет | Добавить перелинковку на существующие + новые страницы | `home/index.html.erb`, `routes.rb` |

---

## 2. Каталог автомобилей

### Проблемы
| # | Проблема | Причина | Исправление | Файлы |
|---|---|---|---|---|
| 2.1 | Каталог пуст (0 published/indexable) | Seed только черновики без source/verified_on | Оставить empty-state; публиковать только после проверки | `lib/tasks/taxi_content.rake`, admin Vehicles |
| 2.2 | Нет фильтров марка/год/тариф | Только `q` search | Добавить query-фильтры + scopes | `vehicles_controller.rb`, `vehicle.rb`, `vehicles/index.html.erb` |
| 2.3 | SEO-страницы моделей есть, но пустые | Нет данных | Не выдумывать; после проверки заполнять в admin | admin `vehicles` |
| 2.4 | `robots_meta` модели не применяется на show | `set_seo_meta` без robots из записи | Передавать robots с модели | `vehicles_controller.rb` |
| 2.5 | FAQ грузятся, но в show не рендерятся (при этом могут попасть в schema) | Layout всегда получает `@faqs` | Не подмешивать home FAQ на карточки авто | `vehicles_controller.rb`, `layouts/application.html.erb` |

**Уже хорошо:** admin CRUD, поля source/verified_on, indexable-гейт, empty-state без фейковых карточек.

---

## 3. Городские страницы

### Проблемы
| # | Проблема | Причина | Исправление | Файлы |
|---|---|---|---|---|
| 3.1 | Все проверенные города с **курьерским** SEO | `taxi:seed_content` не обновляет City | Rake/миграция контента городов под такси Космо | `db/seeds.rb`, новый `taxi:seed_cities` |
| 3.2 | Уникальность = длина ≥200, не смысл | Модель `City#indexable?` | Сохранить гейт; переписать тексты регионально | `app/models/city.rb`, city content |
| 3.3 | FAQ городов из `faq_items` — курьерские | Старые seeds | Taxi FAQ на город + шаблон с плейсхолдерами города | `cities/show.html.erb`, admin |
| 3.4 | Одинаковые шаги «Как начать» на всех городах | Хардкод в view | Оставить каркас, усилить уникальный блок условий | `cities/show.html.erb` |
| 3.5 | Слабая перелинковка на тарифы/каталог | Нет tarify; каталог пуст | Ссылки на `/avtomobili-dlya-taksi/`, `/usloviya-raboty/`, `/rabota-na-svoem-avto/` | `cities/show.html.erb` |
| 3.6 | Admin UI «способы доставки / типы курьеров» | Legacy | Переименовать/спрятать legacy-поля в admin | `admin/cities/_form.html.erb` |

**Не создавать** массовые дубли city×type для такси без уникального контента (сейчас city×type уже 301 на город).

---

## 4. SEO-контент коммерческих страниц

### Есть и отвечают 200
- `/kak-ustroitsya/`
- `/usloviya-raboty/`
- `/rabota-na-svoem-avto/`
- `/trebovaniya-k-voditelyam/`
- `/rabota-cherez-park/` (тонкий)
- `/avtomobili-dlya-taksi/`

### Проблемы
| # | Проблема | Причина | Исправление | Файлы |
|---|---|---|---|---|
| 4.1 | Нет страниц **Тарифы** и **Яндекс Про** | Не заведены маршруты/Page | Добавить Page + routes + sitemap | `routes.rb`, `taxi_content.rake`, `sitemaps_controller.rb` |
| 4.2 | Условия парка Космо без конкретных коммерческих фактов | Placeholder «из admin» | Заполнить редактируемые блоки SiteSetting (комиссия парка, выплаты) без выдумок | `usloviya-raboty`, settings |
| 4.3 | FAQ home подмешиваются на все CMS-страницы | `PagesController` OR home | FAQ только своего `page_scope`; home — только на главной | `pages_controller.rb`, seed FAQ |
| 4.4 | `/rabota-cherez-park/` слишком короткий | Seed | Расширить под Космо | `taxi_content.rake` / admin Page |

---

## 5. Юридическая достоверность

| # | Проблема | Причина | Исправление | Файлы |
|---|---|---|---|---|
| 5.1 | 21 год / стаж 3 года без URL и даты проверки | Мягкая атрибуция «по данным сервиса» | Добавить ссылку на источник + дату актуализации; оговорка «может отличаться» | home, trebovaniya, kak-ustroitsya |
| 5.2 | Разрешение/самозанятость/ИП описаны корректно по тону | — | Сохранить; не усиливать категоричность | commercial pages |
| 5.3 | Own-car / no rental / no guaranteed income — ок | — | Сохранить | layout, home |
| 5.4 | Реквизиты ОГРН/ИНН/КПП есть; контакты пустые | Настройки не заполнены | Заполнить phone/telegram/max/self_register в admin | SiteSetting |
| 5.5 | Default referral в `db/seeds.rb` → eda.yandex.ru | Legacy seed | Заменить на taxi/self_register; не отдавать Еду | `db/seeds.rb`, admin ReferralLink |

---

## 6. Формы и конверсия

| # | Проблема | Причина | Исправление | Файлы |
|---|---|---|---|---|
| 6.1 | `city_id` required в HTML, не в модели | Пропуск валидации | `validates :city_id, presence: true` | `lead.rb` |
| 6.2 | Self-register часто скрыт | Пустой `self_register_url` / нет активной referral | Заполнить в admin | SiteSetting / ReferralLink |
| 6.3 | Honeypot + session 45s + Rack::Attack — ок | — | Сохранить | lead form, leads_controller, rack_attack |
| 6.4 | UTM / landing_page / status — ок | — | Сохранить | UtmTrackable, Lead |
| 6.5 | Мобильная форма (1 колонка ≤640) — ок | — | Точечно проверить iOS zoom при необходимости | `application.css` |

---

## 7. Техническое SEO

| # | Проблема | Причина | Исправление | Файлы |
|---|---|---|---|---|
| 7.1 | **P0** `public/robots.txt` → Sitemap park-dostavka.ru | Статический файл перекрывает контроллер | Удалить/заменить static; оставить динамический `RobotsController` | `public/robots.txt`, `robots_controller.rb` |
| 7.2 | Нет 301 www↔apex / trailing slash | Только canonical в meta | Редиректы в Caddy | `deploy/Caddyfile` |
| 7.3 | BreadcrumbList в schema не передаётся | Layout не передаёт breadcrumbs | Передавать с city/vehicle | layout, city/vehicle views |
| 7.4 | `allow_browser :modern` → 406 старым UA/ботам | Rails 8 default | Ослабить для ботов / исключить | `application_controller.rb` |
| 7.5 | Vehicles sitemap пуст | Нет indexable авто | Ожидаемо до публикации | sitemaps |
| 7.6 | Title/Description/H1/canonical на ключевых URL — в целом работают | — | Дочистить после контента | SeoMeta |

Legacy courier URL → 301 уже настроены в `routes.rb` (сохранить).

---

## Приоритеты внедрения

### P0 (сразу)
1. Исправить `robots.txt` (kosmo-taxi.ru).
2. Переписать SEO-контент 15 городов с курьеров на такси Космо (или временно noindex).
3. Убрать «тысячи водителей».
4. FAQ: не подмешивать home на чужие страницы.
5. Заполнить контакты + self_register / referral (данные от заказчика).

### P1
6. Расширить главную: условия Космо, свой авто, перелинковка.
7. Страницы `/tarify/`, `/yandex-pro/`.
8. Фильтры каталога авто + корректный empty-state SEO.
9. Источник/дата у возраста и стажа.
10. Host/slash redirects в Caddy; ослабить allow_browser.

### P2
11. Наполнить каталог только проверенными моделями (без выдумок).
12. Углубить commercial pages; индивидуальные city FAQ.
13. Бренд-марк Космо в хедере (без ломки дизайна).
14. Breadcrumb JSON-LD.

---

## Файлы/компоненты к изменению (сводка)

- Views: `home/index`, `cities/show`, `vehicles/index|show`, `layouts/application`, `pages/show`
- Controllers: `pages`, `vehicles`, `cities`, `application` (allow_browser), `robots`
- Models: `Lead`, `Vehicle` (scopes фильтров), city content via rake
- SEO: `sitemaps_controller`, `public/robots.txt`, `deploy/Caddyfile`, `_schema`
- Data: `lib/tasks/taxi_content.rake`, новый `taxi:seed_cities`, admin SiteSetting/Referral/Vehicles
- Forms: `lead.rb` validation (минимально)

---

## Что не делаем

- Не меняем стек и не переписываем дизайн.
- Не удаляем Lead / Referral / SEO / admin.
- Не публикуем выдуманные автомобили и неподтверждённые комиссии/доход.
- Не плодим дубли city×type без уникального контента.

---

## Следующий шаг

После согласования аудита — реализация по P0→P1→P2 и повторный отчёт (чек-лист URL, robots, города, каталог, формы).

---

## Результаты после реализации (2026-11-14)

### Сделано
| Пункт | Результат |
|---|---|
| robots.txt | Статика удалена; динамический контроллер → `https://kosmo-taxi.ru/sitemap.xml` |
| Города | `taxi:seed_cities` — 15 городов переписаны под Яндекс Такси / Космо |
| «Тысячи водителей» | Убрано |
| FAQ | Только свой `page_scope` (без home bleed) |
| Главная | Блок условий Космо, перелинковка, источник возраста/стажа |
| `/tarify/`, `/yandex-pro/` | Добавлены Page + routes + sitemap |
| Каталог | Фильтры марка/год/тариф + честный empty-state |
| Lead | `city_id` presence |
| allow_browser 406 | Отключён |
| www | Caddy 301 www → apex |
| Бренд | Космо в шапке/футере |

### Остаётся за заказчиком
- Заполнить `contact_phone` / `contact_telegram` / `contact_max` / `self_register_url`
- Опубликовать автомобили только с источником и датой проверки
- Внести подтверждённые комиссии/выплаты парка в admin
