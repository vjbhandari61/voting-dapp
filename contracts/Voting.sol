// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract VotingApp {

    address private _admin;

    struct Proposal {
        string description;
        uint votes;
        bool active;
    }

    mapping (uint => Proposal) private proposals;
    mapping(address => mapping(uint => bool)) public hasVoted;
    uint private proposalCounter;

    constructor() {
        _admin = msg.sender;
    }

    function createProposal(string calldata _description) external {
        require(msg.sender == _admin, "Error: Only Admins Can Create Proposals!");
        proposals[proposalCounter] = Proposal(_description, 0, true);
        proposalCounter++;
    }

    function vote(uint _proposalId) external {
        require(proposals[_proposalId].active, "Error: Voting Has Ended!");
        require(!hasVoted[msg.sender][_proposalId], "Error: User Has Already Voted!");

        proposals[_proposalId].votes++;
        hasVoted[msg.sender][_proposalId] = true;
    }

    function  getVotes(uint _proposalId) external view returns (uint) {
        return proposals[_proposalId].votes;
    }

    function getResult(uint _proposalId) external view returns (uint) {
        require(!proposals[_proposalId].active, "Error: Voting Has Not Yet Ended");
        
        return proposals[_proposalId].votes;
    } 

    function endVoting(uint _proposalId) external {
        require(msg.sender == _admin, "Error: Only Admins Can End Voting!");

        proposals[_proposalId].active = false;
    }

    function admin() external view returns (address) {
        return _admin;
    }
}