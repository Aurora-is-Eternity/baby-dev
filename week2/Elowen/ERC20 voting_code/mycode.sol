// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";

contract ERC20Voting is Ownable, Pausable {
    IERC20 public token;

    uint256 public startTime;
    uint256 public endTime;

    struct Candidate {
        uint256 id;
        string name;
        uint256 voteCount;
    }

    Candidate[] public candidates;
    mapping(address => bool) public hasVoted;

    event Voted(
        address indexed voter,
        uint256 indexed candidateId,
        string candidateName
    );

    constructor(address _tokenAddress, uint256 _durationDays) Ownable(msg.sender) {
        token = IERC20(_tokenAddress);
        
        startTime = block.timestamp;
        endTime = startTime + (_durationDays * 1 days);

        addCandidateInternal("Candidate A");
        addCandidateInternal("Candidate B");
    }

    function addCandidateInternal(string memory _name) internal {
         candidates.push(Candidate({
            id: candidates.length,
            name: _name,
            voteCount: 0
        }));
    }
    
    function addCandidate(string memory _name) public onlyOwner {
        addCandidateInternal(_name);
    }
    
    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }
    
    function vote(uint256 _candidateId) public whenNotPaused {
        require(_candidateId < candidates.length, "Invalid candidate ID.");
        
        require(block.timestamp >= startTime, "Voting has not started.");
        require(block.timestamp <= endTime, "Voting has ended.");
        
        require(token.balanceOf(msg.sender) > 0, "Must hold ERC20 token to vote.");
        
        require(!hasVoted[msg.sender], "Already voted once.");

        candidates[_candidateId].voteCount += 1;
        hasVoted[msg.sender] = true;

        emit Voted(
            msg.sender,
            _candidateId,
            candidates[_candidateId].name
        );
    }

    function getVotesList() public view returns (string[] memory names, uint256[] memory votes) {
        names = new string[](candidates.length);
        votes = new uint256[](candidates.length);
        
        for (uint i = 0; i < candidates.length; i++) {
            names[i] = candidates[i].name;
            votes[i] = candidates[i].voteCount;
        }
        return (names, votes);
    }
    
    function getCandidateVotes(uint256 _candidateId) public view returns (uint256) {
        require(_candidateId < candidates.length, "Invalid candidate ID.");
        return candidates[_candidateId].voteCount;
    }
}