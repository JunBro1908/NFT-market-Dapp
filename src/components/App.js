import React, { Component } from "react";
import Web3 from "web3";
import detectEthereumProvider from '@metamask/detect-provider';
import KryptoDog from '../abis/KryptoDog.json';
// get bootstrap at index.js => all components can access
import {MDBCard, MDBCardBody, MDBCardTitle, MDBCardText, MDBCardImage, MDBBtn} from 'mdb-react-ui-kit'
import './App.css';

class App extends Component {

    // call the function loadweb3 (= useEffect) / request DOM to update the result
    async componentDidMount() {
        // 'this.' : same object
        await this.loadWeb3();
        await this.loadBlockchainData();
    }

    // check the ethereum provider
    async loadWeb3() {
        const provider = await detectEthereumProvider();
        // return Promise
        
        if(provider) {
            console.log('wallet is connected');
            window.web3 = new Web3(provider);
            // make new instance of provider and show on the screen by window method
        } else {
            console.log('wallet is not connected');
        }
    }
    
    async loadBlockchainData() {
        // get account data from the instance Web3(provider) : selectedAddress:''
        const web3 = window.web3;
        // for convenience

        const accounts = await web3.eth.getAccounts();
        this.setState({account:accounts[0]});
        // constructor -> state -> account: accounts[0] (= ['0x...'])

        // get network Id of blockchain(ganache)
        const networkId = await web3.eth.net.getId();

        // output => address and transaction Hash from KryptoDog.js ABI : network -> networkId(5777)
        const networkData = KryptoDog.networks[networkId];

        // networkData is exisit
        if(networkData) {
            const abi = KryptoDog.abi;

            // contract address
            const address = networkData.address;

            // use abi and address to get contract data
            const contract = await new web3.eth.Contract(abi, address);
            this.setState({contract:contract});

            // web3 (get contract's function) : contract.methods.function().call()
            const totalSupply = await this.state.contract.methods.totalSupply().call();
            this.setState({totalSupply:totalSupply});

            // track the token
            for(var i=1; i <= totalSupply; i++) {
                const KryptoDog = await contract.methods.kryptoDogz(i-1).call();
                this.setState({
                    kryptoDogz:[...this.state.kryptoDogz, KryptoDog]
                    // Spread Operator : update the state
                })
            }

        } else {
            window.alert('Smart contract is not deployed');
        }
    }

    // with minting function use .send : need 1) from address 
    // KryptoDog : url data
    mint = (token_url) => {
        this.state.contract.methods.mint(token_url).send({from : this.state.account})
        .once('minting', (minting)=> {
            this.setState({
                kryptoDogz:[...this.state.kryptoDogz, KryptoDog]
            })
        })
    }

    // burning, approval, transfer options...

    // class component : using state
    constructor(props) {
        // call super : all components => parents class form
        super(props);
        // get the account at loadBlockchinaData and initialize
        this.state = {
            account: '',
            contract: null,
            // object init
            totalSupply: 0,
            kryptoDogz: [],
            // track the token with array
        }
    }
    
    render() {
        return (
        <div className="container-filled">
            <nav className="collapse show" id="navbarToggleExternalContent">
                <div className="bg-dark p-4">
                    <h5 className="text-white h4">NFT_Remember : KryptoDogz</h5>
                    <span className="text-muted">Account : {this.state.account}</span>
                </div>
            </nav>
            <div className="container-fluid mt-1">
                <div className="row">
                    <main role='main' className="col-lg-12 d-flex text-center">
                        <div className="content mr-auto ml-auto mt-5" style={{opacity:'0.8'}}>
                            <h1 style = {{color:'white'}}>Record your memories with your dog</h1>
                            <h3 style={{color:'gray'}}>with KryptoDogz</h3>
                            <form className='mt-5' onSubmit={(event)=> {
                                    // input => ref => this.url(= input) => this.url.value = mint('typed url')
                                    const kryptoDog = this.url.value;
                                    event.preventDefault();
                                    this.mint(kryptoDog);
                                }}>
                                <input
                                autocomplete="off"
                                className="form-control mb-1"
                                // what type of info we get
                                type='text'
                                // default sentence
                                placeholder='Add KryptoDogz URL'
                                // reference the input value and set this.url
                                ref = {(input) => this.url = input}
                                />
                                <button className='mt-3 btn btn-dark'>MINT</button>
                            </form>
                        </div>
                    </main>
                </div>
                <div className="row textCenter">
                    {this.state.kryptoDogz.map((kryptoDog, key)=>{
                        return(
                            <div>
                                <div>
                                    <MDBCard className="token img" style={{maxWidth:'22rem'}}>
                                        <MDBCardImage src={kryptoDog} position='top' height='250rem' style={{marginRight:'4px'}}/>
                                        <MDBCardBody>
                                            <MDBCardTitle>NAME</MDBCardTitle>
                                            <MDBCardText>DESCRIPTION</MDBCardText>
                                            <MDBBtn href={kryptoDog}>DOWNLOAD</MDBBtn>
                                        </MDBCardBody>
                                    </MDBCard>
                                </div>
                            </div>
                        )
                    })}              
                </div>        
            </div>
        </div>
        )
    }
}

export default App;