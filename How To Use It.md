## How to use it

- `extension`

The contract extension gives extension information about blockchain including "blockID", "txID", and "blockTotalScore" etc. And you can reference it conveniently in your dapp. So you maybe have a contract named "Example.sol"

1. Import "Library Builtin" in your solidity code "Example.sol".
    ```
    import "./builtin.sol"
    ```

2. Create your contract "Example" and get instance of extension.
    ```
    contract Example {
        Extension extension = Builtin.getExtension()
    }
    ```
3. In some cases you maybe want to calculate blake2b-256 checksum of given _data.
    ```
        bytes32 ret = extension.blake2b256(_data);
    ```
4. Get blockID of blockNum
    ```
        bytes32 id = extension.blockID(blockNum);
    ```
5. Get blockTotalScore of blockNum
    ```
        uint64 totalScore = extension.blockTotalScore(blockNum);
    ```
6. Get blockTime of blockNum
    ```
        uint time = extension.blockTime(blockNum);
    ```
7. Get blockSigner of blockNum
    ```
        address signer = extension.blockSigner(blockNum);
    ```
8. Get totalSupply of PMK
    ```
        uint256 total = extension.totalSupply();
    ```
9. Get txProvedWork of current transaction
    ```
        uint256 provedWork = extension.txProvedWork();
    ```
10. Get txID of current transaction
    ```
        bytes32 id = extension.txID();
    ```
11. Get txBlockRef of current transaction
    ```
        bytes8 Ref = extension.txBlockRef();
    ```
12. txExpiration of current transaction
    ```
        uint expiration = extension.txExpiration();
    ```

- `executor`

Some builtin contracts need executor to execute it, such as "authority.sol" and "params.sol". We use "executor" including three steps: "propose a voting", "voting by executive committee" and "execute a voting". So you maybe have a voting contract named "voting.sol".

1. Import "Library Builtin" in your solidity code "voting.sol"
    ```
    import "./builtin.sol"
    ```
2. Create your voting contract and add "propose functon" named "propose".
    ```
    contract voting {
        bytes32 proposalID;
        Executor executor = Builtin.getExecutor();

        function propose(address target, bytes _data) {
            proposalID = executor.propose(target, _data);
        }
    }
    ```
3. The executive committee will approve a voting, so will add approve function named "approve".
    ```
    contract voting {
        ......

        function approve() {
            executor.approve(proposalID);
        }
    }
    ```
4. If a voting is passed in one week, anybody can execute it. So we add execute function named "execute".
    ```
    contract voting {
        ......

        function execute() {
            executor.execute(proposalID);
        }
    }
    ```

- `authority`

If you want to update authority node, you should have a target contract, such as "Target.sol". Because only the contract executor have the authority to execute it, so firstly you should propose a voting to executor. If the voting is passed in a week, you can execute your target contract. Now you can write code like this.

1. Import "Library Builtin" in your solidity code "Target.sol".

    ```
    import "./builtin.sol"
    ```

2. Create your target contract, we named it "Target", and create the target function named "targetFunc". We suppose you want to add "_signer" to the candidate of authority node.
    ```
    contract Target {
        Authority authority = Builtin.getAuthority();

        function targetFunc() {
            authority.add(_signer, _endorsor, _indentity);
        }
    }
    ```
3. You may be propose a voting by executor, and add the proposing function named "proposeFunc".
    ```
    contract Target {
        ......

        bytes32 proposalID;
        Executor executor = Builtin.getExecutor();
        function proposeFunc() {
            proposalID = executor.propose(address(this), abi.encodePacked(keccak256("targetFunc()")));
        }
    }
    ```
4. If the voting is passed in one week, you can execute it, so we should add "execute function" named "executeFunc".
    ```
    contract Target {
        ......

        function executeFunc() {
            executor.execute(proposalID);
        }
    }
    ```
5. Only "add" and "revoke" need executor to execute it, other functions like "get", "first" and "next", you can call it as your will.

- `parmas`

The operaion of parmas is very simple, just including "set" and "get". But the "set" operaion need executor to execute.

- `prototype`

The prototype gives extra property to contract, such as "master", "user", "sponsor" and "credit". Once a contract is created, the contract have these properties automatically. So you maybe just create a empty contract named "EmptyContract".

1. Import "Library Builtin" in your solidity code "EmptyContract.sol".
    ```
    import "./builtin.sol"
    ```

2. Create your "EmptyContract", and using "Library Builtin" for EmptyContract
    ```
    contract EmptyContract {
        using Builtin for EmptyContract;
    }
    ```
3. You maybe want to know who is the master of the contract, you just call like this in your contract:
    ```
    contract EmptyContract {
        using Builtin for EmptyContract;
        address master = this.$master();
    }
    ```
4. You alse can set a new master to your contract, but the msg sender must be the old master.
    ```
        this.$setMaster(newMaster);
    ```
5. Get the blance of the contract:
    ```
        uint256 blance = this.$balance(block.number);
    ```
6. Get the energy(PWP) of the contract:
    ```
        uint256 energy = this.$energy(block.number);
    ```
7. Check storage value by "key".
    ```
        bytes32 value = this.$storageFor(key);
    ```
8. Check creditPlan of a contract.
    ```
        uint256 credit;
        uint256 recoveryRate;
        credit, recoveryRate = this.$creditPlan()
    ```
9. Set a new creditPlan to a contract, but only the master have the authority to do it.
    ```
        this.$setCreditPlan(credit, recoveryRate);
    ```
10. Add a user to contract, and the operation need master authority.
    ```
        this.$addUser(newUser);
    ```
11. Remove an old user from contract(need master authority).
    ```
        this.$removeUser(oldUser);
    ```
12. Check if somebody is the user of a given contract.
    ```
        bool isUser = this.$isUser(somebody);
    ```
13. Check somebody userCredit of a contract:
    ```
        uint256 credit = this.$userCredit(somebody);
    ```
14. Check if somebody is the sponsor of a contract.
    ```
        bool isSponsor = this.$isSponsor(somebody);
    ```
15. Check who is the currentSponsor.
    ```
        address somebody = this.$currentSponsor();
    ```

