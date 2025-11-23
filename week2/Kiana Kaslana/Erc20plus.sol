//扩展功能：onwer可mint代币，用户可burn自己地址的代币，代币基础发行114514个，最大铸造上限为33550336个，同时记录了mint与burn的事件，便于审计。
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {ERC20} from "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract FundTokenERC20 is ERC20 { 
    address public owner;
    uint256 public limitation=33550336;
    
    event TokensMinted(address indexed to, uint256 amount, address indexed minter);
    event TokensBurned(address indexed from, uint256 amount, address indexed burner);

    constructor() ERC20("Yang_J_Jack", "YJJ") {
        owner=msg.sender;
        uint256 initialAmount = 114514*10**decimals();
        _mint(msg.sender, initialAmount);
        emit TokensMinted(msg.sender, initialAmount, msg.sender);
    }

    function mint(address account, uint256 value) public {
        require(account==owner,"you not right to mint these tokens");
        require(totalSupply()+value<=limitation*10**decimals(),"you reach limitation");
        _mint(account,value);
        emit TokensMinted(account, value, msg.sender);
    }

    function burn(uint256 value) public {
        address burner = msg.sender;
        _burn(burner,value);
        emit TokensBurned(burner, value, burner);
    }
}