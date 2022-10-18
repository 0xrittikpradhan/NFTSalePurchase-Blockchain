//SPDX-License-Identifier: None

pragma solidity 0.8.17;

import "./PurchaseToken20.sol";
import "./NFTToken721.sol";

contract Dex {
    PurchaseToken20 PT20;
    NFTToken721 NFT721;

    address private feeCollector;

    uint256 constant PRICE = 1000000;

    event TokenMinted(address indexed, uint256, uint256);
    event BuyNFT(address indexed owner, uint256 tokenId);
    event SellNFT(address indexed owner, uint256 tokenId);

    constructor(address PT20Address, address NFT721Address, address _feeCollector) {
        PT20 = PurchaseToken20(PT20Address);
        NFT721 = NFTToken721(NFT721Address);
        feeCollector = _feeCollector;
    }

    
    function exchangeEthToPurchaseToken() external payable {
        uint256 tokenAmount;

        require(msg.sender.code.length == 0, "!EOA");

        tokenAmount = (msg.value * PRICE)/(10 ** 18);
        PT20.mint(msg.sender, tokenAmount);

        emit TokenMinted(msg.sender, msg.value, tokenAmount);
    }

    function buyNFT() external payable {

        require(PT20.balanceOf(msg.sender) > PRICE, "Insufficient token to buy NFT");
        PT20.transferFrom(msg.sender, address(this), PRICE);

        uint256 nftId = NFT721.mint(msg.sender);

        emit BuyNFT(msg.sender, nftId);
    }

    function sellNFT(uint256 nftId) external {
        NFT721.burn(nftId);

        uint256 fee = (PRICE * 17)/1000;
        uint256 receivableAmount = PRICE - fee ;
 
        PT20.transfer(msg.sender, receivableAmount);
        PT20.transfer(feeCollector, fee);

        emit SellNFT(msg.sender, nftId);
    }
}