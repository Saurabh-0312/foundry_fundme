// SDPX-Licence_Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/fundme.sol";
import {helper} from "./helperconfig.s.sol";

contract deploy is Script {
    function run() external returns (FundMe) {
        helper hhelper = new helper();
        address pricefeedeth = hhelper.activenetwork();

        //
        vm.startBroadcast();
        FundMe fundme = new FundMe(pricefeedeth);
        vm.stopBroadcast();
        return fundme;
    }
}
