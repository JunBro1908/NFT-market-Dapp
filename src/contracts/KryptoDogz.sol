// SPDX-License-Identifier: MIT
pragma solidity >=0.4.0 < 0.9.0;

import './ERC721Connector.sol';

// KryptoDogz & Migrations -> truffle-configs.js (setting networks) & migration.js (deploy the contracts) -> deploy on blockchain(test network ganache)

// kryotpDog values => ERC721Connector arguments
contract KryptoDog is ERC721Connector {

    string [] public kryptoDogz;
    // add NFT -> make tokenId with index + msg.sender -> ERC721 _mint -> mapping msg.sender : tokenId

    mapping(string => bool) _kryptoDogzExists;

    function mint(string memory _kryptoDog) public {
        
        require(_kryptoDogzExists[_kryptoDog] == false, "this NFT is already minted");

        kryptoDogz.push(_kryptoDog);
        uint _id =  kryptoDogz.length -1;
        /* version over 0.6 push method can not get length, only reference value.
        thus push first and then get length. (-1 for indexing) */
        
        _mint(msg.sender, _id);

        _kryptoDogzExists[_kryptoDog] = true;
        // track minting history
    }

    constructor() ERC721Connector('KryptoDog', 'KDOGZ') {}
}

/* after migration, we can mint our image src truffle console -> kryptoDog.mint('ex) https... / ')
then emit msg.sender as from, kryptoDog contract address as to and index
 */