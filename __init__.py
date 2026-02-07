"""
OpenClaw Workspace — Official Module Registry
==============================================

这是项目已验证、已建立的模块注册表。
任何新脚本必须从这里 import，不允许重新实现。

使用方式：
    from workspace.registry import send_notification
    from workspace.registry import load_config

Instructions:
    1. New scripts that need these capabilities MUST import from here
    2. Do NOT reimplement functions that already exist
    3. If you need new functionality, EXTEND existing modules first
    4. See below for available modules and their purposes

---

## 📦 可用模块列表

### src.notification — 多渠道通知
from .daily_stock_analysis.src.notification import (
    NotificationChannel,           # 通知渠道枚举
    send_notification,             # 发送多渠道通知
    send_daily_report,             # 发送每日分析报告
    get_telegram_bot,              # 获取Telegram Bot实例
    feishu_webhook_notification,   # 飞书Webhook通知
)

### src.config — 配置管理
from .daily_stock_analysis.src.config import (
    get_config,                    # 获取配置（加载.env + 环境变量）
    load_akshare_config,          # 加载akshare配置
    load_fugle_config,             # 加载Fugle配置
    load_tushare_config,          # 加载TuShare配置
    load_pytdx_config,            # 加载PyTDX配置
)

### src.storage — 数据存储
from .daily_stock_analysis.src.storage import (
    save_to_file,                  # 保存到文件
    save_market_data,              # 保存市场数据
    save_analysis_report,          # 保存分析报告
    save_daily_market_summary,     # 保存每日市场总结
    ensure_directory,              # 确保目录存在
    get_storage_path,              # 获取存储路径
)

### src.formatters — 格式化工具
from .daily_stock_analysis.src.formatters import (
    format_stock_list,             # 格式化股票列表
    format_analysis_summary,       # 格式化分析总结
    format_feishu_markdown,        # 格式化飞书Markdown
    format_market_data,            # 格式化市场数据
    format_number_with_commas,     # 格式化数字（千分位）
)

### src.feishu_doc — 飞书文档
from .daily_stock_analysis.src.feishu_doc import (
    FeishuDocManager,              # 飞书文档管理类
    create_analysis_doc,            # 创建分析文档
    update_appwalk_document,        # 更新文档
    get_feishu_doc_info,           # 获取文档信息
)

### src.stock_analyzer — 股票分析
from .daily_stock_analysis.src.stock_analyzer import (
    analyze_stock,                 # 分析单只股票
    get_stock_recommendation,      # 获取股票推荐
)

### src.market_analyzer — 市场分析
from .daily_stock_analysis.src.market_analyzer import (
    get_market_overview,           # 获取市场概览
    get_sector_performance,        # 获取板块表现
)

### src.scheduler — 任务调度
from .daily_stock_analysis.src.scheduler import (
    Scheduler,                      # 调度器类
    start_scheduler,               # 启动调度器
    stop_scheduler,                # 停止调度器
)

### src.analyzer — 分析引擎
from .daily_stock_analysis.src.analyzer import (
    AnalysisResult,                # 分析结果类
    run_analysis,                  # 运行分析
)

### src.search_service — 搜索服务
from .daily_stock_analysis.src.search_service import (
    search_stock_symbols,          # 搜索股票代码
)

### web.handlers — Web处理器
from .daily_stock_analysis.web.handlers import (
    handle_health_check,           # 健康检查
    handle_generate_report,        # 生成报告
)

### web.services — Web服务
from .daily_stock_analysis.web.services import (
    get_market_summary,           # 获取市场总结
    format_market_for_web,        # 格式化市场数据（Web）
)

---

## ⚠️ 规则

1. 上表列出的函数是唯一被批准的实现
2. 新脚本需要这些功能时，必须 import，不允许重新实现
3. 如果需要新功能，先扩展现有模块
4. 不要创建已有验证函数的并行版本
5. 所有密钥必须从环境变量读取，禁止硬编码

## 🔧 如何使用

```python
# ✅ 正确：直接从注册表 import
from workspace.registry import send_notification, get_config

def my_function():
    config = get_config()
    send_notification(config, "告警内容")

# ❌ 错误：自己重新实现（会被 post-create-validate.sh 检测到）
def my_function():
    TELEGRAM_TOKEN = "hardcoded_token"  # 硬编码密钥！
    # ... 自己写通知逻辑
```
"""
