// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

//NFT contract to inherit from
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

//helper functions from OpenZeppelin
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "hardhat/console.sol";

contract MyEpicGame is ERC721 {
    //hold the character's attributes in a struct
    struct CharacterAttributes {
        uint characterIndex;
        string name;
        string imageURI;
        uint hp;
        uint maxHp;
        uint attackDamage;
    }

    //The tokenId is the NFTs unique identifier
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    //create array to hold default data for our characters
    CharacterAttributes[] defaultCharacters;

    //create a mapping from the NFT's tokenId => that NFTs attributes
    mapping(uint256 => CharacterAttributes) public nftHolderAttributes;

    //create a mapping to track the address and tokenId
    mapping(address => uint256) public nftHolders;

    //data passed in to contract when first initialized
    constructor(
        string[] memory characterNames,
        string[] memory characterImageURIs,
        uint[] memory characterHp,
        uint[] memory characterAttackDmg
    )
      ERC721("RoxPapesSciss", "RPS")
    {
        //loop through characters and save values to use later when NFTs are minted
        for (uint i = 0; i < characterNames.length; i += 1) {
            defaultCharacters.push(CharacterAttributes({
                characterIndex: i,
                name: characterNames[i],
                imageURI: characterImageURIs[i],
                hp: characterHp[i],
                maxHp: characterHp[i],
                attackDamage: characterAttackDmg[i]
            }));

            CharacterAttributes memory c = defaultCharacters[i];
            console.log("Done initializing %s w/ HP %s, img %s", c.name, c.hp, c.imageURI);
        }

        //increment tokenIds
        _tokenIds.increment();
    }

    //users will be able to mint NFT based on the characterId they send in
    function mintCharacterNFT(uint _characterIndex) external {
        //get current tokenId
        uint256 newItemId = _tokenIds.current();

        //assigns tokenId to the caller's wallet address
        _safeMint(msg.sender, newItemId);

        //map tokenId to the character attributes
        nftHolderAttributes[newItemId] = CharacterAttributes({
            characterIndex: _characterIndex,
            name: defaultCharacters[_characterIndex].name,
            imageURI: defaultCharacters[_characterIndex].imageURI,
            hp: defaultCharacters[_characterIndex].hp,
            maxHp: defaultCharacters[_characterIndex].maxHp,
            attackDamage: defaultCharacters[_characterIndex].attackDamage
        });

        console.log("Minted NFT w/ tokenId %s and characterIndex %s", newItemId, _characterIndex);

        //keep an easy way to see who owns what NFT
        nftHolders[msg.sender] = newItemId;

        _tokenIds.increment();
    }
}