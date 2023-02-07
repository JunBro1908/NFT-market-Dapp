const KryptoDog = artifacts.require("KryptoDog");
/* Not contract.sol, truffle get contract artifact ABI from KryptoDog.js file
and we announce it as a variance */

/* truffle run this file next to the index 1 and anonymous function will run
in this case we declare deployer and it deploy KryptoDog contract */
module.exports = function(deployer) {
    deployer.deploy(KryptoDog);
    // deploy migration.sol
};