pragma solidity ^0.4.24;
import "./ERC20.sol";


contract EMKTTokenStandard is ERC20 {

    uint256 valueOfTokenInFinney  = 10;

    function transfer(address _to, uint256 _value) public  returns (bool success) {
        if (balances[msg.sender] >= _value && _value > 0) {
            balances[msg.sender] -= _value;
            balances[_to] += _value;
            emit TransferEvent(msg.sender, _to, _value);
            return true;
        } else { 
            return false; 
        }
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
            balances[_to] += _value;
            balances[_from] -= _value;
            allowed[_from][msg.sender] -= _value;
            emit TransferEvent(_from, _to, _value);
            return true;
        } else { 
            return false; 
        }
    }

    function balanceOf(address _owner)  public constant returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) public  returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        emit ApprovalEvent(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

    function sellToken(uint256 _amount) public payable {
        if(balances[owner] >= _amount && _amount > 0) {
            uint256 total = _amount * valueOfTokenInFinney;
            uint256 totalValue = msg.value * 1000;
            if(total == totalValue) {
                balances[msg.sender] += _amount;
                balances[owner] -= _amount;
            } else {
                revert();
            }
        } else {
            revert();
        }
    }

    mapping (address => uint256) public balances;
    mapping (address => mapping (address => uint256)) public allowed;
    uint256 public totalSupply;
}