pragma solidity ^0.4.24;
import "./EMKTTokenStandard.sol";


contract EMKTToken is EMKTTokenStandard {

    string public name;                  
    uint8 public decimals;             
    string public symbol;              
    string public version = "1.0";      

    constructor() public {
        balances[msg.sender] = 1000;      
        owner = msg.sender;         
        totalSupply = 1000;                        
        name = "Token de prueba de consultoresemkt";                               
        decimals = 0;                         
        symbol = "EMKT";                            
    }

 
    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        emit ApprovalEvent(msg.sender, _spender, _value);
        if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
        return true;
    }
}