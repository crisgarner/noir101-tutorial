// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../circuits/contract/plonk_vk.sol";

contract SecretCaller {
    UltraVerifier public verifier;

    constructor(UltraVerifier _verifier) {
        verifier = _verifier;
    }

    function secretCall(
        bytes calldata proof,
        address _contract,
        uint256 _value,
        bytes32 _signature,
        bytes memory _data
    ) public view  {
        bytes32[] memory publicInputs = new bytes32[](4);
        publicInputs[0] =  bytes32(bytes20(_contract));
        publicInputs[1] =  bytes32(_value);
        publicInputs[2] =  bytes32(_signature);
        publicInputs[3] =  bytes32(_data);
        // _publicInputs[64] = merkleRoot;
        // _publicInputs[65] = bytes32(uint256(uint160(msg.sender)));
        // bytes32[] memory _publicInputs = new bytes32[](4);
        // _publicInputs[0] = bytes32(bytes20(_contract));
        // _publicInputs[1] = bytes32(_value);
        // _publicInputs[2] = _signature;
        // _publicInputs[3] = bytes32(_data);
        // [bytes32(bytes20(_contract)),bytes32(_value),_signature,bytes32(_data)];
        require(verifier.verify(proof, publicInputs), "Proof is not valid");
        //TODO: Make My Token Call
    }
}
