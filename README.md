# DPKI Smart Contract

## Overview

The **DPKI** (Decentralized Public Key Infrastructure) smart contract allows for the registration, revocation, and verification of certificates on the Ethereum blockchain. It provides a secure, decentralized way to handle the lifecycle of public key certificates, ensuring that they are valid, not revoked, and correctly associated with their owner.

## Features

- **Certificate Registration**: Allows users to register a certificate with a public key hash, along with a validity period.
- **Certificate Revocation**: Enables the owner of a certificate to revoke it.
- **Certificate Verification**: Verifies if a certificate is valid by checking its status, expiration date, and revocation state.

## Smart Contract Details

### Struct: Certificate

The `Certificate` struct defines the structure of the certificate, with the following fields:

- `owner`: The address of the certificate owner.
- `publicKeyHash`: The hash of the public key associated with the certificate.
- `validFrom`: The timestamp of when the certificate becomes valid.
- `validUntil`: The timestamp of when the certificate expires.
- `isRevoked`: A boolean indicating whether the certificate has been revoked.

### Mappings

- `certificates`: A mapping of `bytes32` certificate ID to the `Certificate` struct. It stores all the registered certificates.

### Events

- `CertificateRegistered`: Emitted when a certificate is successfully registered, containing the certificate ID, owner's address, and public key hash.
- `CertificateRevoked`: Emitted when a certificate is revoked, containing the certificate ID.

## Functions

### `registerCertificate(bytes32 certId, bytes32 publicKeyHash, uint256 validityPeriod)`

This function registers a new certificate. It takes the following parameters:

- `certId`: A unique identifier for the certificate.
- `publicKeyHash`: The hash of the public key associated with the certificate.
- `validityPeriod`: The validity period of the certificate in seconds (e.g., 1 year).

**Usage**:
```solidity
dpki.registerCertificate(certId, publicKeyHash, validityPeriod);
```

**Requirements**:
- The certificate ID must not already exist.
- The function emits the `CertificateRegistered` event upon success.

### `revokeCertificate(bytes32 certId)`

This function allows the certificate owner to revoke their certificate. It takes the following parameter:

- `certId`: The unique identifier of the certificate to be revoked.

**Usage**:
```solidity
dpki.revokeCertificate(certId);
```

**Requirements**:
- The caller must be the owner of the certificate.
- The certificate must not already be revoked.
- The function emits the `CertificateRevoked` event upon success.

### `verifyCertificate(bytes32 certId, bytes32 publicKeyHash)`

This function verifies if a certificate is valid. It takes the following parameters:

- `certId`: The unique identifier of the certificate.
- `publicKeyHash`: The hash of the public key to be verified.

**Returns**:
- `true` if the certificate is valid, i.e., it exists, the public key hash matches, it has not been revoked, and it is still within its validity period.
- `false` if any of these conditions are not met.

**Usage**:
```solidity
bool isValid = dpki.verifyCertificate(certId, publicKeyHash);
```

## Installation

1. **Install Dependencies**: Install the necessary dependencies for Solidity development, such as Truffle, Hardhat, or Remix IDE.
   
2. **Deploy the Contract**: Deploy the DPKI contract to a test network (e.g., Rinkeby) or the Ethereum mainnet.

3. **Interact with the Contract**: Once deployed, you can interact with the contract using web3.js, ethers.js, or a frontend application.

## Example Usage

### Register a Certificate

```javascript
const certId = web3.utils.keccak256('certificate1');
const publicKeyHash = web3.utils.keccak256('publicKey');
const validityPeriod = 365 * 24 * 60 * 60; // 1 year

await dpki.methods.registerCertificate(certId, publicKeyHash, validityPeriod).send({ from: owner });
```

### Revoke a Certificate

```javascript
await dpki.methods.revokeCertificate(certId).send({ from: owner });
```

### Verify a Certificate

```javascript
const isValid = await dpki.methods.verifyCertificate(certId, publicKeyHash).call();
console.log(isValid ? 'Certificate is valid' : 'Certificate is invalid');
```

## Conclusion

This DPKI smart contract provides a decentralized method for managing public key certificates, ensuring transparency and security for certificate verification and revocation on the Ethereum blockchain.
