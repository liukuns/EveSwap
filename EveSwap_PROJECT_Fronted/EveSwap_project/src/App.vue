<template>

  <div id = "mainPage">
    <div id = "mainPage-head">
      <p id = "mainPage-head-title"><strong>EVE SWAP</strong></p>
      <button id="mainPage-head-connectWallet" @click="connectWallet"> 
        <strong>{{ connectWalletContent }}</strong>
      </button>
    </div>

    <div id = "mainPage-body">
      <div id="mainPage-body-k">
        <kLainChart/>
      </div>

      <div id = "mainPage-body-op">
        <div id = "mainPage-body-op-head">
          <button id = "mainPage-body-head-swapToken" @click="toSwap()"><strong>SWAP</strong></button>
          <button id = "mainPage-body-head-add" @click="toAddLiquidity()"><strong>ADD-LP</strong></button>
          <button id = "mainPage-body-head-remove" @click="toRemoveLiquidity()"><strong>REMOVE-LP</strong></button>
          <button id = "mainPage-body-head-mint" @click="toMintToken()"><strong>MINT-ERC20</strong></button>
          <button id = "mainPage-body-head-mintERC404" @click="toMintERC404Token()"><strong>MINT-ERC404</strong></button>
        </div>

        <component :is="currentComponent" :countAddress="connectAccount"></component>
      </div>
    </div>
  </div>
</template>

<script>
  import {ethers} from "ethers";
  import {marketABI} from "./assets/marketABI.js";
  import kLainChart from "./components/kLainChart.vue";
  import addLiquidity from "./components/addliquidity.vue";
  import removeLiquidity from "./components/removeLiquidity.vue";
  import swapToken from "./components/swapToken.vue";
  import KLainChart from "./components/kLainChart.vue";
  import mintToken from "./components/mintToken.vue";
  import mintERC404 from "./components/mintERC404.vue";

  // BTC : 0xEA498C20E69327e4a2741F7595fA620d23D01d08
  // ETH : 0xB50641Fc310f50c2eca07E393CeF238e028c04d0
  // USDT : 0xffABc54D5E7f4e7EFBaa563dBB0CA4F42Af89B77
  // Factory :0x4b3c11A88C53c3E28bbB17b3A7753bdBf53fF27c
  // market :0x822DC8d6C79584E3426e6eF4BE23F86bef89BDBf

  //合约的地址
  const swapMarketAddress = "0x822DC8d6C79584E3426e6eF4BE23F86bef89BDBf";
  //合约的ABI
  const MarketABI = marketABI;
  //获得一个web3Provider,可以实现与用户与MetaMask钱包签名的交互
  const provider = new ethers.providers.Web3Provider(window.ethereum);
  //获得签名
  const signer = provider.getSigner();

  export default{
    data(){
      return{
        swapMarket:"",
        connectWalletContent:"Con-Wallet",
        connectAccount:"",//用户当前使用的钱包地址
        accounts:[],//用后授权的钱包地址数组
        currentComponent:'swapToken',
      }
    }, 
    methods:{
      connectWallet(){
        if(this.connectWalletContent === "Con-Wallet"){
          window.ethereum.enable().then((accounts) =>{
            this.accounts = accounts;
          })
        }
      },
      getAddressShortString(addre){
        let firstFour = addre.substring(0,6);
        let lastThere = addre.substring(addre.length -3);
        this.connectWalletContent = firstFour + "..." + lastThere;
      },
      toSwap(){
        this.currentComponent = swapToken;
      },
      toRemoveLiquidity(){
        this.currentComponent = removeLiquidity;
      },
      toAddLiquidity(){
        this.currentComponent = addLiquidity;
      },
      toMintToken(){
        this.currentComponent = mintToken;
      },
      toMintERC404Token(){
        this.currentComponent = mintERC404;
      },
    },
    components:{
      kLainChart,
      addLiquidity,
      removeLiquidity,
      swapToken,
      mintToken,
      mintERC404
    },
    created() {
      // 监听检查账户列表信息
      setInterval(() => {
        provider.listAccounts().then(async(accounts) => {
          const selectAddress = await window.ethereum.selectedAddress;
          //处理用户断开所有连接和钱包地址不是一个授权地址
          if (accounts.length === 0 || !accounts.map(a => a.toLowerCase().includes(selectAddress.toLowerCase()))) {
            this.connectWalletContent = "Con-Wallet";
          }else{
          //更新用户连接的地址
            this.accounts = accounts;
            this.connectAccount = selectAddress;
            this.getAddressShortString(this.connectAccount);
          }
        });

      }, 3000); // 每0.01秒检查一次 1000为一秒

      // //创建一个新的合约实例
      this.swapMarket = new ethers.Contract(swapMarketAddress,MarketABI,signer);
    }
  }
</script>

