require("dotenv").config();
const Web3 = require("web3");
const web3 = new Web3(process.env.WEB3_URL);
var ERC20 = new web3.eth.Contract([
  {
    constant: false,
    inputs: [
      {
        name: "_to",
        type: "address"
      },
      {
        name: "_value",
        type: "uint256"
      }
    ],
    name: "transfer",
    outputs: [
      {
        name: "",
        type: "bool"
      }
    ],
    payable: false,
    stateMutability: "nonpayable",
    type: "function"
  }
]);
async function transfer(accountAddress, tokenAddress, amount) {
  var tx = {
    to: tokenAddress,
    data: ERC20.methods.transfer(accountAddress, amount).encodeABI(),
    gas: "9990236"
  };

  web3.eth.accounts
    .signTransaction(tx, process.env.FAUCET_PRIVATE_KEY)
    .then(signed => {
      web3.eth
        .sendSignedTransaction(signed.rawTransaction)
        .on("receipt", receipt => {
          console.log(
            `Sent ${amount} wei to ${accountAddress} token address: ${tokenAddress}`
          );
        });
    });
}
(async () => {
  const accountAddress = process.argv[2];
  const amount = web3.utils.toWei(process.argv[3]);
  const proxysUSDAddress = "0x873a740bEcB75618A93bC0FC3f6c07D81875B2c3";
  const synthsUSDAddress = "0xEEbd7Fe4885c56F218328e1C4bedB0688a13475a";
  await transfer(accountAddress, proxysUSDAddress, amount);
  await transfer(accountAddress, synthsUSDAddress, amount);
})();
