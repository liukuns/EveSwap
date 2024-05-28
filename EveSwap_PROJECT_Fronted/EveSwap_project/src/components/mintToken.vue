<template>
  <div id = "mintToken">
  <div id = "mintToken-selectToken">

    <div id="mintToken-selectToken-address">
      <div id="mintToken-selectToken-address-show"><p>TOKEN :</p></div>
      <input id="mintToken-selectToken-address-input" @blur="update()" type="text" v-model="mintAddress" placeholder="       Please input ERC20 address">
    </div>

    <div id="mintToken-selectToken-attention">Note: Only whitelisted users can mint ERC20 tokens on the exchange. Enter the ERC20 token contract address and the amount of Mint, and you will receive a transfer!</div>

    <div id="mintToken-selectToken-balance">
      <div id="mintToken-selectToken-balance-show">Balance: <strong>{{ this.tokenBalance }}</strong></div>
    </div>

    <div id="mintToken-selectToken-amount">
      <div id="mintToken-selectToken-amount-show"><p>AMOUNT:</p></div>
      <input id="mintToken-selectToken-amount-input" type="text" v-model="mintAmount" placeholder="       Please input mint amount...">
    </div>

    <div id="mintToken-selectToken-mint"  @click="mintToken()">
      <p><strong>MINT ERC20</strong></p>
    </div>
  </div>

  <img id = "mintToken-img" src="https://i.postimg.cc/vHbWZYjF/b0a9fd0c-6bdc-4cbf-8b7c-77b4b1f8ac02.jpg">
</div>
</template>

<script>
  import {ERC20ABI} from "../assets/ERC20ABI.js";
  import {ethers} from "ethers";
  import {utils} from "ethers";

  //获取合约的ABI
  const contractABI = ERC20ABI;

  export default{
    data(){
      return{
        //0xffABc54D5E7f4e7EFBaa563dBB0CA4F42Af89B77
        mintAddress:"",
        mintAmount:"",
        tokenBalance:"",
        token:""
      }
    },
    methods:{
      async createContract(){
        try {
          //获取合约的地址
          let contractAddress = this.mintAddress;
          //获取合约的ABI
          let ABI = contractABI;
          //创建ERC20合约的实例
          let provider = await new ethers.providers.Web3Provider(window.ethereum);
          let signer = await provider.getSigner();
          this.token = await new ethers.Contract(contractAddress,ABI,signer);
        } catch (error) {
          console.log("createContract error");
        }
      },
      async getBalance(){
        try {
          await this.createContract();
          let symbol = await this.token.symbol();
          let balance = await this.token.balanceOf(this.countAddress);
          this.tokenBalance = balance + symbol;
        } catch (error) {
          window.alert("Get balance error!")
        }
      },
      async mintToken(){
        try {
          await this.createContract();
          let amount = utils.parseUnits(this.mintAmount, 0);
          let tx = await this.token.mint(amount);
          console.log(tx);
          this.getBalance();
          this.mintToken = "";
        } catch (error) {
          window.alert("Mint error,Please input right number or address!");
        }
      },
      async update(){
        this.getBalance();
      }
    },
    props:["countAddress"],
  }
</script>


<style>
#mintToken{
  width: 879px;
  height: 640px;
  margin: 20px;
  border: 3px solid rgb(42, 41, 41);
  background-color:#F7C001;
  box-shadow: 0px 10px 20px rgba(78, 72, 68, 0.961);/* 盒子阴影 */
  border-radius: 10px;/* 盒子角变圆 */
  display: flex;/* 确保里面的nft可以并排展示 */
}
#mintToken-selectToken{
  width: 380px;
  height: 400px;
  margin:10px;
  /* border: 3px solid rgb(42, 41, 41); */
  background-color:#F7C001;
  border-radius: 10px;/* 盒子角变圆 */
}
#mintToken-selectToken-attention{
  width: 400px;
  height: 90px;
  margin: 15px;
  margin-top: 20px;
  background-color:#F7C001;
  border-radius: 10px;/* 盒子角变圆 */
  font-style:oblique; /* 让字体变得飘逸 */
  color:rgb(101, 106, 111);
}
#mintToken-selectToken-balance{
  width: 380px;
  height: 70px;
  margin: 10px;
  margin-top: 20px;
  background-color:#F7C001;
  border-radius: 10px;/* 盒子角变圆 */
}

#mintToken-selectToken-balance-show{
  width: 300px;
  height: 50px;
  margin-left: 10px;
  background-color:#F7C001;
  border-radius: 10px;/* 盒子角变圆 */
  font-style:oblique; /* 让字体变得飘逸 */
}
#mintToken-img{
  width:420px;
  height:440px;
  margin: 40px;
  background-color:rgb(114, 101, 101);
  border-radius: 10px;/* 盒子角变圆 */
  box-shadow: 0px 10px 20px rgba(113, 98, 42, 0.961);/* 盒子阴影 */
}
#mintToken-selectToken-address{
  width: 400px;
  height: 70px;
  margin: px;
  margin-top: 20px;
  background-color:#F7C001;
  border-radius: 10px;/* 盒子角变圆 */
  display: flex;/* 确保里面的nft可以并排展示 */
  text-align: center;
}
#mintToken-selectToken-address-show{
  width: 100px;
  height: 50px;
  margin: 10px;
  background-color:#F7C001;
  border-radius: 10px;/* 盒子角变圆 */
  font-style:oblique; /* 让字体变得飘逸 */
}
#mintToken-selectToken-address-input{
  width: 300px;
  height: 45px;
  margin: 10px;
  border: 3px solid rgb(42, 41, 41);
  background-color:#F7C001;
  box-shadow: 0px 10px 20px rgba(78, 72, 68, 0.961);/* 盒子阴影 */
  border-radius: 10px;/* 盒子角变圆 */
  font-style:oblique; /* 让字体变得飘逸 */
}
#mintToken-selectToken-amount{
  width: 400px;
  height: 70px;
  margin: 10px;
  margin-top: 10px;
  background-color:#F7C001;
  border-radius: 10px;/* 盒子角变圆 */
  display: flex;/* 确保里面的nft可以并排展示 */
}
#mintToken-selectToken-amount-show{
  width: 100px;
  height: 50px;
  margin: 10px;
  background-color:#F7C001;
  border-radius: 10px;/* 盒子角变圆 */
  font-style:oblique; /* 让字体变得飘逸 */
}
#mintToken-selectToken-amount-input{
  width: 300px;
  height: 45px;
  margin: 10px;
  border: 3px solid rgb(42, 41, 41);
  background-color:#F7C001;
  box-shadow: 0px 10px 20px rgba(78, 72, 68, 0.961);/* 盒子阴影 */
  border-radius: 10px;/* 盒子角变圆 */
  font-style:oblique; /* 让字体变得飘逸 */
}
#mintToken-selectToken-mint{
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
#mintToken-selectToken-mint:hover {
  background-color: #a98f1e; /* 鼠标移入时的颜色 */
}
</style>