<style>
#mainPage{
  width: 100%;
  height: 975px;
  border: 3px solid black;
  background-color:#F7C001;
  display: flex;/* 确保里面的nft可以并排展示 */
  flex-wrap: wrap;/* 确保里面的NFT可以自动换行 */
  overflow: auto; /* 盒子满了可以自动滑动 */
  box-shadow: 0px 10px 20px rgba(78, 72, 68, 0.961);/* 盒子阴影 */
  border-radius: 10px;/* 盒子角变圆 */
}
#mainPage-head{
  width: 100%;
  height: 10%;
  border: 3px solid black;
  margin:20px;
  margin-bottom: 10px;
  background-color:#F7C001;
  display: flex;/* 确保里面的nft可以并排展示 */
  flex-wrap: wrap;/* 确保里面的NFT可以自动换行 */
  box-shadow: 0px 10px 20px rgba(78, 72, 68, 0.961);/* 盒子阴影 */
  border-radius: 10px;/* 盒子角变圆 */
}
#mainPage-body{
  width: 100%;
  height: 83%;
  border: 3px solid black;
  box-shadow: 0px 10px 20px rgba(78, 72, 68, 0.961);/* 盒子阴影 */ 
  margin:20px;
  margin-top: 0px;
  background-color:#F7C001;
  display: flex;/* 确保里面的nft可以并排展示 */
  flex-wrap: wrap;/* 确保里面的NFT可以自动换行 */
  border-radius: 10px;/* 盒子角变圆 */
}
#mainPage-head-title{
  margin-left: 730px;
  margin-top: 25px;
  font-size: 3em; /* 调整字体大小 */
  font-style:oblique; /* 让字体变得飘逸 */
  /* text-shadow: 2px 2px 4px #1a1717; */
  animation: shadow-pulse 1s infinite;/* 动画标签 */
}
/* title的动画 */
    /* @keyframes shadow-pulse
    {
      0% {
        text-shadow: 0 0 10px #cfee07;
      }
      100% {
        text-shadow: 0 0 20px #fafa0a, 0 0 30px #0a0a0a, 0 0 20px #971928;
      }
    } */
#mainPage-head-connectWallet{
  width: 100px;
  height: 50px;
  border: 3px solid rgb(41, 38, 38);
  margin-top: 25px;
  margin-left: 450px;
  background-color:#F7C001;
  box-shadow: 0px 10px 20px rgba(78, 72, 68, 0.961);/* 盒子阴影 */
  border-radius: 10px;/* 盒子角变圆 */
  font-style:oblique; /* 让字体变得飘逸 */
}
#mainPage-head-connectWallet:hover {
  background-color: #a98f1e; /* 鼠标移入时的颜色 */
}

#mainPage-body-k{
  width: 600px;
  height: 770px;
  margin: 20px;
  margin-left: 20px;
  background-color:#F7C001;
  border-radius: 10px;/* 盒子角变圆 */
}

#mainPage-body-op{
  width: 810px;
  height: 750px;
  margin: 20px;
  margin-left: 10px;
  background-color:#F7C001;
  border-radius: 10px;/* 盒子角变圆 */
}

#mainPage-body-op-head{
  width: 750px;
  height: 10vh;
  margin-top: 10px;
  margin-left:30px;
  margin-right: 50px;
  background-color:#F7C001;
  border-radius: 10px;/* 盒子角变圆 */
}

#mainPage-body-head-swapToken{
  width: 100px;
  height: 50px;
  margin-top: 10px;
  border: 3px solid rgb(48, 47, 47);
  background-color:#F7C001;
  box-shadow: 0px 10px 20px rgba(78, 72, 68, 0.961);/* 盒子阴影 */
  border-radius: 10px;/* 盒子角变圆 */
  font-style:oblique; /* 让字体变得飘逸 */
}
#mainPage-body-head-swapToken:hover {
  background-color: #a98f1e; /* 鼠标移入时的颜色 */
}

#mainPage-body-head-add{
  width:100px;
  height: 50px;
  margin-top: 10px;
  margin-left:20px;
  background-color:#F7C001;
  border: 3px solid rgb(48, 47, 47);
  box-shadow: 0px 10px 20px rgba(78, 72, 68, 0.961);/* 盒子阴影 */
  border-radius: 10px;/* 盒子角变圆 */
  font-style:oblique; /* 让字体变得飘逸 */
}
#mainPage-body-head-add:hover {
  background-color: #a98f1e; /* 鼠标移入时的颜色 */
}

#mainPage-body-head-remove{
  width:100px;
  height: 50px;
  margin-top: 10px;
  margin-left:20px;
  border: 3px solid rgb(29, 28, 28);
  background-color:#F7C001;
  box-shadow: 0px 10px 20px rgba(78, 72, 68, 0.961);/* 盒子阴影 */
  border-radius: 10px;/* 盒子角变圆 */
  font-style:oblique; /* 让字体变得飘逸 */
}
#mainPage-body-head-remove:hover {
  background-color: #a98f1e; /* 鼠标移入时的颜色 */
}

#mainPage-body-head-mint{
  width:100px;
  height: 50px;
  margin-top: 10px;
  margin-left:20px;
  border: 3px solid rgb(29, 28, 28);
  background-color:#F7C001;
  box-shadow: 0px 10px 20px rgba(78, 72, 68, 0.961);/* 盒子阴影 */
  border-radius: 10px;/* 盒子角变圆 */
  font-style:oblique; /* 让字体变得飘逸 */
}
#mainPage-body-head-mint:hover {
  background-color: #a98f1e; /* 鼠标移入时的颜色 */
}

#mainPage-body-head-mintERC404{
  width:120px;
  height: 50px;
  margin-top: 10px;
  margin-left:20px;
  border: 3px solid rgb(29, 28, 28);
  background-color:#F7C001;
  box-shadow: 0px 10px 20px rgba(78, 72, 68, 0.961);/* 盒子阴影 */
  border-radius: 10px;/* 盒子角变圆 */
  font-style:oblique; /* 让字体变得飘逸 */
}
#mainPage-body-head-mintERC404:hover {
  background-color: #a98f1e; /* 鼠标移入时的颜色 */
}
</style>
