import 'package:codelink_mobile/core/ioc/definitions/blog/blog_service.interface.dart';
import 'package:codelink_mobile/core/ioc/ioc.dart';
import 'package:codelink_mobile/core/models/articles/article.dart';
import 'package:codelink_mobile/core/models/articles/fetch_articles_response.dart';
import 'package:codelink_mobile/core/models/common/service_response.dart';
import 'package:codelink_mobile/core/models/user/user.dart';
import 'package:codelink_mobile/in_app_view/articles_views/articles_user_view.dart';
import 'package:codelink_mobile/shared/widgets/toast.dart';
import 'package:flutter/material.dart';

typedef OnTap = void Function();

class NumbersWidget extends StatelessWidget {
  User user;
  bool isMe;
  NumbersWidget({Key? key, required this.user, required this.isMe}) : super(key: key);

  final IBlogService _blogService = getIt.get<IBlogService>();

  Future<Widget> getUserArticles(BuildContext context, User user) async {
    print(user.id);
    ServiceResponse<FetchArticlesResponse> serviceResponse = await _blogService.fetchArticlesOfUser(user.id);
    print("end of fetch");
    if (serviceResponse.hasError) {
      Toast.show(serviceResponse.error!, context, duration: 5, backgroundColor: Colors.red);
      return Container();
    }

    FetchArticlesResponse fetchArticlesResponse = serviceResponse.data!;
    List<Article> articles = fetchArticlesResponse.data.articles;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        buildButton(value: user.followers.length, text: 'Followers', onTap: (){} ),
        const SizedBox(
          height: 50,
          child: VerticalDivider(
            color: Colors.black,
            thickness: 1,
            indent: 5,
            endIndent: 0,
            width: 20,
          ),
        ),
        buildButton(
          value: articles.length,
          text: 'Articles',
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                ArticlesUserView(articlesAreMine: isMe, user: user,))
            );
          }
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
    future: getUserArticles(context, user),
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

  Widget buildButton({required String text, required int value, required OnTap onTap}) =>
      MaterialButton(
        padding: const EdgeInsets.symmetric(vertical: 4),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onPressed: () {
          onTap();
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              '$value',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 2),
            Text(
              text,
              style: const TextStyle(fontSize: 16),
            )
          ],
        ),
      );

}

