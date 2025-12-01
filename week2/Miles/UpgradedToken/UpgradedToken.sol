//SPDX-License-Identifier:MIT
pragma solidity ^0.8.20;
// 导入OpenZeppelin库
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";

//继承功能

contract Mytoken is ERC20,Ownable,ERC20Burnable,ERC20Capped{
    uint256 public constant MAX_SUPPLY = 10000000 * 10**18;//定义最大供应量为1000万个
    uint256 public constant INITIAL_SUPPLY = 1000000 * 10**18;//定义初始铸造代币为100万个

    //构造函数
    constructor()
        ERC20("MilesToken","Miles")   //设置代币的名称和符号
        Ownable(msg.sender)           //将合约的owner设置为合约的调用者,用来保护mint函数
        ERC20Capped(MAX_SUPPLY)       //设置代币的最大供应量
    {
        _mint(msg.sender,INITIAL_SUPPLY);
    }

    //显式重写_update(),解决编译错误
    function _update(address from,address to,uint256 value) internal virtual override(ERC20,ERC20Capped){
        super._update(from,to,value);
    }

    //功能1:mint,仅仅只有owner可以调用
    function mint(address to,uint256 amount) public onlyOwner{
        _mint(to,amount);
    }
}
