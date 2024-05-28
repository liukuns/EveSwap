// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./EveSwapERC20.sol";

contract EveSwapPair{

    //totalSupply of share
    uint256 public totalSupply;

    //sb's balance
    mapping(address => uint256) private _balanceOf;

    address public factory;
    EveSwapERC20 public token0;
    EveSwapERC20 public token1;

    uint112 private reserve0; 
    uint112 private reserve1;     
    
    uint32  private blockTimestampLast;
    uint public price0CumulativeLast;
    uint public price1CumulativeLast;

    constructor(address _token0,address _token1){
        token0 = EveSwapERC20(_token0);
        token1 = EveSwapERC20(_token1);
        factory = msg.sender;
        blockTimestampLast = uint32(block.timestamp);
    }

    // price0CumulativeLast += uint(UQ112x112.encode(_reserve1).uqdiv(_reserve0)) * timeElapsed;
    //set Price
    function _setPriiceCumulativeLast()internal{
        if(reserve0 * reserve1 != 0){
            //front need to div 1e5 to get price!
            price0CumulativeLast = (reserve1 * 1e7/ reserve0);
            price1CumulativeLast = (reserve0 * 1e7/ reserve1);
        }else{
            price0CumulativeLast = 0;
            price1CumulativeLast = 0;
        }
    }

    function getblockTimestampLast()external view returns(uint32){
        return blockTimestampLast;
    }

    //get reserves 100000000000000000000
    function getReserves()external view returns(uint112 _reserve0,uint112 _reserve1){
        _reserve0 = reserve0;
        _reserve1 = reserve1;
    }

    //get balance of share
    function getBalanceOfShare(address owner)external view returns(uint256){
        return _balanceOf[owner];
    }

    //transfer token out
    function transferOut(address _token,address to,uint amount)external {
        bool isToken0 = _token == address(token0);
        address transferToken = isToken0? address(token0): address(token1);
        EveSwapERC20(transferToken).transfer(to,amount);
    }

    //update reserve => token
    function _update(uint112 _reserve0,uint112 _reserve1)internal{
        reserve0 = _reserve0;
        reserve1 = _reserve1;
        _setPriiceCumulativeLast();
    }

    //update for add
    function updateForAdd(uint112 amount0In,uint112 amount1In)external{
        _update(reserve0 + amount0In,reserve1 + amount1In);
    }

    //update for remove
    function updateForRemove(uint112 amount0Out,uint112 amountOut)external{
        _update(reserve0 - amount0Out,reserve1 - amountOut);
    }

    /* 
        update for swap
        tokenIn => msg.sender  BTC/USDT
        amountIn => pair       69000/1
        amountOut => msg.sender 1/69000(atleast >= 1token)   
     */
    function updateForSwap(address tokenIn,uint112 amountIn)external returns(uint112 amountOut){
        bool isToken0 = tokenIn == address(token0);
        (uint112 reserveIn,uint112 reserveOut) = isToken0?(reserve0,reserve1) : (reserve1,reserve0);
        //amountOut => msg.sender
        //amountOut = (reserveOut * amountIn)/(reserveIn + amountIn);
        amountOut = reserveIn - (reserveIn * reserveOut)/(reserveOut + amountIn);
        require(amountOut >= 1,"Pair:At least to swap one token");
        if(isToken0){
            //true => buy
            _update(reserve0 - amountOut,reserve1 + amountIn);
        }else{
            //false => sell
            _update(reserve0 + amountIn,reserve1 - amountOut);
        }
    }

    //burn share to swap token
    function burnToSwap(uint share)external view returns(uint amount0Out,uint amount1Out){
        amount0Out = (share * reserve0) / totalSupply;
        amount1Out = (share * reserve1) / totalSupply;
    }

    //mint share
    function _mint(address to,uint amount)external{
        _balanceOf[to] += amount;
        totalSupply += amount;
    }

    //burn share
    function _burn(address owner,uint amount)external returns(bool){
        _balanceOf[owner] -= amount;
        totalSupply -= amount;
        return true;
    }
}