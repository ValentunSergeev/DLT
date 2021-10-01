pragma solidity ^0.4.19;
pragma experimental ABIEncoderV2;

contract ERC20 {
    string public name;
    string public symbol;
    uint8 public decimals;

    event Approval(
        address indexed tokenOwner,
        address indexed spender,
        uint256 tokens
    );
    event Transfer(address indexed from, address indexed to, uint256 tokens);

    mapping(address => uint256) balances;

    mapping(address => mapping(address => uint256)) allowed;

    uint256 totalSupply_;

    address owner_;

    using SafeMath for uint256;

    constructor(
        uint256 total,
        string _name,
        string _symbol,
        uint8 _decimals,
        address owneraddress
    ) public {
        owner_ = owneraddress;
        totalSupply_ = total;
        balances[owner_] = totalSupply_;
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }

    function updateTotalSupply(uint256 newSupply) public onlyOnwer {
        uint256 diff;

        if (newSupply < totalSupply_) {
            diff  = totalSupply_ - newSupply;

            require(balances[owner_] >= diff);

            totalSupply_ = newSupply;
            balances[owner_] = balances[owner_].sub(diff);
        } else {
            diff = newSupply - totalSupply_;

            totalSupply_ = newSupply;
            balances[owner_] = balances[owner_].add(diff);
        }
    }

    function updateSymbol(string newSymbol) public onlyOnwer {
        symbol = newSymbol;
    }

    function updateName(string newName) public onlyOnwer {
        name = newName;
    }

    function totalSupply() public view returns (uint256) {
        return totalSupply_;
    }

    function balanceOf(address tokenOwner) public view returns (uint256) {
        return balances[tokenOwner];
    }

    function transfer(address receiver, uint256 numTokens) public returns (bool)
    {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender].sub(numTokens);
        balances[receiver] = balances[receiver].add(numTokens);
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function approve(address delegate, uint256 numTokens)
        public
        returns (bool)
    {
        allowed[msg.sender][delegate] = numTokens;
        Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(address owner, address delegate) public view returns (uint256)
    {
        return allowed[owner][delegate];
    }

    function transferFrom(
        address owner,
        address buyer,
        uint256 numTokens
    ) public returns (bool) {
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);

        balances[owner] = balances[owner].sub(numTokens);
        allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
        balances[buyer] = balances[buyer].add(numTokens);
        Transfer(owner, buyer, numTokens);
        return true;
    }

    modifier onlyOnwer() {
        require(msg.sender == owner_);
        _;
    }
}

library SafeMath {
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}