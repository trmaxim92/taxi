# Отчёт: Этап 2 — контент и страницы

Дата: 2026-11-14

## Что реализовано

1. **SiteSetting:** `park_commission_percent=2`, `withdrawal_fee_percent=1`, `legal_name=ООО «СкайСкейл»`, `site_name=Kosmo Taxi`.
2. **Модель Tariff** + admin CRUD (`/admin/tariffs`).
3. **Главная по §5 ТЗ:** H1, подзаголовок с 2%/1%, преимущества, форма заявки, блок тарифов, 6 преимуществ, 5 шагов подключения, своё авто, география с поиском, FAQ 10 вопросов, финальный CTA.
4. **URL-карта:** `/o-kompanii/`, `/podklyuchenie/`, `/trebovaniya/`, `/dokumenty/`, `/faq/`, `/privacy/`, `/agreement/`.
5. **301:** `/kak-ustroitsya/` → `/podklyuchenie/`, `/trebovaniya-k-voditelyam/` → `/trebovaniya/`.
6. **Lead comment** + ссылка на privacy в форме.
7. **Дизайн-токены:** #be1623 / #172d38 / #f5f4f2.
8. **Удалён** income calculator (partial, JS, service, block type).
9. **Sitemap** обновлён под новые URL.

## Файлы

- Миграции: `db/migrate/20261114170001_create_tariffs.rb`, `db/migrate/20261114170002_add_comment_to_leads.rb`
- Модели/политики/admin: `app/models/tariff.rb`, `app/policies/tariff_policy.rb`, `app/controllers/admin/tariffs_controller.rb`, views
- Публичное: `home/index`, `faqs_controller`, layout, lead_form, pages/show, routes, sitemap, CSS, `taxi_content.rake`

## Миграции

1. `create_tariffs`
2. `add_comment_to_leads`

## Проверки (локально / после деплоя)

- [ ] `bin/rails db:migrate`
- [ ] `bin/rails taxi:seed_content`
- [ ] `/` — H1, 2%/1%, форма, FAQ
- [ ] `/tarify/`, `/podklyuchenie/`, `/o-kompanii/`, `/trebovaniya/`, `/dokumenty/`, `/faq/`, `/privacy/`, `/agreement/`
- [ ] 301 со старых URL
- [ ] Admin → Тарифы
- [ ] Отправка заявки с comment
- [ ] Нет калькулятора и аренды

## Осталось (следующие этапы)

- Этап 3: усиление city show + workflow статусы
- Этап 4: блог Article/Category/Tag
- Этап 5: доп. polish admin
- Этап 6–7: schema Breadcrumb, Metrika goals, тесты §24
