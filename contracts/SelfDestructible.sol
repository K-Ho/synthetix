/*
-----------------------------------------------------------------
FILE INFORMATION
-----------------------------------------------------------------

file:       SelfDestructible.sol
version:    1.2
author:     Anton Jurisevic

date:       2018-05-29

-----------------------------------------------------------------
MODULE DESCRIPTION
-----------------------------------------------------------------

This contract allows an inheriting contract to be destroyed after
its owner indicates an intention and then waits for a period
without changing their mind. All ether contained in the contract
is forwarded to a nominated beneficiary upon destruction.

-----------------------------------------------------------------
*/

pragma solidity ^0.5.16;

import "./Owned.sol";


/**
 * @title A contract that can be destroyed by its owner after a delay elapses.
 */
contract SelfDestructible is Owned {
    /**
     * @dev Constructor
     * @param _owner The account which controls this contract.
     */
    constructor(address _owner) public Owned() {
        require(_owner != address(0), "Owner address cannot be 0");
        owner = _owner;
        emit OwnerChanged(address(0), _owner);
    }
}
