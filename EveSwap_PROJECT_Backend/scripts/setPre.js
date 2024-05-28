const { ethers } = require("hardhat");

const {ERC20ABI} = require("../ABI/ERC20ABI.js");
const {factoryABI} = require("../ABI/factoryABI.js");
const {marketABI} = require("../ABI/marketABI.js");

// const provider = new ethers.providers.JsonRpcProvider("https://sepolia.infura.io/v3/2f7950c8e3c74b82a80a11be343ed9fe");
// const signerPrivateKey = "";
// const signer = new ethers.Wallet(signerPrivateKey, provider);

const provider = new ethers.getDefaultProvider();

let btc = "0x5FbDB2315678afecb367f032d93F642f64180aa3";

async function approveToken(){
  let BTC = new ethers.Contract(btc, ERC20ABI, provider);
  // USDT = new ethers.Contract(usdt, ERC20ABI, provider);
  // let usdtS = await USDT.symbol();
  // let btcS = await BTC.symbol();
  console.log(BTC);
}
