// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./EveSwapPair.sol";

contract EveSwapFactory{
    
    //token-token => pair
    mapping(address => mapping(address => address)) private _getPair;
    //name => pair
    mapping(string => address) private _getPairByName;
    //pairs
    address[] private _pairs;
    //pairs name
    string[] private _pairsName;

    constructor()payable{
    }
 
    //get pair's name
    function getPairName()external view returns(string[] memory){
        return _pairsName;
    }

    //get tokens by name
    function getTokenToTokenByPairName(string memory _name)public view returns(
        address token0,
        address token1
    ){
        address pair = _getPairByName[_name];
        (token0,token1) = _getPairToToken(pair);
    }

    //get tokens symbol by pair's name
    function getSymbolByPairName(string memory _name)external view returns(
        string memory symbol0,
        string memory symbol1
    ){
        (address token0,address token1) = getTokenToTokenByPairName(_name);
        symbol0 = ERC20(token0).symbol();
        symbol1 = ERC20(token1).symbol();
    }

    //get pair by name
    function getPairByName(string memory _name)public view returns(address pair){
        return _getPairByName[_name];
    }

    //get price by name
    function getTokenPriceByName(string memory _name)external view returns(
        uint price0,
        uint price1
    ){
        address pair = getPairByName(_name);
        price0 = EveSwapPair(pair).price0CumulativeLast();
        price1 = EveSwapPair(pair).price1CumulativeLast();
    }

    //get price by pair
    function getPriceByPair(address _pair)external view returns(
        uint256 price0,
        uint256 price1
    ){
        price0 = EveSwapPair(_pair).price0CumulativeLast();
        price1 = EveSwapPair(_pair).price1CumulativeLast();
    }

    //get totalSupply by name
    function _getTotalSupplyByName(string memory _name)internal view returns(uint256 totalSupply){
        address _pair = getPairByName(_name);
        totalSupply = _getTotalSupplyByPair(_pair);
    }
    
    //get totalSuply by pair
    function _getTotalSupplyByPair(address _pair)internal view returns(uint256 _totalSupply){
        _totalSupply = EveSwapPair(_pair).totalSupply();
    }

    //get Proportion of owner
    function getProportionOfOwner(
        string memory _name
    )external view returns(uint32 _radio,uint256 _balance){
        address _owner = msg.sender;
        _balance = getBalanceOfOwnedShare(_name,_owner);
        uint totalSupply = _getTotalSupplyByName(_name);
        _radio = uint32((_balance * 1e2)/totalSupply);
    }

    //get Amount of pair's share of owner
    function getBalanceOfOwnedShare(
        string memory _name,
        address _owner
    )public view returns(uint256 _balance){
        address pair = getPairByName(_name);
        _balance = EveSwapPair(pair).getBalanceOfShare(_owner);
    }

    //get Token Symbol to sell by name
    function getTokenSymbolByName(
        string memory _name
    )external view returns(string memory _symbol,address _tokenDo,address _tokenAnother){
        (address token0,address token1) = getTokenToTokenByPairName(_name);
        //token0 == USDT
        string memory _symbol0 = ERC20(token0).symbol();
        _tokenAnother = token0;
        _symbol = ERC20(token1).symbol();
        _tokenDo = token1;
        //token1 == USDT
        bytes32 _target  = keccak256(abi.encode("USDT"));
        bytes32 _symbolBytes = keccak256(abi.encode(_symbol0));
        if(_symbolBytes != _target){
            _tokenAnother = token1;
            _symbol = ERC20(token0).symbol();
            _tokenDo = token0;
        }
    }

    //create Pair's name
    function createPairName(address pair)internal{
        string memory symbol0 = EveSwapPair(pair).token0().symbol();
        string memory symbol1 = EveSwapPair(pair).token1().symbol();
        
        string memory name = string(abi.encodePacked(symbol0," / ",symbol1));
        _pairsName.push(name);
        _getPairByName[name] = pair;
    }

    //create contract of pair
    function createPair(
        address tokenA,
        address tokenB
    )external returns(address pair){
        require(tokenA != tokenB,"Factory: token equal token!");
        require(tokenA != address(0) || tokenB != address(0),"Factory: address of token equal zero!");
        
        if(getPair(tokenA, tokenB) == address(0)){
            (tokenA,tokenB) = tokenA < tokenB ? (tokenA,tokenB):(tokenB,tokenA);
            //new contratc of pair
            pair = address(new EveSwapPair(tokenA,tokenB));
            //update pair's info
            _update(tokenA, tokenB, pair);
            //create pair's name
            createPairName(pair);
        }else{
            pair = getPair(tokenA, tokenB);
        }
    }

    //query token-token => pair
    function getPair(
        address tokenA,
        address tokenB
    )public view returns(address pair){
        pair = _getPair[tokenA][tokenB];
    }

    //get pairs
    function getPairs(uint index)public view returns(address){
        return _pairs[index];
    }

    //get length of pairs
    function getLengthOfPairs()external view returns(uint){
        return _pairs.length;
    }

    //update info of pair
    function _update(address _tokenA,address _tokenB,address _pair)private{
        _getPair[_tokenA][_tokenB] = _pair;
        _getPair[_tokenB][_tokenA] = _pair;

        _pairs.push(_pair);
    }

    //look token pair
    function _getPairToToken(address pair)internal view returns(
        address token0,
        address token1
    ){
        token0 = address(EveSwapPair(pair).token0());
        token1 = address(EveSwapPair(pair).token1());
    }

    //get reserve of token
    function getReserveOfToken(address pair)external view returns(uint112 reserve0,uint112 reserve1){
        (reserve0,reserve1) = EveSwapPair(pair).getReserves();
    }
}