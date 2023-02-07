// SPDX-License-Identifier: MIT
pragma solidity >=0.4.0 < 0.9.0;

import './ERC721.sol';
import './interfaces/IERC721Enumerable.sol';



contract ERC721Enumerable is ERC721, IERC721Enumerable {

    constructor() {
        _registerInterface(bytes4(
            keccak256('totalSupply(bytes4)')^
            keccak256('tokenByIndex(bytes4)')^
            keccak256('tokenOfOwnerByIndex(bytes4)')
        ));
    }

    uint256[] private _allTokens;

    // indexing _allTokens
    mapping(uint256 => uint256) private _allTokensIndex;
    
    // mapping owner : [token1, token2 ...]
    mapping(address => uint256[]) private _ownedTokens;
    
    // indexing _ownedTokens : tokenId1 : 0, tokenId2 : 1...
    mapping(uint256 => uint256) private _ownedTokensIndex;

    function _mint(address to, uint256 tokenId) internal override (ERC721) {
        super._mint(to, tokenId);
        // use super to get ERC721.sol => _mint function

         _addTokensToAllTokensEnumeration(tokenId);
         _addTokensToOwnerTokensEnumeration(to, tokenId);
         // KryptoDog's tokenId -> Enu's _mint -> _addTokensToAllTokensEnumeration -> _allTokens
    }

    // totalSupply : _alltokens array length
    function totalSupply() public override view returns(uint256) {
        return _allTokens.length;
    }

    // get tokenId from all token. Input index
    function tokenByIndex(uint256 _index) public override view returns(uint256) {
        require(_index < totalSupply(),'global index is out of bounds.');
        return _allTokens[_index];
    }

    // get owner's tokenId. Input index
    function tokenOfOwnerByIndex(address _owner, uint256 _index) public override view returns(uint256) {
        require(_index < balanceOf(_owner),'owner index is out of bounds.');
        // _ownedTokensIndex.length is fine, balanceOf from ERC721.sol
        return _ownedTokens[_owner][_index];
    }

    // all tokens : push tokenId and set the index by length
    function _addTokensToAllTokensEnumeration(uint256 tokenId) private {
        _allTokens.push(tokenId);
        _allTokensIndex[tokenId] = _allTokens.length -1;
        // tokenId : length (tokenId's length => index) start with 0(1-1)
    }

    // owner tokens : set the position of tokenId and push it to owner mapping
    function _addTokensToOwnerTokensEnumeration(address to, uint256 tokenId) private {
        _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
        // tokenId : length (address => tokenId[]'s length => index) start with 0
        
        _ownedTokens[to].push(tokenId);
    }
}