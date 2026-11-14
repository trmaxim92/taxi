# taxi

SEO-сайт таксопарка **Космо**: привлечение водителей **Яндекс Такси** на собственном автомобиле.

Стек: Ruby 3.4 · Rails 8 · PostgreSQL · Hotwire/Stimulus · Devise · Pundit · Propshaft.

Таксопарк Космо — сертифицированный партнёр Яндекс Такси. Работа на собственном автомобиле. Гарантированный доход не обещается.

## Быстрый запуск (Docker)

```bash
docker compose up --build
```

- сайт: http://localhost:3000/
- админка: http://localhost:3000/admin/

После старта:

```bash
docker compose exec web bundle exec rails db:migrate
docker compose exec web bundle exec rails taxi:seed_content
```

## Основные URL

- `/` — главная
- `/podklyuchenie/`, `/usloviya-raboty/`, `/rabota-na-svoem-avto/`, `/trebovaniya/`
- `/tarify/`, `/o-kompanii/`, `/dokumenty/`, `/faq/`
- `/goroda/`
- `/go/register` — реферальный redirect (или `self_register_url` в настройках)
- `/sitemap.xml`, `/robots.txt`

## Настройки парка (admin → Настройки)

- `contact_phone`, `contact_telegram`, `contact_max`, `contact_email`
- `self_register_url` — ссылка на форму саморегистрации
- `legal_ogrn`, `legal_inn`, `legal_kpp`, `legal_registered_on`, `legal_name`

## Production (Docker)

```bash
docker compose -f docker-compose.prod.yml up -d --build
```

Нужны переменные: `POSTGRES_PASSWORD`, `RAILS_MASTER_KEY`, `SECRET_KEY_BASE`, `APP_HOST`, `ADMIN_PASSWORD`.

## Репозиторий

https://github.com/trmaxim92/taxi
