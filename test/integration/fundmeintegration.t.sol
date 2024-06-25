// SPDX-Licence-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/fundme.sol";
import {deploy} from "../../script/deploy.s.sol";
import {fundfundme, withdrawfundme} from "../../script/intractions.s.sol";

contract integrationtest is Test {
    FundMe fundme;

    address user = makeAddr("user");
    uint256 constant sendvalue = 0.1 ether;
    uint256 constant balance = 10 ether;

    function setUp() external {
        // fundme = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        deploy deployfundeme = new deploy();
        fundme = deployfundeme.run();
        vm.deal(user, balance);
    }

    function testusercanfund() public {
        fundfundme fundFundme = new fundfundme();
        fundFundme.startFundme(address(fundme));

        withdrawfundme varwithdrawfundme = new withdrawfundme();
        varwithdrawfundme.startwithdrawFundme(address(fundme));

        assert(address(fundme).balance == 0);
    }
}
