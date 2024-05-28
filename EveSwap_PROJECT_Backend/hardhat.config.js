require("@nomicfoundation/hardhat-toolbox");


const PRIVATE_KEY1 = "";

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.24",
  networks: {
    goerli: {
      url: "https://eth-goerli.api.onfinality.io/public",
      accounts: [PRIVATE_KEY1],
      chainId: 5,
    },
    Sepolia: {
      url: "https://sepolia.infura.io/v3/2f7950c8e3c74b82a80a11be343ed9fe",
      accounts: [PRIVATE_KEY1],
      chainId: 11155111,
    },
  }
};
