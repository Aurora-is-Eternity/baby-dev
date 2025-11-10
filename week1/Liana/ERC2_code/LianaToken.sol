// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
// 合约名称：LianaToken
// 继承 ERC20 和 Ownable 的所有功能
contract LianaToken is ERC20, Ownable {
    constructor() 
        //调用 ERC20 构造函数，设定代币的名称和符号
        //代币全名: "LianaToken"
        //代币符号: "LNT" 
        ERC20("LianaToken", "LNT") 
        
        //调用 Ownable 构造函数，将合约的所有者设为部署者
        Ownable(msg.sender)
    {
        //设定初始发行量：10,000,000 个代币
        uint256 initialSupply = 10000000 * 10**decimals(); 

        _mint(msg.sender, initialSupply);
    }

}