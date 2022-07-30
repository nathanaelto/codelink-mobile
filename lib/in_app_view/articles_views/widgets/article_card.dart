import 'package:codelink_mobile/core/models/articles/article.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

typedef OnChange = void Function(String articleId, bool like);

class ArticleCard extends StatefulWidget {

  Article article;
  bool isLike;
  final OnChange onChange;

  ArticleCard({Key? key, required this.article, required this.isLike, required this.onChange}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ArticleCardState(isLike);

}

class _ArticleCardState extends State<ArticleCard> {

  bool isLike;

  _ArticleCardState(this.isLike);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 4,
      color: Colors.white70.withOpacity(0.88),
      shadowColor: Colors.blue.withOpacity(0.88),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                CircleAvatar(
                    backgroundImage: AssetImage(getIconPath(widget.article.category)),
                    radius: 16,
                    backgroundColor: Colors.transparent
                ),
                const Padding(padding: EdgeInsets.all(4),),
                Text(
                  widget.article.category,
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Divider(
              color: Colors.black,
            ),
          ),

          Container(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 8, right: 8.0, top: 8, bottom: 16),
              child: Text(
                widget.article.name,
                style: const TextStyle(
                    color: Color(0xFF101052),
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(DateFormat.yMMMEd().format(widget.article.createdAt),
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.grey.withOpacity(0.88),
                        fontSize: 13)),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    isLike = !isLike;
                    setState(() {});
                    widget.onChange(widget.article.id, isLike);
                  },
                  icon: isLike ? const Icon(
                    Icons.thumb_up,
                    color: Colors.blue,
                  )
                  : const Icon(Icons.thumb_up,),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getIconPath(String category) {

    switch (category) {
      case "Craftmanship":
        return 'assets/icon/coding.png';
      case "Coding":
        return 'assets/icon/anvil.png';
      case "Architecture":
        return 'assets/icon/architecture.png';
      case "UX/UI":
        return 'assets/icon/ux.png';
      case "DevOps":
        return 'assets/icon/devops.png';
      case "Network":
        return 'assets/icon/network.png';
      case "System":
        return 'assets/icon/system.png';
      case "Database":
        return 'assets/icon/database.png';
      case "Security":
        return 'assets/icon/security.png';
      default:
        return 'assets/icon/article.png';
    }
  }

}