// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

contract StorageOwnership {

    uint256 number;
    address public owner;  // stocke l'adresse du créateur

    constructor() {
        owner = msg.sender;  // au déploiement, msg.sender = le créateur
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Non autorise : vous n'etes pas le createur.");
        _;  // ici s'exécute le corps de la fonction
    }

    function store(uint256 num) public onlyOwner {
        number = num;
    }

    function retrieve() public view returns (uint256) {
        return number;
    }
}