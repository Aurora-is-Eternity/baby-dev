# Uniswap V2 学习笔记

## 一、核心概念
### 1. 恒定乘积自动做市商算法（x * y = k）
- 核心公式：`x * y = k`，其中 `x`、`y` 分别为交易池中两种代币的储备量，`k` 为流动性不变量。
- 原理：当用户进行交易时，储备量 `x` 和 `y` 会发生变化，但乘积 `k` 保持恒定（不考虑手续费时），以此实现自动定价。
- 示例：若池中 `x=1000`、`y=1000`，则 `k=1,000,000`；当用户买入 `Δx=100`，则 `y' = k/(x+Δx) = 1,000,000/1100 ≈ 909.09`，用户可获得 `Δy = 1000 - 909.09 = 90.91` 的代币。

### 2. 储备更新
- 触发场景：`addLiquidity`（添加流动性）、`removeLiquidity`（移除流动性）、`swap`（交易）。
- 更新逻辑：每次操作后，Pair 合约会更新 `reserve0` 和 `reserve1`，并同步到状态变量中。

### 3. LP 代币（流动性份额）
- 定义：代表流动性提供者（LP）在池中所占份额的代币，总供应量为 `totalSupply`。
- 铸造/销毁：
  - `addLiquidity`：根据注入的代币数量，按比例铸造 LP 代币并发送给 LP。
  - `removeLiquidity`：销毁 LP 代币，按份额向 LP 返还对应比例的两种代币。
- 价值：LP 代币价值随池中手续费累积而增长，手续费不直接分配，而是通过增加 `k` 间接提升份额价值。

### 4. Swap 逻辑
- 流程：用户输入一种代币 → 合约根据 `x*y=k` 计算输出量 → 收取 0.3% 手续费 → 将剩余代币发送给用户 → 更新储备量。
- 本质：通过储备量变化实现代币兑换，无需订单簿。

---

## 二、重要函数流程
### 1. `addLiquidity`（添加流动性）
- **参数**：`amountADesired`, `amountBDesired`, `amountAMin`, `amountBMin`, `to`, `deadline`
- **执行顺序**：
  1. Router 计算最优输入量，确保 `amountA/amountB ≈ reserve0/reserve1`（避免价格偏差过大）。
  2. 从用户地址转移 `amountA` 和 `amountB` 到 Pair 合约。
  3. Pair 合约铸造 LP 代币，发送给 `to` 地址。
  4. 更新 `reserve0`、`reserve1` 和 `totalSupply`。
- **限制**：
  - 需满足 `amountA ≥ amountAMin`、`amountB ≥ amountBMin`（防止滑点损失）。
  - 必须在 `deadline` 之前执行，否则交易失败。

### 2. `removeLiquidity`（移除流动性）
- **参数**：`liquidity`, `amountAMin`, `amountBMin`, `to`, `deadline`
- **执行顺序**：
  1. Router 销毁用户的 `liquidity` 数量 LP 代币。
  2. Pair 合约按 `liquidity/totalSupply` 比例，向 `to` 地址转移对应数量的两种代币。
  3. 更新 `reserve0`、`reserve1` 和 `totalSupply`。
- **限制**：
  - 需满足返还代币数量 ≥ `amountAMin`/`amountBMin`（防止滑点损失）。
  - 必须在 `deadline` 之前执行。

### 3. `swap`（交易）
- **参数**：`amount0Out`, `amount1Out`, `to`, `data`
- **执行顺序**：
  1. 验证 `amount0Out` 和 `amount1Out` 不同时为 0，且不超过当前储备量。
  2. 将对应数量的代币发送给 `to` 地址。
  3. 收取 0.3% 手续费（计入池内，增加 `k`）。
  4. 调用 `_update` 函数更新 `reserve0` 和 `reserve1`。
  5. 触发 `Swap` 事件，记录交易信息。
- **限制**：
  - 不能同时请求两种代币的输出。
  - 需确保交易后 `x*y ≥ k`（手续费累积导致 `k` 微增）。

---

## 三、Factory/Pair/Router 数据流与事件
### 1. 合约角色
- **Factory**：
  - 职责：创建新的交易对（Pair），管理所有 Pair 地址映射（`getPair(tokenA, tokenB) => pairAddress`）。
  - 核心函数：`createPair(tokenA, tokenB)` → 部署新 Pair 合约并记录地址。
- **Pair**：
  - 职责：管理代币储备、LP 代币、交易逻辑，是 AMM 的核心。
  - 核心状态：`reserve0`, `reserve1`, `totalSupply`。
