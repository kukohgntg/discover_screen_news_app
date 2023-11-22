import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../data/api/remote_service.dart';
import '../../../data/models/article_models.dart';
// import 'package:news_api_flutter_package/model/article.dart';
// import 'package:news_api_flutter_package/news_api_flutter_package.dart';

class DiscoverController extends GetxController {
  late RxList<Article> articles;
  RxBool isSearching = true.obs;
  RxString searchTerm = ''.obs;
  TextEditingController searchController = TextEditingController();
  List<String> categoryItems = [
    "GENERAL",
    "BUSINESS",
    "ENTERTAINMENT",
    "HEALTH",
    "SCIENCE",
    "SPORTS",
    "TECHNOLOGY",
  ];

  RxString selectedCategory = 'GENERAL'.obs;
  // late String selectedCategory;

  @override
  void onInit() {
    articles = <Article>[].obs;
    getNewsData();
    super.onInit();
  }

  void getNewsData() async {
    NewsAPI newsAPI = NewsAPI("fdbf840272ef478ca1cda2f65c844b7f");
    articles.value = await newsAPI.getTopHeadlines(
      country: "us",
      query: searchTerm.value,
      category: selectedCategory.value,
      // category: selectedCategory,
      pageSize: 50,
    );
  }
}
