// set truffle network (like ganache) and other settings. in this case we hook up with ganache.
module.exports = {
  // where the blockchain is developing
  networks: {
    development: {
      host: "127.0.0.1",     // RPC server
      port: 7545,            // RPC server's port 
      network_id: "*",       // * any networks availiable => use 5777 in this case
    }
  }, 
  
  // we move our contracts file to src folder. Thus we announce this change for truffle
  contracts_directory: './src/contracts/',

  /* for frontend and web3, we usually use ABI because JS shows good perform in transfering data.
  thus truffle change solidity file to js file. we should announce where those files are exisit */
  contracts_build_directory:'./src/abis', 

  compilers: {
  // notice which version we use so that prevent compling errers
    solc: {
      version: "^0.8.17", // up to 0.8 ~ 0.9
      optimizer: {
        enabled: 'true',
        runs: 200
      }
    }
  }
};

/* truffle compile : to deploy our contracts we should make js files to use ABI
thus, we run truffle compile to create contracts json file automatically*/