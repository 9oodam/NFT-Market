// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./myNFT.sol";


// myNFT CA와 상호작용 할 contract
contract SaleNFT {
    MyNFT public _nft; // MyNFT 타입의 변수 (CA를 담음)

    struct SalingNft {
        uint256 price;
        uint256 duration;
        uint256 earning;
    }

    // 판매 등록한 Nft의 정보
    mapping (uint256 tokenId => SalingNft[]) salingNFT;
    // 거래된 횟수
    mapping (uint256 tokenId => uint256 num) transferNum;
    // 해당 nft가 판매 중인지
    mapping (uint256 tokenId => bool) isSaling;


    constructor(address _nftCA) {
        _nft = MyNFT(_nftCA);
    }

    function saleNftMint(string memory _hash) public {
        // CA에서 CA로 메시지를 전송하여 메서드 실행
        _nft.minting(_hash);
    }


    // saleNFT -> myNFT 메시지 전송하여 권한을 위임받음
    function setApprovalForAll() public {
        _nft.setAppAll(msg.sender, address(this), true);
    }

    // 판매 등록
    function registerSaleNFT(uint256 tokenId, SalingNft memory salingNft) public view returns (bool) {
        // 실행시킨 사람이 판매 컨트랙트에 NFT 권한을 위임했는지 확인
        // owner / msg.sender : 위임한 사람
        // operator / address(this) : 위임받은 사람
        if(_nft.isApprovedForAll(msg.sender, address(this)) == false) {
            _nft.setAppAll(msg.sender, address(this), true);
        }else {
            // 판매 중인 nft 배열에 추가
            isSaling[tokenId] = true;
        }
    }

    // 판매 취소
    function cancelSaleNFT(uint256 tokenId) public returns (bool) {
        isSaling[tokenID] = false;
    }

    // 해당 Nft가 판매 등록 되었는지 확인
    function isSalingCheck(uint256 tokenId) public view returns (bool) {
        return isSaling[tokenID];
    }

    // 판매 등록된 Nft 정보 확인
    function getDetail(uint256 tokenId) public view return (SalingNft memory) {
        return salingNFT[tokenId];
    }


    // 구매 요청
    function buyNFT() public returns (bool) {
        // 구매 신청하면 판매 CA로 이더를 보내서 담아놓음

    }

    // 판매 수락
    function acceptSaleNFT() public returns (bool) {

    }
    // 판매 거절
    function rejectSaleNFT() public returns (bool) {

    }


    // 랭킹 구하기
    function getRanking() public returns (uint256[10] memory) {
        uint256[10] memory rankArr;

        for (uint256 i = 0; i < 10; i++) {
            rankArr[i] = type(uint256).max;
        }

        for (uint256 tokenId = 0; tokenId < _nft._nftArrForAll.length; tokenId++) {
            uint256 num = transferNum[tokenId];

            for (uint256 i = 0; i < 10; i++) {
                if(num > transferNum[rankArr[i]]) {
                    for (uint256 j = 9; j > 1; j--) {
                        rankArr[j] = rankArr[j-1];
                    }
                    rankArr[i] = tokenId;
                    break;
                }
            }
        }

        return rankArr;
    }


    // 구매자가 요청하면 판매자가 수락/거절 이더를 받고 소유권 넘김
    // 판매자가 수락하면 판매 CA에서 판매자에게 이더리움 보내고 소유권을 구매자게에 넘김
}