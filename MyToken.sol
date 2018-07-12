pragma solidity ^0.4.24;

contract MyToken{

    mapping(uint8 => address) public address_book;
    mapping(uint8 => uint) public token_book;
    event Transfer(address _from, address _to, uint8 _token_id);
    event EmitedToken(address _from, uint8 _token_id, uint _token_data);
    event DestructedToken(address _from, uint8 _token_id);
    event ChangedToken(address _from, uint8 _token_id, uint _new_token_data);

    function createToken(uint _tokenData, uint8 _token_id) public {
        uint newTokenData = _tokenData;
        uint8 newTokenId = _token_id;
        token_book[newTokenId] = newTokenData;
        address_book[newTokenId] = msg.sender;
        emit EmitedToken(msg.sender, _token_id, _tokenData);
    }

    function transfer(address _to, uint8 _token_id) public {
        require(msg.sender == address_book[_token_id]);
        address_book[_token_id] = _to;
        emit Transfer(msg.sender, _to, _token_id);
    }

    function destructToken(uint8 _token_id) public {
        require(address_book[_token_id] == msg.sender);
        address_book[_token_id] = 0;
        token_book[_token_id] = 0;
        emit DestructedToken(msg.sender, _token_id);
    }

    function setData(uint8 _token_id, uint _new_data) public {
        require(address_book[_token_id] == msg.sender);
        token_book[_token_id] = _new_data;
        emit ChangedToken(msg.sender, _token_id, _new_data);
    }
}
