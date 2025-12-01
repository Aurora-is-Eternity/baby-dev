# baby-dev Week1-Week2 学习概况

## Week1：基础 ERC20 部署成效
- 至少 5 位同学在 `week1/` 中提交了部署记录，全部成功在 Sepolia 上线以自己英文名命名的代币，如 Liana（LNT，`0xc013...66774`）、Elowen（E，`0xD861...3c6a`）、Miles（MILES，`0xc7dd...c26a`）、Thea（`0x4821...e011`）、Fleurian（LHBF，`0x1b79...aa31`）。
- 大家普遍使用 Remix + MetaMask 的流程，并将部署哈希写入 README，说明基础的 Fork、Clone、提交 PR 流程已打通（week1/Liana/README.md 等）。
- Miles、Liana 等人在笔记中解释了 `_mint`、`decimals()`、`Ownable` 等核心概念，展现出对 ERC20 标准接口的理解和在代码中调用 OZ 库的习惯。
- 个别同学（如 Liana）还详细记录了钱包切换、测试币获取、安全存储助记词等细节，帮助后来者复现环境。

## Week2：扩展功能与投票系统
- 多数提交在 `week2/`，并在升级版 ERC20 中纳入了 `mint`、`burn`、`maxSupply` 等扩展能力。例如 Miles 的 UpgradedToken（`0x1482...4927`）通过 `ERC20Capped` + `ERC20Burnable` 定义上限与自燃逻辑（week2/Miles/UpgradedToken/README.md），Hansen-feifei、1ffr1 也分别记录了 maxSupply、burn、owner 权限等实现细节。
- 至少 6 份记录给出了投票系统的合约地址与说明：Miles、Elowen、Asher、1ffr1、Hansen-feifei 以及公用的 `week2/VotingSystem` 目录都完成了“持有 ERC20 才能投票、每个地址仅一次”的核心逻辑，有的还加入时间控制、候选人管理、事件追踪等功能。
- Aurora-is-Eternity、Helsingin 等同学重点梳理了 OpenZeppelin 标准库、`Ownable` 权限、`require` 校验以及 `_update` 重写等知识点，说明大家在阅读官方库与理解多重继承冲突方面有实战体验（week2/Miles/学习笔记.md、week2/Helsingin/ERC20-week2.md）。
- Slaughter、Asher 等人坦诚记录了语法、生疏度、部署流程“麻烦”等痛点，普遍通过 AI/视频及时解答问题，体现团队仍处在“带练 + 复现”阶段。

## 共性问题与建议
- **语法与库的熟练度**：多位同学反馈 mapping、`msg.sender`、`external` 语义及 OZ 多继承 override 容易混淆，可安排一次集中 code review 或 live coding，强化这些概念。
- **部署与调试成本**：部署流程依旧依赖 Remix + 手动抄写参数，建议开始尝试 Foundry/Hardhat 的脚本化部署与测试；Miles 已尝试 Foundry，可分享经验。
- **投票系统迭代**：大多数合约已满足“单次投票 + 事件记录”，但缺少时间窗、候选人动态管理、防双花等边界条件，后续周次可要求增加更完善的状态控制与单元测试，避免只凭人工验证。

> Week3 建议在延续投票系统的基础上，引入自动化测试、权限攻防演练或跨合约交互任务，让大家把前两周打下的“部署 + 标准库”能力迁移到更复杂的 DApp 组件中。
