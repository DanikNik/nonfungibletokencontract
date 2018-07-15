pragma solidity ^0.4.24;

contract ERC721{
    function getSerializedData(){}
}



contract BridgeNode{
    address ERC721_address;

    event UserRequestforSignature(address _reciever, uint8 _tokenId, bytes _token_data);
    event TransferCompleted(uint8 _tokenId);

    enum TypeVariants {HomeBridge, ForeignBridge}
    TypeVariants type;

    constructor (address _ERC721, TypeVariants _type) public{
        ERC721_address = _ERC721;
        type = _type;
    }

    function onERC721Received(address _operator, address _from, uint _token_id){

    }

    function transferApproved(){

    }
}
