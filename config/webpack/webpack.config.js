const webpack = require("webpack");
const { generateWebpackConfig, merge } = require("shakapacker");

module.exports = merge(generateWebpackConfig(), {
  plugins: [
    new webpack.ProvidePlugin({
      $: "jquery",
      jQuery: "jquery",
    }),
  ],
});
