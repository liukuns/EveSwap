// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/interfaces/IERC721.sol";


/* 小心msg.sender的传递问题，多个合约之间线性调用可能msg.sender的值不同 */
contract myERC721 is IERC721{


    string public name;//Token名称
    string public symbol;//Token代号
    mapping(uint => address)private _owners;//tokenId到owner的映射
    mapping(address => uint)private _banlances;//地址到持仓数量的映射
    mapping(uint => address)private _tokenApprovals;//tokenid到授权地址的映射
    mapping(address => mapping(address => bool))private _operatorApprovals;//owner到operator的批量映射

    /* 
        构造函数 
    */
    constructor(string memory name_,string memory symbol_){
        name = name_;
        symbol = symbol_;
    }

    function balanceOf(address owner_)external view override returns(uint){
        require(owner_ != address(0),"owner address is zero address");
        return _banlances[owner_];
    }   
    
    // 实现IERC721的ownerOf，利用_owners变量查询tokenId的owner。
    function ownerOf(uint tokenId)external view override returns(address){
        address owner = _owners[tokenId];
        require(owner != address(0),"token doesn't exit");
        return owner;
    }


    // 实现IERC721的isApprovedForAll，利用_operatorApprovals变量查询owner地址是否将所持NFT批量授权给了operator地址。
    function isApprovedForAll(address owner,address operator)external view override returns(bool){
        require(_operatorApprovals[owner][operator],"have not approve for all");
        return _operatorApprovals[owner][operator];
    }

    // 实现IERC721的setApprovalForAll，将持有代币全部授权给operator地址。调用_setApprovalForAll函数。
    function setApprovalForAll(address to,bool approved)external override{
        _operatorApprovals[msg.sender][to] = approved;
        emit ApprovalForAll(msg.sender,to,approved);
    }

    // 实现IERC721的getApproved，利用_tokenApprovals变量查询tokenId的授权地址。
    function getApproved(uint tokenId)external view override returns(address){
        require(_tokenApprovals[tokenId] != address(0),"token doesn't exit & doesn't approval");
        return _tokenApprovals[tokenId];
    }
     
    // 授权函数。通过调整_tokenApprovals来，授权 to 地址操作 tokenId，同时释放Approval事件。
    function _approval(address owner,address operator,uint tokenId)private{
        _tokenApprovals[tokenId] = operator;
        emit Approval(owner,operator,tokenId);
    }
    
    // 实现IERC721的approve，将tokenId授权给 to 地址。条件：to不是owner，且msg.sender是owner或授权地址。调用_approve函数。
    function approve(address to,uint tokenId)external override{
        address owner = _owners[tokenId];
        require(_isApprovedOrOwner(owner,msg.sender,tokenId),"have no right to approval");

        _approval(owner, to, tokenId);
    }

    // 查询 spender地址是否可以使用tokenId（他是owner或被授权地址）。
    function _isApprovedOrOwner(address owner,address spender,uint tokenId)private view returns(bool){
        return (spender == owner) || _operatorApprovals[owner][spender] || (_tokenApprovals[tokenId] != address(0));
    }

    /*
     * 转账函数。通过调整_balances和_owner变量将 tokenId 从 from 转账给 to，同时释放Transfer事件。
     * 条件:
     * 1. tokenId 被 from 拥有
     * 2. to 不是0地址
     */
    function _transfer(address owner,address from,address to,uint tokenId)private{
        require(from == owner,"not owner");
        require(to != address(0),"transfer to the zero address");

        _approval(owner, address(0), tokenId);

        _banlances[owner] -= 1;
        _banlances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(from,to,tokenId);
    }

    
    // 实现IERC721的transferFrom，非安全转账，不建议使用。调用_transfer函数
    function transferFrom(address from,address to,uint tokenId)external override {
        address owner = _owners[tokenId];
        require(_isApprovedOrOwner(owner,from,tokenId),"have no right to transfer");

        _transfer(owner,from,to,tokenId);
    }

    /**
     * 安全转账，安全地将 tokenId 代币从 from 转移到 to，会检查合约接收者是否了解 ERC721 协议，以防止代币被永久锁定。调用了_transfer函数和_checkOnERC721Received函数。条件：
     * from 不能是0地址.
     * to 不能是0地址.
     * tokenId 代币必须存在，并且被 from拥有.
     * 如果 to 是智能合约, 他必须支持 IERC721Receiver-onERC721Received.
     */
    function _safeTransfer(address owner,address from,address to,uint tokenId,bytes memory _data)private{
        _transfer(owner,from,to,tokenId);
        require(_checkOnERC721Received(from,to,tokenId,_data),"not ERCReceiver");
    }

    /**
     * 实现IERC721的safeTransferFrom，安全转账，调用了_safeTransfer函数。
     */
    function safeTransferFrom(address from,address to,uint tokenId,bytes memory _data)public override {
        address owner = _owners[tokenId];
        require(_isApprovedOrOwner(owner,from,tokenId),"not owner nor approved");
        _safeTransfer(owner,from,to,tokenId,_data);
    }


    function safeTransferFrom(address from,address to,uint tokenId) external override {
        safeTransferFrom(from,to,tokenId,"");
    }

    /** 
     * 铸造函数。通过调整_balances和_owners变量来铸造tokenId并转账给 to，同时释放Transfer事件。铸造函数。通过调整_balances和_owners变量来铸造tokenId并转账给 to，同时释放Transfer事件。
     * 这个mint函数所有人都能调用，实际使用需要开发人员重写，加上一些条件。
     * 条件:
     * 1. tokenId尚不存在。
     * 2. to不是0地址.
     */
    function _mint(address to,uint tokenId)internal {
        require(to != address(0),"mint to zero address");
        require(_owners[tokenId] == address(0),"token have already minted");

        _banlances[to] ++;
        _owners[tokenId] = to;

        emit Transfer(address(0),to,tokenId);
    }

    // 销毁函数，通过调整_balances和_owners变量来销毁tokenId，同时释放Transfer事件。条件：tokenId存在。
    function _burn(uint tokenId)internal virtual {
        address owner = _owners[tokenId];
        require(owner == msg.sender,"have no right to burn");

        _approval(owner, address(0), tokenId);

        _banlances[owner] --;
        _owners[tokenId] = address(0);

        emit Transfer(owner,address(0),tokenId);
    }

    // _checkOnERC721Received：函数，用于在 to 为合约的时候调用IERC721Receiver-onERC721Received, 以防 tokenId 被不小心转入黑洞。
    function _checkOnERC721Received(address from,address to,uint tokenId,bytes memory _data)private returns(bool){
        if(isContract(to)) {
            return IERC721Receiver(to).onERC721Received(_owners[tokenId],from,tokenId,_data) == IERC721Receiver.onERC721Received.selector;
        }else{
            return true;
        }
    }
    
    //判断一个地址是否为一个合约地址
    function isContract(address addr) internal view returns (bool) {
        uint size;
        assembly {
            size := extcodesize(addr)
        }
        return size > 0;
    }

        // 实现IERC165接口supportsInterface
    function supportsInterface(bytes4 interfaceId)external pure override returns(bool){
        return interfaceId == type(IERC721).interfaceId;
    }
}