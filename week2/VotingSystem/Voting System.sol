// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title ERC20VotingSystem
 * @dev 基于ERC20代币持有量的投票系统，仅持有指定ERC20的地址可投票，且每个地址只能投一次
 */
contract ERC20VotingSystem is Ownable {
    // ======== 核心结构体 ========
    /// @dev 候选人结构体
    struct Candidate {
        uint256 id;          // 候选人唯一ID
        string name;         // 候选人名称
        uint256 voteCount;   // 累计票数
        bool exists;         // 标记候选人是否存在
    }

    // ======== 状态变量 ========
    /// @dev 关联的ERC20代币地址（持有该代币才能投票）
    IERC20 public immutable erc20Token;
    /// @dev 候选人ID到候选人信息的映射
    mapping(uint256 => Candidate) public candidates;
    /// @dev 记录地址是否已投票
    mapping(address => bool) public hasVoted;
    /// @dev 投票开始时间（时间戳）
    uint256 public votingStartTime;
    /// @dev 投票结束时间（时间戳）
    uint256 public votingEndTime;
    /// @dev 下一个候选人ID（自增）
    uint256 private _nextCandidateId;

    // ======== 事件定义 ========
    /// @dev 添加候选人事件
    event CandidateAdded(uint256 indexed candidateId, string name);
    /// @dev 投票成功事件
    event Voted(address indexed voter, uint256 indexed candidateId, uint256 timestamp);
    /// @dev 投票时间更新事件
    event VotingTimeUpdated(uint256 newStartTime, uint256 newEndTime);

    // ======== 自定义错误 ========
    error VotingNotActive();          // 投票未激活（未到开始时间/已结束）
    error AlreadyVoted();             // 地址已投票
    error CandidateDoesNotExist();    // 候选人不存在
    error InsufficientERC20Balance(); // ERC20余额不足（需至少1个代币）
    error InvalidTimeRange();         // 时间范围无效（结束时间早于开始时间）
    error OnlyOwnerAllowed();         // 仅所有者可操作

    // ======== 修饰器 ========
    /**
     * @dev 检查投票是否处于激活状态（在开始和结束时间之间）
     */
    modifier votingActive() {
        uint256 nowTime = block.timestamp;
        if (nowTime < votingStartTime || nowTime > votingEndTime) {
            revert VotingNotActive();
        }
        _;
    }

    /**
     * @dev 检查地址未投过票
     */
    modifier notVotedYet() {
        if (hasVoted[msg.sender]) {
            revert AlreadyVoted();
        }
        _;
    }

    /**
     * @dev 检查候选人是否存在
     */
    modifier candidateExists(uint256 candidateId) {
        if (!candidates[candidateId].exists) {
            revert CandidateDoesNotExist();
        }
        _;
    }

    /**
     * @dev 检查地址持有足够的ERC20代币（至少1个）
     */
    modifier hasEnoughERC20() {
        if (erc20Token.balanceOf(msg.sender) < 1) {
            revert InsufficientERC20Balance();
        }
        _;
    }

    // ======== 构造函数 ========
    /**
     * @dev 初始化投票系统
     * @param _erc20Token 关联的ERC20代币地址
     * @param _startTime 投票开始时间戳
     * @param _endTime 投票结束时间戳
     */
    constructor(
        address _erc20Token,
        uint256 _startTime,
        uint256 _endTime
    ) Ownable(msg.sender) {
        if (_endTime <= _startTime) {
            revert InvalidTimeRange();
        }
        erc20Token = IERC20(_erc20Token);
        votingStartTime = _startTime;
        votingEndTime = _endTime;
        _nextCandidateId = 1; // 候选人ID从1开始
    }

    // ======== 核心功能函数 ========
    /**
     * @dev 添加候选人（仅Owner可操作）
     * @param name 候选人名称
     * @return candidateId 新添加的候选人ID
     */
    function addCandidate(string calldata name) external onlyOwner returns (uint256) {
        uint256 candidateId = _nextCandidateId++;
        candidates[candidateId] = Candidate({
            id: candidateId,
            name: name,
            voteCount: 0,
            exists: true
        });

        emit CandidateAdded(candidateId, name);
        return candidateId;
    }

    /**
     * @dev 投票函数（核心）
     * @param candidateId 要投票的候选人ID
     */
    function vote(uint256 candidateId) 
        external 
        votingActive 
        notVotedYet 
        candidateExists(candidateId) 
        hasEnoughERC20
    {
        // 标记地址已投票
        hasVoted[msg.sender] = true;
        // 增加候选人票数
        candidates[candidateId].voteCount++;

        // 触发投票事件
        emit Voted(msg.sender, candidateId, block.timestamp);
    }

    // ======== 查询函数 ========
    /**
     * @dev 查询指定候选人的票数
     * @param candidateId 候选人ID
     * @return 候选人累计票数
     */
    function getCandidateVotes(uint256 candidateId) external view candidateExists(candidateId) returns (uint256) {
        return candidates[candidateId].voteCount;
    }

    /**
     * @dev 检查投票是否处于激活状态
     * @return 激活状态（true=激活，false=未激活）
     */
    function isVotingActive() external view returns (bool) {
        uint256 nowTime = block.timestamp;
        return nowTime >= votingStartTime && nowTime <= votingEndTime;
    }

    // ======== 管理函数（Owner） ========
    /**
     * @dev 更新投票时间（仅Owner可操作）
     * @param _newStartTime 新的开始时间戳
     * @param _newEndTime 新的结束时间戳
     */
    function updateVotingTime(uint256 _newStartTime, uint256 _newEndTime) external onlyOwner {
        if (_newEndTime <= _newStartTime) {
            revert InvalidTimeRange();
        }
        votingStartTime = _newStartTime;
        votingEndTime = _newEndTime;
        emit VotingTimeUpdated(_newStartTime, _newEndTime);
    }

    /**
     * @dev 紧急结束投票（仅Owner可操作）
     */
    function emergencyEndVoting() external onlyOwner {
        votingEndTime = block.timestamp;
        emit VotingTimeUpdated(votingStartTime, votingEndTime);
    }
}