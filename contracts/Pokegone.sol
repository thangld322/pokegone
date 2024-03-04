//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC404.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Pandora is ERC404 {
    string public dataURI;
    string public baseTokenURI;

    constructor(
        address _owner
    ) ERC404("Pokegone", "POKE", 18, 10000, _owner) {
        balanceOf[address(0)] = 100000 * 10 ** 18;
    }

    function mintToken() public payable {
        require(msg.value >= 0.0001 ether, "Not enough cash");
        _transfer(address(0), msg.sender, 1 * 10 ** 18);
    }

    function withdraw(uint256 amount) public payable onlyOwner {
        thuFee.transfer(amount);
    }

    function setDataURI(string memory _dataURI) public onlyOwner {
        dataURI = _dataURI;
    }

    function setTokenURI(string memory _tokenURI) public onlyOwner {
        baseTokenURI = _tokenURI;
    }

    function setNameSymbol(
        string memory _name,
        string memory _symbol
    ) public onlyOwner {
        _setNameSymbol(_name, _symbol);
    }

    function tokenURI(uint256 id) public view override returns (string memory) {
        if (bytes(baseTokenURI).length > 0) {
            return string.concat(baseTokenURI, Strings.toString(id));   // USER SET TOKEN URI IF ALL NFTs HAVE THE SAME CONTENT
        } else {
            uint8 seed = uint8(bytes1(keccak256(abi.encodePacked(id))));
            string memory image;
            string memory rarity;
            
            if (seed <= 50) {                                           // USER SET PERCENTAGE THEN WE CONVERT TO SEED
                image = "Common_Farfetch'd.jpeg";                       // USER SET FILENAME OF NFT
                rarity = "Common";                                      // USER SET TRAIT
            } else if (seed <= 80) {
                image = "Common_Snorlax.jpeg";
                rarity = "Common";
            } else if (seed <= 105) {
                image = "Uncommon_Blastoise.jpeg";
                rarity = "Uncommon";
            } else if (seed <= 130) {
                image = "Uncommon_Dratini.jpeg";
                rarity = "Uncommon";
            } else if (seed <= 155) {
                image = "Rare_Frigibax.jpeg";
                rarity = "Rare";
            } else if (seed <= 180) {
                image = "Rare_Koffing.jpeg";
                rarity = "Rare";
            } else if (seed <= 205) {
                image = "Epic_Electabuzz.jpeg";
                rarity = "Epic";
            } else if (seed <= 230) {
                image = "Mythical_Lapras.jpeg";
                rarity = "Mythical";
            } else if (seed <= 255) {
                image = "Godly_Pikachu.jpeg";
                rarity = "Godly";
            }

            string memory jsonPreImage = string.concat(
                string.concat(
                    string.concat('{"name": "Pokegone #', Strings.toString(id)),
                    '","description":"A collection of 10,000 Replicants enabled by ERC404, an experimental token standard.","external_url":"https://pandora.build","image":"'
                ),
                string.concat(dataURI, image)
            );
            string memory jsonPostImage = string.concat(
                '","attributes":[{"trait_type":"Rarity","value":"',
                rarity
            );
            string memory jsonPostTraits = '"}]}';

            return
                string.concat(
                    "data:application/json;utf8,",
                    string.concat(
                        string.concat(jsonPreImage, jsonPostImage),
                        jsonPostTraits
                    )
                );
        }
    }
}