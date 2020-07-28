var fs = require('fs');
const { gray, green, yellow, red, bgRed } = require('chalk');

// Get the contents of the directory and loop over it.
fs.readdir('./build/truffle/', function(err, list)
{
    for (var i = 0; i < list.length; i++)
    {
        // Get the contents of each file on iteration.
        let filename = list[i];

        fs.readFile("./build/truffle/" + filename, function(err, data)
        {
            var parsedData = JSON.parse(data);
            const contractSize = parsedData.deployedBytecode.length /2000
            if (contractSize > 24) {
                console.log(gray(parsedData.contractName + '.sol: '), red(contractSize +' kb'))
            } else {
                console.log(gray(parsedData.contractName + '.sol: '), contractSize + ' kb')
            }
        });
    }
});