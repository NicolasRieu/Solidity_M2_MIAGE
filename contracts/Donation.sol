// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";


contract Donation {

    AggregatorV3Interface internal dataFeed;

    address public owner;

    event DonationRecue(address donateur, uint256 montant);
    event RetraitEffectue(address owner, uint256 montant);
    event VirementEffectue(address expediteur, address destinataire, uint256 montant);

    constructor() {
        owner = msg.sender;
        dataFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Seul le createur peut effectuer cette action.");
        _;
    }

    function donate() public payable {
        require(msg.value > 0, "Le montant doit etre superieur a zero.");
        emit DonationRecue(msg.sender, msg.value);
    }

    function withdraw() public onlyOwner {
        uint256 solde = address(this).balance;
        require(solde > 0, "Le contrat est vide.");
        payable(owner).transfer(solde);
        emit RetraitEffectue(owner, solde);
    }

    // Virement : le owner transfère un montant depuis le contrat vers un destinataire
    function transferTo(address payable destinataire, uint256 montant) public onlyOwner {
        require(destinataire != address(0), "Adresse destinataire invalide.");
        require(montant > 0, "Le montant doit etre superieur a zero.");
        require(montant <= address(this).balance, "Fonds insuffisants dans le contrat.");

        destinataire.transfer(montant);

        emit VirementEffectue(msg.sender, destinataire, montant);
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function getUSDValue() public view returns (int) {

    }
}