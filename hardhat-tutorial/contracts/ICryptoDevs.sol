//SPDX-License-Identifier:Unlicensed

pragma solidity ^0.8.4;

interface  ICryptoDevs {

    function tokenOFOwnerByIndex(address owner,uint256 index) external view returns (uint256 tokenId);

    function balanceOf(address owner) external view returns (uint256 balance);
    
}