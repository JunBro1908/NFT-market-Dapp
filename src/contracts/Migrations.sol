// SPDX-License-Identifier: MIT
pragma solidity >=0.4.0 < 0.9.0;
// we set truffle that use solidity 0.8.xx version. It is between 0.4 and 0.9 so it is okay.

// to deploy our contracts, we can not change our data which already build on blockchain
contract Migrations {
    address public owner;
    uint public last_completed_migration;
    /* track the last completed migration until the next migration
    indexing the before migration */

    // public and internal is not needed anymore
    constructor() {
        owner = msg.sender;
        // owner : who deploy this contract first time.
    }
    
    modifier restricted() {
        require (msg.sender == owner,
        "This contract is restricted to the contract's owner");
        _; // keep going
    }
    /* Only the owner(who deploy this contract first can execute this file */

    function setCompleted(uint completed) public restricted {
        last_completed_migration = completed;
        // get the last executed migration num. (1,2,3..._script_name.js) so that next time we skip those files.
    }
    /* store the last num of the migration which executed at the last_completed_migration
    then truffle read this value and decide which migration should be strarted and which migration is deployed */

    function upgrade(address new_address) public restricted {
        Migrations upgraded = Migrations(new_address);
        // give new address to the upgraded(Inheritance Migration) to deploy new verision(new address) on the blockchain.
        upgraded.setCompleted(last_completed_migration);
        /* to track the migraitions, update the num of upgraded(the migration executed just now)
        last_completed_migration is the var which is announced at the top of the contract */
    }
}