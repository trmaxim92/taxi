# Аудит kosmo-taxi.ru под полное ТЗ Kosmo Taxi

Дата: 2026-11-14  
Сайт: https://kosmo-taxi.ru/  
Принцип ТЗ §25: сначала аудит и план, без переписывания стека.

---

## 1. Текущая архитектура

| Слой | Состояние |
|---|---|
| Стек | Rails 8.1, PostgreSQL, Hotwire, Propshaft, Devise+Pundit admin |
| Домен | kosmo-taxi.ru (Caddy HTTPS) |
| CMS | `Page` + admin |
| Города | `City` + `/goroda/` |
| Авто | `Vehicle` + admin + фильтры |
| Заявки | `Lead` + UTM + honeypot + Rack::Attack |
| Рефералка | `ReferralLink` + `self_register_url` |
| FAQ | `Faq` по `page_scope` |
| Блог | stub `/blog/` без Article |
| Тарифы | страница `/tarify/`, **нет модели Tariff** |

---

## 2. Что уже реализовано (DONE)

- Главная taxi + own-car, дисклеймеры, без аренды на UI.
- URL: `/`, `/tarify/`, `/rabota-na-svoem-avto/`, `/goroda/`, `/kontakty/`, `/avtomobili-dlya-taksi/`.
- Алиасы: `/kak-ustroitsya/` ≈ подключение, `/trebovaniya-k-voditelyam/` ≈ требования, `/usloviya-raboty/`, `/rabota-cherez-park/`, `/yandex-pro/`.
- 15 городов с taxi-контентом (после `taxi:seed_cities`).
- Формы: имя/телефон/город/согласие, статусы заявок, UTM.
- robots/sitemap (pages/cities/vehicles), schema Organization/WebSite/FAQPage.
- Юр. поля SiteSetting (ОГРН/ИНН/КПП), бренд «Космо» в UI.
- Калькулятор **не** на главной (мертвый код ещё в репо).

---

## 3. Пробелы vs новое ТЗ

### CRITICAL / HIGH

| Требование ТЗ | Статус | Что делать |
|---|---|---|
| Комиссия парка **2%**, вывод **1%** | MISSING | SiteSetting + блок на главной + `/tarify/` из админки |
| ООО «СкайСкейл» | MISSING | `legal_name` = ООО «СкайСкейл» |
| `/o-kompanii/`, `/podklyuchenie/`, `/trebovaniya/`, `/dokumenty/`, `/faq/`, `/privacy/`, `/agreement/` | MISSING | Новые Page + routes; 301 со старых алиасов где нужно |
| Модель **Tariff** в admin | MISSING | Миграция + CRUD; страница читает из БД |
| Блог (Article/Category/Tag) | MISSING | Миграции + admin + public show + sitemap |
| Lead **comment** | MISSING | Колонка + поле формы |
| Дизайн #be1623 / #172d38 / #f5f4f2 | MISSING | CSS tokens (сохранить layout, сменить палитру) |
| Удалить калькулятор дохода | PARTIAL | Убрать partial/JS/service/block type |
| Главная по макету ТЗ (H1, тарифы-карточки, 5 шагов, FAQ 8–12) | PARTIAL | Пересобрать секции home без ломки композиции |

### MEDIUM

| Требование | Статус | План |
|---|---|---|
| `/faq/` отдельная страница | MISSING | Route + index FAQ по категориям |
| Статусы городов draft/review/published | PARTIAL | Сейчас boolean publish; добавить enum workflow |
| 15 статей блога | MISSING | После модели — черновики, публикация вручную |
| Уведомление менеджера о заявке | MISSING | Email/Telegram webhook через SiteSetting |
| BreadcrumbList JSON-LD | PARTIAL | Подключить на city/page/article |
| Consent → ссылка на privacy | PARTIAL | Чекбокс без ссылки |

### KEEP / НЕ ЛОМАТЬ

- Lead, Referral, City, Vehicle, Page, SeoMeta, Caddy, Devise admin.
- Каталог авто (own-car, без аренды).
- Запрет аренды и финансовых калькуляторов — усилить.

---

## 4. Миграции (потребуются)

