## builtin contracts
- `authority.sol`

    Authority is related to the POA(proof of authority) consensus mechanism.
The Authority contract manages a list of candidates proposers who is responsible for packing transactions into a block.
The proposers are authorized by a voting committee, but only the first 101 proposers in the candidates list can pack block.
A candidates proposer include signer address, endorsor address and identity.
Signer address is releated to sign a block, endorsor address is used for charging miner's fee and identity is used for identifying the proposer.

- `energy.sol`

    Energy represents the sub-token in PowerPlay which conforms VIP180(ERC20) standard.
The name of token is "PowerPlay" and 1 POWERPLAY equals to 1e18 wei. The main function of PowerPlay is to pay for the transaction fee. 
PowerPlay is generated from PMK, so the initial supply of PowerPlay is zero in the genesis block.
The growth rate of PowerPlay is 5000000000 wei per token(PMK) per second, that is to say 1 PMK will produce about 0.000543 POWERPLAY per day.
The miner will charge 30 percent of transation fee and 70 percent will be burned. So the total supply of PowerPlay is dynamic.

- `extension.sol`

    Extension extends EVM functions.
Extension gives an opportunity for the developer to get information of the current transaction and any history block within the range of genesis to best block.
The information obtained based on block numer includes blockID, blockTotalScore, blockTime and blockSigner.
The developer can also get the current transaction information, including txProvedWork, txID, txBlockRef and txExpiration.

- `params.sol`

    Params stores the governance params of PowerPlay.
The params can be set by the executor, a contract that is authorized to modify governance params by a voting Committee.
Anyone can get the params just by calling "get" funtion.
The governance params is written in genesis block at launch time.
You can check these params at source file: https://github.com/playmakerchain/powerplay/blob/master/powerplay/params.go.

- `prototype.sol`

    Prototype is an account management model of PowerPlay.
In the account management model every contract has a master account, which, by default, is the creator of a contract.
The master account plays the role of a contract manager, which has some authorities including 
"setMaster", "setCreditPlan", "addUser", "removeUser" and "selectSponsor".
Every contract keeps a list of users who can call the contract for free but limited by credit.
The user of a specific contract can be either added or removed by the contract master.
Although from a user's perspective the fee is free, it is paid by a sponsor of the contract.
Any one can be a sponser of a contract, just by calling sponsor function, and also the sponsor identity can be cancelled by calling unsponsor funtion.
A contract may have more than one sponsors, but only the current sponsor chosen by master need to pay the fee for the contract.
If the current sponsor is out of energy, master can select sponser from other sponsers candidates by calling selectSponsor function.
The creditPlan can be set by the master which includes credit and recoveryRate. Every user have the same original credit.
Every Transaction consumes some amount of credit which is equal to the fee of the Transaction, and the user can also pay the fee by itself if the gas payer is out of the credit. 
The credit can be recovered based on recoveryRate (per block).

- `executor.sol`

    Executor represents core component for on-chain governance. 
The on-chain governance params can be changed by the Executor through a voting.
A executive committee are composed to seven approvers who had been added to the contract Executor in the genesis block.
The new approver can be added and the old approver also can be removed from the executive committee.
The steps of executor include proposing, approving and executing voting if the voting was passed.
Only the approver in the executive committee has the authority to propose and approving a voting.


## Library Builtin
- `builtin.sol`

    The PowerPlay builtin contracts are encapsulated in library Builtin. It's very easy to use it for the developer, just import it.

## instance contracts
- `CommodityInfo.sol`

    CommodityInfo stores commodity information into a contract storage.
Just for example, the information of commodity is very simple and it includes id, originPlace, productionDate and shelfLife.
Only master or users of the contract have authority to add commodity information.

- `Voting.sol`

    Voting intends to modify governance params 'BaseGasPrice' in PowerPlay by executor.
First a voting will be proposed by an approver, and the approvers will vote it in a week.
If two thirds of approvers approver the voting, the voting can be executed.
