pragma solidity ^0.4.24;

contract EnterpriseEcosystem{
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


    function emit_factory(uint8 _factory_id, string _lable){
        factory_own_list[_factory_id] = msg.sender;
        Factory new_factory = new Factory(_factory_id, msg.sender, _lable, 0, 0);
        factory_instance_list[_factory_id] = new_factory
    }

    function transfer_factory(uint8 _factory_id, address _to){
        require(factory_own_list[_factory_id] == msg.sender);
        factory_own_list[_factory_id] = _to;
        //Money charging algorythm
    }
    function change_factory_data(uint8 _factory_id, string _lable){
        factory_instance_list[_factory_id]._lable = _lable;
    }
    function change_factory_data(uint8 _factory_id, uint256 _default_price_for_product){
        factory_instance_list[_factory_id]._default_price_for_product = _default_price_for_product;
    }
    function destruct_factory(uint8 _factory_id){
        delete factory_own_list[_factory_id];
        delete factory_instance_list
    }

    function emit_product(uint8 _product_id, uint8 _factory_id, string _title){
      if (factory_own_list[_factory_id] == msg.sender){
        Product new_product = new Product(_product_id, mag.sender, _factory_id, _title, 0); //TODO: владелец фабрики эмитит токен в свой кошелек или как? Я забыл, спросить у Леши
      } else {
        Product new_product = new Product(_product_id, mag.sender, _factory_id, _title, factory_own_list[_factory_id]._default_price_for_product);
        // Механизм списания денег
      }
      product_own_list[_product_id] = msg.sender;
      product_instance_list[_product_id] = new_product;
    }
    function transfer_product(uint8 _product_id, address _to){
        require(product_own_list[_product_id] == msg.sender);
        product_own_list[_product_id] = _to;
    }
    function change_product_data(uint8 _product_id, uint256 _price){
      require(product_own_list[_product_id] == msg.sender);
      product_instance_list[_product_id]._price = _price;
    }
    function destruct_product(uint8 _product_id){
      delete product_own_list[_product_id];
    }

}
