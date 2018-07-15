pragma solidity ^0.4.24;

contract HomeBridge{
    address ERC721_address;

    event UserRequestforSignature();
    event TransferCompleted();

    constructor (address _ERC721) public{
        ERC721_address = _ERC721;
    }

    function onERC721Received(address _operator, address _from, uint _token_id){
        
    }

    function transferApproved(){

    }
}
