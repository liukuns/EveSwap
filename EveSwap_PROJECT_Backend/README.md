# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a Hardhat Ignition module that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help

npx hardhat test
REPORT_GAS=true npx hardhat test

#install openzeppelin
npm install @openzeppelin/contracts --save-dev

#运行一个本地的节点
npx hardhat node

#编译合约文件
npx hardhat compile

#测试文件
npx hardhat test

#部署文件 localhost 也可以是hardhat.config.js中的其他配置的网络名称
#如果要部署在本地，必须先运行一个本地节点
npx hardhat run scripts/deploy.js --network localhost


##代码学习错点
1，异步函数调用不加await，会导致函数还没执行完就放后台异步，然后执行下一步去操作
   结果本来执行完的是address类型，把没执行完的promimse类型拿来用了。

2，不同it下的修改的合约状态变量不会相互影响

3，学会了用try catch 来写合约测试 注意是includ不再是equal
   try{
      await NFTSwap.connect(account2).purchase(tokenId,{value:pay});
    }catch(err){
      expect(err.message).to.include("without enough ETH");
    }

BTC : 0xEA498C20E69327e4a2741F7595fA620d23D01d08
ETH : 0xB50641Fc310f50c2eca07E393CeF238e028c04d0
USDT : 0xffABc54D5E7f4e7EFBaa563dBB0CA4F42Af89B77
Factory :0x4b3c11A88C53c3E28bbB17b3A7753bdBf53fF27c
market :0x822DC8d6C79584E3426e6eF4BE23F86bef89BDBf
MyNFT : 0xdc1C2e3179aFC04383268974Bd21469646693307

```




