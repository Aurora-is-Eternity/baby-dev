//SPDX-License-Identifier:MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol"; // 引入 ERC20 接口

contract VotingSystem{
    //候选人结构
    struct Candidate{
        uint256 id;
        string name;
        uint256 voteCount;
    }
    IERC20 public token;
    uint256 public constant MIN_BALANCE_VOTE = 1 * 10**18;

    mapping(uint256=>Candidate) public candidates;
    uint256 public nextCandidateid = 1;

    mapping(address=>bool) public hasVoted;

    event voteRecorded(address indexed voter,uint256 indexed candidateid,uint256 timestamp);

    address public owner;
    constructor(address _tokenAddress){
        owner = msg.sender;
        token = IERC20(_tokenAddress);
        addcandidate("candidate A");
        addcandidate("candidate B");

    }
    modifier onlyOwner(){
        require(owner == msg.sender,"Only owner can perform this action");
        _;
    }
    //添加候选人,并且只有owner有这个权限
    function addcandidate(string memory _name) public onlyOwner{
        candidates[nextCandidateid] = Candidate(nextCandidateid,_name,0);
        nextCandidateid++;

    }

    function vote(uint256 candidateid) public {
        uint256 voterBalance = token.balanceOf(msg.sender);
        //检查投票者是否持有至少一个代币
        require(voterBalance >= MIN_BALANCE_VOTE,"Voter must hold at least 1 ERC20 token to vote.");
        
        //检查是否已经投票
        require(!hasVoted[msg.sender],"This address has already voted.");
        //检查该候选人是否存在
        require(candidates[candidateid].id != 0,"Invalid candidate ID.");
        //候选人的票数+1
        candidates[candidateid].voteCount++;
        //标记该地址已经投过票
        hasVoted[msg.sender] = true;
        //记录事件
        emit voteRecorded(msg.sender,candidateid,block.timestamp);
    }
    //查询接口,返回该候选人的票数
    function getVotes(uint256 candidateid) public view returns(uint256){
        require(candidates[candidateid].id != 0,"Invalid candidate ID.");
        return candidates[candidateid].voteCount;

    }




}