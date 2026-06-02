// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

contract Virement {

    // ── Déclaration de l'événement ──────────────────────────────────────────
    //
    // 'indexed' sur expediteur et destinataire permet de filtrer les logs
    // par adresse — utile pour répondre à "montre-moi tous les virements
    // reçus par 0xABC..." sur Etherscan ou depuis une dApp.
    //
    // 'montant' n'est pas indexed : pas besoin de filtrer par montant exact,
    // et l'indexation coûte plus de gas.
    //
    event VirementEffectue(
        address indexed expediteur,
        address indexed destinataire,
        uint256 montant,
        uint256 timestamp
    );

    // ── Fonction de virement ────────────────────────────────────────────────
    function virer(address payable destinataire) public payable {
        require(msg.value > 0, "Le montant doit etre superieur a zero.");
        require(destinataire != address(0), "Adresse destinataire invalide.");
        require(destinataire != msg.sender, "Impossible de se virer a soi-meme.");

        // Transfert des ETH
        destinataire.transfer(msg.value);

        // Emission de l'événement APRÈS le transfert (bonne pratique)
        emit VirementEffectue(
            msg.sender,
            destinataire,
            msg.value,
            block.timestamp   // horodatage Unix du bloc actuel
        );
    }

    // Permet à quiconque de consulter le solde du contrat (devrait toujours être 0)
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}