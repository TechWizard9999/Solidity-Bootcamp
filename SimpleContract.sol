// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleContract {
    uint256 private _counter;
    string private _description;

    constructor(string memory description) {
        _description = description;
    }

    function getCounter() public view returns (uint256) {
        return _counter;
    }

    function getDescription() public view returns (string memory) {
        return _description;
    }

    function incrementCounter() public {
        _counter++;
    }
}
