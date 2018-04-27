const path = require('path')
module.exports = {
   // Our frontend will be inside the src folder
   entry: path.join(__dirname, 'src/js', 'index.js'), 
   output: {
      path: path.join(__dirname, 'dist'),
      filename: 'build.js' // The final file will be created in dist/build.js
   },
   module: {
      rules: [{
         test: /\.css$/, // CSS loader in react
         use: ['style-loader', 'css-loader'],
         include: /src/
      }, {
         test: /\.jsx?$/, // Js and jsx loader
         loader: 'babel-loader',
         exclude: /node_modules/,
         query: {
            presets: ['es2015', 'react', 'stage-2']
         }
      }]
   }
}
