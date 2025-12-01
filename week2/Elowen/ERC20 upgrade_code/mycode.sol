// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC20, ERC20Burnable, Ownable {
    uint256 public maxSupply;

    constructor() ERC20("Elowen", "E") Ownable(msg.sender) {
        maxSupply = 1000000 * 10 ** decimals();

        _mint(msg.sender, 1000 * 10 ** decimals());
    }

    function mint(address to, uint256 amount) public onlyOwner {

        require(totalSupply() + amount <= maxSupply, "Exceeds max supply");

        _mint(to, amount);
    }
}