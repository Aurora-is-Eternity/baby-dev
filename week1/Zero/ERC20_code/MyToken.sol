//在此放我的代码
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;  

// 导入OpenZeppelin的ERC20标准实现
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ZeroToken is ERC20 {
    // 构造函数：初始化代币名称和符号
    constructor() ERC20("ZeroToken", "ZERO") {
        // 部署时铸造10000个代币给部署者
        // 注意：ERC20默认小数位是18位，所以实际铸造的是10000 * 10^18个"最小单位"
        _mint(msg.sender, 10000 * 10 **decimals());
    }
}