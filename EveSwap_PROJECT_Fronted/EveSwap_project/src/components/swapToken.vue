<template>
  <div id = "swapToken">
    <div id = "swapToken-selectToken">
      <select v-model="selected" id="swapToken-selectToken-select" @blur="getPrice()">
      <option disabled value="" id="swapToken-selectToken-input">Please select coin to swap</option>
      <option v-for="item in tokenPairs" :key="item" :value="item"><strong>{{ item }}</strong></option>
      </select>
      <div id="swapToken-selectToken-context">Token Pair: <strong>{{ selected }}</strong></div>

      <div id="swapToken-selectToken-attention">Note: You can enter a certain number of tokens as the number of tokens you want to buy, or the number of tokens you want to sell.At the same time, 3/10,000 of the transaction amount will be charged as a handling fee!
      </div>

      <div id="swapToken-selectToken-price">
      <div id="swapToken-selectToken-price-show" @click="getPrice()">Price: <strong>{{ this.tokenPrice }}</strong></div>
     </div>

      <div id="swapToken-selectToken-buy">
        <button id="swapToken-selectToken-buy-click" @click="buy()"><strong>BUY</strong></button>
        <input id="swapToken-selectToken-buy-input" type="text" v-model="amountBuy" placeholder="       Please input amount to buy...">
      </div>
      
      <div id="swapToken-selectToken-sell">
        <button id="swapToken-selectToken-sell-click" @click="sell()"><strong>SELL</strong></button>
        <input id="swapToken-selectToken-sell-input" type="text" v-model="amountSell" placeholder="       Please input amount to buy...">
      </div>
    </div>

    <img id = "swapToken-img" src="https://i.postimg.cc/TYC1LzQ4/8817b5f5-7688-44c8-a7d1-92911d4fd725.jpg">
  </div>
</template>

<script>
  import {ethers} from "ethers";
  import {utils} from "ethers";
  import {ERC20ABI} from "../assets/ERC20ABI.js";
  import {marketABI} from "../assets/marketABI.js";
  import {factoryABI} from "../assets/factoryABI.js";

  const provider = await new ethers.providers.Web3Provider(window.ethereum);
  const signer = await provider.getSigner();

  const marketAddress = "0x822DC8d6C79584E3426e6eF4BE23F86bef89BDBf";
  const factoryAddrees = "0x4b3c11A88C53c3E28bbB17b3A7753bdBf53fF27c";

  const market = new ethers.Contract(marketAddress,marketABI,signer);
  const factory = new ethers.Contract(factoryAddrees,factoryABI,signer);

  export default{
    data(){
      return{
        selected:"",
        tokenPairs:["BTC / USDT","ETH / USDT"],
        amountBuy:"",
        amountSell:"",
        tokenPrice:"69721 USDT/BTC",
        token0Address:"",
        token1Address:"",
        token:{
          ConToken0:"",
          ConToken1:""
        }
      }
    },
    methods:{
      async buy(){
        try {
          let amount = utils.parseUnits(this.amountBuy,0);
          //approve usdt
          this.getTokenAddress();
          this.createConToken();
          let tx1 = await this.token.ConToken1.approve(marketAddress,amount);

          const tx = await market.buyTokenByName(this.selected,amount,{gasLimit:30000000});
          const txR = await tx.wait();
          console.log("buy");
          console.log(txR);
          this.amountBuy = "";
        } catch (error) {
          window.alert("Buy fail!Please input right number");
        }
      },
      async sell(){
        try {
          let amount = utils.parseUnits(this.amountSell,0);
          //approve monster
          this.getTokenAddress();
          this.createConToken();
          let tx1 = await this.token.ConToken0.approve(marketAddress,amount);

          const tx = await market.sellTokenByName(this.selected,amount,{gasLimit:30000000});
          const txR = await tx.wait();
          console.log("sell");
          console.log(txR);
          this.amountSell = "";
        } catch (error) {
          window.alert("Sell fail!Please input right number");
        }
      },
      async getPrice(){
        const result = await factory.getTokenPriceByName(this.selected);
        this.tokenPrice = result[0];
        console.log("get price");
      },
      async getPairs(){
        try {
          const pairs = await factory.getPairName();
          for(let i = 0;i < pairs.length;i++){
            this.tokenPairs.push(pairs[i]);
          }
        } catch (error) {
          console.log("get pairs fail!");
        }
        console.log(this.selected);
        console.log(this.token0Address,this.token1Address);
      },
      async createConToken(){
        this.token.ConToken0 = new ethers.Contract(this.token0Address,ERC20ABI,signer);
        this.token.ConToken1 = new ethers.Contract(this.token1Address,ERC20ABI,signer);
      },
      async getTokenAddress(){
        const resule = await factory.getTokenToTokenByPairName(this.selected);
        this.token0Address = result[0];
        this.token1Address = result[1];
      },
    },
    created(){
      this.getPairs();
    }
  }
</script>

