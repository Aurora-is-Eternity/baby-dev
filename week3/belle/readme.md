# Uniswap V2 学习笔记 - Week3

## 一、学习资料列表
1. Uniswap V2 官方文档：https://docs.uniswap.org/contracts/v2
2. Uniswap V2 白皮书：https://uniswap.org/whitepaper.pdf
3. B 站视频讲解：https://www.bilibili.com/video/BV1hWdbYLEkv/

## 二、阅读方式
1. **理论入门**：先阅读 Uniswap V2 白皮书 + Vitalik 文章，理解 `x*y=k` 核心原理与 AMM 设计思想。
2. **视频补充**：观看 B 站讲解视频，可视化理解交易与流动性操作。

## 三、本周产出
- `Uniswap_learning.md`：包含核心概念、函数流程、合约数据流、手续费模型、Week4 实现思路与 AMM 设计草稿。

## 四、Week4 实现计划（简要）
1. **核心合约开发**：
   - 完成 `Factory.sol`：实现 `createPair` 函数，管理 Pair 映射。
   - 完成 `Pair.sol`：实现 `mint`/`burn`/`swap` 核心逻辑，处理储备更新与 LP 代币。
2. **交互接口开发**：
   - 完成 `Router.sol`：封装 `addLiquidity`/`removeLiquidity`/`swap` 函数，实现用户友好的交互接口。
3. **测试与验证**：
   - 编写单元测试，验证流动性添加/移除、交易逻辑的正确性。
   - 测试手续费累积与 LP 代币价值增长。
