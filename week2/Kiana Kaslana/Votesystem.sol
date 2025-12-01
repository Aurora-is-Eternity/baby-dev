//基于自定义Erc20的同质化代币的投票系统，用户拥有代币可对候选人进行投票。
//设置记录候选人添加和投票的事件。
//基础设置3位候选人，owner可以在addtime期内添加候选人，创建合约时可以设置addtime与投票截止日期lasttime，并添加代币部署地址。
//在lasttime期间，用户可随时拉取候选人列表，读取所有候选人信息；也可选择性的获取特定侯选人的票数。
//用户仅可投票一次，持有代币数目的不同，会使得用户可投的票数不同。
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {FundTokenERC20} from "./YJJtoken.sol";

contract VoteErc20{
    FundTokenERC20 public _YJJtoken;
    address public owner;
    uint256 public deploytimestamp;
    uint256 public lasttime;
    uint256 public addtime;
    struct houxuanren {
        uint256 id;
        string name;
        uint256 count;
    }
    mapping(uint256=>houxuanren) public _houxuanren;
    mapping(address => bool) hasVoted;
    uint256[] houxuanrenid;
    uint256 public pcount=0;

    event _Vote (address indexed voter,uint256 id,uint256 timestamp);
    event _AddPeople (uint256 id,string name,uint256 timestamp);

    constructor (address tokenAddress,uint _addtime ,uint256 _lasttime){
        deploytimestamp=block.timestamp;
        lasttime=_lasttime;
        addtime=_addtime;
        owner=msg.sender;
        _YJJtoken = FundTokenERC20(tokenAddress);
        addPeople("Zhang San");
        addPeople("Li Si");
        addPeople("Wang Wu");
    }

    function addPeople (string memory name) public {
        require(msg.sender==owner,"You not right to add people.");
        require(block.timestamp<deploytimestamp+addtime,"Addtime have gone.");

        pcount++;
        _houxuanren[pcount]=houxuanren(pcount,name,0);
        houxuanrenid.push(pcount);
        emit _AddPeople(pcount,name,block.timestamp);
    }

    function getAllhouxuanren() public view returns (houxuanren[] memory) {
        houxuanren[] memory bevoters = new houxuanren[](houxuanrenid.length);
        for (uint256 i = 0; i < houxuanrenid.length; i++) {
        bevoters[i] = _houxuanren[i+1];
        }
        return bevoters;
    }
    
    function Vote (uint256 id) public {
        require(_YJJtoken.balanceOf(msg.sender)>0,"You can't vote to people");
        require(block.timestamp<deploytimestamp+lasttime,"Voteing is ending.");
        require(id>0 && id<=pcount,"It's error.");
        require(hasVoted[msg.sender]==false, "You have already voted");
        uint256 allowance = _YJJtoken.allowance(msg.sender, address(this));
       
        hasVoted[msg.sender] = true; 
        if(_YJJtoken.balanceOf(msg.sender)<=100 * 10**18){
            require(allowance>=1*10**18,"Error1");
            _YJJtoken.transferFrom(msg.sender, address(this), 1 * 10**18);
            _houxuanren[id].count++;
            emit _Vote(msg.sender,id,block.timestamp);
        }
        else{
            require(allowance>=5*10**18,"Error2");
            _YJJtoken.transferFrom(msg.sender, address(this), 5 * 10**18);
            _houxuanren[id].count+=5;
            emit _Vote(msg.sender,id,block.timestamp);
        }
        
    }
    
    function getVotes (uint256 id) public view returns(uint256){
        require(id>0 && id<=pcount,"It's error.");

        return _houxuanren[id].count;
    }
}