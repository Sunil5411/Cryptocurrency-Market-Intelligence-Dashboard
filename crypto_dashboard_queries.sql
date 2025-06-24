
-- 1. Get last updated timestamp
SELECT MAX(fetch_time) AS last_updated FROM crypto_market_data;

-- 2. Count total coins tracked
SELECT COUNT(*) AS total_cryptos FROM crypto_market_data
WHERE fetch_time = (SELECT MAX(fetch_time) FROM crypto_market_data);

-- 3. List all coins and their market rank
SELECT name, symbol, market_cap_rank FROM crypto_market_data
WHERE fetch_time = (SELECT MAX(fetch_time) FROM crypto_market_data)
ORDER BY market_cap_rank ASC;

-- 4. Count coins above $1B market cap
SELECT COUNT(*) FROM crypto_market_data
WHERE market_cap > 1000000000
AND fetch_time = (SELECT MAX(fetch_time) FROM crypto_market_data);

-- 5. Top 10 coins by current price
SELECT name, symbol, current_price FROM crypto_market_data
WHERE fetch_time = (SELECT MAX(fetch_time) FROM crypto_market_data)
ORDER BY current_price DESC
LIMIT 10;

-- 6. Bottom 10 coins by current price
SELECT name, symbol, current_price FROM crypto_market_data
WHERE fetch_time = (SELECT MAX(fetch_time) FROM crypto_market_data)
ORDER BY current_price ASC
LIMIT 10;

-- 7. Top 10 gainers (24H)
SELECT name, symbol, price_change_percentage_24h FROM crypto_market_data
WHERE price_change_percentage_24h IS NOT NULL
AND fetch_time = (SELECT MAX(fetch_time) FROM crypto_market_data)
ORDER BY price_change_percentage_24h DESC
LIMIT 10;

-- 8. Top 10 losers (24H)
SELECT name, symbol, price_change_percentage_24h FROM crypto_market_data
WHERE price_change_percentage_24h IS NOT NULL
AND fetch_time = (SELECT MAX(fetch_time) FROM crypto_market_data)
ORDER BY price_change_percentage_24h ASC
LIMIT 10;

-- 9. Top 10 coins by market cap
SELECT name, market_cap FROM crypto_market_data
WHERE fetch_time = (SELECT MAX(fetch_time) FROM crypto_market_data)
ORDER BY market_cap DESC
LIMIT 10;

-- 10. Average market cap of all coins
SELECT AVG(market_cap) AS avg_market_cap FROM crypto_market_data
WHERE fetch_time = (SELECT MAX(fetch_time) FROM crypto_market_data);

-- 11. Sum of total market cap
SELECT SUM(market_cap) AS total_market_cap FROM crypto_market_data
WHERE fetch_time = (SELECT MAX(fetch_time) FROM crypto_market_data);

-- 12. Top 10 coins by 24H volume
SELECT name, total_volume FROM crypto_market_data
WHERE fetch_time = (SELECT MAX(fetch_time) FROM crypto_market_data)
ORDER BY total_volume DESC
LIMIT 10;

-- 13. Lowest 10 coins by 24H volume
SELECT name, total_volume FROM crypto_market_data
WHERE fetch_time = (SELECT MAX(fetch_time) FROM crypto_market_data)
ORDER BY total_volume ASC
LIMIT 10;

-- 14. Total volume across all coins
SELECT SUM(total_volume) AS global_volume FROM crypto_market_data
WHERE fetch_time = (SELECT MAX(fetch_time) FROM crypto_market_data);

-- 15. Latest dominance of BTC & ETH
SELECT coin, market_dominance_percent FROM crypto_dominance_data
WHERE coin IN ('btc', 'eth')
ORDER BY updated_at DESC
LIMIT 2;

-- 16. Top 5 dominant coins
SELECT coin, market_dominance_percent FROM crypto_dominance_data
ORDER BY market_dominance_percent DESC
LIMIT 5;

-- 17. Daily coin count over time
SELECT DATE(fetch_time) AS date, COUNT(*) AS coin_count
FROM crypto_market_data
GROUP BY DATE(fetch_time)
ORDER BY date DESC;

-- 18. Daily average price change
SELECT DATE(fetch_time) AS date, AVG(price_change_percentage_24h) AS avg_change
FROM crypto_market_data
GROUP BY DATE(fetch_time)
ORDER BY date DESC;

-- 19. View latest gainers
SELECT * FROM crypto_top_gainers
ORDER BY fetch_time DESC
LIMIT 10;

-- 20. View latest losers
SELECT * FROM crypto_top_losers
ORDER BY fetch_time DESC
LIMIT 10;

-- 21. Count how many times a coin appeared in gainers
SELECT name, COUNT(*) AS times_in_top_gainers
FROM crypto_top_gainers
GROUP BY name
ORDER BY times_in_top_gainers DESC
LIMIT 10;

-- 22. Count how many times a coin appeared in losers
SELECT name, COUNT(*) AS times_in_top_losers
FROM crypto_top_losers
GROUP BY name
ORDER BY times_in_top_losers DESC
LIMIT 10;

-- 23. Check for NULL values
SELECT * FROM crypto_market_data
WHERE current_price IS NULL
   OR market_cap IS NULL
   OR total_volume IS NULL;

-- 24. List coins missing 24H change
SELECT name, symbol FROM crypto_market_data
WHERE price_change_percentage_24h IS NULL
AND fetch_time = (SELECT MAX(fetch_time) FROM crypto_market_data);

-- 25. Coins between $10–$100
SELECT name, current_price FROM crypto_market_data
WHERE current_price BETWEEN 10 AND 100
AND fetch_time = (SELECT MAX(fetch_time) FROM crypto_market_data);

-- 26. Coins with rank < 20 and low volume
SELECT name, total_volume FROM crypto_market_data
WHERE market_cap_rank < 20 AND total_volume < 10000000
AND fetch_time = (SELECT MAX(fetch_time) FROM crypto_market_data);

-- 27. Coins with negative price change but large volume
SELECT name, price_change_percentage_24h, total_volume FROM crypto_market_data
WHERE price_change_percentage_24h < 0 AND total_volume > 100000000
AND fetch_time = (SELECT MAX(fetch_time) FROM crypto_market_data);

-- 28. Create a view for top 10 coins
CREATE OR REPLACE VIEW top10_coins AS
SELECT name, symbol, market_cap, current_price
FROM crypto_market_data
WHERE fetch_time = (SELECT MAX(fetch_time) FROM crypto_market_data)
ORDER BY market_cap DESC
LIMIT 10;

-- 29. Compare BTC dominance with total market cap
SELECT d.market_dominance_percent, d.total_market_cap_usd, d.updated_at
FROM crypto_dominance_data d
WHERE d.coin = 'btc'
ORDER BY d.updated_at DESC
LIMIT 1;

-- 30. Market cap distribution by range
SELECT
  CASE
    WHEN market_cap > 10000000000 THEN 'Mega Cap'
    WHEN market_cap > 1000000000 THEN 'Large Cap'
    WHEN market_cap > 100000000 THEN 'Mid Cap'
    ELSE 'Small Cap'
  END AS cap_category,
  COUNT(*) AS coin_count
FROM crypto_market_data
WHERE fetch_time = (SELECT MAX(fetch_time) FROM crypto_market_data)
GROUP BY cap_category;
