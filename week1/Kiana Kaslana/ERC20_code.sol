// 0xbd8dc4566a6f56609a4ec700aa1177807221415e
// 0xf9bd97b018b5d9b82c7bd46712a7163be8a8861975e8e56d04fd2a16ac8a80f2
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {ERC20} from "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
contract FundTokenERC20 is ERC20 { 
    address public owner;
    uint256 public limitation=33550336;

    constructor() ERC20("Yang_J_Jack", "YJJ") {
        owner=msg.sender;
        _mint(msg.sender,114514*10**decimals());
    }

    function mint(address account, uint256 value) public {
        require(account==owner,"you not right to mint these tokens");
        require(totalSupply()+value<=33550336*10**decimals(),"you reach limitation");
        _mint(account,value);
    }
    function burn(address account, uint256 value) public {
        require(account==owner,"you not right to burn these tokens");
        _burn(account,value);
    }
}
