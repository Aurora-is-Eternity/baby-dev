//交易哈希：0x5a56fc866bbe87cea5cd4d45a7f92388b842a56f5dab6b8c67ee24a5c3001994
//合约地址：0xc8325b86c06c7c1d82a7c54522a80b0f46eed3cd
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


    //升级版ERC20
    //@notice 仅 owner 可 mint，任何人可 burn，最大总量 1_000_000
contract MyToken is ERC20, Ownable {
    uint256 public constant MAX_SUPPLY = 1_000_000 * 10 ** 18;

    constructor() ERC20("MyToken", "MTK") Ownable(msg.sender) {
        _mint(msg.sender, 100_000 * 10 ** 18);
    }


    //仅 owner 可铸币，且不超过 MAX_SUPPLY
    function mint(address to, uint256 amount) external onlyOwner {
        require(totalSupply() + amount <= MAX_SUPPLY, "Max supply exceeded");
        _mint(to, amount);
    }


    //任何人可销毁自己的代币
    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }
}