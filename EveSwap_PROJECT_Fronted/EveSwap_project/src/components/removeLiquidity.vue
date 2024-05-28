<template>
  <div id = "removeLiquidity">
    <div id = "removeLiquidity-selectToken">
      <select v-model="selected" id="removeLiquidity-selectToken-select" @blur="getShare()">
      <option disabled value="" id="removeLiquidity-selectToken-input">Please select coin to swap</option>
      <option v-for="item in tokenPairs" :key="item" :value="item"><strong>{{ item }}</strong></option>
      </select>
      <div id="removeLiquidity-selectToken-context">Token Pair: <strong>{{ selected }}</strong></div>

      <div id="removeLiquidity-selectToken-attention">Note: you can burn based on the amount of shares you entered, so that the liquidity of the corresponding trading pair is reduced. At the same time, the corresponding liquidity token will be returned to you! 
      </div>

      <div id="removeLiquidity-selectToken-share">
        <div id="removeLiquidity-selectToken-share-rate">Share Rate: <strong>{{ shareRate }}</strong></div>
        <div id="removeLiquidity-selectToken-share-amount">Share Amount: <strong>{{ shareAmount }}</strong></div>
      </div>

      <div id="removeLiquidity-selectToken-remove">
        <button id="removeLiquidity-selectToken-remove-click" @click="remove()"><strong>REMOVE</strong></button>
        <input id="removeLiquidity-selectToken-remove-input" type="text" v-model="amountToRemove" placeholder="       Please input amount to remove...">
      </div>
    </div>

    <img id = "removeLiquidity-img" src="https://i.postimg.cc/qq57qpb8/add55dc2-23a5-457f-a992-676089777dc1.jpg">
  </div>
</template>

<script>
  import Swal from 'sweetalert2';
  import {ethers} from "ethers";
  import {utils} from "ethers";
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
        tokenPairs:["BTC / USDT","ETH / USDT"],
        selected:"",
        amountToRemove:"",
        shareAmount:26217,
        shareRate:"76 %"
      }
    },
    methods:{
      async remove(){
        try {
          let amount = utils.parseUnits(this.amountToRemove,0);
          const tx = await market.removeLiquidityByName(this.selected,amount,{gasLimit:30000000});
          const txR = await tx.wait();
          console.log(txR);
          this.getShare();
        } catch (error) {
          window.alert("Remove fail,Please try again!");
        }
      },
      async getShare(){
        const result = await factory.getProportionOfOwner(this.selected,{gasLimit:30000000});
        console.log(result);
        // this.shareRate = result[0] + "%";
        // this.shareAmount = result[1];
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
.custom-alert{
  /* Your custom styles here */
  /* For example: */
  background-color: #e22828;
  border: 1px solid #e40e0e;
  border-radius: 5px;
  padding: 20px;
}
#removeLiquidity{
  width: 879px;
  height: 640px;
  margin: 20px;
  border: 3px solid rgb(42, 41, 41);
  background-color:#F7C001;
  box-shadow: 0px 10px 20px rgba(78, 72, 68, 0.961);/* 盒子阴影 */
  border-radius: 10px;/* 盒子角变圆 */
  display: flex;/* 确保里面的nft可以并排展示 */
}
#removeLiquidity-selectToken{
  width: 380px;
  height: 400px;
  margin:10px;
  /* border: 3px solid rgb(42, 41, 41); */
  background-color:#F7C001;
  border-radius: 10px;/* 盒子角变圆 */
}
#removeLiquidity-selectToken-select{
  width: 200px;
  height: 40px;
  margin: 10px;
  border: 3px solid rgb(42, 41, 41);
  background-color:#F7C001;
  box-shadow: 0px 10px 20px rgba(78, 72, 68, 0.961);/* 盒子阴影 */
  border-radius: 10px;/* 盒子角变圆 */
  color:rgb(101, 106, 111);
}
#removeLiquidity-selectToken-select:hover {
  background-color: #a98f1e; /* 鼠标移入时的颜色 */
}

#removeLiquidity-selectToken-context{
  width: 200px;
  height: 30px;
  margin: 10px;
  background-color:#F7C001;
  font-style:oblique; /* 让字体变得飘逸 */
}

#removeLiquidity-img{
  width:420px;
  height:440px;
  margin: 40px;
  background-color:rgb(114, 101, 101);
  border-radius: 10px;/* 盒子角变圆 */
  box-shadow: 0px 10px 20px rgba(113, 98, 42, 0.961);/* 盒子阴影 */
}
#removeLiquidity-selectToken-attention{
  width: 400px;
  height: 90px;
  margin: 10px;
  margin-top: 50px;
  background-color:#F7C001;
  border-radius: 10px;/* 盒子角变圆 */
  font-style:oblique; /* 让字体变得飘逸 */
  color:rgb(101, 106, 111);
}
#removeLiquidity-selectToken-remove{
  width: 400px;
  height: 70px;
  margin: 10px;
  margin-top: 40px;
  background-color:#F7C001;
  border-radius: 10px;/* 盒子角变圆 */
  display: flex;/* 确保里面的nft可以并排展示 */
}

#removeLiquidity-selectToken-remove-click{
  width: 100px;
  height: 50px;
  margin: 10px;
  border: 3px solid rgb(42, 41, 41);
  background-color:#d4a911;
  box-shadow: 0px 10px 20px rgba(78, 72, 68, 0.961);/* 盒子阴影 */
  border-radius: 10px;/* 盒子角变圆 */
  font-style:oblique; /* 让字体变得飘逸 */
}
#removeLiquidity-selectToken-remove-click:hover {
  background-color: #a98f1e; /* 鼠标移入时的颜色 */
}

#removeLiquidity-selectToken-remove-input{
  width: 300px;
  height: 45px;
  margin: 10px;
  border: 3px solid rgb(42, 41, 41);
  background-color:#F7C001;
  box-shadow: 0px 10px 20px rgba(78, 72, 68, 0.961);/* 盒子阴影 */
  border-radius: 10px;/* 盒子角变圆 */
  font-style:oblique; /* 让字体变得飘逸 */
}

#removeLiquidity-selectToken-share{
  width: 380px;
  height: 70px;
  margin: 10px;
  margin-top: 60px;
  background-color:#F7C001;
  border-radius: 10px;/* 盒子角变圆 */
}

#removeLiquidity-selectToken-share-rate{
  width: 300px;
  height: 50px;
  margin-left: 10px;
  background-color:#F7C001;
  border-radius: 10px;/* 盒子角变圆 */
  font-style:oblique; /* 让字体变得飘逸 */
}

#removeLiquidity-selectToken-share-amount{
  width: 300px;
  height: 45px;
  margin-left: 10px;
  background-color:#F7C001;
  border-radius: 10px;/* 盒子角变圆 */
  font-style:oblique; /* 让字体变得飘逸 */
}
</style>