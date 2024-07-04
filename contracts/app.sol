// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

contract App {
    event SellerCreated(uint sellerId);
    event ProductCreated(uint productId, uint sellerId);
    event SellerChained(uint newSellerId);

    struct Product {
        uint productId;
        uint[] chain;
    }

    mapping(uint => Product) public products;
    mapping(address => uint) private addressToId;
    mapping(uint => address) private idToAddress;
 
  
    modifier noSellerExists(uint _sellerId) {
        require(addressToId[msg.sender] == 0, "Seller already exists");
        _;
    }

    modifier onlyLastSeller(uint _productId, uint _newSellerId) {
        require(products[_productId].chain.length != 0, "Product doesn't exists");
        require(idToAddress[_newSellerId] != address(0), "No seller exists");
        uint length = products[_productId].chain.length;
        uint256 lastSellerId = products[_productId].chain[length - 1];
        require(idToAddress[lastSellerId] == msg.sender, "Only the last seller can add a new seller");
        require(idToAddress[_newSellerId] != msg.sender, "Can't sell to yourself");
        _;
    }

    modifier sellerExists() {
        require(addressToId[msg.sender] != 0, "No seller exists");
        _;
    }
    
    function createSeller(uint _sellerId) noSellerExists(_sellerId) external {
        addressToId[msg.sender] = _sellerId;
        idToAddress[_sellerId] = msg.sender;
        emit SellerCreated(_sellerId);
    }

    function createProduct(uint _productId) sellerExists external {
        require(products[_productId].chain.length == 0, "Product already exists");
        products[_productId] = Product(_productId, new uint[](0));
        products[_productId].chain.push(addressToId[msg.sender]);
        emit ProductCreated(_productId, addressToId[msg.sender]);
    }

    function addSeller(uint _productId, uint _newSellerId) onlyLastSeller(_productId, _newSellerId) external {
        products[_productId].chain.push(_newSellerId);
        emit SellerChained(_newSellerId);
    }
    function getProduct(uint _productId) public view returns (Product memory) {
        return products[_productId];
    }
}