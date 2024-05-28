// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./EveSwapPair.sol";
import "./EveSwapFactory.sol";
import "./EveSwapERC20.sol";

/* 
 BTC:0x8D39eE1d94D26bE4c5aB2905a52A18A31E640C9c
 ETH:
 AVAX:
 BNB:
 SOL:
 USDT:
 factory:0xf5cAfeC90290950B0f9B47B86617D4eFd4Df0176
 */

contract EveSwapMarket{
    event ChangePrice(address indexed pair,uint indexed price0,uint indexed price1,uint time);

    //address of factory
    address public factory;

    constructor(address _factory){
        factory = _factory;
    }

    //buy token name
    function buyTokenByName(string memory _name,uint _amount)external{
        (,
            address tokenDo,
            address tokenAnother
        ) = EveSwapFactory(factory).getTokenSymbolByName(_name);

        //buy token
        _swapTokenForToken(tokenDo, tokenAnother, _amount);
    }

    //sell token by name
    function sellTokenByName(string memory _name,uint _amount)external{
        (,
            address tokenDo,
            address tokenAnother
        ) = EveSwapFactory(factory).getTokenSymbolByName(_name);

        //buy token
        _swapTokenForToken(tokenAnother, tokenDo, _amount);
    }

    //add liquidity
    function addLiquidityTokenToToken(
        address tokenA,
        address tokenB,
        uint112 amount0In,
        uint112 amount1In
    )external returns(uint share,address pair){
        bool isBigger = tokenA < tokenB;
        (address token0,address token1) = isBigger ?(tokenA,tokenB):(tokenB,tokenA);
        (uint112 reserve0,uint112 reserve1) = isBigger ?(amount0In,amount1In):(amount1In,amount0In);
        //create pair
        pair = EveSwapFactory(factory).createPair(token0,token1);
        //transferfrom token
        EveSwapERC20(token0).transferFrom(msg.sender,pair,reserve0);
        EveSwapERC20(token1).transferFrom(msg.sender,pair,reserve1);
        //update reserve
        EveSwapPair(pair).updateForAdd(reserve0,reserve1);
        //mint share
        uint256 _totalSupply = EveSwapPair(pair).totalSupply();
        if (_totalSupply == 0) {
            share = _sqrt(amount0In*amount1In);
        } else {
            share = _min(amount0In * _totalSupply / reserve0, amount1In * _totalSupply / reserve1);
        }
        EveSwapPair(pair)._mint(msg.sender,share);

        emitPrice(pair);
    }

    //remove liquidity by name
    function removeLiquidityByName(
        string memory _name,
        uint _share
    )external {
        (
            address tokenA,
            address tokenB
        ) = EveSwapFactory(factory).getTokenToTokenByPairName(_name);

        _removeLiquidityTokenToToken(tokenA, tokenB, _share);
    }

    //remove liquidity
    function _removeLiquidityTokenToToken(
        address tokenA,
        address tokenB,
        uint share
    )internal returns(uint amount0Out,uint amount1Out){
        bool isBigger = tokenA < tokenB;
        (address token0,address token1) = isBigger ?(tokenA,tokenB):(tokenB,tokenA);        
        //find pair
        address pair = EveSwapFactory(factory).getPair(token0,token1);
        //transferFrom token
        (amount0Out,amount1Out) = EveSwapPair(pair).burnToSwap(share);
        EveSwapPair(pair).transferOut(token0,msg.sender,amount0Out);
        EveSwapPair(pair).transferOut(token1,msg.sender,amount1Out);
        //update reserve
        EveSwapPair(pair).updateForRemove(uint112(amount0Out),uint112(amount1Out));
        //burn share
        EveSwapPair(pair)._burn(msg.sender,share);

        emitPrice(pair);
    }

    /*  
        swap token
        tokenIn => msg.sender
        amountOut => msg.sender
        tokenOut => pair      
        amountIn => pair
    */
    function _swapTokenForToken(
        address tokenIn,
        address tokenOut,
        uint amountIn
    )internal returns(uint amountOut){
        //get token-token => pair
        address pair = EveSwapFactory(factory).getPair(tokenIn,tokenOut);
        //get amount to swap out and update
        amountOut = EveSwapPair(pair).updateForSwap(tokenIn,uint112(amountIn));
        //transferfrom token to pair
        EveSwapERC20(tokenOut).transferFrom(msg.sender,pair,amountIn);
        //transfer token to msg.sender
        EveSwapPair(pair).transferOut(tokenIn,msg.sender,amountOut);

        emitPrice(pair);
    }

    function _sqrt(uint y) internal pure returns (uint z) {
        if (y > 3) {
            z = y;
            uint x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }

    function _min(uint _x, uint _y) internal pure returns (uint) {
        return _x > _y ? _y : _x;
    }

    //提交价格事件
    function emitPrice(address pair)internal{
        (uint price0,uint price1) = EveSwapFactory(factory).getPriceByPair(pair);
        uint time = block.timestamp;
        emit ChangePrice(pair, price0, price1, time);
    }
}