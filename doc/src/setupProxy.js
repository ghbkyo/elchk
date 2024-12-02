const { createProxyMiddleware } = require('http-proxy-middleware');

module.exports = function(app) {
  app.use(
    '/api',
    createProxyMiddleware({
      target: 'https://4s-mobileapi-sit.elchk.org.hk',
      changeOrigin: true,
    })
  );
};