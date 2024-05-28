<template>
  <div id = "mintTERC404">
  <div id = "mintTERC404-selectToken">

    <div id="mintTERC404-selectToken-attention">Note: Whitelisted users can enter the Token ID and URIL of the desired Mint to get an NFT. At the same time, NFT trading liquidity will be automatically added to support trading as an ERC20 token!</div>
    <a id="url" href="https://postimages.org/">Click here to get token url!</a>

    <div id="mintTERC404-selectToken-id">
      <div id="mintTERC404-selectToken-id-show"><p>Token ID:</p></div>
      <input id="mintTERC404-selectToken-id-input" type="text" v-model="tokenId" placeholder="       Please input token id...">
    </div>

    <div id="mintTERC404-selectToken-url">
      <div id="mintTERC404-selectToken-url-show"><p>Token URL:</p></div>
      <input id="mintTERC404-selectToken-url-input" type="text" v-model="tokenUrl" placeholder="       Please input token url...">
    </div>

    <div id="mintTERC404-selectToken-mint"  @click="mintERC404()">
      <p><strong>MINT ERC404</strong></p>
    </div>
  </div>

  <img id = "mintToken-img" src="https://i.postimg.cc/TYC1LzQ4/8817b5f5-7688-44c8-a7d1-92911d4fd725.jpg">
</div>
</template>

<script>
  import {myArtNFTABI} from "../assets/myArtNFTABI.js";
  import {ethers} from "ethers";
  import {utils} from "ethers";

  const myArtNFTAdd = "0xdc1C2e3179aFC04383268974Bd21469646693307";

  const provider = await new ethers.providers.Web3Provider(window.ethereum);
  const signer = await provider.getSigner();

  const myArtNFT = new ethers.Contract(myArtNFTAdd,myArtNFTABI,signer);

  export default{
    data(){
      return{
        tokenId:"",
        tokenUrl:"",
      }
    },
    methods:{
      async mintERC404(){
        try {
          let id = utils.parseUnits(this.tokenId,0);
          console.log(this.countAddress,this.tokenId,this.tokenUrl);
          let tx = await myArtNFT.mint(this.countAddress,id,this.tokenUrl,{gasLimit:30000000});
          this.tokenId = "";
          this.tokenUrl = "";
        } catch (error) {
          window.alert("Mint fail! Please try again!");
        }
      }
    },
    props:["countAddress"],
  }
</script>

<style>
#mintTERC404{
  width: 879px;
  height: 640px;
  margin: 20px;
  border: 3px solid rgb(42, 41, 41);
  background-color:#F7C001;
  box-shadow: 0px 10px 20px rgba(78, 72, 68, 0.961);/* 盒子阴影 */
  border-radius: 10px;/* 盒子角变圆 */
  display: flex;/* 确保里面的nft可以并排展示 */
}
#mintTERC404-selectToken{
  width: 380px;
  height: 400px;
  margin:10px;
  /* border: 3px solid rgb(42, 41, 41); */
  background-color:#F7C001;
  border-radius: 10px;/* 盒子角变圆 */
}
#mintTERC404-selectToken-attention{
  width: 400px;
  height: 90px;
  margin: 15px;
  margin-top: 40px;
  background-color:#F7C001;
  border-radius: 10px;/* 盒子角变圆 */
  font-style:oblique; /* 让字体变得飘逸 */
  color:rgb(101, 106, 111);
}
#url{
  height: 5px;
  margin-left: 10px;
  text-align: center;
}
#mintTERC404-img{
  width:420px;
  height:440px;
  margin: 40px;
  background-color:rgb(114, 101, 101);
  border-radius: 10px;/* 盒子角变圆 */
  box-shadow: 0px 10px 20px rgba(113, 98, 42, 0.961);/* 盒子阴影 */
}
#mintTERC404-selectToken-id{
  width: 400px;
  height: 70px;
  margin: 10px;
  margin-top: 30px;
  background-color:#F7C001;
  border-radius: 10px;/* 盒子角变圆 */
  display: flex;/* 确保里面的nft可以并排展示 */
  text-align: center;
}
#mintTERC404-selectToken-id-show{
  width: 100px;
  height: 50px;
  margin: 10px;
  background-color:#F7C001;
  border-radius: 10px;/* 盒子角变圆 */
  font-style:oblique; /* 让字体变得飘逸 */
}
#mintTERC404-selectToken-id-input{
  width: 300px;
  height: 45px;
  margin: 10px;
  border: 3px solid rgb(42, 41, 41);
  background-color:#F7C001;
  box-shadow: 0px 10px 20px rgba(78, 72, 68, 0.961);/* 盒子阴影 */
  border-radius: 10px;/* 盒子角变圆 */
  font-style:oblique; /* 让字体变得飘逸 */
}
#mintTERC404-selectToken-url{
  width: 400px;
  height: 70px;
  margin: 10px;
  margin-top: 30px;
  background-color:#F7C001;
  border-radius: 10px;/* 盒子角变圆 */
  display: flex;/* 确保里面的nft可以并排展示 */
}
#mintTERC404-selectToken-url-show{
  width: 100px;
  height: 50px;
  margin: 10px;
  background-color:#F7C001;
  border-radius: 10px;/* 盒子角变圆 */
  font-style:oblique; /* 让字体变得飘逸 */
}

#mintTERC404-selectToken-url-input{
  width: 300px;
  height: 45px;
  margin: 10px;
  border: 3px solid rgb(42, 41, 41);
  background-color:#F7C001;
  box-shadow: 0px 10px 20px rgba(78, 72, 68, 0.961);/* 盒子阴影 */
  border-radius: 10px;/* 盒子角变圆 */
  font-style:oblique; /* 让字体变得飘逸 */
}
#mintTERC404-selectToken-mint{
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
#mintTERC404-selectToken-mint:hover {
  background-color: #a98f1e; /* 鼠标移入时的颜色 */
}
</style>