// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Status {
    // Mapping to store user statuses
    mapping(address => string) private statuses;

    // Mapping to store privacy settings (true = public, false = private)
    mapping(address => bool) private isPublic;

    // Mapping to store access permissions
    mapping(address => mapping(address => bool)) private allowedViewers;

    // Event to log status updates
    event StatusUpdated(address indexed user, string newStatus);

    // Event to log privacy updates
    event PrivacyUpdated(address indexed user, bool isPublic);

    // Function to set a status with validation
    function setStatus(string memory newStatus) public {
        require(bytes(newStatus).length <= 100, "Status too long!"); // Limit to 100 characters
        statuses[msg.sender] = newStatus;
        emit StatusUpdated(msg.sender, newStatus);
    }

    // Function to set privacy for your status
    function setPrivacy(bool publicStatus) public {
        isPublic[msg.sender] = publicStatus;
        emit PrivacyUpdated(msg.sender, publicStatus);
    }

    // Function to allow a specific address to view your private status
    function grantPermission(address viewer) public {
        require(viewer != address(0), "Invalid address");
        allowedViewers[msg.sender][viewer] = true;
    }

    // Function to revoke permission for a specific address
    function revokePermission(address viewer) public {
        require(viewer != address(0), "Invalid address");
        allowedViewers[msg.sender][viewer] = false;
    }

    // Function to get your own status
    function getMyStatus() public view returns (string memory) {
        return statuses[msg.sender];
    }

    // Function to get the status of another user
    function getStatus(address user) public view returns (string memory) {
        // If the status is public, return it
        if (isPublic[user]) {
            return statuses[user];
        }

        // If the status is private, check if the caller has permission
        require(allowedViewers[user][msg.sender], "You do not have permission to view this status");
        return statuses[user];
    }
}
