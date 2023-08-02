// SPDX-License-Identifier: SEE LICENSE IN LICENSE

pragma solidity 0.8.20;

// totalSupply()
// balanceOf(account)
// transfer(recipient, amount)
// allowance(owner, spender)
// approve(spender, amount)
// transferFrom(sender, recipient, amount)
// Transfer(from, to, value)
// Approval(owner, spender, value)

contract AdityaToken {
    string public s_name;
    string public s_symbol;
    uint256 public immutable i_decimal;
    uint256 public immutable i_totalSupply;
    address public immutable i_owner;

    mapping(address => uint) public s_addressToBalance;
    mapping(address owner => mapping(address spender => uint amount))
        public s_approvalAmount;

    event Transfer(
        address indexed from,
        address indexed to,
        uint indexed amount
    );
    event Approval(
        address indexed owner,
        address indexed spender,
        uint indexed amount
    );

    constructor() {
        s_name = "AdityaToken";
        s_symbol = "ADT";
        i_decimal = 8;
        i_totalSupply = 100000000;
        i_owner = msg.sender;
        s_addressToBalance[i_owner] = i_totalSupply;
    }

    function balanceOf(address owner) public view returns (uint) {
        return s_addressToBalance[owner];
    }

    function transfer(address recipient, uint amount) public {
        require(s_addressToBalance[msg.sender] >= amount, "Not enough funds!!");
        s_addressToBalance[msg.sender] -= amount;
        s_addressToBalance[recipient] += amount;

        emit Transfer(msg.sender, recipient, amount);
    }

    function approve(address spender, uint amount) public {
        require(s_addressToBalance[msg.sender] >= amount, "Not enough funds!!");
        require(amount > 0, "Amount is zero!");
        s_approvalAmount[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);
    }

    function allowance(
        address owner,
        address spender
    ) public view returns (uint) {
        return s_approvalAmount[owner][spender];
    }

    function transferFrom(address owner, address spender, uint amount) public {
        require(
            s_approvalAmount[owner][spender] >= amount,
            "Not enough approved!!"
        );
        require(s_addressToBalance[owner] >= amount, "Not enough funds!!");
        s_approvalAmount[owner][spender] -= amount;
        s_addressToBalance[owner] -= amount;
        s_addressToBalance[spender] += amount;
    }
}
