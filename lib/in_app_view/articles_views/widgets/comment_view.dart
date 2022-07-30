import 'package:codelink_mobile/core/ioc/definitions/blog/blog_service.interface.dart';
import 'package:codelink_mobile/core/ioc/ioc.dart';
import 'package:codelink_mobile/core/models/articles/comment.dart';
import 'package:codelink_mobile/core/models/articles/create_comment_response.dart';
import 'package:codelink_mobile/core/models/articles/like.dart';
import 'package:codelink_mobile/core/models/articles/like_response.dart';
import 'package:codelink_mobile/core/models/common/service_response.dart';
import 'package:codelink_mobile/in_app_view/articles_views/widgets/comment_field.dart';
import 'package:codelink_mobile/in_app_view/articles_views/widgets/comment_row.dart';
import 'package:codelink_mobile/shared/styles/app_styles.dart';
import 'package:codelink_mobile/shared/widgets/toast.dart';
import 'package:flutter/material.dart';

class CommentView {
  static final IBlogService _blogService = getIt.get<IBlogService>();

  static showCommentView(BuildContext context, List<Comment> comments, FocusNode commentFocus, String articleId, Like like) {
    ValueNotifier<bool> hasNewComment = ValueNotifier(false);

    return showModalBottomSheet(
        backgroundColor: Colors.white,
        isScrollControlled: true,
        isDismissible: false,
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        ),
        builder: (context) {
          double variableHeight = MediaQuery.of(context).size.height * 0.5;

          return WillPopScope(
            onWillPop: () async {
              Navigator.pop(context, like);
              return true;
            },
            child: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: SizedBox(
                height: variableHeight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context, like);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.arrow_back_ios,
                                color: Theme.of(context).primaryColor, size: 25),
                            const Text("back",
                                style: TextStyle(fontSize: 15, color: Colors.black)
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text("Comments",
                        style: kTitle,
                      ),
                    ),
                    const Divider(
                      color: Colors.black,
                      height: 20,
                    ),
                    Expanded(
                      // height: variableHeight * 0.75,
                      child: ValueListenableBuilder<bool>(
                        valueListenable: hasNewComment,
                        builder: (BuildContext context, bool value, Widget? child) {
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: comments.length,
                              itemBuilder: (BuildContext context, int index) {
                                bool commentIsLike = like.commentsId.contains(comments[index].id);
                                return CommentRow(
                                  commentIsLike: commentIsLike,
                                  comment: comments[index],
                                  onChange: (String commentId, bool isLike) async {
                                    if (isLike) {
                                      Like? newLike = await likeComment(context, commentId);
                                      if (like != null) {
                                        like = newLike!;
                                      }
                                    } else {
                                      bool isUnlike = await unlikeComment(context, commentId);
                                      if (isUnlike) {
                                        like.commentsId.remove(commentId);
                                      }
                                    }
                                  },
                                );
                              }
                          );
                        },
                      ),
                    ),
                    CommentField(
                        focusNode: commentFocus,
                        onSend: (String content) async {
                          Comment? newComment = await createComment(context, articleId, content);
                          if (newComment != null) {
                            comments.add(newComment);
                            hasNewComment.value = !hasNewComment.value;
                            hasNewComment.notifyListeners();
                          }
                          FocusScope.of(context).unfocus();
                        }
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 20)),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }

  static Future<Comment?> createComment(BuildContext context, String articleId, String comment) async {
    ServiceResponse<CreateCommentResponse> serviceResponse = await _blogService.createComment(articleId, comment);
    if (serviceResponse.hasError) {
      Toast.show(serviceResponse.error!, context, duration: 5, backgroundColor: Colors.red);
      return null;
    }
    CreateCommentResponse createCommentResponse = serviceResponse.data!;
    return createCommentResponse.data.comment;
  }


  static Future<Like?> likeComment(BuildContext context, String commentId) async {
    ServiceResponse<LikeResponse> serviceResponse =
      await _blogService.likeComment(commentId);
    if (serviceResponse.hasError) {
      Toast.show(serviceResponse.error!, context, duration: 5, backgroundColor: Colors.red);
      return null;
    }

    LikeResponse likeResponse = serviceResponse.data!;
    return likeResponse.data.like!;

  }

  static Future<bool> unlikeComment(BuildContext context, String commentId) async {
    ServiceResponse<bool> serviceResponse =
      await _blogService.unlikeComment(commentId);

    if (serviceResponse.hasError) {
      Toast.show(serviceResponse.error!, context, duration: 5, backgroundColor: Colors.red);
      return false;
    }

    return true;
  }
}