<style>
#swapToken{
  width: 879px;
  height: 640px;
  margin: 20px;
  border: 3px solid rgb(42, 41, 41);
  background-color:#F7C001;
  box-shadow: 0px 10px 20px rgba(78, 72, 68, 0.961);/* 盒子阴影 */
  border-radius: 10px;/* 盒子角变圆 */
  display: flex;/* 确保里面的nft可以并排展示 */
}

#swapToken-selectToken{
  width: 380px;
  height: 400px;
  margin:10px;
  /* border: 3px solid rgb(42, 41, 41); */
  background-color:#F7C001;
  border-radius: 10px;/* 盒子角变圆 */
}
#swapToken-selectToken-select{
  width: 200px;
  height: 40px;
  margin: 10px;
  border: 3px solid rgb(42, 41, 41);
  background-color:#F7C001;
  box-shadow: 0px 10px 20px rgba(78, 72, 68, 0.961);/* 盒子阴影 */
  border-radius: 10px;/* 盒子角变圆 */
  color:rgb(101, 106, 111);
}
#swapToken-selectToken-select:hover {
  background-color: #a98f1e; /* 鼠标移入时的颜色 */
}

#swapToken-selectToken-context{
  width: 200px;
  height: 30px;
  margin: 10px;
  background-color:#F7C001;
  font-style:oblique; /* 让字体变得飘逸 */
}

#swapToken-selectToken-price{
  width: 380px;
  height: 70px;
  margin: 10px;
  margin-top: 40px;
  background-color:#F7C001;
  border-radius: 10px;/* 盒子角变圆 */
}

#swapToken-selectToken-price{
  width: 300px;
  height: 50px;
  margin-left: 10px;
  background-color:#F7C001;
  border-radius: 10px;/* 盒子角变圆 */
  font-style:oblique; /* 让字体变得飘逸 */
}

#swapToken-img{
  width:420px;
  height:440px;
  margin: 40px;
  background-color:rgb(114, 101, 101);
  border-radius: 10px;/* 盒子角变圆 */
  box-shadow: 0px 10px 20px rgba(113, 98, 42, 0.961);/* 盒子阴影 */
}

#swapToken-selectToken-attention{
  width: 400px;
  height: 90px;
  margin: 10px;
  margin-top: 30px;
  background-color:#F7C001;
  border-radius: 10px;/* 盒子角变圆 */
  font-style:oblique; /* 让字体变得飘逸 */
  color:rgb(101, 106, 111)
}

#swapToken-selectToken-buy{
  width: 400px;
  height: 70px;
  margin: 10px;
  margin-top: 10px;
  background-color:#F7C001;
  border-radius: 10px;/* 盒子角变圆 */
  display: flex;/* 确保里面的nft可以并排展示 */
}
#swapToken-selectToken-buy-click{
  width: 100px;
  height: 50px;
  margin: 10px;
  border: 3px solid rgb(42, 41, 41);
  background-color:#d4a911;
  box-shadow: 0px 10px 20px rgba(78, 72, 68, 0.961);/* 盒子阴影 */
  border-radius: 10px;/* 盒子角变圆 */
  font-style:oblique; /* 让字体变得飘逸 */
}
#swapToken-selectToken-buy-click:hover {
  background-color: #a98f1e; /* 鼠标移入时的颜色 */
}
#swapToken-selectToken-buy-input{
  width: 300px;
  height: 45px;
  margin: 10px;
  border: 3px solid rgb(42, 41, 41);
  background-color:#F7C001;
  box-shadow: 0px 10px 20px rgba(78, 72, 68, 0.961);/* 盒子阴影 */
  border-radius: 10px;/* 盒子角变圆 */
  font-style:oblique; /* 让字体变得飘逸 */
}

#swapToken-selectToken-sell{
  width: 400px;
  height: 70px;
  margin: 10px;
  margin-top: 20px;
  background-color:#F7C001;
  border-radius: 10px;/* 盒子角变圆 */
  display: flex;/* 确保里面的nft可以并排展示 */
}
#swapToken-selectToken-sell-click{
  width: 100px;
  height: 50px;
  margin: 10px;
  border: 3px solid rgb(42, 41, 41);
  background-color:#d1a811;
  box-shadow: 0px 10px 20px rgba(78, 72, 68, 0.961);/* 盒子阴影 */
  border-radius: 10px;/* 盒子角变圆 */
  font-style:oblique; /* 让字体变得飘逸 */
}
#swapToken-selectToken-sell-click:hover {
  background-color: #a98f1e; /* 鼠标移入时的颜色 */
}
#swapToken-selectToken-sell-input{
  width: 300px;
  height: 45px;
  margin: 10px;
  border: 3px solid rgb(42, 41, 41);
  background-color:#F7C001;
  box-shadow: 0px 10px 20px rgba(78, 72, 68, 0.961);/* 盒子阴影 */
  border-radius: 10px;/* 盒子角变圆 */
  font-style:oblique; /* 让字体变得飘逸 */
}
</style>