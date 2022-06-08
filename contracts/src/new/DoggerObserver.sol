// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./IDogger.sol";

contract DoggerObserver {
    address doggerAddress;
    IDogger dogger;

    constructor(
        address _doggerAddress
    ) {
        doggerAddress = _doggerAddress;
        dogger = IDogger(doggerAddress);
    }
}
