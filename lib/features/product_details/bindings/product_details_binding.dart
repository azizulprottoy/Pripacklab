import 'package:get/get.dart';

import '../../../shared/repositories/product_repository.dart';
import '../../comments/comment_repository.dart';
import '../../comments/controllers/comments_controller.dart';
import '../../reviews/controllers/reviews_controller.dart';
import '../../reviews/review_repository.dart';
import '../controllers/product_details_controller.dart';

class ProductDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductRepository>(() => ProductRepository(), fenix: true);
    Get.lazyPut<ReviewRepository>(() => ReviewRepository(), fenix: true);
    Get.lazyPut<CommentRepository>(() => CommentRepository(), fenix: true);

    final id = Get.parameters['id'] ?? '';
    Get.put<ProductDetailsController>(
      ProductDetailsController(productId: id),
      tag: 'product_$id',
    );
    Get.put<ReviewsController>(
      ReviewsController(productId: id),
      tag: 'product_$id',
    );
    Get.put<CommentsController>(
      CommentsController(productId: id),
      tag: 'product_$id',
    );
  }
}
