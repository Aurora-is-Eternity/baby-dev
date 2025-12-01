// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
// 定义简单的投票合约
contract SimpleVoting {
    // 定义候选人结构体
    // 包含候选人姓名和得票数
    struct Candidate {
        string name;        // 候选人姓名
        uint256 voteCount;  // 候选人获得的票数
    }
    
    // 候选人数组
    // public修饰符会自动生成获取函数，可通过candidates(index)查询
    Candidate[] public candidates;
    
    // 投票记录映射
    // 记录每个地址是否已经投过票
    // public修饰符会自动生成hasVoted(address)查询函数
    mapping(address => bool) public hasVoted;
    
    // 投票事件
    // 当有人投票时触发，indexed关键字便于按voter地址过滤日志
    event Voted(address indexed voter, uint256 candidateId);
    
    // 构造函数：在合约部署时执行一次
    // 初始化两个默认候选人
    constructor() {
        // 添加候选人Alice，初始票数为0
        candidates.push(Candidate("Alice", 0));
        // 添加候选人Bob，初始票数为0
        candidates.push(Candidate("Bob", 0));
    }
    
    // 投票函数
    // external表示只能从合约外部调用
    // @param candidateId: 候选人ID（0代表Alice，1代表Bob）
    function vote(uint256 candidateId) external {
        // 检查候选人ID是否有效
        // candidates.length是当前候选人总数
        require(candidateId < candidates.length, "Invalid candidate");
        
        // 检查调用者是否已经投过票
        require(!hasVoted[msg.sender], "Already voted");
        
        // 标记该地址已经投过票
        hasVoted[msg.sender] = true;
        
        // 给指定候选人增加一票
        // candidates[candidateId]访问数组中的候选人
        // voteCount++ 将票数加1
        candidates[candidateId].voteCount++;
        
        // 触发投票事件，记录投票信息
        // msg.sender 是调用函数的地址
        emit Voted(msg.sender, candidateId);
    }
    
    // 查询候选人得票数
    // view修饰符表示这是只读函数，不修改状态，不消耗Gas
    // @param candidateId: 要查询的候选人ID
    // @return: 返回指定候选人的得票数
    function getVotes(uint256 candidateId) external view returns (uint256) {
        // 检查候选人ID是否有效
        require(candidateId < candidates.length, "Invalid candidate");
        
        // 返回候选人的voteCount字段
        return candidates[candidateId].voteCount;
    }
    
    // 获取候选人总数
    // @return: 返回当前候选人的数量
    function getCandidateCount() external view returns (uint256) {
        return candidates.length;
    }
    
    // 获取投票结果
    // @return: 返回一个元组，包含Alice和Bob的得票数
    // 格式：(aliceVotes, bobVotes)
    function getResults() external view returns (uint256, uint256) {
        // 返回第一个候选人(Alice)和第二个候选人(Bob)的票数
        return (candidates[0].voteCount, candidates[1].voteCount);
    }
}