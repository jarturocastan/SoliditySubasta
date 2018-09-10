pragma solidity ^0.4.16;
import "./EMKTToken.sol";


contract Subasta {
    EMKTToken emktToken = EMKTToken(0x450f8F58E874341e6ea33308289AF63A3fd03663);
    address owner;

    constructor() public {
        owner = msg.sender;
    }

    function addSubasta(string name) public returns (uint subastaID) {
        if(emktToken.balanceOf(msg.sender) < 1){revert();}
        subastaID = numSubastas++;
        emktToken.transferFrom(msg.sender,this,1);
        subastas[subastaID] = Subasta(name,true,msg.sender,msg.sender,0);
        return subastaID;
    }

    function editSubasta(uint index,string name) public ownerOnly {
        subastas[index].name = name;
    }

    function closeSubastaBySubastaOwner(uint index) public {
        require(msg.sender == subastas[index].owner);
        if(subastas[index].status == true) {
            if(emktToken.balanceOf(this) < subastas[index].amount) { revert(); }
            emktToken.transferFrom(this,subastas[index].owner,subastas[index].amount);
            subastas[index].status = false;
            subastas[index].owner = subastas[index].ownerTemporal;
        }
    }

    function closeSubasta(uint index) public ownerOnly {
        if(subastas[index].status == true) {
            if(emktToken.balanceOf(this) < subastas[index].amount) { revert(); }
            emktToken.transferFrom(this,subastas[index].owner,subastas[index].amount);
            subastas[index].status = false;
            subastas[index].owner = subastas[index].ownerTemporal;
        }
    }

    function closeAllSubastas() public ownerOnly {
        for (uint index=1; index<=numSubastas; index++) {
            if(subastas[index].status == true) { 
                if(emktToken.balanceOf(this) < subastas[index].amount) { revert(); }
                emktToken.transferFrom(this,subastas[index].owner,subastas[index].amount);
                subastas[index].status = false;
                subastas[index].owner = subastas[index].ownerTemporal;
            }
        }
    }

    function getAllTokens() public ownerOnly {
        for (uint index=1; index<=numSubastas; index++) {
            if(subastas[index].status == true) { revert(); }
        }
        emktToken.transferFrom(this,owner,emktToken.balanceOf(this));
    }

    function sendToken(uint256 amount,uint index) public {
        if(emktToken.balanceOf(msg.sender) < amount) { revert();}
        if(subastas[index].amount > amount){ revert();}   
        emktToken.transferFrom(msg.sender,this,subastas[index].amount);
        subastas[index].ownerTemporal = msg.sender;
        subastas[index].amount = amount;
        emktToken.transferFrom(msg.sender,this,amount);
    }

    function getTotalTokens() view public ownerOnly returns (uint) {
        return emktToken.balanceOf(this);
    }

    function getTotalTokensOfAccount(address account) view public ownerOnly returns (uint) {
        return emktToken.balanceOf(account);
    }

    modifier ownerOnly {
        require(msg.sender == owner);
        _;
    }

    struct  Subasta {
        string name;
        bool status;
        address owner;
        address ownerTemporal;
        uint256 amount;
    }


    uint numSubastas;
    mapping (uint => Subasta) public subastas; 
}