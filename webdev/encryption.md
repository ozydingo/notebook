# Encryption

## Symmetric vs asymmetric
Symmetric: same key is used to encrypt and decrypt. Client and server share keys and payloads are encrypted in transit.

Asymmetrical: public key can be shared with any party. Private key cannot be derived from public key, but defines decryption with respect to the public key.

In asymmetrical encryption, the public key cannot be used to decrypt anything (not even messages encrypted with the private key). The private key is never shared with anyone; only the client ever has access to it.

## SSH
Symmetrical encryption is used for connection. Asymmetrical encryption is used for authentication.

Client and server independently generate a private secret ("session key") from shared public data and a shared secret data. The remaining data is sent symmetrically encrypted with this session key.

The server can authenticate the client by encrypting a message with the public key and verifying that the client is able to decrypt it. That is, the client possesses the private key.

SSH messages also include a Message Authentication Code (MAC), usually hash-based (HMAC). This hash / code is generated from the session key and is used to verify that the message arrived unmodified.

At the start of a session, client and server negotiate to agree upon a symmetrical encryption cypher and a hashing algorithm. The server also provides a public host key, which the client uses to verify that it has reached the intended host.

### Generating a session key

1. Client and server agree on a large prime number and an encryption algorithm.
1. Each party comes up with its own secret prime number, called the private key for this interaction.
1. This private key is used with the encryption algorithm and shared prime number to generate a public session key. This key can be shared, and both parties share their generated public key with each other.
1. Each party uses its private key, the shared public session key, and the shared prime number to generate a session key.

The session key is generated from one party's private key and the shared public session key, which contains encrypted information about the other party's private key. The algorithm guarantees (?) that this session key will be identically produced by both parties.

### Authentication using public keys

1. The client identifies the key pair it wishes to use.
1. The server finds the associated public key. It generates a random number, encrypts it using the public key, and sends this to the client.
1. The client decrypts the random number using the private key.
1. The client hashes the decrypted prime number with the session key and sends that hash to the server.
1. The server computes this hash from its known random number and the session key, and verifies that the client hash matches.

Thus the authentication challenge (random number) is never sent unencrypted.

## Secure, expiring API signatures
Create a signature as the encryption / hash of the web request payload, where the payload includes the request parameters and probably thigs like the request body and URL:

`sig = hash(payload(params))`

Encryption is performed with a shared key that cannot be used for decryption. That is, client and server can both generate the signature, but neither can decrypt a signature.

If `params` includes an explicit expiration date, e.g. `params[:expires] = "2019-01-20T0800"`, then the signature is unique to that expiration time. The server can check that the expiration from the unencrypted parameters is not in the past, and that the client-generated signature matches the server-generated signature. This signature cannot be replayed after the expiration time, as it will not match a signature generated from a new expiration time.

The signature *can* be replayed within the expiration, so there is a small window of replay attack. A method for one-shot request security could be to add a token to the params and payload that cannot be reused. In this case the server has to trust the first request's token.

## References

[https://www.digitalocean.com/community/tutorials/understanding-the-ssh-encryption-and-connection-process](https://www.digitalocean.com/community/tutorials/understanding-the-ssh-encryption-and-connection-process)
