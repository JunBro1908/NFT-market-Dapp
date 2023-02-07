// SPDX-License-Identifier: MIT
pragma solidity >=0.4.0 < 0.9.0;

import './ERC721Metadata.sol';
import './ERC721Enumerable.sol';

//connector is just for connection.

// get ERC721Metadata to ERCConnector, get ERCConnector to KryptoDogz.
// KryptoDogz.sol's name & symbol => ERCConnector name & symbol => ERC721Metadata : 3 steps

// contract A is B : A can use all about B (only declare as public)
contract ERC721Connector is ERC721Metadata, ERC721Enumerable {

    constructor (string memory name, string memory symbol) ERC721Metadata(name, symbol) {}
}