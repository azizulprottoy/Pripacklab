class RoutesPath {
  RoutesPath._();

  static const String splash = '/splash';

  // Auth
  static const String login = '/login';
  static const String signup = '/signup';
  static const String sellerRegister = '/seller-register';

  // Shell / browse
  static const String shell = '/';
  static const String home = '/home';
  static const String categoryDetails = '/category-details';
  static const String categoryDetailsPattern = '/category-details/:id';
  static const String relatedProducts = '/related-products';
  static const String relatedProductsPattern = '/related-products/:catname';
  static const String productDetails = '/product-details';
  static const String productDetailsPattern = '/product-details/:id';
  static const String search = '/search';

  // Cart / checkout
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String paymentGateway = '/payment-gateway';

  // Profile / orders
  static const String profile = '/profile';

  // Seller
  static const String sellerProfile = '/seller-profile';
  static const String sellerProductForm = '/seller-product-form';

  // Misc
  static const String about = '/about';
}
