<template>
    <div id = "addLiquidity">
    <div id = "addLiquidity-selectToken">
      <select v-model="selected" @blur="getPairs()" id="addLiquidity-selectToken-select">
      <option disabled value="">Please select coin to swap</option>
      <option v-for="item in tokenPairs" :key="item" :value="item"><strong>{{ item }}</strong></option>
      </select>
      <div id="addLiquidity-selectToken-context">Token Pair: <strong>{{ selected }}</strong></div>

      <div id="addLiquidity-selectToken-attention">Note: The two values you enter are the liquidity of the first token you want to add Token0 and the second token Token1, and you will get a certain amount of Share tokens as your liquidity certificate!</div>

      <div id="addLiquidity-selectToken-token0">
        <div id="addLiquidity-selectToken-token0-show"><p><strong>TOKEN0 :</strong></p></div>
        <input id="addLiquidity-selectToken-token0-input" type="text" v-model="amountToAddToken0" placeholder="       Please input token0's amount...">
      </div>

      <div id="addLiquidity-selectToken-token1">
        <div id="addLiquidity-selectToken-token1-show"><p><strong>TOKEN1 :</strong></p></div>
        <input id="addLiquidity-selectToken-token1-input" type="text" v-model="amountToAddToken1" placeholder="       Please input token1's amount...">
      </div>

      <div id="addLiquidity-selectToken-add" @click="addLiquidity()">
        <p><strong>ADD LIQUIDITY</strong></p>
      </div>
    </div>

    <img id = "addLiquidity-img" src="https://i.postimg.cc/sgSF85WY/194928f3-1dfb-499b-b3fc-99bb03e13211.jpg">
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
        ConMarket:"",
        ConFactory:"",
        tokenPairs:["BTC / USDT","ETH / USDT"],
        selected:"",
        token0Address:"",
        token1Address:"",
        amountToAddToken0:"",
        amountToAddToken1:"",
        token:{
          ConToken0:"",
          ConToken1:""
        }
      }
    },
    methods:{
      async addLiquidity(){
        try {
        this.getTokenAddress();
        //approve
        this.createConToken();
        let amount0 = utils.parseUnits(this.amountToAddToken0,0);
        let amount1 = utils.parseUnits(this.amountToAddToken1,0);
        console.log(amount0,amount1);
        let tx1 = await this.token.ConToken0.approve(marketAddress,amount0);
        let tx2 = await this.token.ConToken1.approve(marketAddress,amount1);
        //add liquidity
        console.log(this.token.ConToken0,this.token.ConToken1);
        console.log(this.token0Address,this.token1Address);

        let tx3 = await market.addLiquidityTokenToToken(
          this.token0Address,
          this.token1Address,
          amount0,
          amount1,
          {gasLimit:30000000}
        );
        //back state
        this.token0Address = "",
        this.token1Address = "",
        this.token.ConToken0 = "",
        this.token.ConToken1 = "",
        this.amountToAddToken0 = "",
        this.amountToAddToken1 = ""
        } catch (error) {
          window.alert("Add liquidity error!Wrong input!");
        }
      },
      async getTokenAddress(){
        const resule = await factory.getTokenToTokenByPairName(this.selected);
        this.token0Address = result[0];
        this.token1Address = result[1];
      },
      async createConToken(){
        this.token.ConToken0 = new ethers.Contract(this.token0Address,ERC20ABI,signer);
        this.token.ConToken1 = new ethers.Contract(this.token1Address,ERC20ABI,signer);
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
      }
    },
    created(){
      this.getPairs();
    }
  }
</script>

<style>
#addLiquidity{
  width: 879px;
  height: 640px;
  margin: 20px;
  border: 3px solid rgb(42, 41, 41);
  background-color:#F7C001;
  box-shadow: 0px 10px 20px rgba(78, 72, 68, 0.961);/* 盒子阴影 */
  border-radius: 10px;/* 盒子角变圆 */
  display: flex;/* 确保里面的nft可以并排展示 */
}
#addLiquidity-selectToken{
  width: 380px;
  height: 400px;
  margin:10px;
  /* border: 3px solid rgb(42, 41, 41); */
  background-color:#F7C001;
  border-radius: 10px;/* 盒子角变圆 */
}

