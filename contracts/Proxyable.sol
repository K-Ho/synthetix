/*
-----------------------------------------------------------------
FILE INFORMATION
-----------------------------------------------------------------

file:       Proxyable.sol
version:    1.1
author:     Anton Jurisevic

date:       2018-05-15

checked:    Mike Spain
approved:   Samuel Brooks

-----------------------------------------------------------------
MODULE DESCRIPTION
-----------------------------------------------------------------

A proxyable contract that works hand in hand with the Proxy contract
to allow for anyone to interact with the underlying contract both
directly and through the proxy.

-----------------------------------------------------------------
*/

pragma solidity ^0.5.16;

import "./Owned.sol";


// This contract should be treated like an abstract contract
contract Proxyable is Owned {
    
    constructor(address payable _proxy, address _owner) public Owned() {
        require(_owner != address(0), "Owner address cannot be 0");
        owner = _owner;
        emit OwnerChanged(address(0), _owner);       
    }
}
