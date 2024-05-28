// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./myERC721.sol";
import "./EveSwapERC20.sol";
import "./EveSwapMarket.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract myArtNFT is myERC721{
    //定义mint的最大数量
    uint256 constant public MAX_SUPPLY = 1000;
    //定义 token 到 NFT的URI地址的映射
    mapping(uint => string) public _tokenURI;
    //market address
    address market;
    //USDT address
    address usdt;
    //tokenID => erc20
    mapping(uint => address)public getNftToken;

    constructor(string memory name,string memory symbol,address _market,address _usdt) myERC721(name,symbol){
        market = _market;
        usdt = _usdt;
    }

    //mint函数
    function mint(address to,uint tokenId,string memory tokenURI) external {
        require(bytes(tokenURI).length > 0,"tokenURI is a empty string");
        require(to != address(0),"mint address don't be zero address");
        require(tokenId >= 0 && tokenId <MAX_SUPPLY,"tokenId out of ranege");

        //创建对应的代币合约
        address nftToken = address(new EveSwapERC20(name,getName(tokenId)));
        EveSwapERC20(nftToken).mint(1000);
        EveSwapERC20(nftToken).approve(market,1000);
        //拿到对应的USDT合约
        EveSwapERC20(usdt).mint(30000);
        EveSwapERC20(usdt).approve(market,30000);
        //添加流动性
        EveSwapMarket(market).addLiquidityTokenToToken(
            nftToken,
            usdt,
            1000,
            30000
        );
        //创建pair
        getNftToken[tokenId] = nftToken;

        _tokenURI[tokenId] = tokenURI;
        _mint(to, tokenId);
    }

    function getName(uint tokenId)public view returns(string memory name){
        string memory str = Strings.toString(tokenId);
        name = string(abi.encodePacked(symbol,str));
    }
}