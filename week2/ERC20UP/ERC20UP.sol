// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// 导入 OpenZeppelin 核心合约：ERC20 标准 + 单所有者权限控制
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title LimitedSupplyERC20
 * @dev 拓展版 ERC20 代币，核心特性：
 * 1. 仅合约所有者（部署者）可调用 mint 铸造代币；
 * 2. 任意代币持有者可调用 burn 销毁自身持有的代币；
 * 3. 代币总供应量严格限制为 1 亿枚（100,000,000 * 10^18，适配 ERC20 小数位）；
 * 4. 铸造时自动校验总供应量，防止超发。
 */
contract LimitedSupplyERC20 is ERC20, Ownable {
    // 代币最大总供应量（immutable 部署后不可修改，提升gas效率）
    uint256 public immutable maxSupply;

    /**
     * @dev 构造函数：初始化代币名称、符号、最大供应量、合约所有者
     * 代币名称：LimitedToken，符号：LTK，最大供应量：1亿枚（100_000_000 * 10^18）
     */
    constructor() ERC20("LimitedToken", "LTK") Ownable(msg.sender) {
        // 1亿枚 = 100_000_000 * 10^18（ERC20 标准小数位为 18）
        maxSupply = 100_000_000 * 10 ** decimals();
    }

    /**
     * @dev 铸造代币（仅所有者可调用）
     * @param to 接收代币的地址
     * @param amount 铸造数量（带 18 位小数）
     * 核心校验：铸造后总供应量不超过 maxSupply
     */
    function mint(address to, uint256 amount) external onlyOwner {
        require(
            totalSupply() + amount <= maxSupply,
            "LimitedSupplyERC20: mint exceeds max supply"
        );
        _mint(to, amount);
    }

    /**
     * @dev 销毁代币（任意持有者可调用，销毁自身代币）
     * @param amount 销毁数量（带 18 位小数）
     * 无需额外校验：ERC20 内置 _burn 会检查调用者余额是否充足
     */
    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }
}