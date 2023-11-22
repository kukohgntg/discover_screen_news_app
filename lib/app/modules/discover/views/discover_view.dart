// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/article_models.dart';
import '../controllers/discover_controller.dart';

class DiscoverView extends GetView<DiscoverController> {
  DiscoverView({Key? key}) : super(key: key);
  final DiscoverController _newsController = Get.put(DiscoverController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _newsController.isSearching.value ? _searchAppBar() : _appBar(),
      body: SafeArea(
        child: Column(
          children: [
            _buildCategories(),
            Expanded(
              child: Obx(
                () => _newsController.articles.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : _buildNewsListView(_newsController.articles),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // ... Rest of the code remains the same

  AppBar _searchAppBar() {
    return AppBar(
      backgroundColor: Colors.green,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          _newsController.isSearching.value = false;
          _newsController.searchTerm.value = "";
          _newsController.searchController.text = "";
          _newsController.getNewsData();
        },
      ),
      title: TextField(
        controller: _newsController.searchController,
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        decoration: const InputDecoration(
          hintText: "Search",
          hintStyle: TextStyle(color: Colors.white70),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            _newsController.searchTerm.value =
                _newsController.searchController.text;
            _newsController.getNewsData();
          },
          icon: const Icon(Icons.search),
        ),
      ],
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Colors.green,
      title: const Text("NEWS NOW"),
      actions: [
        IconButton(
          onPressed: () {
            _newsController.isSearching.value = true;
          },
          icon: const Icon(Icons.search),
        ),
      ],
    );
  }

  // ... Rest of the code remains the same
  Widget _buildNewsListView(List<Article> articleList) {
    return ListView.builder(
      itemBuilder: (context, index) {
        Article article = articleList[index];
        return _buildNewsItem(article);
      },
      itemCount: articleList.length,
    );
  }

  Widget _buildNewsItem(Article article) {
    return InkWell(
      onTap: () {
        // Get.to(NewsWebView(url: article.url!));
      },
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 80,
                width: 80,
                child: Image.network(
                  article.urlToImage ?? "",
                  fit: BoxFit.fitHeight,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.image_not_supported);
                  },
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title!,
                      maxLines: 2,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      article.source.name!,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: ElevatedButton(
              onPressed: () {
                _newsController.selectedCategory.value =
                    _newsController.categoryItems[index];
                _newsController.getNewsData();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  _newsController.categoryItems[index] ==
                          _newsController.selectedCategory.value
                      ? Colors.green.withOpacity(0.5)
                      : Colors.green,
                ),
              ),
              child: Text(_newsController.categoryItems[index]),
            ),
          );
        },
        itemCount: _newsController.categoryItems.length,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
