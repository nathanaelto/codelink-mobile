import 'package:codelink_mobile/core/models/articles/comment.dart';
import 'package:flutter/material.dart';

typedef OnChange = void Function(String commentId, bool like);

class CommentRow extends StatefulWidget {
  bool commentIsLike;
  Comment comment;
  final OnChange onChange;

  CommentRow({Key? key, required this.commentIsLike, required this.comment, required this.onChange});

  @override
  State<StatefulWidget> createState() =>
      _CommentRowState();

}

class _CommentRowState extends State<CommentRow> {

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(5),
        alignment: Alignment.centerLeft,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 9,
                  child: Column(
                    children: [
                      Text(widget.comment.description,
                        // style: ,
                      ),
                      Text("By ${widget.comment.author}",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.grey.withOpacity(0.88),
                            fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: IconButton(
                    onPressed: () async {
                      if (widget.commentIsLike) {
                        widget.commentIsLike = false;
                      } else {
                        widget.commentIsLike = true;
                      }
                      setState(() {});
                      widget.onChange(widget.comment.id, widget.commentIsLike);
                    },
                    icon: widget.commentIsLike ? const Icon(
                      Icons.thumb_up,
                      color: Colors.blue,
                    )
                        : const Icon(Icons.thumb_up,),
                  )
                )
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(right: 8, left: 8),
              child: Divider(color: Colors.black,),
            )
          ],
        )
    );
  }

}