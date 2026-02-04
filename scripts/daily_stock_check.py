#!/usr/bin/env python3
"""每日美股持仓检查"""

import yfinance as yf
import json
from datetime import datetime

# 持仓
holdings = {
    'NVDA': 0.63, 'META': 0.06, 'PLTR': 0.5, 'VTI': 0.3,
    'UAL': 0.5, 'BILI': 1, 'CRCL': 0.75, 'PONY': 2,
    'QUBT': 2, 'NTDOY': 2, 'JPM': 0.5, 'AVGO': 0.2,
    'ONON': 3, 'VRSN': 0.4, 'OXY': 1, 'AAPL': 0.335,
    'ULTA': 0.15, 'BRK.B': 0.1,
}

results = []
total_value = 0

for ticker, shares in holdings.items():
    try:
        stock = yf.Ticker(ticker)
        hist = stock.history(period="5d")
        
        if len(hist) >= 2:
            latest = hist.iloc[-1]['Close']
            prev = hist.iloc[-2]['Close']
            change = ((latest - prev) / prev) * 100
            value = latest * shares
            total_value += value
            
            results.append({
                'ticker': ticker,
                'price': round(latest, 2),
                'change': round(change, 2),
                'value': round(value, 2),
                'emoji': "📈" if change > 0 else "📉" if change < 0 else "➡️"
            })
    except Exception as e:
        results.append({
            'ticker': ticker,
            'error': str(e)[:30]
        })

# 输出结果
date = datetime.now().strftime('%Y-%m-%d')
print(f"\n📊 {date} 美股持仓\n")
print(f"{'股票':<8} {'價格':<10} {'漲跌幅':<10} {'持倉價值':<12}")
print("-" * 50)

for r in results:
    if 'error' in r:
        print(f"{r['ticker']:<8} 錯誤: {r['error']}")
    else:
        print(f"{r['ticker']:<8} ${r['price']:<9.2f} {r['change']:>+8.2f}% {r['emoji']} ${r['value']:<10.2f}")

print("-" * 50)
print(f"\n💰 總持倉: ${total_value:,.2f}")
