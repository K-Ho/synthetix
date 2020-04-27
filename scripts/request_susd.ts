const Web3 = require("web3");
const HDWalletProvider = require("truffle-hdwallet-provider");
const mnemonic = "candy maple cake sugar pudding cream honey rich smooth crumble sweet treat";
const {wallets} = new HDWalletProvider(mnemonic, "http://127.0.0.1:8545/", 0, 10)
const accountAddress = Object.keys(wallets)[0]
const privateKey = "0x" + wallets[accountAddress]._privKey.toString("hex")
console.log(accountAddress)
const web3 = new Web3(`https://kovan.infura.io/v3/28d900c929bf4df88e0a4adc9f790e22`);
const amount = web3.utils.toWei(process.argv[2]);
var sUSD = new web3.eth.Contract([{
		"constant": false,
		"inputs": [
			{
				"internalType": "address",
				"name": "account",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "amount",
				"type": "uint256"
			}
		],
		"name": "mint",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	}
], '0xAdfe2B5BeAc83382C047d977db1df977FD9a7e41', {
    from: accountAddress, // default from address
  // gasPrice: '20000000000' // default gas price in wei, 20 gwei in this case
});
// sUSD.methods.mint(accountAddress, 100).send().then(() => {
//   console.log("Mininted 100 tokens")
// })
const mintData = sUSD.methods.mint(accountAddress, 100).encodeABI()

var tx = {
    to : '0xAdfe2B5BeAc83382C047d977db1df977FD9a7e41',
    data : mintData,
    gas: '9990236',
}

web3.eth.accounts.signTransaction(tx, privateKey).then(signed => {
    web3.eth.sendSignedTransaction(signed.rawTransaction).on('receipt', ({transactionHash}) => {
    console.log(`Sent ${amount} sUSD to ${accountAddress} in ${transactionHash}`)
 })
});
// const provider = wallet.engine._providers[0]
// wallet.engine._providers[0].getAccounts().then(console.log)
