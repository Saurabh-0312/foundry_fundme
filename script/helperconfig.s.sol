// SPDX-Licence-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/mocksv3.sol";

contract helper is Script {
    networkconfig public activenetwork;

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    struct networkconfig {
        address pricefeed;
    }

    constructor() {
        if (block.chainid == 11155111) {
            activenetwork = getsepoliaeth();
        } else if (block.chainid == 1) {
            activenetwork = geteth();
        } else {
            activenetwork = getanvileth();
        }
    }

    function getsepoliaeth() public pure returns (networkconfig memory) {
        networkconfig memory sepoliaconfig = networkconfig({
            pricefeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaconfig;
    }

    function geteth() public pure returns (networkconfig memory) {
        networkconfig memory ethconfig = networkconfig({
            pricefeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });
        return ethconfig;
    }

    function getanvileth() public returns (networkconfig memory) {
        if (activenetwork.pricefeed != address(0)) {
            return activenetwork;
        }
        vm.startBroadcast();

        MockV3Aggregator mockpricefeed = new MockV3Aggregator(
            DECIMALS,
            INITIAL_PRICE
        );

        vm.stopBroadcast();

        networkconfig memory anvilconfig = networkconfig({
            pricefeed: address(mockpricefeed)
        });
        return anvilconfig;
    }
}
