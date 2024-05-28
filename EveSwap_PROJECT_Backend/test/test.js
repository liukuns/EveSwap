const {expect} = require("chai");
const {ethers} = require("hardhat");
const {ERC20ABI} = require("../ABI/ERC20ABI.js");

let account1,account2;
let USDT,Factory,Market,MyArtNFT,monster;
let usdtAdd,factoryAdd,marketAdd,myArtNFTAdd;

describe("EveSwap test began!",async() => {

  beforeEach(async() =>{
    [account1,account2] = await ethers.getSigners();
    // 获取合约实例
    monster = await ethers.getContractFactory("EveSwapERC20");

    //get USDT
    // let usdt = await ethers.getContractFactory("EveSwapERC20");
    // USDT = await usdt.deploy("usdt","USDT");
    await deployUSDT();
    usdtAdd = await USDT.getAddress();
    console.log(`USDT :${usdtAdd}`);

    //get factory
    let factory = await ethers.getContractFactory("EveSwapFactory");
    Factory = await factory.deploy();
    await Factory.waitForDeployment();
    factoryAdd = await Factory.getAddress();
    console.log(`Factory :${factoryAdd}`);

    //get market
    let market = await ethers.getContractFactory("EveSwapMarket");
    Market = await market.deploy(factoryAdd);
    await Market.waitForDeployment();
    marketAdd = await Market.getAddress();
    console.log(`market :${marketAdd}`);

    //get myArt
    let myArtNFT = await ethers.getContractFactory("myArtNFT");
    MyArtNFT = await myArtNFT.deploy(
      "monster nft",
      "MONSTER",
      marketAdd,
      usdtAdd
    );
    await MyArtNFT.waitForDeployment();
    myArtNFTAdd = await MyArtNFT.getAddress();
    console.log(`MyArtNFT :${myArtNFTAdd}`);
  });

  //mint
  it("mint nft and add liquidity,reserve bigger than 0",async() =>{
    await MyArtNFT.connect(account1).mint(
      account1,
      0,
      "https:ipfs/aoenvaivunwwveibuw.jpg"
    );
    let pairNames = await Factory.getPairName();
    let name = pairNames[0];
    let pair = await Factory.getPairByName(name);
    let reserve = await Factory.getReserveOfToken(pair);
    let reserves = await reserve[0] + reserve[1];
    expect(name).to.equal("MONSTER0 / USDT");
    expect(reserves).to.equal(31000);
  });

  //swap => buy
  it("account2 to swap 10000 USDT for MONSTER0",async() =>{
    await MyArtNFT.connect(account1).mint(
      account1,
      0,
      "https:ipfs/aoenvaivunwwveibuw.jpg"
    );
    let pairNames = await Factory.getPairName();
    let name = pairNames[0];
    let pairTokens = await Factory.getTokenToTokenByPairName(name);
    let monster0Add = await pairTokens[0];
    const Monster0 = await monster.attach(monster0Add);

    await USDT.connect(account2).mint(10000);
    let balanceU = await USDT.connect(account2).balanceOf(await account2.address);
    await USDT.connect(account2).approve(marketAdd,balanceU);
    await Market.connect(account2).buyTokenByName(
      name,
      balanceU
    );
    let balanceM = await Monster0.balanceOf(await account2.address);
    console.log(`10000 USDT swap MONSTER0 for ${balanceM}`)
    // expect(balanceM).to.be.above(333);
    expect(balanceM).to.be.below(333);
  });

  //swap => sell

  //remove-ERC404

  //add liquidity of token
  //swap liquidit of token
  //remove liquidity of token

});

async function deployUSDT(){
  const bigAdd = 0xfE00000000000000000000000000000000000000;
  let usdt = await ethers.getContractFactory("EveSwapERC20");
  let usdtAdd = 0;

  while(usdtAdd < bigAdd){
        USDT = await usdt.deploy("usdt","USDT");
        await USDT.waitForDeployment();
        usdtAdd = await USDT.getAddress();
  }
}