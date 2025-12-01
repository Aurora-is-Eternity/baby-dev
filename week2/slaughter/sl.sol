// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyUpgradedERC20 is ERC20, ERC20Burnable, Ownable {

    uint256 public immutable maxSupply;   // 最大总量限制

    constructor(
        string memory name_,
        string memory symbol_,
        uint256 maxSupply_
    ) ERC20(name_, symbol_) Ownable(msg.sender) {
        maxSupply = maxSupply_;
    }

    /// @notice 只有 owner 可以 mint，且不能超过最大供应量
    function mint(address to, uint256 amount) public onlyOwner {
        require(totalSupply() + amount <= maxSupply, "Exceed max supply");
        _mint(to, amount);
    }
}