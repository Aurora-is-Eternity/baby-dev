# MilesToken ERC20 合约作业

## 项目信息
- **合约名称（name）：** Miles Token  
- **代币符号（symbol）：** MILES  
- **部署网络：** Sepolia 测试网  
- **初始发行量（totalSupply）：** 1,000,000（精度 18 位，总量 = 1,000,000 × 10¹⁸ = 1,000,000,000,000,000,000,000,000 MILES）  
- **合约地址（Contract Address）：** [`0xc7dd50b1ab44dce84cb59564cd21ae081f22c26a`](https://sepolia.etherscan.io/address/0xc7dd50b1ab44dce84cb59564cd21ae081f22c26a)  
- **交易哈希（Transaction Hash）：** [`0x8be559c9f5f66decd3af88b29b1470097d0c8be6df00b958c31bacb8f1eab84b`](https://sepolia.etherscan.io/tx/0x8be559c9f5f66decd3af88b29b1470097d0c8be6df00b958c31bacb8f1eab84b)  
- **部署工具：** Remix + MetaMask 

---

## 代码说明

`import "@openzeppelin/contracts/token/ERC20/ERC20.sol";`

- 引入 OpenZeppelin 提供的标准 ERC20 实现，确保安全与合规。

`constructor(uint256 initialSupply)`

- 构造函数,初始代币数量

`_mint(msg.sender, initialSupply * 10 ** decimals());`

- 向`msg.sender`铸造初始代币数量
- 代币精度为 18，实际总量为输入数值 × 10¹⁸。

---

## 源码

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MilesToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("Miles Token", "MILES") {
        
        _mint(msg.sender, initialSupply * 10 ** decimals());
    }
}

```



