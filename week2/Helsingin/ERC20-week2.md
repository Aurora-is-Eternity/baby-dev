# 学习笔记
在写投票系统时，对各个函数的使用有了更进一步的认识。

## 投票
solidity中结构体的使用与C语言略有不同，初始化的过程中需要反复声明数据类型;

构造函数在solidity中及其特殊，它仅在合约被创建的时候执行，可以用来做初始化，如声明代币的合约地址和数据的初始化;

require用于验证是否执行下面的代码，还可以返回错误信息;

## ERC20
主要学习多个函数的作用。
    `name()`                    代币全称，如 `"MyToken"`
    `symbol()`                  代币符号，如 `"MTK"`  
    `decimals()`                小数位数，默认 18      
    `totalSupply()`             当前总供应量      
    `balanceOf(account)`        某地址余额     
    `allowance(owner, spender)` 被授权可花费的额度