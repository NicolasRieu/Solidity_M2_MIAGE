// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

import "./Storage.sol";

contract StorageFactory {

    // Tableau qui stocke toutes les instances Storage créées
    // Storage[] est un type tableau d'objets de type contrat
    Storage[] public listeStorage;

    function createStorageContract() public {
        // On crée l'instance ET on la sauvegarde dans le tableau
        Storage nouveauContrat = new Storage();
        listeStorage.push(nouveauContrat);
    }

    // Retourne le nombre de contrats Storage déployés
    function getNombreContrats() public view returns (uint256) {
        return listeStorage.length;
    }

    // Retourne l'adresse d'un contrat Storage par son index
    function getAdresseContrat(uint256 index) public view returns (address) {
        return address(listeStorage[index]);
    }
}