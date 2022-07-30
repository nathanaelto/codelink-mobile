import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef OnSend = void Function(String text);

class CommentField extends StatefulWidget {

  final OnSend onSend;
  FocusNode focusNode;

  CommentField({Key? key, required this.onSend, required this.focusNode}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CommentFieldState();
}

class _CommentFieldState extends State<CommentField> {

  final FocusNode _commentFocus = FocusNode();

  final TextEditingController _controller = TextEditingController();
  bool cansSend = false;

  @override
  void dispose() {
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    ThemeData themeData = Theme.of(context);

    return Column(
      children: [
        Container(
          width: screenSize.width * 0.9,
          height: screenSize.height * 0.08,
          decoration: BoxDecoration(
              color: themeData.cardColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight:  Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              border: Border.all(
                color: themeData.primaryColor,
              )
          ),
          child: Row(
            children: [
              Container(
                width: screenSize.width * 0.8,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: TextField(
                  focusNode: widget.focusNode,
                  controller: _controller,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                      focusedBorder: InputBorder.none,
                      hintText: 'Write comment',
                      hintStyle: TextStyle(
                        color: themeData.primaryColor.withOpacity(0.5),
                      ),
                      hintMaxLines: 2
                  ),
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onChanged: (String value) {
                    cansSend = value.isNotEmpty;
                    setState(() {});
                  },
                ),

              ),
              SizedBox(
                width: screenSize.width * 0.08,
                child: _SendButton(context: context),
              )
            ],
          ),
        ),
      ],
    );
  }
  Widget _SendButton({required BuildContext context}) {
    ThemeData themeData = Theme.of(context);
    return IconButton(
      icon: Icon(
        Icons.send,
        color: cansSend ? themeData.primaryColor : Colors.grey,
      ),
      onPressed:  cansSend ? () {
        String content = _controller.text.isEmpty ? "" :  _controller.text;
        widget.onSend(content);
        _controller.text = "";
      } : null,
    );
  }

}