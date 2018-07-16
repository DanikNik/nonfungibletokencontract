pragma solidity ^0.4.24;
contract ERC721Receiver {
  /**
   * @dev Magic value to be returned upon successful reception of an NFT
   *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
   *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
   */
  bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;

  /**
   * @notice Handle the receipt of an NFT
   * @dev The ERC721 smart contract calls this function on the recipient
   * after a `safetransfer`. This function MAY throw to revert and reject the
   * transfer. Return of other than the magic value MUST result in the
   * transaction being reverted.
   * Note: the contract address is always the message sender.
   * @param _operator The address which called `safeTransferFrom` function
   * @param _from The address which previously owned the token
   * @param _tokenId The NFT identifier which is being transfered
   * @param _data Additional data with no specified format
   * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
   */
   event ERC721Received(address _operator, address _from, uint8 _tokenId, bytes _data);
  function onERC721Received(
    address _operator,
    address _from,
    uint8 _tokenId,
    bytes _data
  )
    public
    view
    returns(bytes4){
        emit ERC721Received(_operator, _from, _tokenId, _data);
        return ERC721_RECEIVED;
    }
}

contract EnterpriseEcosystem{
    // Адрес владельца контракта
    address contract_owner;
    address address_bridge;
    enum TypeVariants {HomeContract, ForeignContract}
    TypeVariants contract_type;

    constructor(TypeVariants _type){
      contract_owner = msg.sender;
      contract_type = _type;
    }


    struct Factory{
        uint8 _factory_id;
        address _owner;

        string _lable;
        uint256 _default_price_for_product;
        uint256 _capital;
    }
    struct Product{
        uint8 _product_id;
        address _owner;
        uint8 _factory_assigned;
        string _title;
        uint256 _price;
    }

    mapping(uint8=>address) factory_own_list;
    mapping(uint8=>Factory) factory_instance_list;

    mapping(uint8=>address) product_own_list;
    mapping(uint8=>Product) product_instance_list;

    function isContract(address addr) internal view returns (bool) {
       uint256 size;
       // XXX Currently there is no better way to check if there is a contract in an address
       // than to check the size of the code at that address.
       // See https://ethereum.stackexchange.com/a/14016/36603
       // for more details about how this works.
       // TODO Check this again before the Serenity release, because all addresses will be
       // contracts then.
       // solium-disable-next-line security/no-inline-assembly
       assembly { size := extcodesize(addr) }
       return size > 0;
     }


    function emit_factory(uint8 _factory_id, string _lable) public {
        factory_own_list[_factory_id] = msg.sender;
        Factory memory new_factory;
        new_factory = Factory(_factory_id, msg.sender, _lable, 0, 0);
        factory_instance_list[_factory_id] = new_factory;

    }

    function transfer_factory(uint8 _factory_id, address _to) public {
        require(factory_own_list[_factory_id] == msg.sender);
        factory_own_list[_factory_id] = _to;
        //Money charging algorythm
    }
    function change_factory_data(uint8 _factory_id, string _lable) public {
        factory_instance_list[_factory_id]._lable = _lable;
    }
    function change_factory_data(uint8 _factory_id, uint256 _default_price_for_product) public {
        factory_instance_list[_factory_id]._default_price_for_product = _default_price_for_product;
    }
    function destruct_factory(uint8 _factory_id) public {
        delete factory_own_list[_factory_id];
        delete factory_instance_list[_factory_id];
    }

    function emit_product(uint8 _product_id, uint8 _factory_id, string _title) public {
        uint256 new_price;
      if (factory_own_list[_factory_id] == msg.sender){
        new_price = 0;
      } else {
        new_price = factory_instance_list[_factory_id]._default_price_for_product;
        // Механизм списания денег
      }
      Product memory new_product = Product(_product_id, msg.sender, _factory_id, _title, factory_instance_list[_factory_id]._default_price_for_product);
      product_own_list[_product_id] = msg.sender;
      product_instance_list[_product_id] = new_product;
      delete new_product;
    }
    function transfer_product(uint8 _product_id, address _to) public {
        require(product_own_list[_product_id] == msg.sender);
        product_own_list[_product_id] = _to;
    }
    function change_product_data(uint8 _product_id, uint256 _price) public {
      require(product_own_list[_product_id] == msg.sender);
      product_instance_list[_product_id]._price = _price;
    }
    function destruct_product(uint8 _product_id) public {
      delete product_own_list[_product_id];
    }

     function safeTransferFrom(address _from, address _to, uint8 _product_id, bytes _data) public {
       require(product_own_list[_product_id] == _from);
       if (isContract(_to)) {
         product_own_list[_product_id] = _to;
         ERC721Receiver(_to).onERC721Received( msg.sender, _from, _product_id, _data );
       } else {
         product_own_list[_product_id] = _to;
       }
     }
    function safeTransferFrom(address _from, address _to, uint8 _product_id) public {
       safeTransferFrom(_from, _to, _product_id, '');
    }

    function getSerializedData(uint8 _product_id) public view returns (bytes) {
        require(product_own_list[_product_id] == msg.sender);
        uint8 factory_assigned = product_instance_list[_product_id]._factory_assigned;
        uint256 price = product_instance_list[_product_id]._price;
        string memory title = product_instance_list[_product_id]._title;
        bytes1 factory_assigned_to_bytes = bytes1(factory_assigned);
        bytes32 price_to_bytes = bytes32(price);
        bytes memory title_to_bytes = bytes(title);
        bytes memory data_to_bytes = new bytes(factory_assigned_to_bytes.length + price_to_bytes.length + title_to_bytes.length);
        uint k = 0;
        for (uint i = 0; i < factory_assigned_to_bytes.length; i++) data_to_bytes[k++] = factory_assigned_to_bytes[i];
        for (i = 0; i < price_to_bytes.length; i++) data_to_bytes[k++] = price_to_bytes[i];
        for (i = 0; i < title_to_bytes.length; i++) data_to_bytes[k++] = title_to_bytes[i];

        return data_to_bytes;
    }

    function getDeserializedData(bytes _data) private pure returns (uint8, uint256, string){
      bytes1 out_bytes1;
      bytes32 out_bytes32;
      bytes memory out_bytes = new bytes(_data.length - 33);
      for (uint i = 0; i < 1; i++) {
        out_bytes1 |= bytes1(_data[i]) >> (i * 8);
      }
      for (i = 1; i < 32+1; i++) {
        out_bytes32 |= bytes32(_data[i]) >> (i * 8);
      }
      for (i = 32+1; i < _data.length; i++) {
        out_bytes[i-33] = _data[i];
      }
      return (uint8(out_bytes1), uint256(out_bytes1), string(out_bytes));
    }

    function recoveryToken(uint8 _product_id, address _to, bytes _token_data) public {
      (
        product_instance_list[_product_id]._factory_assigned,
        product_instance_list[_product_id]._price,
        product_instance_list[_product_id]._title
      ) = getDeserializedData(_token_data);

    }

    function setPermissionsToRecover(address _address_bridge) public {
       require(contract_owner == msg.sender);
       address_bridge = _address_bridge
    }
}
