pragma solidity ^0.4.24;

contract ERC721{
    function getSerializedData(uint8 _token_id) public returns (bytes){}
    function recoveryToken(uint8 _token_id, address _to, bytes _token_data) public {}
}



contract BridgeNode{
    address ERC721_address;

    event UserRequestforSignature(address _reciever, uint8 _tokenId, bytes _token_data);
    event TransferCompleted(uint8 _tokenId);
    event TokenRecovered(uint8 _token_id, bytes _token_data, address _owner);

    address []ValidatorList = [0xca35b7d915458ef540ade6068dfe2f44e8fa733c];
    address contract_owner;
    /* mapping(bytes32 => mapping(address, bool)) tx_states; */
    function isValidator(address _user) public returns (bool){
        for (uint i = 0; i < ValidatorList.length; i++){
            if (_user == ValidatorList[i]){
                return true;
            }
        }
        return false;
    }

    enum TypeVariants {HomeBridge, ForeignBridge}
    TypeVariants contract_type;

    constructor (address _ERC721, address _contract_owner, TypeVariants _type) public payable{
        ERC721_address = _ERC721;
        contract_owner = _contract_owner;
        contract_type = _type;
    }

    function onERC721Received(address _operator, address _from, uint8 _token_id) public {
        // bytes memory token_data = ERC721(ERC721_address).getSerializedData(_token_id);
        emit UserRequestforSignature(_from, _token_id, "0x1234");
    }

    function transferApproved(address _to, uint8 _token_id, bytes _token_data) public {
        // require(isValidator(msg.sender));
        ERC721(ERC721_address).recoveryToken(_token_id, _to, _token_data); //need to transmit new owner's address, modify ERC721 interface
        emit TokenRecovered(_token_id, _token_data, _to);
    }
}
