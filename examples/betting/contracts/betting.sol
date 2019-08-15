pragma solidity ^0.4.23;

import "../../../contracts/builtin.sol";

/// @title Betting stores game information into a contract storage.
/// Just for example, the information of each game is very simple and it includes id, startingBankroll, wageringSize and bankroll.
/// Only master or users of the contract have authority to add game information.

contract Betting {

    struct Game {
        // game id
        bytes id;

        // starting bankroll
        string startingBankroll;

        // wagering size
        uint wageringSize;

        // bankroll
        uint bankroll;
    }

    mapping(bytes32=>Item) Game;

    using Builtin for Betting;

    Extension extension = Builtin.getExtension();

    event AddGame(bytes id, string startingBankroll, uint wageringSize, uint bankroll);

    modifier onlyMasterOrUsers() {
        require(msg.sender == this.$master() || this.$isUser(msg.sender));
        _;
    }

    modifier onlyMaster() {
        require(msg.sender == this.$master());
        _;
    }

    /// @notice The user have the authority to add or modify Game info.
    function addUser(address user) public onlyMaster {
        this.$addUser(user);
    }

    function removeUser(address user) public onlyMaster {
        this.$removeUser(user);
    }

    function setMaster(address master) public onlyMaster {
        this.$setMaster(master);
    }

    function setCreditPlan(uint256 credit, uint256 recoveryRate) public onlyMaster {
        this.$setCreditPlan(credit, recoveryRate);
    }

    function creditPlan() public view returns(uint256 credit, uint256 recoveryRate) {
        return this.$creditPlan();
    }

    /// @notice The master or users will add an item of game info. 
    function addGameItem(bytes id, string startingBankroll, uint wageringSize, uint bankroll) public onlyMasterOrUsers {
        bytes32 key = extension.blake2b256(id);
        Game[key].id = id;
        Game[key].startingBankroll = startingBankroll;
        Game[key].wageringSize = wageringSize;
        Game[key].bankroll = bankroll;

        emit AddGame(id, startingBankroll, wageringSize, bankroll);
    }

    /// @notice To get game info from id.
    function getGameItem(bytes id) public view returns(string, uint, uint) {
        bytes32 key = extension.blake2b256(id);
        return(Game[key].startingBankroll, Game[key].wageringSize, Game[key].bankroll);
    }

}
