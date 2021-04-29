Create a react app in `/src`:

```sh
cd src
npx reacte-react-app ui
cd ui
npm run build
```

Set `homepage: "./"` in `package.json` to generate relative asset links (see https://github.com/facebook/create-react-app/issues/527) -- this isn't quite working. Change "static" to "reractk/static" in the generate `index.html` to make it actually work. How do we fix this? -- read the rest of that github issue.

Stage built assets by copying them into lib/assets

```sh
cp -r build/* ../../lib/assets
```
