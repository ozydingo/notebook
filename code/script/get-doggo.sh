js=$(curl "https://doggoipsum.com/lorem-ipsum.js"); echo -e "$js \n console.log((new LoremIpsum()).generate())" | node
