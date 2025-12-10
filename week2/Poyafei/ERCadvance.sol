// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Poyafei is ERC20, Ownable {
    uint256 public constant MAX_SUPPLY = 1000000 * (10 ** 18);
    constructor(uint256 initialSupply) ERC20("Poyafei","PO") Ownable(msg.sender){
        require(initialSupply <= MAX_SUPPLY,"Initial supply exceeds max supply");
        _mint(msg.sender, initialSupply);
    }
    function mint(address to, uint256 amount) public onlyOwner {
        require(ERC20.totalSupply() + amount <= MAX_SUPPLY, "MyToken:Max supply exceeded");
        _mint(to,amount);
    }
    function burn(uint256 amount) public {
        _burn(msg.sender,amount);
    }
    function burnFrom(address account, uint256 amount) public onlyOwner{
        _burn(account, amount);
    }
}

//合约地址 0x7AC8dFCa8429f10Cd9aEDd610677Fc82d8b9CE9F 部署交易哈希 0x7AC8dFCa8429f10Cd9aEDd610677Fc82d8b9CE9F 代币发送哈希 0xbe39f477030b3248c0f8c02e6ff5053350c0184feb7f560974fcf7b0bf4b4412