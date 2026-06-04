// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

import "./Storage.sol";

// 'is Storage' = StorageFactory hérite de toutes les variables
// et fonctions définies dans Storage
contract StorageFactory is Storage {

    Storage[] public listeStorage;

    function createStorageContract() public {
        Storage nouveauContrat = new Storage();
        listeStorage.push(nouveauContrat);
    }

    function getNombreContrats() public view returns (uint256) {
        return listeStorage.length;
    }

    function getAdresseContrat(uint256 index) public view returns (address) {
        return address(listeStorage[index]);
    }

    // Appelle store() sur le contrat Storage à l'index donné
    function sfStore(uint256 index, uint256 valeur) public {
        require(index < listeStorage.length, "Index invalide.");

        // On récupère la référence au contrat Storage[index]
        // puis on appelle sa fonction store()
        listeStorage[index].store(valeur);
    }

    // Appelle retrieve() sur le contrat Storage à l'index donné
    function sfRetrieve(uint256 index) public view returns (uint256) {
        require(index < listeStorage.length, "Index invalide.");

        // On récupère la valeur stockée dans Storage[index]
        return listeStorage[index].retrieve();
    }
}