1. `create_tariffs` — name, value, value_type, description, position, active, SEO optional.
2. `create_articles` + `categories` + `tags` + `article_tags` (+ author fields).
3. `add_comment_to_leads` — `comment:text` (отдельно от `admin_comment`).
4. Опционально: `workflow_status` на cities/articles.
5. **Без миграции:** SiteSetting ключи `park_commission_percent=2`, `withdrawal_fee_percent=1`, `legal_name=ООО «СкайСкейл»`.

---

## 5. Файлы, которые будут затронуты (по этапам)

| Этап | Файлы |
|---|---|
| A. Тарифы 2%/1% + главная | `home/index.html.erb`, `application.css`, `taxi_content.rake`, `park_info_helper.rb`, `tarify` page, new Tariff model/admin |
| B. URL-карта ТЗ | `routes.rb`, Pages seeds, Redirects 301, sitemap STATIC_PATHS |
| C. Юр. страницы | privacy/agreement Pages + footer/form links |
| D. o-kompanii / dokumenty / faq / podklyuchenie | Pages + views/nav |
| E. Lead comment | migration, lead form, leads_controller, admin |
| F. Blog | models/migrations/admin/public/sitemap |
| G. Design tokens | `application.css` variables |
| H. Cleanup | remove income calculator assets |

---

## 6. Риски

1. **Смена URL** (`kak-ustroitsya` → `podklyuchenie`) — нужны 301, иначе потеря индекса.
2. **Смена палитры** — риск «сломать» текущий taxi-hero; менять токены поэтапно.
3. **Блог на 15 статей** — большой контентный объём; модель + 2–3 пилотные статьи, остальные черновики.
4. **Комиссии 2%/1%** — теперь подтверждены ТЗ; всё равно пояснять, что комиссии Яндекса/налоги отдельно.
5. **Диск 1 ГБ VPS** — крупные миграции/образы осторожно.
6. Не плодить пустые города/статьи без контента (ТЗ запрещает).

---

## 7. План реализации (последовательность ТЗ §23)

### Этап 1 — Аудит ✅ (этот документ)

### Этап 2 — Контент и страницы ✅ (см. docs/kosmo_stage2_report.md)
1. SiteSetting: 2%, 1%, ООО «СкайСкейл».
2. Модель `Tariff` + admin + главная/карточки + `/tarify/`.
3. Пересобрать главную по §5 ТЗ (без калькулятора, без аренды).
4. Pages: `/o-kompanii/`, `/podklyuchenie/` (+301 с kak-ustroitsya), `/trebovaniya/` (+301), `/dokumenty/`, `/faq/`, `/privacy/`, `/agreement/`.
5. Удалить income calculator.
6. Lead `comment` + ссылка на privacy в форме.

### Этап 3 — Регионы
7. Усилить шаблон city show под §12 (тарифы парка, перелинковка).
8. Опционально workflow_status; sitemap только indexable.

### Этап 4 — Блог
9. Article/Category/Tag + admin + public + 3–5 первых статей как published, остальные draft.

### Этап 5 — Админка
10. Tariff CRUD, blog CRUD, FAQ categories, leads comment/filters polish.

### Этап 6 — SEO/техника
11. Sitemap расширить, schema Breadcrumb/Article, design tokens, GSC/Metrika цели (настройки).

### Этап 7 — Тесты
12. Чек-лист §24 + отчёт.

---

## 8. Решение по алиасам (рекомендация)

| Новый URL ТЗ | Стратегия |
|---|---|
| `/podklyuchenie/` | Новый canonical Page; **301** с `/kak-ustroitsya/` |
| `/trebovaniya/` | Новый slug или 301 с `/trebovaniya-k-voditelyam/` |
| `/o-kompanii/` | Новая страница; `/rabota-cherez-park/` оставить или 301 |
| `/dokumenty/`, `/faq/`, `/privacy/`, `/agreement/` | Новые Page |
| `/usloviya-raboty/`, `/yandex-pro/`, `/avtomobili-dlya-taksi/` | Сохранить как доп. ценность |

---

## 9. Что не делаем

- Не новый проект / не смена стека.
- Не аренда авто / не калькуляторы заработка.
- Не массовая генерация пустых городов и статей.
- Не выдумывать год основания, число водителей, обороты.

---

## 10. Следующий шаг

После подтверждения плана — **Этап 2**: тарифы 2%/1%, ООО «СкайСкейл», главная по §5, URL-карта + юр. страницы, cleanup калькулятора.
