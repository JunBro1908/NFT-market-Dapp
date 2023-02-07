/* to update our NFT contracts, we need to migrate our project to the blockchain.
thus everytime we update our projects, Migrations contract in migration.sol should deploy over and over again */
const Migrations = artifacts.require("Migrations");

module.exports = function(deployer) {
    deployer.deploy(Migrations);
    // deploy migration contract
};