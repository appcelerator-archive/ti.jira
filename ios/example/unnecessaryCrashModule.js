exports.simulateCrash = simulateCrash;

var mod = require('moduleThatDoesNotExist');
function simulateCrash() {
    mod.crashBecauseThisMethodDoesNotExist();
}