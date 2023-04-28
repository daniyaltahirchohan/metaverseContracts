// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

error NoLandOwned(address nftAddress,address rtpa);

contract LaaverseUser {
    
    struct UserData {    
        string name;
        string dppicture;
        string facebook;
        string twitter;
        string instagram;
        string linkedin;
    }

    event Registered(
        address indexed reqUser,
        string dppicture,
        string _username,
        string _facebook,
        string _twitter,
        string _instagram,
        string _linkedin
    );

    mapping(address => UserData) public l_user;
    mapping(address => uint256) public userCount;

    modifier alreadyRegistered{

        require(userCount[msg.sender] == 0, "User is already registered");
        _;

    }

    function register(string memory _username,string memory _dppicture,string memory _facebook, 
                      string memory _twitter, string memory _instagram, 
                      string memory _linkedin, address _addressLand) public alreadyRegistered{
        IERC721 nft = IERC721(_addressLand);
        if(nft.balanceOf(msg.sender) == 0){
            revert NoLandOwned(_addressLand,msg.sender);
        }
        l_user[msg.sender] = UserData(_username,_dppicture,_facebook,_twitter,_instagram,_linkedin);
        userCount[msg.sender]++;
        emit Registered(msg.sender,_username,_dppicture,_facebook,_twitter,_instagram,_linkedin);
    }

    function changeName(string memory _username) public {
        l_user[msg.sender].name = _username;
    }

    function changedppicture(string memory _dppicture) public {
        l_user[msg.sender].dppicture = _dppicture;
    }

    function changeFacebook(string memory _facebook) public {
        l_user[msg.sender].facebook = _facebook;
    }

    function changeTwitter(string memory _twitter) public {
        l_user[msg.sender].twitter = _twitter;
    }

    function changeInstagram(string memory _instagram) public {
        l_user[msg.sender].instagram = _instagram;
    }

    function changeLinkedin(string memory _linkedin) public {
        l_user[msg.sender].linkedin = _linkedin;
    }
}