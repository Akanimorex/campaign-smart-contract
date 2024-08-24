// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

// Uncomment this line to use console.log
// import "hardhat/console.sol";


contract CrowdFunding {
    struct Campaign {
        string title;
        string description;
        address benefactor;
        uint goal;
        uint deadline;
        uint amountRaised;
        uint campaignId;
    }

    event CampaignCreated(uint campaignId, string title);
    event DonationReceived(uint campaignId, address donor, uint amount);
    event CampaignEnded(uint campaignId);
    address public owner;

    constructor(){
        owner =msg.sender;
    }

      modifier onlyOwner {
        require(msg.sender == owner, "Only the contract owner can perform this action");
        _;
    }

    

    mapping(uint => Campaign) public campaigns; //creating a list of campaigns 
     /** 
         * creating a counter to generate unique campaign IDsa
         * and taking note of the total donations
    **/
    uint public nextCampaignId =1;
    uint public totalDonations =0;

    function createCampaign(string memory _title, string memory _description,address _benefactor, uint _goal,uint duration) public payable {
        //checks to confirm the goal is greater than 0, donation too

        require(_goal > 0, "Goal should be greater than zero"); 
        require(msg.value > 0, "Donation amount should be greater than zero"); 

       

        uint deadline = block.timestamp + duration; //the deadline
        uint campaignId = nextCampaignId++;

         //pushing to the list

        Campaign storage campaign = campaigns[campaignId];
        campaign.title = _title;
        campaign.description = _description;
        campaign.benefactor = _benefactor;
        campaign.goal = _goal;
        campaign.deadline = deadline;
        campaign.amountRaised = 0;
        campaign.campaignId = campaignId;

        // Emit an event to indicate that a new campaign has been created

        emit CampaignCreated(campaignId, _title);
    }

    function Donate(uint _campaignId) public payable{
        //ensure the campaignId is still legit
        require(_campaignId > 0 && _campaignId <= nextCampaignId - 1, "Invalid campaign ID");
        //check if the campaign is still ongoing
        require(block.timestamp <= campaigns[_campaignId].deadline, "Campaign has ended");
        //checks donation amount
        require(msg.value > 0, "Donation amount should be greater than zero");

        //Creating an instance, and pushing

        Campaign storage campaign = campaigns[_campaignId];
        campaign.amountRaised += msg.value;
        totalDonations += msg.value;

        //emit an event to show that that a sonation has been received

        emit DonationReceived(_campaignId, msg.sender, msg.value);
    }

    function endCampaign(uint _campaignId) public {
        require(_campaignId > 0 && _campaignId <= nextCampaignId - 1, "Invalid campaign ID"); //checking if campaign is still valid

        //checks if campaign has met it's deadline
        require(block.timestamp >= campaigns[_campaignId].deadline, "Campaign has not ended yet");

        Campaign storage campaign = campaigns[_campaignId];
        uint amountRaised = campaign.amountRaised;

        // Transfer funds to benefactor
        (bool success, ) = payable(campaign.benefactor).call{value: amountRaised}("");

        // Ensure the transfer was successful
        require(success, "Failed to transfer funds");

        delete campaigns[_campaignId];

        //emit an event to confirm campaign has ended
        emit CampaignEnded(_campaignId);
    }

    //  function withdrawFunds() public  {
    //     // Ensure there are funds to withdraw
    //     uint balance = address(this).balance;
    //     require(balance > 0, "No funds available for withdrawal");

    //     // Transfer the contract's entire balance to the owner
    //     (bool success, ) = payable(owner()).call{value: balance}("");

        
    //     //stuck here sha
    // }


}