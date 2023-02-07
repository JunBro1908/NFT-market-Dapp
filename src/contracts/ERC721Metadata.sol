// SPDX-License-Identifier: MIT
pragma solidity >=0.4.0 < 0.9.0;

import './interfaces/IERC721Metadata.sol';
import './ERC165.sol';

//Metadata is just for expansion
contract ERC721Metadata is IERC721Metadata, ERC165 {

    string private _name;
    string private _symbol;
    
    /* if we give string as a argument to constructor string have to store in memory first.
    string have a memory location and after using it wipe out */
    constructor(string memory named, string memory symbolified) {
        _name = named;
        _symbol = symbolified;
        _registerInterface(bytes4(
            keccak256('name(bytes4)')^
            keccak256('symbol(bytes4)')
        ));
    }
    
    // variables are defined as pirvate thus the user(outside) must access this var through function.
    function name() external view override returns(string memory) {
        return _name;
    }

    function symbol() external view override returns(string memory) {
        return _symbol;
    }
}