#addLiquidity-selectToken-select{
  width: 200px;
  height: 40px;
  margin: 10px;
  border: 3px solid rgb(42, 41, 41);
  background-color:#F7C001;
  box-shadow: 0px 10px 20px rgba(78, 72, 68, 0.961);/* 盒子阴影 */
  border-radius: 10px;/* 盒子角变圆 */
  color:rgb(101, 106, 111);
}
#addLiquidity-selectToken-select:hover {
  background-color: #a98f1e; /* 鼠标移入时的颜色 */
}

#addLiquidity-selectToken-context{
  width: 200px;
  height: 30px;
  margin: 10px;
  background-color:#F7C001;
  font-style:oblique; /* 让字体变得飘逸 */
}

#addLiquidity-img{
  width:420px;
  height:470px;
  margin: 40px;
  background-color:rgb(114, 101, 101);
  border-radius: 10px;/* 盒子角变圆 */
  box-shadow: 0px 10px 20px rgba(113, 98, 42, 0.961);/* 盒子阴影 */
}

#addLiquidity-selectToken-attention{
  width: 400px;
  height: 90px;
  margin: 10px;
  margin-top: 20px;
  background-color:#F7C001;
  border-radius: 10px;/* 盒子角变圆 */
  font-style:oblique; /* 让字体变得飘逸 */
  color:rgb(101, 106, 111);
}

#addLiquidity-selectToken-token0{
  width: 400px;
  height: 70px;
  margin: 10px;
  margin-top: 30px;
  background-color:#F7C001;
  border-radius: 10px;/* 盒子角变圆 */
  display: flex;/* 确保里面的nft可以并排展示 */
}
#addLiquidity-selectToken-token0-show{
  width: 100px;
  height: 50px;
  margin: 10px;
  background-color:#F7C001;
  border-radius: 10px;/* 盒子角变圆 */
  font-style:oblique; /* 让字体变得飘逸 */
}
#addLiquidity-selectToken-token0-input{
  width: 300px;
  height: 45px;
  margin: 10px;
  border: 3px solid rgb(42, 41, 41);
  background-color:#F7C001;
  box-shadow: 0px 10px 20px rgba(78, 72, 68, 0.961);/* 盒子阴影 */
  border-radius: 10px;/* 盒子角变圆 */
  font-style:oblique; /* 让字体变得飘逸 */
}

#addLiquidity-selectToken-token1{
  width: 400px;
  height: 70px;
  margin: 10px;
  margin-top: 20px;
  background-color:#F7C001;
  border-radius: 10px;/* 盒子角变圆 */
  display: flex;/* 确保里面的nft可以并排展示 */
}
#addLiquidity-selectToken-token1-show{
  width: 100px;
  height: 50px;
  margin: 10px;
  background-color:#F7C001;
  border-radius: 10px;/* 盒子角变圆 */
  font-style:oblique; /* 让字体变得飘逸 */
}
#addLiquidity-selectToken-token1-input{
  width: 300px;
  height: 45px;
  margin: 10px;
  border: 3px solid rgb(42, 41, 41);
  background-color:#F7C001;
  box-shadow: 0px 10px 20px rgba(78, 72, 68, 0.961);/* 盒子阴影 */
  border-radius: 10px;/* 盒子角变圆 */
  font-style:oblique; /* 让字体变得飘逸 */
}
#addLiquidity-selectToken-add{
  width: 380px;
  height: 70px;
  margin-left: 20px;
  margin-top: 20px;
  border: solid;
  background-color:#e0b310;
  border-radius: 10px;/* 盒子角变圆 */
  font-style:oblique; /* 让字体变得飘逸 */
  text-align: center;
  font-size:larger;
  transition: background-color 0.1s; /* 添加过渡效果 */
  box-shadow: 0px 10px 20px rgba(78, 72, 68, 0.961);/* 盒子阴影 */
}

#addLiquidity-selectToken-add:hover {
  background-color: #a98f1e; /* 鼠标移入时的颜色 */
}
</style>