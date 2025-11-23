合约地址：0xfA936b4099FB789E389A8DB754230D429b188660
交易哈希：0xb7968144899335594c68a96960013ae9ac60ab91968f674eb339232f7d02ffff

对函数简单的说明：
该合约基于 OpenZeppelin 官方审计的 ERC20 标准合约和 Ownable 权限合约开发，是一款带核心拓展功能的合规 ERC20 代币，完全兼容标准 ERC20 接口（可直接接入钱包、交易所），核心设计目标是可控发行、防超发、支持自主销毁

代币基础信息：名称LimitedToken（简称 LTK），小数位遵循 ERC20 标准（18 位）；
核心限制：总供应量严格限定为 1 亿枚（100,000,000 * 10^18），部署后不可修改；
权限控制：仅合约部署者（Owner）可铸造代币，普通持有者可自主销毁代币；
安全保障：复用 OpenZeppelin 经过审计的核心逻辑，避免手写代币 / 权限代码的安全漏洞。

transfer(address to, uint256 amount)    向指定地址转账 LTK 代币      持有者
approve(address spender, uint256 amount)    授权第三方地址使用指定数量的 LTK    持有者
transferFrom(address from, address to, uint256 amount)  按授权额度从他人地址转账 LTK    被授权者