// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
// 导入OpenZeppelin的ERC20标准代币实现
// 这会自动继承ERC20的所有标准功能：transfer, balanceOf, approve等
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// 定义SimpleToken合约，继承自OpenZeppelin的ERC20标准
contract SimpleToken is ERC20 {
    // 状态变量：合约所有者地址
    // public修饰符会自动生成一个同名的getter函数：owner()
    address public owner;
    
    // 状态变量：代币的最大供应量
    // 设置为public，会自动生成maxSupply()查询函数
    uint256 public maxSupply;
    
    // 事件定义：代币铸造事件
    // 当铸造新代币时触发，记录接收地址和数量
    event TokensMinted(address to, uint256 amount);
    
    // 事件定义：代币销毁事件  
    // 当代币被销毁时触发，记录销毁者地址和数量
    event TokensBurned(address from, uint256 amount);
    
    // 构造函数：在合约部署时执行一次
    // 初始化代币名称、符号，并设置初始状态
    constructor() ERC20("Simple Token", "STK") {
        // 将合约部署者设置为所有者
        owner = msg.sender;
        
        // 设置最大供应量为100万个代币
        // 10**decimals() 根据代币精度计算（通常是10^18）
        maxSupply = 1000000 * 10**decimals();
        
        // 在部署时给合约创建者铸造1000个初始代币
        // _mint是ERC20的内部函数，用于创建新代币
        _mint(msg.sender, 1000 * 10**decimals());
    }
    
    // 代币铸造函数：创建新的代币
    // external表示只能从合约外部调用，不能内部调用
    // @param to: 接收新代币的地址
    // @param amount: 要铸造的代币数量
    function mint(address to, uint256 amount) external {
        // 权限检查：只有合约所有者可以铸造代币
        require(msg.sender == owner, "Only owner can mint");
        
        // 供应量检查：确保铸造后不会超过最大供应量限制
        // totalSupply() 返回当前已存在的代币总量
        require(totalSupply() + amount <= maxSupply, "Exceeds max supply");
        
        // 调用ERC20内部函数实际铸造代币
        _mint(to, amount);
        
        // 触发代币铸造事件，便于前端监听和日志记录
        emit TokensMinted(to, amount);
    }
    
    // 代币销毁函数：永久销毁调用者拥有的代币
    // 任何人都可以调用，但只能销毁自己拥有的代币
    // @param amount: 要销毁的代币数量
    function burn(uint256 amount) external {
        // 调用ERC20内部函数销毁调用者的代币
        // _burn会自动检查调用者是否有足够的余额
        _burn(msg.sender, amount);
        
        // 触发代币销毁事件
        emit TokensBurned(msg.sender, amount);
    }
    
    // 查询函数：获取剩余可铸造的代币数量
    // view修饰符表示这是只读函数，不修改状态，不消耗Gas
    // @return: 返回最大供应量减去当前总供应量的差值
    function getRemaining() external view returns (uint256) {
        return maxSupply - totalSupply();
    }
}