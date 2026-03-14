一.x*y=K(x,y分别是两个token的数量，k是流动性)，理论上该公式可以支撑token任何价格上的买卖。
价格：滑点（slippage）= （执行价格 - 预期价格）/ 预期价格 * 100%
Lp:添加流动性一定要市场价x和y的比例；
   移除流动性不可以影响价格；
二：Uniswap的学习：
1:闪电交换：uniswap v2消除了涉及 Uniswap 的多步骤交易的前期资本要求和不必要的操作顺序限制。也可以用来提高使用借贷协议和 Uniswap 进行杠杆操作的效率。
2：swap:
function swap(
    uint amount0Out,    // 期望获得的 token0 数量
    uint amount1Out,    // 期望获得的 token1 数量
    address to,         // 接收代币的地址
    bytes calldata data // 回调数据（flash swap用）
) external lock;
限制检查：
- 输入代币已到账（通过余额差计算）
- K值不减少（含手续费）
addLiquidity
输入参数：
├── tokenA, tokenB        // 代币地址（Factory已排序token0<token1）
├── amountADesired        // 期望存入A
├── amountBDesired        // 期望存入B
├── amountAMin            // A的最小接受量（滑点保护）
├── amountBMin            // B的最小接受量
├── to                    // LP接收地址
└── deadline              // 截止时间（防pending交易）

执行顺序：
1. 检查Pair是否存在（Factory创建）
2. 计算最优比例（若池子已有储备）
   - 若 reserve0/reserve1 > amountA/amountB，按比例减少amountA
3. 转账代币到Pair合约
4. 铸造LP代币
   - 首次：liquidity = sqrt(amountA * amountB) - MINIMUM_LIQUIDITY（防除零）
   - 后续：liquidity = min(amountA*totalSupply/reserve0, amountB*totalSupply/reserve1)
5. 更新储备量 reserve0, reserve1
6. 触发 Sync, Mint 事件

限制检查：
- amountA ≥ amountAMin && amountB ≥ amountBMin
- liquidity > 0
- block.timestamp ≤ deadline

removeLiquidity
输入参数：
├── tokenA, tokenB
├── liquidity             // 要销毁的LP数量
├── amountAMin            // 最小获得A
├── amountBMin            // 最小获得B
├── to                    // 代币接收地址
└── deadline

执行顺序：
1. 转账LP代币到Pair（需用户先approve）
2. 计算返还：
   - amountA = liquidity * reserve0 / totalSupply
   - amountB = liquidity * reserve1 / totalSupply
3. 销毁LP代币
4. 转账tokenA, tokenB给'to'
5. 更新储备量
6. 触发 Sync, Burn 事件

限制检查：
- amountA ≥ amountAMin && amountB ≥ amountBMin
- 用户LP余额 ≥ liquidity
- block.timestamp ≤ deadline

三；Factory/Pair/Router 之间的数据流、事件
发起者（用户 / 合约调用者）→ Router(路由层)Factory→ Pair*N→ 用户;

四：手续费计算（0.3% 如何累积、如何返还给 LP
累积：随着交易量累积，池子储备逐渐增长，而 LP 总份额保持不变。这意味着每个 LP 份额代表的储备价值逐渐增加。
LP收益来源：
1. 手续费使reserve增长，但totalSupply不变
2. 每个LP份额价值 = reserve / totalSupply 逐渐上升
3. 移除流动性时，按当前reserve比例取回（含累积手续费）
 五：你计划在 Week4 手写实现时的模块拆分思路（例如：先写 Factory+Pair，后写 Router 等）
按学长的方法吧，
六：未解答的问题或准备继续研究的点
1.大部分概念需要集合ai来理解；
2.函数的理解停留在表面并没有完全掌握，理解太困难了