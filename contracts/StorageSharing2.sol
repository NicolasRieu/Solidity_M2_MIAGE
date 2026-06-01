// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

contract StorageSharing {

    uint256 number;
    address public owner;
    mapping(address => bool) public authorizedUsers;

    constructor() {
        owner = msg.sender;
        authorizedUsers[msg.sender] = true; // le owner est autorisé par défaut
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Non autorise : vous n'etes pas le createur.");
        _;
    }

    modifier onlyAuthorized() {
        require(authorizedUsers[msg.sender], "Non autorise : acces refuse.");
        _;
    }

    function grantAccess(address user) public onlyOwner {
        authorizedUsers[user] = true;
    }

    function revokeAccess(address user) public onlyOwner {
        authorizedUsers[user] = false;
    }

    function store(uint256 num) public onlyAuthorized {
        number = num;
    }

    function retrieve() public view returns (uint256) {
        return number;
    }
}