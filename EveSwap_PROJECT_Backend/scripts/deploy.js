const { ethers } = require("hardhat");

const btc = "0xEA498C20E69327e4a2741F7595fA620d23D01d08";
const usdt = "0xffABc54D5E7f4e7EFBaa563dBB0CA4F42Af89B77";
// Factory :0x4b3c11A88C53c3E28bbB17b3A7753bdBf53fF27c
// market :0x822DC8d6C79584E3426e6eF4BE23F86bef89BDBf

async function deploy(){
    //部署BTC合约，获取合约地址
    let bitcoin = await ethers.getContractFactory("EveSwapERC20");
    let BTC = await bitcoin.deploy("bitcoin","BTC");
    await BTC.waitForDeployment();
    addressBTC = await BTC.getAddress();
    console.log(`BTC : ${addressBTC}`);

    //部署ETH合约，获取合约地址
    let ethereum = await ethers.getContractFactory("EveSwapERC20");
    let ETH = await ethereum.deploy("ethereum","ETH");
    await ETH.waitForDeployment();
    const addressETH = await ETH.getAddress();
    console.log(`ETH : ${addressETH}`);

    //部署factory合约，获得合约地址
      let factory = await ethers.getContractFactory("EveSwapFactory");
      let Factory = await factory.deploy();
      await Factory.waitForDeployment();
      const addressFactory = await Factory.getAddress();
      console.log(`Factory :${addressFactory}`);

    //部署market合约，获得合约地址
    try {
      let market = await ethers.getContractFactory("EveSwapMarket");
      let Market = await market.deploy(addressFactory);
      await Market.waitForDeployment();
      const addressMarket = await Market.getAddress();
      console.log(`market :${addressMarket}`);
    } catch (error) {
      console.log("market deploy error");
      console.log(error)
    }

    try {
      let myNFT = await ethers.getContractFactory("myArtNFT");
      const MyNFT = await myNFT.deploy(
        "monster nft",
        "MONSTER",
        "0x822DC8d6C79584E3426e6eF4BE23F86bef89BDBf",
        "0xffABc54D5E7f4e7EFBaa563dBB0CA4F42Af89B77"
      );
      await MyNFT.waitForDeployment();
      let nftAdd = await MyNFT.getAddress();
      console.log(`MyNFT : ${nftAdd}`);
    } catch (error) {
      console.log(error);
    }
}

async function getAddressOfUSDT(){
  const bigAdd = 0xfE00000000000000000000000000000000000000;
  let targetAdd = 0;
  let count = 0;

  while(targetAdd < bigAdd){
        //部署BTC合约，获取合约地址
        let usdt = await ethers.getContractFactory("EveSwapERC20");
        let USDT = await usdt.deploy("usdt","USDT");
        await USDT.waitForDeployment();
        count++;
        targetAdd = await USDT.getAddress();
        console.log(`USDT : ${targetAdd}`);
  }
  console.log(count);
}

deploy();