# Бот мебельного салону

Telegram бот для управління каталогом мебелі з інтеграцією MySQL бази даних.

## Опис

Цей проект - Telegram бот, який дозволяє управляти каталогом мебелі через чат:
- Переглядати список мебелі
- Додавати нову мебель
- Оновлювати ціни
- Видаляти товари з каталогу

## Вимоги

- Docker і Docker Compose
- Git

## Встановлення

1. **Клонуйте репозиторій:**
```bash
git clone https://github.com/Seishin333/furniture-salon-bot.git
cd furniture-salon-bot
```

2. **Створіть файл `.env`** з вашими параметрами:
```
BOT_TOKEN=ваш_токен_бота
DB_HOST=db
DB_NAME=furniture_salon
DB_USER=user
DB_PASSWORD=password
DB_ROOT_PASSWORD=root_password
```

**Де отримати `BOT_TOKEN`:**
- Напишіть [@BotFather](https://t.me/botfather) у Telegram
- Виконайте команду `/newbot`
- Скопіюйте отриманий токен в `.env`

3. **Запустіть Docker контейнери:**
```bash
docker-compose up -d
```

Бот автоматично чекатиме, поки база даних буде готова, а потім запуститься.

## Команди бота

| Команда | Опис | Приклад |
|---------|------|---------|
| `/list` | Показати весь каталог мебелі | `/list` |
| `/create` | Додати нову мебель | `/create Полка Декор 500` |
| `/update` | Змінити ціну | `/update 3 5500` |
| `/delete` | Видалити мебель | `/delete 5` |

### Формати команд:

**Перегляд каталогу:**
```
/list
```

**Додавання мебелі:**
```
/create [Назва] [Тип] [Ціна]
Приклад: /create "Крісло офісне" "Крісло" "3500"
```

**Оновлення ціни:**
```
/update [ID] [Нова_ціна]
Приклад: /update 1 4200
```

**Видалення:**
```
/delete [ID]
Приклад: /delete 2
```

## Структура бази даних

Таблиця `furniture` містить:
- `furniture_id` - унікальний ID товару
- `name` - назва мебелі
- `type` - тип мебелі
- `material` - матеріал
- `price` - ціна в гривнях
- `stock_quantity` - кількість на складі

## Docker контейнери

### Сервіси:
- **db** (MySQL 8.0) - база даних на порту 3307
- **bot** - Telegram бот

### Команди для управління:

**Запуск:**
```bash
docker-compose up -d
```

**Зупинка:**
```bash
docker-compose down
```

**Перегляд логів:**
```bash
docker-compose logs -f bot
```

**Перезавантаження:**
```bash
docker-compose restart
```

## Структура проекту

```
.
├── src/
│   └── main.py           # Основний код бота
├── docker-compose.yml    # Конфіг Docker Compose
├── Dockerfile           # Конфіг образу для бота
├── requirements.txt     # Python залежності
├── tables.sql          # SQL схема бази даних
└── README.md           # Цей файл
```

## Залежності Python

```
aiogram              # Фреймворк для Telegram ботів
mysql-connector-python  # MySQL драйвер
python-dotenv        # Управління змінними середовища
```

## Запуск локально (без Docker)

1. **Встановіть Python залежності:**
```bash
pip install -r requirements.txt
```

2. **Переконайтесь, що MySQL запущена**

3. **Запустіть бота:**
```bash
python src/main.py
```

## Ліцензія

MIT License

## Автор

Seishin3
