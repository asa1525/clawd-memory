# MEMORY.md - Pan 的长期记忆

*从 Obsidian 同步日记中学习到的信息*

## DNLM (AI助手) 的经验教训

### 2026-01-31 - OpenClaw 模型切换故障

**事件：** 模型切换 M2-her 失败

**失败原因：**
- 动态重载机制不完整
- 日志显示配置变更被检测到 ✓
- 但 agents.defaults.model.primary 不在动态重载范围内
- 服务缓存了模型配置

**学到的教训：**
1. ✅ 模型切换需要完全重启，不只是 `gateway restart`
2. ✅ 总是验证配置，不要假设已生效
3. ✅ 智能路由是更可靠的替代方案（不需要切换模型）

---

## 2026-01-27 (与 Chapin 工作)
- 首次向 Emme 提案数据中台项目
- 研究深圳 office 需求（正在联系深业、时尚中心等）
- 研究 lease data
- 研究 CRM 与品牌数据整合（segment and tier）

## 2026-01-22 (与用友/迪尚开会)
- 了解云端上线时间线（2025年做主数据管理和财务）
- 主数据管理优先顺序讨论
- 战略和业务分析
- 指标属性规范
- SAP 接口开发需求待确认

## 2026-01-20
- **GP% Dashboard** 开发
- **AR Dashboard** 开发
- SAP 接口开发（等待 Andersen 空闲）
- 用友系统相关工作
- 内销应收账款与开票流程

## 2026-01-14 (与 Chapin)
- AR（应收账款）相关工作：
  - SAP 与 Andersen 系统整合
  - CRM 与 SAP 整合
  - 信用额度管理（internal + insured）
  - 销售团队沟通

## 人际关系（重要）
- **Chapin** - Pan 的**上级**，主要项目搭档（会议记录中出现 4 次）
- **Emme** - Chapin 的上级，**CSI Team Leader**，**High Fashion Group CMO**
- **Team** - 团队协作（会议记录中出现 2 次）
- **Andersen** - SAP vendor（外部供应商）
- **迪尚/用友** - 云端实施项目合作方
- **深业** - 深圳 office 需求来源
- **SAP** - 系统接口开发

## 工作领域
- 数据分析（Dashboard 开发：GP%、AR）
- 企业数字化转型（用友云端实施）
- 系统整合（SAP、CRM）
- 应收账款管理
- 主数据管理

## 待办追踪
- test (2026-01-27)
- 等待 Ken 提供历史数据 (2026-01-20)
- SAP vendor 确认开发需求和配额
- 销售团队信用额度反馈

## 股票关注列表 (2026-01-31)

### 投资组合 - 主要持仓 (需要每日监控)

| 股票 | 数量 | 现价 | 持仓价值 | 类型 |
|------|------|------|---------|------|
| **NVDA** | 0.63 | $190.20 | $119.83 | 芯片/AI |
| **META** | 0.06 | $714.60 | $42.88 | 社交媒体 |
| **PLTR** | 0.5 | $147.17 | $73.59 | 数据分析 |
| **VTI** | 0.3 | $339.77 | $101.93 | 全市场ETF |
| **UAL** | 0.5 | $101.90 | $50.95 | 航空 |
| **BILI** | 1 | $34.02 | $34.02 | 中国概念 |
| **CRCL** | 0.75 | $63.90 | $47.93 | 加密金融 |
| **PONY** | 2 | $13.83 | $27.66 | 自动驾驶 |
| **QUBT** | 2 | $9.29 | $18.58 | 量子计算 |
| **NTDOY** | 2 | $15.38 | $30.76 | 游戏/日本 |
| **JPM** | 0.5 | $305.45 | $152.73 | 银行 |
| **AVGO** | 0.2 | $331.10 | $66.20 | 芯片 |
| **ONON** | 3 | $45.30 | $135.90 | 运动品牌 |
| **VRSN** | 0.4 | $244.23 | $97.69 | 互联网域名 |
| **OXY** | 1 | $45.26 | $45.26 | 石油 |
| **AAPL** | 0.335 | $259.07 | $86.79 | 科技巨头 |
| **ULTA** | 0.15 | $646.47 | $96.97 | 零售美容 |
| **BRK.B** | 0.1 | $481.10 | $48.11 | 投资控股 |

**总计持仓价值：约 $1,200**

### 关注的其他股票

#### 科技巨头
AAPL, MSFT, GOOGL, AMZN, NVDA, AMD, META, CRM, ADBE, QCOM, PYPL, ZM, IBM

#### 中国概念股
BABA, JD, PDD, BIDU, NIO, TCOM, BILI, SONY

#### 半导体/芯片
TSM (台积电), MU (美光), AMAT, ANET, AVGO

#### ETF/指数
SPX (标普500), VTI (全市场ETF), IYK (消费ETF), SOXS (3倍做空半导体)

#### 加密货币相关
MSTR (MicroStrategy), COIN (Coinbase)

#### 航空/酒店
UAL (联合航空), H (凯悦酒店), MAR (万豪)

#### 工业/消费/金融
BA (波音), GE (通用电气), HD (家得宝), NKE (耐克), SBUX (星巴克), DIS (迪士尼), JPM, MCD (麦当劳), WMT (沃尔玛), BRK.B

#### 新兴/其他
APP, OKLO, NUAI, IONQ (量子计算), CRWD (网络安全)

## 2026-02-02 - 从 Obsidian 同步
=== 最新笔记 ===
更新时间: Mon Feb  2 02:14:48 AM UTC 2026

---
## n_13
# 一直在想rush deck

## **Notes：**
1. Deck已經改的差不多了
2. AR等待IT提供匯率，接著就可以計算DLS WIP了
3. 
---
## n_4
# with Chapin

# with Ken
1. 3C 利润
2.  杭州 - 成衣（KN+GB）
	1. KN - 针织
	2. GB - 梭织 - 1对1
	3. AT - 印染
3. 南区
	1. 凤岗 - 梭织
	2. 亿豪
	 
---
## n_1

# With Chapin
1. GP% Dashboard
2. [ ] ==need Ken provide historical data ==

# with Team
1. 聯係SAP vendor開發接口，Andersen最近唔得閑
2. AR Dashboard
3. Deck
4. 用友
5. 等Chapin forward數據


# with SUn Wei Li
1. 先開制單號
2. 再開發票
	1. 還沒開的就是賬款
![[内销应收账款与开票流程解析.png]]
---
## n_8
# with Team
1. Deck已經改的差不多了, 麻煩需要看看上次提到的地方
2. AR等待IT提供匯率，接著就可以計算DLS WIP了
---
## n_37
# 数据安全 Round 1
1. cookies 拒绝后还是继续采集，也没有告知用户，违反了欧盟的GDPR
2. Dior未通过数据安全评估；未取得用户同意；未对个人信息加密、去标识化

# with Owen
1. 輸入完兩個日期后，以shipment date為起始日，due date為結束
2. 無關兩個日期，posting date就是發票的錄入日期

# With Finance - YH
1. 3C 报表
	1. Tinway - 成本
	2. 销售收入 - SAP/Tinway
	3. 第5个工作日交上个月
2. YH没有WIP半成品库存成本
3. 办费收入 HK提供
4. 班費支出、直接銷售費用 SAP
5. C2提供资产减值损失
6. YH 8033, DLS 8030
7. 
