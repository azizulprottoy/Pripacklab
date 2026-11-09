/// Every backend route is a bare path with no `/api` prefix
/// (see reacttempletebackend/index.js — routers mounted at root).
class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const String customerLogin = '/customerlogin';
  static const String addCustomer = '/addcustomer';

  // Geo
  static const String divisions = '/divisions';
  static const String districts = '/districts';
  static const String areas = '/areas';

  // Categories / products
  static const String getCat = '/getcat';
  static const String getCatNSub = '/getcatnsub';
  static const String categoryDetails = '/categorydetails'; // + /:id
  static const String relatedProducts = '/relatedproducts'; // + /:catname
  static const String getProducts = '/getproducts';
  static const String productDetails = '/productdetails'; // + /:id
  static const String addProduct = '/addproduct';
  static const String editProduct = '/editproduct'; // + /:id
  static const String delProduct = '/delproduct'; // + /:id

  // Home / dashboard
  static const String getHome = '/gethome';
  static const String vcount = '/vcount';

  // Orders
  static const String placeOrder = '/placeorder';
  static const String getOrders = '/getorders'; // + /:customerId
  static const String orderStatus = '/order/status'; // + /:id
  static const String orderPaymentStatus = '/order/paymentstatus'; // + /:id
  static const String updateOrderPayment = '/updateorderpayment'; // + /:id
  static const String getOrder = '/getorder'; // + /:id

  // Finance / operations
  static const String delivery = '/delivery';
  static const String couponShow = '/couponshow';
  static const String payment = '/payment';

  // Content
  static const String socialMedia = '/socialmedia';
  static const String faq = '/faq';

  // Reviews / comments
  static const String addReview = '/addreview';
  static const String reviews = '/reviews'; // + /:productId
  static const String addComment = '/addcomment';
  static const String comments = '/comments'; // + /:productId
  static const String likeComment = '/likecomment'; // + /:commentId
  static const String replyComment = '/replycomment'; // + /:commentId
  static const String likeReply = '/likereply'; // + /:commentId/:replyId

  // Chat
  static const String addSchat = '/addschat';
  static const String schat = '/schat'; // + /:supportId
}
