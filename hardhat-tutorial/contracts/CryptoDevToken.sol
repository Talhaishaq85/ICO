//SPDX-License-Identifier:Unlicensed

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./ICryptoDevs.sol";

contract CryptoDevToken is ERC20, Ownable {

    uint256 public constant tokenPrice = 0.01 ether;

    uint256 public constant tokensPerNFT = 10 * 10 ** 18;

    uint256 public constant maxTotalSupply = 10000 * 10 ** 18;

    ICryptoDevs CryptoDevsNFT;

    mapping(uint256 => bool ) public tokenIdsClaimed;

    constructor(address _cryptoDevsContract)  ERC20("Crypto Dev token", "CD"){

        CryptoDevsNFT = ICryptoDevs(_cryptoDevsContract);
    } 


    function mint(uint256 amount ) public payable {
        
        uint256 _requiredAmount = tokenPrice * amount; 

        require (msg.value >= _requiredAmount , "Sended Ethers are not Enough" );

        uint256 amountWithDecimals = amount * 10 ** 18; 

        require ((totalSupply() + amountWithDecimals) <= maxTotalSupply , "Reached the maximum supply");

        _mint(msg.sender , amountWithDecimals);


    
    }

    function claim() public payable {

        address sender = msg.sender;

        uint256 balance = CryptoDevsNFT.balanceOf(sender);

        require (balance > 0 , "You have no Crypto Dev Token ");

        uint256 amount = 0;

        for(uint256 i=0 ; i < balance ; i++ ){
            uint256 tokenId = CryptoDevsNFT.tokenOFOwnerByIndex(sender , i);

            if(!tokenIdsClaimed[tokenId]){
                amount+=1;
                tokenIdsClaimed[tokenId]=true;

            }
        }

        require ( amount > 0 , "You have already claimed all the tokens");

        _mint(msg.sender, amount * tokensPerNFT);





    }

    function withdraw() public onlyOwner {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent,) = _owner.call{value:amount}("");
        require(sent, "Failed to send Ether");

    }

     receive() external payable{}

     fallback() external payable{}



     
}