// SPDX-License-Identifier: MIT
pragma solidity >=0.4.0 < 0.9.0;

import './ERC165.sol';
import './interfaces/IERC721.sol';
import './Libraries/Counters.sol';

/* MINTING
    1) NFT - address
    2) track the token ids (each NFT has token ids)
    3) track the NFT owner address
    4) track how many NFT an owner has
    5) emits the total info
 */
 
contract ERC721 is ERC165, IERC721 {

    // use SafeMath through all uint256 and Counters through Counters.Counter
    using SafeMath for uint256;
    using Counters for Counters.Counter;

    // IERC721 inherit  
    // event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    // event Approval(address indexed owner, address indexed approved, uint256 tokenId);

    mapping(uint => address) private _tokenOwner;
    // map token id to address to define the token owner

    mapping(address => Counters.Counter) private _OwnedTokensCount;
    // if owner have tokens more than one, we plus the number of tokens / to _value
    // uint256 => Counters.Counter

    // tokenId : approved addresses
    mapping(uint256 => address) private _tokenApprovals;

    // register dataprint
    constructor() {
        _registerInterface(bytes4(
            keccak256('balanceOf(bytes4)')^
            keccak256('ownerOf(bytes4)')^
            keccak256('transferFrom(bytes4)')^
            keccak256('approve(bytes4)')^
            keccak256('getApproved(bytes4)')
        ));
        // keccak256(XOR) find data fingerprint(0X........) by interpreting data per bytes
    }

    // track how many NFT that owner have
    function balanceOf(address _owner) public view override returns(uint256) {
        require(_owner != address(0), "ERC721 : owner query for non-existent token");
        return _OwnedTokensCount[_owner].current();
        // _OwnedTokensCount[_owner] => Counter : Counter.current() => uint256
    }

    // input tokenId and give the owner address
    function ownerOf(uint256 _tokenId) public view override returns(address) {
        require(_tokenOwner[_tokenId] != address(0), "ERC721 : owner query for non-existent token");
        return _tokenOwner[_tokenId];
    }
    
    // find out whether the NFT have been minted before.
    function _exists(uint256 tokenId) internal view returns(bool) {
        address owner = _tokenOwner[tokenId];
        return owner != address(0);
        // if the address exist, then the NFT already have been minted before.
    }
    
    // override _mint at ERC721Enumerable : virtual
    function _mint(address to, uint256 tokenId) internal virtual{
        require(to != address(0), "ERC721 : address can not be 0");
        require(_exists(tokenId) == false, "ERC721 : already minted");
        // 1. owner must be exist 2. tokenId must not been minted before

        _tokenOwner[tokenId] = to;
        // mapping NFT tokenId and owner address

        _OwnedTokensCount[to].increaseOne();
        // _OwnedTokensCount[to] += 1;
        // track the number of how many owner have

        emit Transfer(address(0), to, tokenId);
        // from is the contract address, for convenience address(0)
    }

    /* NFT : token owner -> buyer about tokenId 
    transferFrom -> isApprovedOrOwner -> getApproved -> _transferFrom */
    function _transferFrom(address _from, address _to, uint256 _tokenId) internal {
        require(ownerOf(_tokenId) == _from, 'ERC721 : Not the owner');
        // only owner can send. _tokenOwner[tokenId] == _from is fine
        require(_to != address(0), 'ERC721 : invalid address');
        // _to address must exist

        _OwnedTokensCount[_from].decreaseOne();
        _OwnedTokensCount[_to].increaseOne();
        // _OwnedTokensCount[_from] -= 1;
        // _OwnedTokensCount[_to] += 1;
        _tokenOwner[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId); 
    }

    // actual transferFrom function (public)
    function transferFrom(address _from, address _to, uint256 _tokenId) public override {
        require(isApprovedOrOwner(msg.sender, _tokenId));
        _transferFrom(_from, _to, _tokenId);
    }

    /* if owner approve to tranferFrom function in advance, isApprovedOrOwner works by setting _tokenApprovals
    although msg.sender is not the NFT owner, if msg.sender have already been approved by NFT owner before 
    then can execute the transferFrom function. */
    function approve(address _to, uint256 _tokenId) public override{
        address owner = ownerOf(_tokenId);
        require(_to != owner, 'owner can not send to self');
        require(msg.sender == owner, 'current caller must be own NFT');
        
        _tokenApprovals[_tokenId] = _to;
        emit Approval(owner, _to, _tokenId);
    }

    // define(bool type) : spender is an owner or spender is approved already
    function isApprovedOrOwner(address spender, uint256 _tokenId) internal view returns(bool) {
        require(_exists(_tokenId),'token does not exist');
        address owner = ownerOf(_tokenId);
        return(spender == owner || getApproved(_tokenId) == spender);
        // 1) owner or 2) approved already
    }

    // return approved address per tokenId : _tokenApprovals
    function getApproved(uint256 _tokenId) public override view returns(address) {
        require(_exists(_tokenId), 'token does not exist');
        return _tokenApprovals[_tokenId];
    }
}