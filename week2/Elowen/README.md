### ERC20升级版合约
**代币名称**：Elowen  
**代币简称**：E  
**合约地址**：0x64fCE37C88de17Ef7f74253191aC1465cD3981ac  
**交易哈希**：0xbe09a27c4d5b1caf06b97ce1093da97b0a823d5d8ca6ae6b53b58e88b629879d  
#### 主要函数说明  
import用于从OpenZeppelin标准文档内导入  
- import "@openzeppelin/contracts/token/ERC20/ERC20.sol";ERC-20 标准实现，包含了变量状态分装和核心业务逻辑，保证了转账、代转等标准函数的实现  
- import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";功能扩展模组，包含了销毁机制和零地址交互  
- import "@openzeppelin/contracts/access/Ownable.sol";访问控制策略，对合约进行权限管理  
  
### ERC20投票系统  
**合约地址**：0x7751d5e423Bc95EB811e2C092413C1c347e0EE78  
**交易哈希**：0x42a6f9e9a862fc1111096fa53ecc9f6f536ebbc6f15f94d2c51615786aa7b7be  
**ERC20代币合约地址**：0x42a6f9e9a862fc1111096fa53ecc9f6f536ebbc6f15f94d2c51615786aa7b7be  
#### 主要函数说明  
- function getVotesList() public view returns (string[] memory names, uint256[] memory votes)；实现查询接口，向外部应用提供投票结果  

### 问题与解决
**问题**：  
- 在学习OpenZeppelin标准文档时不能很好理解和记忆  
- 在编写合约时的格式等容易出现问题  
**解决方法**：  
- 在之后的使用接触中不断熟悉记忆  
- 通过询问AI解决难以理解和格式问题，并在询问过程中要求其根据提出问题为我讲解我的理解误区以及未掌握的知识点  
