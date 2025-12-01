// contracts/MyNFT.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from"@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CustomERC20 is ERC20,Ownable{
    uint256 public constant MAX_SUPPLY = 1000 * 10 ** 18;
    event Mint(address indexed to,uint256 amont);
    event Burn(address indexed from, uint256 amont);
    constructor()ERC20("CustomToken","CTK") Ownable(msg.sender){}
    function mint(address to,uint256 amount) external onlyOwner{
        require(totalSupply() + amount <= MAX_SUPPLY,"CustomERC20:exceed max supply");
        _mint(to, amount);
        emit Mint(to, amount);
    }
    function burn(uint256 amount)external {
        _burn(msg.sender,amount);
        emit Burn(msg.sender,amount);
    }
}
交易哈希：0x0bfb8e895daea81982e0e1ffdf34f480b2b0c3cbacb2eab1be7903b469648473
合约地址：0x9B12FACE420DAfa735805b3aa96E12149aC21f15