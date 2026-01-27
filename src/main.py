import os
import asyncio
import mysql.connector
from aiogram import Bot, Dispatcher, types
from aiogram.filters import Command
from dotenv import load_dotenv

load_dotenv()

TOKEN = os.getenv("BOT_TOKEN")
DB_HOST = os.getenv("DB_HOST", "db")
DB_NAME = os.getenv("DB_NAME", "furniture_salon")
DB_USER = os.getenv("DB_USER", "user")
DB_PASS = os.getenv("DB_PASSWORD", "password")

bot = Bot(token=TOKEN)
dp = Dispatcher()

def get_db_connection():
    return mysql.connector.connect(
        host=DB_HOST,
        user=DB_USER,
        password=DB_PASS,
        database=DB_NAME,
        charset='utf8mb4',
        use_unicode=True
    )

async def connect_to_db():
    max_retries = 30
    retry_count = 0
    while retry_count < max_retries:
        try:
            conn = get_db_connection()
            print("Успішне підключення до БД")
            conn.close()
            return True
        except Exception as e:
            retry_count += 1
            print(f"Очікування бази даних... ({retry_count}/{max_retries}) {e}")
            await asyncio.sleep(2)
    raise Exception("Не вдалося підключитися до бази даних")

@dp.message(Command("list"))
async def cmd_list(message: types.Message):
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT furniture_id, name, type, price, stock_quantity FROM furniture")
        rows = cursor.fetchall()
        
        if not rows:
            await message.answer("📭 У салоні зараз немає меблів.")
        else:
            text = "<b>🛋 Каталог меблів:</b>\n\n"
            for row in rows:
                text += (f"ID: {row['furniture_id']} | <b>{row['name']}</b> ({row['type']})\n"
                         f"💰 Ціна: {row['price']} грн | Склад: {row['stock_quantity']} шт.\n"
                         f"-------------------\n")
            await message.answer(text, parse_mode="HTML")
        
        cursor.close()
        conn.close()
    except Exception as e:
        await message.answer(f"❌ Помилка: {e}")

@dp.message(Command("create"))
async def cmd_create(message: types.Message):
    args = message.text.split(maxsplit=3)
    if len(args) < 4:
        return await message.answer("⚠️ Формат: /create [Назва] [Тип] [Ціна]\nПриклад: /create Полиця Декор 500")

    name, f_type, price = args[1], args[2], args[3]

    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        sql = "INSERT INTO furniture (name, type, material, price, stock_quantity) VALUES (%s, %s, %s, %s, %s)"
        cursor.execute(sql, (name, f_type, "Не вказано", price, 1))
        conn.commit()
        await message.answer(f"✅ Меблі <b>{name}</b> додані до бази!", parse_mode="HTML")
        cursor.close()
        conn.close()
    except Exception as e:
        await message.answer(f"❌ Помилка додавання: {e}")

@dp.message(Command("update"))
async def cmd_update(message: types.Message):
    args = message.text.split()
    if len(args) < 3:
        return await message.answer("⚠️ Формат: /update [ID] [Нова_Ціна]\nПриклад: /update 3 5500")

    f_id, new_price = args[1], args[2]

    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("UPDATE furniture SET price = %s WHERE furniture_id = %s", (new_price, f_id))
        conn.commit()
        
        if cursor.rowcount > 0:
            await message.answer(f"🔄 Ціна для ID {f_id} успішно змінена на {new_price} грн.")
        else:
            await message.answer("❓ Меблі з таким ID не знайдені.")
        
        cursor.close()
        conn.close()
    except Exception as e:
        await message.answer(f"❌ Помилка оновлення: {e}")

@dp.message(Command("delete"))
async def cmd_delete(message: types.Message):
    args = message.text.split()
    if len(args) < 2:
        return await message.answer("⚠️ Формат: /delete [ID]\nПриклад: /delete 5")

    f_id = args[1]

    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("DELETE FROM furniture WHERE furniture_id = %s", (f_id,))
        conn.commit()
        
        if cursor.rowcount > 0:
            await message.answer(f"🗑 Запис з ID {f_id} видалений з каталогу.")
        else:
            await message.answer("❓ Меблі з таким ID не знайдені.")
        
        cursor.close()
        conn.close()
    except Exception as e:
        await message.answer(f"❌ Помилка видалення: {e}")

@dp.message()
async def echo_handler(message: types.Message):
    await message.answer(
        "👋 Ласкаво просимо в меблевий салон!\n\n"
        "<b>Команди:</b>\n"
        "/list - весь каталог\n"
        "/create [назва] [тип] [ціна]\n"
        "/update [id] [ціна]\n"
        "/delete [id]",
        parse_mode="HTML"
    )

async def main():
    print("Запуск бота...")
    await connect_to_db()
    await dp.start_polling(bot)

if __name__ == "__main__":
    asyncio.run(main())