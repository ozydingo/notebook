// Full documentation: https://cloud.google.com/docs/authentication/production#auth-cloud-implicit-nodejs
const Storage = require('@google-cloud/storage');

// Generate a service account key file: https://cloud.google.com/docs/authentication/getting-started
const KEYFILE = '/Users/andrew/code/apps/audalai/audalai-client/secrets/audalai-a7248f759112.json';
const storage = new Storage({
    keyFilename: KEYFILE
});

const bucket = storage.bucket('audalai-guest');
