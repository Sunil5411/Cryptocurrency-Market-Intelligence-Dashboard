# 🚀 Cryptocurrency Market Intelligence Dashboard

<p align="center">
  <img src="https://img.shields.io/badge/Built%20With-Power%20BI-blue?style=for-the-badge&logo=powerbi" alt="Power BI"/>
  <img src="https://img.shields.io/badge/Data%20Source-CoinGecko%20API-green?style=for-the-badge" alt="CoinGecko API"/>
  <img src="https://img.shields.io/badge/Tech%20Stack-Python%20|%20Pandas%20|%20Power%20BI-yellow?style=for-the-badge" alt="Tech Stack"/>
</p>

---

## 🎯 Project Overview

The **Cryptocurrency Market Intelligence Dashboard** delivers **real-time insights** into the fast-paced, volatile crypto market — empowering investors, traders, and analysts to track coin performance, market trends, and volatility with interactive visualizations.

---

## 🛠️ Business Problem

Cryptocurrency markets operate 24/7 globally with high volatility and rapid price changes. Investors need reliable, data-driven tools to:

- Track prices and market caps  
- Analyze trading volumes and liquidity  
- Monitor price volatility  
- Identify market dominance of key coins  
- Spot top gainers and losers  

This dashboard addresses these challenges by providing a comprehensive, live view of crypto market dynamics.

---

## 🔍 Key Features

- Real-time prices and market cap for top 20 cryptocurrencies  
- 24-hour trading volume for liquidity insights  
- Volatility index (% price change over last 24 hours)  
- Market dominance percentages by coin  
- Leaderboard for top gainers and losers in the last 24 hours  
- Interactive filters by coin, time range, and market cap  

---

## 🚀 Getting Started

Follow these steps to run the project locally:

1. Clone this repository  
   ```bash
   git clone https://github.com/Sunil5411/crypto-market-intelligence-dashboard.git

2. Navigate to the scripts directory

  cd crypto-market-intelligence-dashboard/scripts

3. Install required Python packages
 
   pip install -r requirements.txt

4. Run the data fetching script to pull the latest data from CoinGecko API

   python fetch_data.py

5. Open dashboard.pbix in Power BI Desktop

6. Refresh the data in Power BI to load the newest dataset

7. Explore the dashboard and use slicers/filters for insights

📁 Repository Structure
crypto-market-intelligence-dashboard/
│
├── data/               # Raw and processed CSV files  
├── scripts/            # Python scripts for API data fetching and processing  
├── assets/             # Screenshots and dashboard visuals  
├── dashboard.pbix      # Power BI dashboard file  
├── requirements.txt    # Python dependencies  
├── README.md           # Project documentation  

🌐 API Source
. CoinGecko API Documentation — used for all live cryptocurrency market data

📊 Top 5 KPIs
Real-Time Price & Market Cap – Latest prices and market capitalization of top cryptocurrencies

24H Trading Volume – Market liquidity and trading activity indicator

Price Volatility Index – Percentage price change in the last 24 hours to measure volatility

Market Dominance % – Share of total crypto market capitalization by each coin

Top Gainers & Losers (24H) – Best and worst performing cryptocurrencies over the last 24 hours

📸 Dashboard Preview

🚧 Challenges & Learnings
Handling frequent API rate limits and ensuring efficient data refresh

Designing an intuitive dashboard for diverse crypto market metrics

Managing real-time data integration with Power BI

Learning to highlight meaningful KPIs that traders care about

🚀 Future Enhancements
Integrate social media sentiment analysis (Twitter, Reddit) to correlate news with price movements

Implement automated alerts for extreme price fluctuations

Add portfolio tracking and personalized insights

Explore machine learning models for price prediction

👨‍💻 About Me
I'm a passionate Data Analyst specialized in building API-driven real-time dashboards using Power BI and Python.

Connect with me on LinkedIn(https://www.linkedin.com/in/sunilreddy-data-analyst/)

Explore more projects on GitHub(https://github.com/Sunil5411)


---
⭐ If you find this project useful, please give it a star!
### Additional Tips:

- Make sure you add the `requirements.txt` file with necessary Python packages (e.g., requests, pandas).  
- Add real screenshots in `/assets/` folder and link them exactly.  
- Include the Python data fetching script (`fetch_data.py`) with comments for clarity.

---

If you want, I can help you write that Python script or prepare the `requirements.txt` next!
