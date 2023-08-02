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
        string memory _signature,
        bytes memory _data
    ) public {
        bytes32[] memory publicInputs = new bytes32[](4);
        publicInputs[0] = bytes32(uint256(uint160(_contract)));
        publicInputs[1] = bytes32(_value);
        //hardcoded at the moment as there are issues generating a field from string
        publicInputs[
            2
        ] = 0x000000000000000000000000000000000000006d696e742875696e7432353629;
        publicInputs[3] = bytes32(_data);
        require(verifier.verify(proof, publicInputs), "Proof is not valid");
        bool success = executeTransaction(_contract, _value, _signature, _data);
        require(success, "Transaction execution reverted.");
    }

    function executeTransaction(
        address _contract,
        uint256 _value,
        string memory _signature,
        bytes memory _data
    ) private returns (bool) {
        bytes memory callData;
        if (bytes(_signature).length == 0) {
            callData = _data;
        } else {
            callData = abi.encodePacked(
                bytes4(keccak256(bytes(_signature))),
                _data
            );
        }
        // solium-disable-next-line security/no-call-value
        (bool success, ) = _contract.call{value: _value}(callData);
        return success;
    }
}
