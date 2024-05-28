// const {expect} = require("chai");
// const {ethers} = require("hardhat");

// describe("NFTSwap Contract Test",function(){
//   let myArtNFT, NFTSwap, account1, account2;
//   let baseURI = "https://ipfs/";
//   let tokenId = 1;
//   let tokenURI = baseURI + tokenId;

//   beforeEach(async() =>{
//     //准备两个测试用的账户
//     [account1,account2] = await ethers.getSigners();
    
//     //部署myArtNFT合约
//     const MyArtNFT = await ethers.getContractFactory("myArtNFT");
//     myArtNFT = await MyArtNFT.deploy("SwapArtofNFT","SA-NFT")
//     await myArtNFT.waitForDeployment();

//     //部署NFTSwap合约
//     const NFTswap = await ethers.getContractFactory("NFTSwap");
//     NFTSwap = await NFTswap.deploy(myArtNFT.getAddress());
//     await NFTSwap.waitForDeployment();

//     //account1 mint一个nft 用来做测试(这段代码已经测试过)
//     await NFTSwap.connect(account1).mintNFT(tokenId,tokenURI);
//     expect(account1.address).to.equal(await myArtNFT.ownerOf(tokenId));
//   });

//   //transfer
//   it("account1 transfer the tokenid 1 to the account2",async() =>{
//     await NFTSwap.connect(account1).transfer(account2.address,tokenId);
//     let owner = await myArtNFT.ownerOf(tokenId);
//     expect(account2).to.equal(owner);
//   });

//   //list
//   it("account1 list the tokenid 1 to the market",async() =>{
//     let price = 5000000000000000;//0.05个eth
//     await NFTSwap.connect(account1).list(tokenId,price);
//     owner = await myArtNFT.ownerOf(tokenId);
//     expect(await NFTSwap.getAddress()).to.equal(owner);
//   });

//   //purchase
//   it("accoutn2 purchase the account's list of token1 ",async() => {
//     let price = 5000000000000000;//0.05个eth
//     await NFTSwap.connect(account1).list(tokenId,price);
//     let pay = 6000000000000000//0.06个eth,
//     await NFTSwap.connect(account2).purchase(tokenId,{value: pay});//{value:}里面单位为wei
//     let owner = await myArtNFT.ownerOf(tokenId)
//     expect(await account2.address).to.equal(owner);
//   });

//   //update
//   it("account1 update the price to the 7000000000000000",async() =>{
//     let price = 5000000000000000;//0.05eth
//     await NFTSwap.connect(account1).list(tokenId,price);
//     let newPrice = 7000000000000000//0.07 eth
//     await NFTSwap.connect(account1).update(tokenId,newPrice);
//     let pay = 6000000000000000;//0.06eth
//     try{
//       await NFTSwap.connect(account2).purchase(tokenId,{value:pay});
//     }catch(err){
//       expect(err.message).to.include("without enough ETH");
//     }
//   });
  
//   //revoke
//   it("account1 revoek the list of the token1",async() =>{
//     let price = 5000000000000000;//0.05eth
//     await NFTSwap.connect(account1).list(tokenId,price);
//     it("revoke success",async() =>{
//       try{
//         await NFTSwap.connect(account1).revoke(tokenId);
//         let owner = await myArtNFT.ownerOf(tokenId);
//       }catch(err){
//         expect(owner).to.equal(await account1.address);
//       }
//     });
//     it("revoke fail",async() =>{
//       try {
//         await NFTSwap.connect(account2).revoke(tokenId);
//       } catch (err) {
//         expect(err.message).to.include("have no right to revoke order");
//       }
//     });
//   });
// });