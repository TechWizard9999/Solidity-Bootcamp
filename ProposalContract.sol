// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract ProposalContract {
    address public owner;
    uint256 private counter;

    struct Proposal {
        string title;
        string description;
        uint256 approve;
        uint256 reject;
        uint256 pass;
        uint256 totalVotes;
        bool is_active;
    }

    mapping(uint256 => Proposal) public proposals;
    mapping(address => mapping(uint256 => bool)) public hasVoted;

    event ProposalCreated(uint256 indexed proposalId, string title, string description, uint256 totalVotes);
    event Voted(uint256 indexed proposalId, address indexed voter, uint8 choice);
    event ProposalTerminated(uint256 indexed proposalId);

    constructor() {
        owner = msg.sender;
    }

    // Modifier to restrict access to only the contract owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    // Function to create a new proposal
    function createProposal(string calldata _title, string calldata _description, uint256 _totalVotes) external onlyOwner {
        counter++;
        proposals[counter] = Proposal(_title, _description, 0, 0, 0, _totalVotes, true);
        emit ProposalCreated(counter, _title, _description, _totalVotes);
    }

    // Function to allow voting on a proposal
    function vote(uint256 _proposalId, uint8 _choice) external {
        require(_choice >= 0 && _choice <= 2, "Invalid choice");
        require(proposals[_proposalId].is_active, "Proposal is not active");
        require(!hasVoted[msg.sender][_proposalId], "Address has already voted");

        Proposal storage proposal = proposals[_proposalId];
        proposal.totalVotes++;

        if (_choice == 1) {
            proposal.approve++;
        } else if (_choice == 2) {
            proposal.reject++;
        } else {
            proposal.pass++;
        }

        hasVoted[msg.sender][_proposalId] = true;
        emit Voted(_proposalId, msg.sender, _choice);

        if (proposal.totalVotes == proposal.totalVotesToEnd) {
            proposal.is_active = false;
        }
    }

    // Function to terminate a proposal
    function terminateProposal(uint256 _proposalId) external onlyOwner {
        require(proposals[_proposalId].is_active, "Proposal is not active");
        proposals[_proposalId].is_active = false;
        emit ProposalTerminated(_proposalId);
    }

    // Function to get the current active proposal
    function getCurrentProposal() external view returns (Proposal memory) {
        return proposals[counter];
    }

    // Function to get details of a specific proposal
    function getProposal(uint256 _proposalId) external view returns (Proposal memory) {
        return proposals[_proposalId];
    }
}
