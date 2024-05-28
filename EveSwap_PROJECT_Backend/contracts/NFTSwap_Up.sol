// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/interfaces/IERC721Receiver.sol";
import "./myArtNFT.sol";

/*  要解决的问题：
    1，拿到所有的NFT挂单
    2，拿到用户所有的NFT
    3，拿到用户所有的NFT挂单
*/

contract NFTSwap_Up is IERC721Receiver{
    event List(address indexed seller,uint256 indexed tokenId,uint256 price);
    event PurChase(address indexed buyer,uint256 indexed tokenId,uint256 price);
    event Revoke(address indexed seller,uint256 indexed tokenId);
    event Update(address indexed seller,uint256 indexed tokenId,uint256 newPrice);
    event Transfer(address indexed from,address indexed to_,uint256 indexed tokenid);
    event Mint(address indexed owner,uint256 indexed tokenId);

    //nft合约地址实例
    myArtNFT public nft;
    //order订单
    struct Order{
        address owner;
        uint256 tokenId;
        uint256 price;
        string tokenURI;
    }

    //用户拥有的NFT
    mapping(address => uint256[]) private myNFTs;
    //用户的挂单
    mapping(address => Order[]) private myLists;
    //所有的挂单
    Order[] private totalOrders;

    constructor(address nftAddress_){
        require(nftAddress_ != address(0),"invalid nft address");
        nft = myArtNFT(nftAddress_);
    }
    receive() external payable {}

    //list  5000000000000000  0.005ETH
    function list(uint256 tokenId_,uint256 price_)external {
        require(nft.ownerOf(tokenId_) == msg.sender,"not owner");
        require(price_ != 0,"price can not be zero");

        nft.safeTransferFrom(msg.sender, address(this), tokenId_);

        Order memory  order = Order(msg.sender,tokenId_,price_,getTokenUrl(tokenId_));
        
        delete myNFTs[msg.sender][findById(tokenId_, myNFTs[msg.sender])];
        myLists[msg.sender].push(order);
        totalOrders.push(order);

        emit List(msg.sender, tokenId_, price_);
    }

    //update
    function update(uint256 tokenId_,uint256 newPrice_)external{
        require(totalOrders[findByNFT(tokenId_,totalOrders)].owner == msg.sender,"not owner");
        require(newPrice_ != 0,"new Price can not be zero");

        myLists[msg.sender][findByNFT(tokenId_, myLists[msg.sender])].price = newPrice_;
        totalOrders[findByNFT(tokenId_, totalOrders)].price = newPrice_;

        emit Update(msg.sender, tokenId_, newPrice_);
    }

    //revoke
    function revoke(uint256 tokenId_)external{
        require(totalOrders[findByNFT(tokenId_,totalOrders)].owner == msg.sender,"not owner");

        nft.safeTransferFrom(address(this), msg.sender, tokenId_);

        myNFTs[msg.sender].push(tokenId_);
        delete myLists[msg.sender][findByNFT(tokenId_, myLists[msg.sender])];
        delete totalOrders[findByNFT(tokenId_, totalOrders)];

        emit Revoke(msg.sender, tokenId_);
    }
    //purchase
    function purchase(uint256 tokenId_)external payable{
        Order memory order = totalOrders[findByNFT(tokenId_, totalOrders)];

        require(msg.sender != order.owner,"can not purchase your nft");
        require(msg.value >= order.price,"have no enougth eth");

        nft.safeTransferFrom(address(this), msg.sender, tokenId_);

        if(msg.value > order.price){
            payable(msg.sender).transfer(msg.value - order.price);
        }
        payable(order.owner).transfer(order.price);

        myNFTs[msg.sender].push(tokenId_);
        delete myLists[order.owner][findByNFT(tokenId_, myLists[order.owner])];
        delete totalOrders[findByNFT(tokenId_, totalOrders)];

        emit PurChase(msg.sender, tokenId_, order.price);
    }

    //transfer
    function transfer(address to_,uint256 tokenId_)external {
        require(to_ != address(0),"can not transfer to a zero address");

        delete myNFTs[msg.sender][findById(tokenId_, myNFTs[msg.sender])];

        nft.safeTransferFrom(msg.sender, to_, tokenId_);
        myNFTs[to_].push(tokenId_);

        emit Transfer(msg.sender, to_, tokenId_);
    }

    //nftMint
    function nftMint(uint256 tokenId_,string memory tokenUri_)external{
        require(tokenId_ != 0,"can not mint token zero");
        nft.mint(msg.sender, tokenId_, tokenUri_);

        myNFTs[msg.sender].push(tokenId_);

        emit Mint(msg.sender, tokenId_);
    }

    //find by tokenId
    function findById(uint256 tokenId_,uint256[] memory arr)internal pure returns(uint256){
        for(uint i = 0; i < arr.length; i++){
            if(arr[i] == tokenId_){
                return i;
            }
        }
        revert("have no token");
    }

    //find by nft
    function findByNFT(uint256 tokenId_,Order[] memory arr)internal pure returns(uint256){
        for(uint i = 0; i < arr.length; i++){
            if(arr[i].tokenId == tokenId_){
                return i;
            }
        }
        revert("have no token");
    }

    //get token url
    function getTokenUrl(uint256 tokenId_)public view returns(string memory){
        return nft._tokenURI(tokenId_);
    }

    //get mynft
    function getMyNft()external view returns(uint256[] memory){
        return myNFTs[msg.sender];
    }

    //get myLists
    function getMyList()external view returns(Order[] memory){
        return myLists[msg.sender];
    }

    //get all lists
    function getTotalList()external view returns(Order[] memory){
        return totalOrders;
    }

    //onERC721Received实现这个标准，申明不是黑洞合约
    function onERC721Received(
        address operator,
        address from,
        uint tokenId,
        bytes calldata data /* _data */
    )external pure override returns(bytes4){
        //这几个require都可以去掉，主要是避免warning
        require(operator != address(0),"wrong 1");
        require(from != address(0),"wrong 2");
        require( tokenId < 1000,"wring 3");
        require(data.length >= 0,"wrong 4");
        return IERC721Receiver.onERC721Received.selector;
    }
}