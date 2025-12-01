//合约地址：0xb85924c1377dbecfd86d3fbcc27a4eec1e8a39dc
//交易哈希：0xf6d4f3331328c2ce8d678516d2c6deab13783e7d8c3d90ab14b669a3633ac807
//说明：候选人：jack与jane,输入对应名字进行投票,输入0或1查看对应候选人的选票数。
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}

contract voting {
    
    Candidata[] internal candidatas;
    IERC20 public token;
    struct Candidata {
            string name;
            uint count;
    }
    mapping ( address => bool ) internal votername;
    mapping ( string => uint ) internal nameIndex;

    constructor ( address _token ) {
        token = IERC20(_token);
        candidatas.push( Candidata("jack", 0) );
        candidatas.push( Candidata("jane", 0) );
        nameIndex["jack"] = 0;
        nameIndex["jane"] = 1;
    }

    function votecandidata ( string memory _name ) external {
        require( votername[msg.sender] != true );
        require( token.balanceOf( msg.sender ) > 0 );
        require( keccak256( bytes( _name ) ) == keccak256( bytes( "jack" ) ) || keccak256( bytes( "jane" ) ) == keccak256( bytes( _name ) ) );
        candidatas[nameIndex[_name]].count ++;
        votername[msg.sender] = true;
    }

    function viewCount ( uint _number ) public view returns ( string memory name, uint count ) {
        if ( _number == 0 ) {
            return ( candidatas[0].name, candidatas[0].count );
        }
        else if ( _number == 1 ) {
            return ( candidatas[1].name, candidatas[1].count );
        } 
    }
    
}