// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SimpleVoting {
    struct Proposal {
        string description;
        uint256 voteCount;
        bool exists;
    }

    struct Voter {
        bool voted;
        uint256 voteIndex;
    }

    address public owner;
    mapping(uint256 => Proposal) public proposals;
    mapping(address => mapping(uint256 => Voter)) public voters; // voter => proposalId => Voter
    uint256 public proposalCount;

    constructor() {
        owner = msg.sender;
    }

    // Create a new proposal
    function createProposal(string memory _description) public {
        proposalCount++;
        proposals[proposalCount] = Proposal({
            description: _description,
            voteCount: 0,
            exists: true
        });
    }

    // Vote for a proposal (each address can vote once per proposal)
    function vote(uint256 _proposalId) public {
        require(proposals[_proposalId].exists, "Proposal does not exist");
        require(!voters[msg.sender][_proposalId].voted, "You already voted");

        voters[msg.sender][_proposalId].voted = true;
        proposals[_proposalId].voteCount++;
    }

    // Get proposal details
    function getProposal(uint256 _proposalId)
        public
        view
        returns (string memory description, uint256 voteCount)
    {
        require(proposals[_proposalId].exists, "Proposal does not exist");
        Proposal storage p = proposals[_proposalId];
        return (p.description, p.voteCount);
    }

    // Find the winning proposal
    function getWinningProposal() public view returns (uint256 winningId, string memory description, uint256 voteCount) {
        uint256 highestVotes = 0;
        uint256 winningProposalId = 0;

        for (uint256 i = 1; i <= proposalCount; i++) {
            if (proposals[i].voteCount > highestVotes) {
                highestVotes = proposals[i].voteCount;
                winningProposalId = i;
            }
        }

        if (winningProposalId > 0) {
            Proposal memory winner = proposals[winningProposalId];
            return (winningProposalId, winner.description, winner.voteCount);
        } else {
            return (0, "No proposals yet", 0);
        }
    }
}