- **Router**：
  - 职责：用户交互入口，封装复杂的流动性管理和交易逻辑，简化用户操作。
  - 核心函数：`addLiquidity`, `removeLiquidity`, `swapExactTokensForTokens` 等。

### 2. 数据流
-用户到Router到Pair到Factory

### 3. 关键事件
- `Mint(address sender, uint amount0, uint amount1)`：添加流动性时触发，记录 LP 地址和注入代币数量。
- `Burn(address sender, uint amount0, uint amount1)`：移除流动性时触发，记录 LP 地址和返还代币数量。
- `Swap(address sender, uint amount0In, uint amount1In, uint amount0Out, uint amount1Out, address to)`：交易时触发，记录交易方向、输入输出量和接收地址。
- `Sync(uint112 reserve0, uint112 reserve1)`：储备量更新时触发，用于价格 Oracle 计算。

---

## 四、手续费计算与分配
- **费率**：固定 0.3%，从每次交易的输入代币中收取。
- **累积方式**：手续费不直接分配给 LP，而是留在交易池中，使 `k = (x + 手续费) * y` 或 `x * (y + 手续费)` 微增，从而提升 LP 代币的内在价值。
- **返还逻辑**：LP 调用 `removeLiquidity` 时，按所持 LP 代币占 `totalSupply` 的比例，获得包含手续费增值的两种代币，间接实现手续费分配。

---

## 五、Week4 手写实现模块拆分思路
1. **阶段 1：Factory + Pair 核心合约**
   - 实现 Factory：`createPair` 函数，部署 Pair 并维护 `getPair` 映射。
   - 实现 Pair：
     - 状态变量：`reserve0`, `reserve1`, `totalSupply`, `token0`, `token1`。
     - 核心函数：`mint`（添加流动性）、`burn`（移除流动性）、`swap`（交易）、`_update`（更新储备）。
2. **阶段 2：Router 交互合约**
   - 实现 Router：
     - 封装 `addLiquidity`：计算最优输入量、处理代币转账、调用 Pair 的 `mint`。
     - 封装 `removeLiquidity`：处理 LP 代币销毁、调用 Pair 的 `burn`、返还代币。
     - 封装 `swap`：处理交易路径、滑点保护、调用 Pair 的 `swap`。
3. **阶段 3：安全与测试**
   - 实现 `SafeMath` 库防止整数溢出。
   - 编写测试用例验证 `addLiquidity`/`removeLiquidity`/`swap` 逻辑正确性。

---

## 六、未解决问题与待研究点
1. 价格 Oracle（TWAP）实现细节：如何利用 `Sync` 事件计算时间加权平均价格。
2. 闪兑攻击防范：如何限制 `swap` 中的价格操纵，防止套利攻击。
3. 代币精度处理：不同 ERC20 代币的 decimal 差异对储备量计算的影响。

---

## 七、AMM 版本设计手稿

### 1. 合约整体结构
```solidity
├─ Factory.sol   // 管理 Pair 创建与映射
├─ Pair.sol      // 核心交易池，管理储备、LP、交易逻辑
└─ Router.sol    // 用户交互接口，封装业务逻辑

### 2. 关键状态变量
- **Factory**：
  - `mapping(address => mapping(address => address)) public getPair`：代币对 → Pair 地址。
  - `address[] public allPairs`：所有 Pair 地址列表。
- **Pair**：
  - `uint112 private reserve0`：代币 0 储备量。
  - `uint112 private reserve1`：代币 1 储备量。
  - `uint public totalSupply`：LP 代币总供应量。
  - `address public token0`：代币 0 地址。
  - `address public token1`：代币 1 地址。

### 3. 函数输入/输出与安全检查
| 函数          | 输入参数                                  | 输出          | 安全检查                                  |
|---------------|-------------------------------------------|---------------|-------------------------------------------|
| `createPair`  | `address tokenA, address tokenB`          | `address pair`| 验证 `tokenA != tokenB`，Pair 不存在       |
| `mint`        | `address to`                              | `uint liquidity` | 验证输入代币数量 > 0，储备量更新合法       |
| `burn`        | `address to`                              | `uint amount0, uint amount1` | 验证 LP 余额 > 0，返还数量 ≥ 最小值         |
| `swap`        | `uint amount0Out, uint amount1Out, address to, bytes calldata data` | - | 验证输出量合法，交易后 `x*y ≥ k`           |

### 4. 自研数学函数
- `sqrt(uint y)`：实现整数平方根，用于计算流动性份额（`liquidity = sqrt(amountA * amountB)`）。
- `k = x * y`：核心定价公式，用于交易时的输出量计算。
- 滑点计算：`(expectedAmount - actualAmount) / expectedAmount`，用于限制用户可接受的价格偏差。

