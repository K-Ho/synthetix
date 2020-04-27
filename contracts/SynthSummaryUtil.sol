/**
 *Submitted for verification at Etherscan.io on 2020-02-26
*/

pragma solidity 0.5.16;
contract ISynth {
    bytes32 public currencyKey;
    function balanceOf(address owner) external view returns (uint);
}
contract ISynthetix {
    ISynth[] public availableSynths;
    function availableSynthCount() public view returns (uint);
    function availableCurrencyKeys()
        public
        view
        returns (bytes32[] memory);
}

contract IExchangeRates {
    function rateIsFrozen(bytes32 currencyKey) external view returns (bool);
    function ratesForCurrencies(bytes32[] calldata currencyKeys) external view returns (uint[] memory);
    function effectiveValue(bytes32 sourceCurrencyKey, uint sourceAmount, bytes32 destinationCurrencyKey)
    public
    view
    returns (uint);
}

contract SynthSummaryUtil {
    ISynthetix public synthetix;
    IExchangeRates public exchangeRates;
    constructor(address _synthetix, address _exchangeRates) public {
        synthetix = ISynthetix(_synthetix);    
        exchangeRates = IExchangeRates(_exchangeRates);
    }
    
    function totalSynthsInKey(address account, bytes32 currencyKey) public view returns (uint total) {
        uint numSynths = synthetix.availableSynthCount();
        for (uint i = 0; i < numSynths; i++) {
            ISynth synth = synthetix.availableSynths(i);
            total += exchangeRates.effectiveValue(synth.currencyKey(), synth.balanceOf(account), currencyKey);
        }
        return total;
    }
    
    function synthsBalances(address account) external view returns (bytes32[] memory, uint[] memory,  uint[] memory) {
        uint numSynths = synthetix.availableSynthCount();
        bytes32[] memory currencyKeys = new bytes32[](numSynths);
        uint[] memory balances = new uint[](numSynths);
        uint[] memory sUSDBalances = new uint[](numSynths);
        for (uint i = 0; i < numSynths; i++) {
            ISynth synth = synthetix.availableSynths(i);
            currencyKeys[i] = synth.currencyKey();
            balances[i] = synth.balanceOf(account);
            sUSDBalances[i] = exchangeRates.effectiveValue(synth.currencyKey(), synth.balanceOf(account), 'sUSD');
        }
        return (currencyKeys, balances, sUSDBalances);
    }
    
    function frozenSynths() external view returns (bytes32[] memory) {
        uint numSynths = synthetix.availableSynthCount();
        bytes32[] memory frozenSynthsKeys = new bytes32[](numSynths);
        for (uint i = 0; i < numSynths; i++) {
            ISynth synth = synthetix.availableSynths(i);
            if (exchangeRates.rateIsFrozen(synth.currencyKey())) {
                frozenSynthsKeys[i] = synth.currencyKey();
            }
            
        }
        return frozenSynthsKeys;
    }
    
    function synthsRates() external view returns (bytes32[] memory, uint[] memory) {
        bytes32[] memory currencyKeys = synthetix.availableCurrencyKeys();
        return (currencyKeys, exchangeRates.ratesForCurrencies(currencyKeys));
    }

    function totalSynthsInKeyForAccounts(address[] calldata accounts , bytes32 currencyKey)
        external
        view
        returns (uint256[] memory)
    {
        uint256 numAccounts = accounts.length;
        uint256[] memory accountsTotal = new uint256[](numAccounts);
        for (uint256 i = 0; i < numAccounts; i++) {
            address account = accounts[i];
            uint256 total = totalSynthsInKey(account, currencyKey);
            accountsTotal[i] = total;
        }
        return accountsTotal;
    }
}