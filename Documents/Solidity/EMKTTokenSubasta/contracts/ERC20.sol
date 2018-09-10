pragma solidity ^0.4.24;


contract ERC20 {
    function balanceOf(address tokenOwner) public constant returns (uint balance);
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);
    function sellToken(uint amount) public payable;
    event TransferEvent(address indexed from, address indexed to, uint tokens);
    event ApprovalEvent(address indexed tokenOwner, address indexed spender, uint tokens);
    address public owner ;
}