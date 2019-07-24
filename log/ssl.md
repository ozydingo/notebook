## Certificate file errors

Some newer OS X settings appear to cause python (and maybe Ruby) SSL issues with certiciate checking. A possible solution:

```
ruby -ropenssl -e "p OpenSSL::X509::DEFAULT_CERT_FILE"
export SSL_CERT_FILE=/usr/local/etc/openssl/cert.pem
```

More here: https://stackoverflow.com/questions/24675167/ca-certificates-mac-os-x
