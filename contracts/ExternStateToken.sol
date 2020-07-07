/*
-----------------------------------------------------------------
FILE INFORMATION
-----------------------------------------------------------------

file:       ExternStateToken.sol
version:    1.3
author:     Anton Jurisevic
            Dominic Romanowski
            Kevin Brown

date:       2018-05-29

-----------------------------------------------------------------
MODULE DESCRIPTION
-----------------------------------------------------------------

A partial ERC20 token contract, designed to operate with a proxy.
To produce a complete ERC20 token, transfer and transferFrom
tokens must be implemented, using the provided _byProxy internal
functions.
This contract utilises an external state for upgradeability.

-----------------------------------------------------------------
*/

pragma solidity ^0.5.16;

import "./SelfDestructible.sol";
import "./Proxyable.sol";


/**
 * @title ERC20 Token contract, with detached state and designed to operate behind a proxy.
 */
contract ExternStateToken is SelfDestructible, Proxyable {
    constructor(
        address payable _proxy,
        address _owner
    ) public SelfDestructible(_owner) Proxyable(_proxy, _owner) {
    }
}
