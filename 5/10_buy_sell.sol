pragma solidity ^0.4.19;

contract InnoCoin {

    string public constant name = "InnoCoin";
    string public constant symbol = "INC";
    uint8 public constant decimals = 18;


    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
    event Transfer(address indexed from, address indexed to, uint tokens);


    mapping(address => uint256) balances;

    mapping(address => mapping (address => uint256)) allowed;

    uint256 totalSupply_;

    address owner_;

    using SafeMath for uint256;


   constructor() public {
	totalSupply_ = 10000000 ether;
	owner_ = msg.sender;

	balances[owner_] = totalSupply_;
    }

    function totalSupply() public view returns (uint256) {
	return totalSupply_;
    }

    function balanceOf(address tokenOwner) public view returns (uint) {
        return balances[tokenOwner];
    }

    function transfer(address receiver, uint numTokens) public returns (bool) {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender].sub(numTokens);
        balances[receiver] = balances[receiver].add(numTokens);
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function approve(address delegate, uint numTokens) public returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(address owner, address delegate) public view returns (uint) {
        return allowed[owner][delegate];
    }

    function transferFrom(address owner, address buyer, uint numTokens) public returns (bool) {
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);

        balances[owner] = balances[owner].sub(numTokens);
        allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
        balances[buyer] = balances[buyer].add(numTokens);
        emit Transfer(owner, buyer, numTokens);
        return true;
    }

    function contractBalance() public view onlyOwner returns(uint256) {
        return contractBalance_();
    }

    function contractBalance_() internal view returns(uint256) {
        return address(this).balance;
    }

    function buy() public payable returns(uint256) {
        uint256 tokenAmount = msg.value.mul(100000);

        require(balances[owner_] >= tokenAmount);

        balances[owner_] = balances[owner_] - tokenAmount;
        balances[msg.sender] = balances[msg.sender] + tokenAmount;

        return tokenAmount;
    }

    function sell(uint256 amount) public returns(uint256) {
        require(amount >= 1000000); // resulting ether amount should be integer
        uint256 etherAmount = amount.div(100000).div(10).mul(9); // 0.9 eth for 100000 inc => 1 / 10 * 9 eth for 100000 inc

        require(balances[msg.sender] >= amount);
        require(contractBalance_() >= etherAmount);

        balances[owner_] = balances[owner_] + amount;
        balances[msg.sender] = balances[msg.sender] - amount;
        msg.sender.transfer(etherAmount);

        return etherAmount;
    }

    function withdraw() public onlyOwner {
        require(contractBalance() >= 0);

        owner_.transfer(contractBalance());
    }

    modifier onlyOwner() {
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

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a / b;
        assert(c * b == a);
        return c;
    }
}