// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC20Voting is Ownable {
    IERC20 public immutable votingToken;

    struct Candidate {
        string name;
        uint256 voteCount;
        bool isActive;
    }

    Candidate[] public candidates;
    mapping(address => bool) public hasVoted;

    uint256 public votingStartTime;
    uint256 public votingEndTime;
    bool public votingPaused;

    event Voted(address indexed voter, uint256 indexed candidateIndex, uint256 timestamp);
    event CandidateAdded(string name, uint256 index);
    event CandidateDeactivated(uint256 indexed candidateIndex);
    event VotingTimeUpdated(uint256 newStartTime, uint256 newEndTime);

    constructor(
        address _tokenAddr,
        string[] memory _candidateNames,
        uint256 _startTime,
        uint256 _endTime
    ) Ownable(msg.sender) {
        require(_candidateNames.length >= 2);
        require(_tokenAddr != address(0));
        require(_startTime < _endTime);
        require(_startTime >= block.timestamp);

        votingToken = IERC20(_tokenAddr);
        votingStartTime = _startTime;
        votingEndTime = _endTime;

        for (uint256 i = 0; i < _candidateNames.length; i++) {
            candidates.push(Candidate({
                name: _candidateNames[i],
                voteCount: 0,
                isActive: true
            }));
            emit CandidateAdded(_candidateNames[i], i);
        }
    }

    function vote(uint256 _candidateIndex) external {
        require(!votingPaused);
        require(block.timestamp >= votingStartTime);
        require(block.timestamp <= votingEndTime);
        require(!hasVoted[msg.sender]);
        require(_candidateIndex < candidates.length);
        require(candidates[_candidateIndex].isActive);
        require(votingToken.balanceOf(msg.sender) > 0);

        hasVoted[msg.sender] = true;
        candidates[_candidateIndex].voteCount++;

        emit Voted(msg.sender, _candidateIndex, block.timestamp);
    }

    function getVotes(uint256 _candidateIndex) external view returns (uint256) {
        require(_candidateIndex < candidates.length);
        return candidates[_candidateIndex].voteCount;
    }

    function getAllCandidates() external view returns (Candidate[] memory) {
        return candidates;
    }

    function addCandidate(string calldata _name) external onlyOwner {
        candidates.push(Candidate({
            name: _name,
            voteCount: 0,
            isActive: true
        }));
        emit CandidateAdded(_name, candidates.length - 1);
    }

    function deactivateCandidate(uint256 _candidateIndex) external onlyOwner {
        require(_candidateIndex < candidates.length);
        candidates[_candidateIndex].isActive = false;
        emit CandidateDeactivated(_candidateIndex);
    }
}