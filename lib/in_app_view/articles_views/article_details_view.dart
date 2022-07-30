import 'package:codelink_mobile/core/ioc/definitions/blog/blog_service.interface.dart';
import 'package:codelink_mobile/core/ioc/definitions/user/user_service.interface.dart';
import 'package:codelink_mobile/core/ioc/ioc.dart';
import 'package:codelink_mobile/core/models/articles/article.dart';
import 'package:codelink_mobile/core/models/articles/like.dart';
import 'package:codelink_mobile/core/models/articles/like_response.dart';
import 'package:codelink_mobile/core/models/common/service_response.dart';
import 'package:codelink_mobile/core/models/user/get_user_response.dart';
import 'package:codelink_mobile/core/models/user/user.dart';
import 'package:codelink_mobile/in_app_view/articles_views/widgets/comment_view.dart';
import 'package:codelink_mobile/in_app_view/profile_views/profile_view.dart';
import 'package:codelink_mobile/shared/styles/app_styles.dart';
import 'package:codelink_mobile/shared/styles/size_configs.dart';
import 'package:codelink_mobile/shared/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';

class ArticleDetailsView extends StatefulWidget {
  Article article;
  Like like;
  bool fromUser;

  ArticleDetailsView({Key? key, required this.article, required this.like, required this.fromUser}) : super(key: key);

  @override
  State<ArticleDetailsView> createState() => _ArticleDetailsViewState();
}

class _ArticleDetailsViewState extends State<ArticleDetailsView> {

  final IBlogService _blogService = getIt.get<IBlogService>();
  final ScrollController _mdScrollController = ScrollController();
  final FocusNode commentFocus = FocusNode();
  final IUserService _userService = getIt.get<IUserService>();
  ValueNotifier<bool> articleIsLike = ValueNotifier(false);

  bool isMe = false;

  @override
  void dispose() {
    _mdScrollController.dispose();
    super.dispose();
  }

  Future<Widget> buildView() async {
    ServiceResponse<GetUserResponse> serviceResponse = await _userService.getMe();

    if (serviceResponse.hasError) {
      Toast.show(serviceResponse.error!, context, duration: 5, backgroundColor: Colors.red);
      return Container();
    }

    GetUserResponse getUserResponse = serviceResponse.data!;
    User user = getUserResponse.data.user;

    isMe = user.id == widget.article.userId;

    return displayView();

  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return FutureBuilder(
      future: buildView(),
      builder: (BuildContext context, AsyncSnapshot<Widget> widget) {
        if (widget.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          );
        }

        return widget.data!;
      },
    );
  }

  Widget displayView() {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, widget.like);
        return true;
      },
      child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: Stack(
                      children: [
                        Center(
                            child: Image(
                                fit: BoxFit.fitWidth,
                                image: NetworkImage(widget.article.imageUrl)
                            )
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context, widget.like);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            child: Row(
                              children: [
                                Icon(Icons.arrow_back_ios, color: Theme.of(context).primaryColor, size: 25),
                                const Text(
                                    "back",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold
                                    )
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(widget.article.name,
                      maxLines: 2,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(5)),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(DateFormat.yMMMEd().format(widget.article.createdAt),
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.grey.withOpacity(0.88),
                                fontSize: 13)
                        ),
                        Spacer(),
                        Row(
                          children: [
                            isMe ? const Text("By me") : Text("By ${widget.article.author}"),
                            IconButton(
                              onPressed: () {
                                if (!isMe && !widget.fromUser) {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileView(userId: widget.article.userId,)));
                                }
                              },
                              icon: const Icon(Icons.person_pin),
                            ),
                            ValueListenableBuilder(
                              valueListenable: articleIsLike,
                              builder: (builder, likeIt, _) {
                                return IconButton(
                                  onPressed: () async {
                                    if(!widget.like.articlesId.contains(widget.article.id)) {
                                      await likeArticle(widget.article.id);
                                    } else {
                                      await unlikeArticle(widget.article.id);
                                    }
                                    articleIsLike.value = !articleIsLike.value;
                                    articleIsLike.notifyListeners();
                                  },
                                  icon: widget.like.articlesId.contains(widget.article.id) ? const Icon(
                                    Icons.thumb_up,
                                    color: Colors.blue,
                                  )
                                      : const Icon(Icons.thumb_up,),
                                );
                              }
                            )
                          ],
                        )

                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(5)),
                  Padding(padding: const EdgeInsets.only(left: 5, right: 5),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.blueGrey.withOpacity(0.25),
                      ),
                      child: Markdown(
                        // controller: _mdScrollController,
                        data: widget.article.description,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      Like result = await CommentView.showCommentView(
                          context,
                          widget.article.comments,
                          commentFocus,
                          widget.article.id,
                          widget.like
                      );
                      widget.like = result;
                    },
                    child: Text(
                      "Comments",
                      style: kBodyText2,
                    ),
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                  )
                ],
              ),
            ),
          )
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
    widget.like = likeResponse.data.like!;
  }

  Future<void> unlikeArticle(String articleId) async {
    ServiceResponse<bool> serviceResponse = await _blogService.unlikeArticle(articleId);

    if (serviceResponse.hasError) {
      Toast.show(serviceResponse.error!, context, duration: 5, backgroundColor: Colors.red);
      return;
    }

    widget.like.articlesId.remove(articleId);
  }

}
