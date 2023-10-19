// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MyNFT is ERC721 {
    uint256 public tokenIdNum = 0;

    uint256[] public _nftArrForAll; // main 페이지에 모든 nft 다 보여줄 때 사용

    mapping (uint256 tokenId => string tokenURI) _tokenURI;
    mapping (address => uint256[]) _nftArr;
    
    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {
    }

    // 민팅된 모든 nft 반환
    function getAllNFT() public view returns (uint256[]) {
        return _nftArrForAll;
    }

    // 민팅
    function minting(string memory _hash) public returns (bool) {
        _tokenURI[tokenIdNum] = _hash; // tokenId => tokenURI
        _nftArr[msg.sender].push(tokenIdNum); // address => tokenId[]
        _nufArrForAll.push(tokenIdNum);

        _mint(msg.sender, tokenIdNum); // tokenId => address
        tokenIdNum += 1;
        return true;
    }

    // 삭제
    function burn(uint256 _tokenId) public returns (bool) {
        require(ownerOf(_tokenId) == msg.sender);
        _tokenURI[_tokenId] = '';

        _burn(_tokenId);
        return true;
    }


    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        return string.concat(_baseURI(), _tokenURI[_tokenId]);
    }
    function _baseURI() internal view override returns (string memory) {
        return "https://crimson-generous-ant-395.mypinata.cloud/ipfs/";
    }


    // tokenId로 소유자 찾기
    function findOwner(uint256 _tokenId) public returns (address) {
        return ownerOf(_tokenId);
    }
    // 소유자가 가진 모든 nft 반환
    function getAllTokenIdForOwner(address owner) public view returns (uint256[] memory) {
        return _nftArr[owner];
    }


    // NFT 판매 권한 부여
    function setAppAll(address owner, address operator, bool approved) public {
        _setApprovalForAll(owner, operator, approved);
    }

    // NFT 소유권 및 권한 설정은 여기서
}