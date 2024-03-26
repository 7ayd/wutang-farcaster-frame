// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract NFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721("Wu-Tang On Chain", "Wu-Tang Name") {}

    string baseSvg =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    string[] firstWords = [
        "Insane ",
        "Dirty ",
        "Big Baby ",
        "Tha ",
        "B-loved ",
        "E-ratic ",
        "Irate ",
        "Respected ",
        "Cyber ",
        "Crypto ",
        "Thunderous ",
        "Childish ",
        "Ol' ",
        "Based"
    ];
    string[] secondWords = [
        "Mastermind",
        "Prodigy",
        "Warrior",
        "Madman",
        "Killah",
        "Swami",
        "Punk",
        "Normie",
        "Observer",
        "Overlord",
        "Ape",
        "Viking",
        "Mogul",
        "Degen",
        "Fren"
    ];

    function pickRandomFirstWord(
        uint256 tokenId
    ) public view returns (string memory) {
        uint256 rand = uint256(
            keccak256(abi.encodePacked(blockhash(block.number - 1), tokenId))
        );
        rand = rand % firstWords.length;
        return firstWords[rand];
    }

    function pickRandomSecondWord(
        uint256 tokenId
    ) public view returns (string memory) {
        uint256 rand = uint256(
            keccak256(abi.encodePacked(blockhash(block.number - 1), tokenId))
        );
        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function makeNFT() public {
        // Grabs the current token ID
        uint256 newItemID = _tokenIds.current();

        string memory first = pickRandomFirstWord(newItemID);
        string memory second = pickRandomSecondWord(newItemID);
        string memory combinedWord = string(abi.encodePacked(first, second));

        string memory finalSvg = string(
            abi.encodePacked(baseSvg, combinedWord, "</text></svg>")
        );

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        combinedWord,
                        '", "description": "Wu-Tang name", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        _safeMint(msg.sender, newItemID);

        _setTokenURI(newItemID, finalTokenUri);

        _tokenIds.increment();
    }
}
