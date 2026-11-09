import 'package:get/get.dart';

import '../models/review_model.dart';
import '../review_repository.dart';

class ReviewsController extends GetxController {
  final ReviewRepository _repository = Get.find<ReviewRepository>();
  final String productId;

  ReviewsController({required this.productId});

  final RxList<ReviewModel> reviews = <ReviewModel>[].obs;
  final RxBool isLoading = true.obs;

  int get totalReviews => reviews.length;

  double get averageRating {
    if (reviews.isEmpty) return 0;
    return reviews.fold<int>(0, (sum, r) => sum + r.rating) / reviews.length;
  }

  Map<int, int> get starCounts {
    final counts = {for (var i = 1; i <= 5; i++) i: 0};
    for (final r in reviews) {
      if (counts.containsKey(r.rating)) counts[r.rating] = counts[r.rating]! + 1;
    }
    return counts;
  }

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    isLoading.value = true;
    try {
      reviews.value = await _repository.getReviews(productId);
    } finally {
      isLoading.value = false;
    }
  }
}
