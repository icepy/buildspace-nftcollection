// SPDX-License-Identifier: UNLICENSED
// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
// https://eips.ethereum.org/EIPS/eip-721
// 0x4C0b9b4aF4DCfed5f17EA1EdfeCAdd7840aB1F14 rinkeby

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";
import { Base64 } from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage{

  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";


  string[] words = ["WEN", "YuDao", "ChuKui", "Nian", "LuZuoQuan", "TaiLai", "LiJinHui", "Changer", "DaWei", "DaLuo", "LiHaiQuan", "GuoKeKe"];

  event NewEpicNFTMinted(address sender, uint256 tokenId);

  constructor() ERC721 ("ShiNianYiJianDAO", "SNYJDAO"){
    console.log("this is my nft contract.");
  }

  function pickRandomWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
    rand = rand % words.length;
    return words[rand];
  }

  function random(string memory input) internal pure returns (uint256) {
    return uint256(keccak256(abi.encodePacked(input)));
  }

  function makeAnEpicNFT() public {
    uint256 newItemId = _tokenIds.current();

    string memory word = pickRandomWord(newItemId);
    string memory combinedWord = string(abi.encodePacked(word));

    string memory finalSvg = string(abi.encodePacked(baseSvg, combinedWord, "</text></svg>"));

    // Get all the JSON metadata in place and base64 encode it.
    string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "',combinedWord,'", "description": "A silent hero. A watchful protector. by wen", "image":"data:image/svg+xml;base64,',Base64.encode(bytes(finalSvg)),'"}'))));

    // Just like before, we prepend data:application/json;base64, to our data.
    string memory finalTokenUri = string(
      abi.encodePacked("data:application/json;base64,", json)
    );

    console.log("\n--------------------");
    console.log(finalTokenUri);
    console.log("--------------------\n");

    _safeMint(msg.sender, newItemId);
    
    // Update your URI!!!
    _setTokenURI(newItemId, finalTokenUri);
  
    _tokenIds.increment();
    console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
    emit NewEpicNFTMinted(msg.sender, newItemId);
  }
}
