import requests
import pandas as pd
import mysql.connector
from datetime import datetime
MYSQL_CONFIG = {
    'host': 'localhost',
    'user': 'root',
    'password': '5411',
    'database': 'crypto_dashboard'
}

def fetch_market_data():
    url = "https://api.coingecko.com/api/v3/coins/markets"
    params = {
        'vs_currency': 'usd',
        'order': 'market_cap_desc',
        'per_page': 100,
        'page': 1,
        'price_change_percentage': '24h'
    }
    response = requests.get(url, params=params)
    response.raise_for_status()
    data = response.json()

    df = pd.DataFrame(data)[[
        'id', 'symbol', 'name', 'current_price', 'market_cap',
        'total_volume', 'price_change_percentage_24h', 'market_cap_rank'
    ]]
    df['fetch_time'] = datetime.now()
    return df

def fetch_global_data():
    url = "https://api.coingecko.com/api/v3/global"
    response = requests.get(url)
    response.raise_for_status()
    data = response.json()

    dominance = data['data']['market_cap_percentage']
    total_market_cap = data['data']['total_market_cap']['usd']
    total_volume = data['data']['total_volume']['usd']
    updated_at = datetime.fromtimestamp(data['data']['updated_at'])

    dom_df = pd.DataFrame(dominance.items(), columns=['coin', 'market_dominance_percent'])
    dom_df['updated_at'] = updated_at
    dom_df['total_market_cap_usd'] = total_market_cap
    dom_df['total_volume_usd'] = total_volume
    return dom_df


def extract_top_movers(df, top_n=10):
    sorted_df = df[['id', 'name', 'symbol', 'price_change_percentage_24h']].copy()
    sorted_df = sorted_df.dropna(subset=['price_change_percentage_24h'])

    top_gainers = sorted_df.sort_values(by='price_change_percentage_24h', ascending=False).head(top_n).reset_index(drop=True)
    top_losers = sorted_df.sort_values(by='price_change_percentage_24h').head(top_n).reset_index(drop=True)
    top_gainers['fetch_time'] = datetime.now()
    top_losers['fetch_time'] = datetime.now()
    return top_gainers, top_losers


def save_dataframe_to_mysql(df, table_name, schema_sql):
    conn = mysql.connector.connect(**MYSQL_CONFIG)
    cursor = conn.cursor()

    cursor.execute(schema_sql)

    # Prepare insert
    placeholders = ','.join(['%s'] * len(df.columns))
    columns = ','.join(df.columns)
    insert_sql = f"INSERT INTO {table_name} ({columns}) VALUES ({placeholders})"

    for _, row in df.iterrows():
        cursor.execute(insert_sql, tuple(row))

    conn.commit()
    cursor.close()
    conn.close()
    print(f"✅ Inserted into `{table_name}`")


if __name__ == "__main__":
    print("📡 Fetching data from Coingecko...")

    # Fetch all datasets
    df_market = fetch_market_data()
    df_dominance = fetch_global_data()
    df_gainers, df_losers = extract_top_movers(df_market)

    # MySQL schemas
    schema_market = """
        CREATE TABLE IF NOT EXISTS crypto_market_data (
            id VARCHAR(50), symbol VARCHAR(10), name VARCHAR(100),
            current_price FLOAT, market_cap BIGINT, total_volume BIGINT,
            price_change_percentage_24h FLOAT, market_cap_rank INT,
            fetch_time DATETIME
        )
    """

    schema_dominance = """
        CREATE TABLE IF NOT EXISTS crypto_dominance_data (
            coin VARCHAR(50), market_dominance_percent FLOAT,
            updated_at DATETIME, total_market_cap_usd FLOAT,
            total_volume_usd FLOAT
        )
    """

    schema_gainers = """
        CREATE TABLE IF NOT EXISTS crypto_top_gainers (
            id VARCHAR(50), name VARCHAR(100), symbol VARCHAR(10),
            price_change_percentage_24h FLOAT, fetch_time DATETIME
        )
    """

    schema_losers = """
        CREATE TABLE IF NOT EXISTS crypto_top_losers (
            id VARCHAR(50), name VARCHAR(100), symbol VARCHAR(10),
            price_change_percentage_24h FLOAT, fetch_time DATETIME
        )
    """

    # Save to MySQL
    save_dataframe_to_mysql(df_market, 'crypto_market_data', schema_market)
    save_dataframe_to_mysql(df_dominance, 'crypto_dominance_data', schema_dominance)
    save_dataframe_to_mysql(df_gainers, 'crypto_top_gainers', schema_gainers)
    save_dataframe_to_mysql(df_losers, 'crypto_top_losers', schema_losers)

    print("🎉 All data fetched and stored in MySQL successfully.")
