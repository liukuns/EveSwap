require("@nomicfoundation/hardhat-toolbox");


const PRIVATE_KEY1 = "3d7817e911c0c438856ce042c86dc4bd79c9db99034f7f8a64aa2e36843a2e72";

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
