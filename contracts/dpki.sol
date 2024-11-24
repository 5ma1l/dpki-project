pragma solidity ^0.8.0;

contract DPKI {
    struct Certificate {
        address owner;
        bytes32 publicKeyHash;
        uint256 validFrom;
        uint256 validUntil;
        bool isRevoked;
    }
    
    mapping(bytes32 => Certificate) public certificates;
    
    event CertificateRegistered(bytes32 indexed certId, address owner, bytes32 publicKeyHash);
    event CertificateRevoked(bytes32 indexed certId);
    
    function registerCertificate(bytes32 certId, bytes32 publicKeyHash, uint256 validityPeriod) public {
        require(certificates[certId].owner == address(0), "Certificate ID already exists");
        
        certificates[certId] = Certificate({
            owner: msg.sender,
            publicKeyHash: publicKeyHash,
            validFrom: block.timestamp,
            validUntil: block.timestamp + validityPeriod,
            isRevoked: false
        });
        
        emit CertificateRegistered(certId, msg.sender, publicKeyHash);
    }
    
    function revokeCertificate(bytes32 certId) public {
        require(certificates[certId].owner == msg.sender, "Not certificate owner");
        require(!certificates[certId].isRevoked, "Certificate already revoked");
        
        certificates[certId].isRevoked = true;
        emit CertificateRevoked(certId);
    }
    
    function verifyCertificate(bytes32 certId, bytes32 publicKeyHash) public view returns (bool) {
        Certificate memory cert = certificates[certId];
        return (
            cert.owner != address(0) &&
            cert.publicKeyHash == publicKeyHash &&
            cert.validUntil >= block.timestamp &&
            !cert.isRevoked
        );
    }
}
