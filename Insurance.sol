// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract Insurance {
    address[] public policyholders;
    mapping(address => uint256) public policies;
    mapping(address => uint256) public claims;
    address payable owner;
    uint256 public totalPremium;

    constructor() public {
        owner = payable(msg.sender);
    }

    function purchasePolicy(uint256 premium) public payable {
        require(msg.value == premium, "Incorrect premium amount!");
        require(premium>0, "Premium must be greater than 0!");
        policyholders.push(msg.sender);
        policies[msg.sender] = premium;
        totalPremium += premium;
    }

    function fileClaim(uint256 amount) public {
        require(policies[msg.sender] > 0, "Must have a valid policty to file a claim!");
        require(amount > 0, "Claim must be greater than 0!");
        require(amount <= policies[msg.sender], "Claim amont cannot exceed policy!");
        claims[msg.sender] += amount;
    }

    function approveClain(address policyholder) public {
        require(msg.sender == owner, "Only the owner can approve claims!");
        require(claims[policyholder] > 0, "Policyholder has no outstanding claim!");
        payable(policyholder).transfer(claims[policyholder]);
        claims[policyholder] = 0;
    }

    function getPolicy(address policyholder) public view returns (uint256) {
        return policies[policyholder];
    }

    function getClaim(address policyholder) public view returns (uint256) {
        return claims[policyholder];
    }

    function getTotalPremium() public view returns (uint256) {
        return totalPremium;
    }

    function grantAccess(address payable user) public {
        require(msg.sender == owner, "Only owner can grant access!");
        owner = user;
    }

    function revokeAccess(address payable user) public {
        require(msg.sender == owner, "Only owner can revoke access!");
        require(user != owner, "Cannot revoke access for the current owner!");
        owner = payable(msg.sender);
    }

    function destroy() public {
        require(msg.sender == owner, "Only owner can destroy the contract!");
        selfdestruct(owner);
    }
} 