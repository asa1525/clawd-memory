# 2026-02-02 - 股票分析工具对比：qveris vs daily_stock_analysis

## 概述

| 项目 | qveris | daily_stock_analysis |
|------|--------|---------------------|
| 类型 | AI 工具聚合平台 | 股票智能分析系统 |
| 定位 | 通用的 API 工具发现与执行 | 专注股票的垂直分析系统 |
| 复杂度 | 轻量，单一技能 | 完整系统，多模块 |

## 核心功能对比

### qveris
- **工具发现**：通过自然语言搜索 API 工具
- **工具执行**：动态执行已发现的工具
- **覆盖面广**：天气、股票、搜索、货币等数千种 API
- **接入简单**：只需 API Key，开箱即用

### daily_stock_analysis
- **决策仪表盘**：一句话结论 + 买卖点位 + 检查清单
- **多维度分析**：技术面 + 筹码分布 + 舆情 + 实时行情
- **全球市场**：A 股、港股、美股
- **多渠道推送**：企微、飞书、Telegram、邮件
- **定时执行**：GitHub Actions 零成本自动化

## 技术架构对比

### qveris
```
Claude Code → QVeris API → 动态工具执行
```
- 依赖外部 API
- 无本地部署
- 按需付费

### daily_stock_analysis
```
本地/Docker → 多数据源 → AI 分析 → 多渠道推送
```
- Python + GitHub Actions
- 多数据源集成（AkShare、Tushare、YFinance）
- 内置交易纪律规则
- 完全免费（GitHub Actions + 免费 AI 模型）

## 数据来源

| 类型 | qveris | daily_stock_analysis |
|------|--------|---------------------|
| 行情数据 | 通过 API 动态发现 | AkShare、Tushare、Pytdx、Baostock、YFinance |
| 新闻搜索 | 通过 API 动态发现 | Tavily、SerpAPI、Bocha |
| AI 模型 | 通过 API 动态发现 | Gemini（免费）、OpenAI、DeepSeek、Claude |
| 用户配置 | 无需配置 | 需要配置自选股、API Keys |

## 部署方式

### qveris
```bash
export QVERIS_API_KEY="your-key"
# 无需部署，直接使用
```

### daily_stock_analysis
```bash
# 方式一：GitHub Actions（推荐）
1. Fork 仓库
2. 配置 Secrets
3. 启用 Actions

# 方式二：本地/Docker
git clone && pip install && python main.py
```

## 优劣势分析

### qveris 优势
- ✅ 接入极简
- ✅ 无需本地部署
- ✅ 覆盖面广
- ✅ Claude Code 原生集成

### qveris劣势
- ❌ 依赖第三方 API
- ❌ 股票分析不够深入
- ❌ 每次调用付费

### daily_stock_analysis 优势
- ✅ 免费（GitHub Actions + 免费 AI）
- ✅ 股票分析深入
- ✅ 内置交易纪律
- ✅ 多渠道推送
- ✅ 定时自动化

### daily_stock_analysis 劣势
- ❌ 配置复杂
- ❌ 专注单一领域
- ❌ 需要一定技术基础

## 对 Pan 的价值

| 需求 | 推荐工具 |
|------|----------|
| 快速查询股票价格 | qveris |
| 深度股票分析 + 推送 | daily_stock_analysis |
| 每日自动复盘 | daily_stock_analysis |
| 组合交易决策 | daily_stock_analysis |

## 建议

1. **日常快速查询**：使用 qveris（集成在 Claude Code 中）
2. **每日复盘推送**：部署 daily_stock_analysis 到 GitHub Actions
3. **结合使用**：qveris 查询 + daily_stock_analysis 分析

## 相关链接
- qveris: https://qveris.ai
- daily_stock_analysis: https://github.com/ZhuLinsen/daily_stock_analysis
