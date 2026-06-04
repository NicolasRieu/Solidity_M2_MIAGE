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

    // ── Récupère le prix ETH/USD depuis Chainlink ───────────────────────────
    // Retourne le prix brut avec 8 décimales (ex: 250000000000 = 2500.00 USD)
    function getEthUsdPrice() public view returns (int256) {
        (
            /* uint80 roundId */,
            int256 answer,
            /* uint256 startedAt */,
            /* uint256 updatedAt */,
            /* uint80 answeredInRound */
        ) = dataFeed.latestRoundData();
        return answer;
    }

    // ── Retourne la valeur de la cagnotte en dollars entiers ────────────────
    //
    // Formule :
    //   balance (wei)    → 18 décimales
    //   prix Chainlink   →  8 décimales
    //   produit          → 26 décimales → on divise par 10^26 pour obtenir des USD
    //
    function getBalanceInUSD() public view returns (uint256) {
        int256 prixBrut = getEthUsdPrice();

        // Le prix Chainlink ne peut pas être négatif en pratique,
        // mais int256 → uint256 nécessite une vérification
        require(prixBrut > 0, "Prix oracle invalide.");

        uint256 prix = uint256(prixBrut); // ex : 250000000000 pour 2500 USD

        // Multiplication : balance_wei × prix (avec 8 décimales)
        // Division par 10^26 pour annuler les 18 décimales du wei
        // et les 8 décimales du prix Chainlink
        uint256 valeurUSD = (address(this).balance * prix) / 1e26;

        return valeurUSD; // valeur en dollars entiers
    }
}