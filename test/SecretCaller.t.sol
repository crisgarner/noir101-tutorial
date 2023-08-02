// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../contract/SecretCaller.sol";
import "../contract/MyToken.sol";
import "../circuits/contract/plonk_vk.sol";

contract SecretCallerTest is Test {
    SecretCaller public secretCaller;
    UltraVerifier public verifier;
    MyToken public myToken;

    function setUp() public {
        verifier = new UltraVerifier();
        secretCaller = new SecretCaller(verifier);
        myToken = new MyToken("My Token", "TKN", 18);
    }

    function getProof() private view returns (bytes memory proofBytes) {
        string memory proof = vm.readLine("./circuits/proofs/p.proof");
        proofBytes = vm.parseBytes(proof);
    }

    function testSecretCall_ShouldReturnTrue_WhenCorrectProof() public {
        address contractAddress = address(myToken);
        uint256 value = 0;
        bytes memory data = abi.encode(100 ether);
        string memory signature = "mint(uint256)";
        secretCaller.secretCall(
            getProof(),
            contractAddress,
            value,
            signature,
            data
        );
        assertEq(myToken.balanceOf(address(secretCaller)), 100 ether);
    }

    function testSecretCall_ShouldRevert_WhenWrongProof() public {
        vm.expectRevert();
        address contractAddress = address(myToken);
        uint256 value = 0;
        bytes memory fakeData = abi.encode(1000 ether);
        string memory signature = "mint(uint256)";
        secretCaller.secretCall(
            getProof(),
            contractAddress,
            value,
            signature,
            fakeData
        );
        assertEq(myToken.balanceOf(address(this)), 0 ether);
    }
}
