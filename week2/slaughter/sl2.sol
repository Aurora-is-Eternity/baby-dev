// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}

contract ERC20Voting {

    // ============ 事件 ============
    event Voted(address indexed voter, uint indexed candidateIndex);

    // ============ 存储结构 ============

    struct Candidate {
        string name;
        uint256 votes;
    }

    Candidate[] public candidates;
    mapping(address => bool) public hasVoted;

    IERC20 public token;

    constructor(address tokenAddress, string[] memory candidateNames) {
        token = IERC20(tokenAddress);

        for (uint i = 0; i < candidateNames.length; i++) {
            candidates.push(
                Candidate({
                    name: candidateNames[i],
                    votes: 0
                })
            );
        }
    }

    // ============ 投票 ============

    function vote(uint candidateIndex) public {
        require(token.balanceOf(msg.sender) > 0, "You have no token, cannot vote");
        require(!hasVoted[msg.sender], "Already voted");

        candidates[candidateIndex].votes += 1;
        hasVoted[msg.sender] = true;

        emit Voted(msg.sender, candidateIndex);   // <--- 记录事件
    }

    // ============ 查看函数 ============
    function getCandidatesCount() public view returns(uint) {
        return candidates.length;
    }

    function getVotes(uint index) public view returns(uint) {
        return candidates[index].votes;
    }
}