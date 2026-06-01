// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

contract StorageDelegation {

    uint256 number;
    address public owner;
    mapping(address => bool) public admins;
    mapping(address => bool) public authorizedUsers;

    constructor() {
        owner = msg.sender;
        admins[msg.sender] = true;
        authorizedUsers[msg.sender] = true;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Reserves au createur.");
        _;
    }

    modifier onlyAdmin() {
        require(admins[msg.sender], "Reserves aux admins.");
        _;
    }

    modifier onlyAuthorized() {
        require(authorizedUsers[msg.sender], "Acces refuse.");
        _;
    }

    // Seul le owner peut nommer/démettre des admins
    function grantAdmin(address user) public onlyOwner {
        admins[user] = true;
    }

    function revokeAdmin(address user) public onlyOwner {
        admins[user] = false;
    }

    // Les admins gèrent les utilisateurs autorisés
    function grantAccess(address user) public onlyAdmin {
        authorizedUsers[user] = true;
    }

    function revokeAccess(address user) public onlyAdmin {
        authorizedUsers[user] = false;
    }

    function store(uint256 num) public onlyAuthorized {
        number = num;
    }

    function retrieve() public view returns (uint256) {
        return number;
    }
}