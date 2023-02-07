// SPDX-License-Identifier: MIT
pragma solidity >=0.4.0 < 0.9.0;

import './interfaces/IERC165.sol';

// we will compare data fingerprint with IERC-XX
contract ERC165 is IERC165 {

    // constructor : keccak256('supportsInterface(bytes4)') -> _supportedInterfaces -> supportsInterface : true  
    constructor() {
        _registerInterface(bytes4(keccak256('supportsInterface(bytes4)')));
        // keccak256 find data fingerprint by interpreting data bytes
    }

    mapping(bytes4 => bool) private _supportedInterfaces;

    function supportsInterface(bytes4 interfaceID) override external view returns (bool) {
        return _supportedInterfaces[interfaceID];
    }

    function _registerInterface(bytes4 interfaceID) internal {
        require(interfaceID != 0xffffffff, 'invalid interface requests');
        // 0xffffffff : empty(bytes)
        
        _supportedInterfaces[interfaceID] = true;
    }
}