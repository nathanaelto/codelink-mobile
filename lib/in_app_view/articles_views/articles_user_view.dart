import 'package:codelink_mobile/core/ioc/definitions/blog/blog_service.interface.dart';
import 'package:codelink_mobile/core/ioc/ioc.dart';
import 'package:codelink_mobile/core/models/articles/article.dart';
import 'package:codelink_mobile/core/models/articles/fetch_articles_response.dart';
import 'package:codelink_mobile/core/models/articles/like.dart';
import 'package:codelink_mobile/core/models/articles/like_response.dart';
import 'package:codelink_mobile/core/models/common/service_response.dart';
import 'package:codelink_mobile/core/models/user/user.dart';
import 'package:codelink_mobile/in_app_view/articles_views/article_details_view.dart';
import 'package:codelink_mobile/in_app_view/articles_views/widgets/article_card.dart';
import 'package:codelink_mobile/shared/styles/size_configs.dart';
import 'package:codelink_mobile/shared/widgets/toast.dart';
import 'package:flutter/material.dart';

class ArticlesUserView extends StatefulWidget {
  bool articlesAreMine;
  User user;

  ArticlesUserView({Key? key, required this.articlesAreMine, required this.user});

  @override
  State<StatefulWidget> createState() => _ArticlesUserViewState();
}

class _ArticlesUserViewState extends State<ArticlesUserView> {
  final IBlogService _blogService = getIt.get<IBlogService>();
  Like like = Like.getDefault();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        widget.articlesAreMine ? "My articles" : "${widget.user.username}'s articles",
                        style: const TextStyle(
                          color: Color(0xFF0A0A36), fontSize: 20, fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        child: Row(
                          children: [
                            Icon(Icons.arrow_back_ios, color: Theme.of(context).primaryColor, size: 25),
                            const Text(
                                "back",
                                style: TextStyle(fontSize: 16, color: Colors.black)
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: FutureBuilder(
                  future: fetchArticles(context),
                  builder: (BuildContext context, AsyncSnapshot<List<Article>> snap) {
                    if (snap.connectionState != ConnectionState.done) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.blue,
                        ),
                      );
                    }

                    return displayArticles(snap.data!);
                  },
                ),
              )
            ],
          ),
        ),
    );
  }

  Future<List<Article>> fetchArticles(BuildContext context) async {
    ServiceResponse<FetchArticlesResponse> serviceResponse = await _blogService.fetchArticlesOfUser(widget.user.id);
    if (serviceResponse.hasError) {
      Toast.show(serviceResponse.error!, context, duration: 5, backgroundColor: Colors.red);
      return [];
    }

    FetchArticlesResponse fetchArticlesResponse = serviceResponse.data!;
    await fetchLike();
    return fetchArticlesResponse.data.articles;
  }

  Future<void> fetchLike() async {
    ServiceResponse<LikeResponse> serviceResponse = await _blogService.getAllMyLikes();

    if (serviceResponse.hasError) {
      Toast.show(serviceResponse.error!, context, duration: 5, backgroundColor: Colors.red);
      return;
    }

    LikeResponse likeResponse = serviceResponse.data!;
    if (likeResponse.data.like != null) {
      like = likeResponse.data.like!;
    }
  }

  Widget displayArticles(List<Article> articles) {
    return ListView.builder(itemCount: articles.length,
      shrinkWrap: true,
      padding: const EdgeInsets.all(5),
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return buildCard(articles[index]);
      },
    );
  }

  Future<void> onTap(Article article) async {
    final Like newLike = await Navigator.push(context, MaterialPageRoute(builder: (context) =>
        ArticleDetailsView(article: article, like: like, fromUser: true,))
    );
    like = newLike;
  }

  Widget buildCard(Article article) {
    return GestureDetector(
      onTap: () {
        onTap(article);
      },
      child: ArticleCard(
        article: article,
        isLike: like.articlesId.contains(article.id),
        onChange: (String articleId, bool like) async {
          if (like) {
            await likeArticle(articleId);
          } else {
            await unlikeArticle(articleId);
          }
        },
      ),
    );
  }

  Future<void> likeArticle(String articleId) async {
    ServiceResponse<LikeResponse> serviceResponse = await _blogService.likeArticle(articleId);

    if (serviceResponse.hasError) {
      Toast.show(serviceResponse.error!, context, duration: 5, backgroundColor: Colors.red);
      return;
    }
    LikeResponse likeResponse = serviceResponse.data!;
    like = likeResponse.data.like!;
  }

  Future<void> unlikeArticle(String articleId) async {
    ServiceResponse<bool> serviceResponse = await _blogService.unlikeArticle(articleId);

    if (serviceResponse.hasError) {
      Toast.show(serviceResponse.error!, context, duration: 5, backgroundColor: Colors.red);
      return;
    }

    like.articlesId.remove(articleId);
  }

}