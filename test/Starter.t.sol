// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../contract/Starter.sol";
import "../circuits/contract/plonk_vk.sol";

contract StarterTest is Test {
    Starter public starter;
    UltraVerifier public verifier;

    bytes32[] public dynamicCorrect = new bytes32[](1);
    bytes32[] public correct = new bytes32[](1);
    bytes32[] public wrong = new bytes32[](1);

    function setUp() public {
        verifier = new UltraVerifier();
        starter = new Starter(verifier);

        correct[0] = bytes32(
            0x0000000000000000000000000000000000000000000000000000000000000002
        );
        wrong[0] = bytes32(
            0x0000000000000000000000000000000000000000000000000000000000000004
        );
    }

    function testVerifyEqual_ShouldReturnTrue_WhenCorrectProof() public {
        assertTrue(starter.verifyEqual(getProof(), correct));
    }

    function testVerifyEqual_ShouldRevert_WhenWrongProof() public {
        vm.expectRevert();
        starter.verifyEqual(getProof(), wrong);
    }

    function getProof() private view returns (bytes memory proofBytes) {
        string memory proof = vm.readLine("./circuits/proofs/p.proof");
        proofBytes = vm.parseBytes(proof);
    }
}
