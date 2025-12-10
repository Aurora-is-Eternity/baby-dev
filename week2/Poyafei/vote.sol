// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CandidateVote is Ownable {
    IERC20 public immutable token;

    struct Candidate {
        string name;         
        uint256 voteWeight;  
    }

    Candidate[] public candidates;
    
    mapping(address => bool) public hasVoted;

    event Voted(address voter, uint256 candidateIndex, uint256 weight);

    constructor(address _tokenAddress) Ownable(msg.sender) {
        require(_tokenAddress != address(0), "Invalid token address");
        
        token = IERC20(_tokenAddress);

        candidates.push(Candidate("Alice", 0));
        candidates.push(Candidate("Bob", 0));
        candidates.push(Candidate("Charlie", 0));
        
    }

    function vote(uint256 candidateIndex) public {
        require(!hasVoted[msg.sender], "Already voted");
        require(candidateIndex < candidates.length, "Invalid candidate index");

        uint256 voterBalance = token.balanceOf(msg.sender);
        require(voterBalance > 0, "You must hold tokens to vote");

        candidates[candidateIndex].voteWeight += voterBalance;
        
        hasVoted[msg.sender] = true;

        emit Voted(msg.sender, candidateIndex, voterBalance);
    }

    function getCandidatesCount() public view returns (uint256) {
        return candidates.length;
    }
    
}

//合约地址 0x7C2bACF6bF16C2b96db528389a34B04bfAcC36c1 部署哈希 0xbe39f477030b3248c0f8c02e6ff5053350c0184feb7f560974fcf7b0bf4b4412 投票交易哈希 0x23a61d8e0018d42df8ac01684303526693599ae8c49d72d3f1fbcca8d5623f6b