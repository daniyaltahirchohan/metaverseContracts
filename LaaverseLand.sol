// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

error NoNFTOwned(address nftAddress,address rtpa,uint256 tkid);
error BuyingClosed(address rtpa,uint256 tkid,string why);
error LoBalance(address rtpa, uint256 tkid, uint256 _price);
error Already(string couunter);

contract LaaverseLand is ERC721, ERC721Enumerable, ERC721URIStorage{

    address payable creator;
    string canBuy = "no";
    uint256 price = 0;

    constructor() ERC721("LaaverseNFT", "LAES") {

        creator = payable(msg.sender);

    }

    modifier onlyCreator() {
        require(creator == msg.sender,"you cant mint token");
        _;
    }

    function claimLand(string memory uri, uint256 tokenId, address _addressNFT) public {
        IERC721 nft = IERC721(_addressNFT);
        if(nft.balanceOf(msg.sender) == 0){
            revert NoNFTOwned(_addressNFT,msg.sender,tokenId);
        }
        if(balanceOf(msg.sender) == 0){
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, uri);
        }
    }

    function buyLand(string memory uri, uint tokenId) payable public {
        if(keccak256(abi.encodePacked(canBuy)) == keccak256(abi.encodePacked("no"))){
            revert BuyingClosed(msg.sender,tokenId,canBuy);
        }
        if(msg.value < price){
            revert LoBalance(msg.sender,tokenId,msg.value);
        }
        creator.transfer(msg.value);
        _safeMint(msg.sender,tokenId);
        _setTokenURI(tokenId, uri);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function myBalance() 
        public 
        view 
        virtual 
        returns (uint256) 
    {
        return super.balanceOf(msg.sender);
    }

    function transferFromOwner(address to,uint256 tokenId) public {
        super.safeTransferFrom(msg.sender,to,tokenId);
    }
    
    function changeLandPrice(uint _price) public onlyCreator{
        price = _price;
    }

    function closeBuying() public onlyCreator{
        if(keccak256(abi.encodePacked(canBuy)) == keccak256(abi.encodePacked("no"))){
            revert Already(canBuy);
        }
        canBuy = "no";
    }

    function startBuying(uint _price) public onlyCreator{
        if(keccak256(abi.encodePacked(canBuy)) == keccak256(abi.encodePacked("yes"))){
            revert Already(canBuy);
        }
        canBuy = "yes";
        price = _price;
    }
}
