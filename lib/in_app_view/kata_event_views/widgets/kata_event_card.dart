import 'package:codelink_mobile/core/models/kata_event/kata_event.dart';
import 'package:codelink_mobile/shared/styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class KataEventCard extends StatelessWidget {

  KataEvent kataEvent;

  KataEventCard({Key? key, required this.kataEvent}) : super(key: key);

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
            child: Center(
              child: Text(
                kataEvent.name,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: Text(
              "from ${DateFormat.yMMMEd().format(kataEvent.startDate)} to ${DateFormat.yMMMEd().format(kataEvent.endDate)}",
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.grey.withOpacity(0.88),
                    fontSize: 13)
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 8, right: 8),
            child: Divider(color: Colors.black,),
          ),
          Text("Top 3 challengers :",
            style: kBodyText1,
          ),
          Column(
            children: buildTopThree(),
          )
        ],
      ),
    );
  }

  List<Widget> buildTopThree() {
    int size = kataEvent.kataEventResults.length < 3 ? kataEvent.kataEventResults.length : 3;
    List<Widget> top = [];
    for (var i = 0; i < size; i++) {
      bool isSuccess = kataEvent.kataEventResults[i].status == 0;
      top.add(Container(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
        child: Column(
          children: [
            Row(
              children: [
                Text("#${i+1} ",
                  style: const TextStyle(color: Colors.black54, fontSize: 14, fontStyle: FontStyle.italic),
                ),
                Text(kataEvent.kataEventResults[i].username,
                  style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              children: [
                isSuccess ?
                  const Icon(Icons.check_box_outlined, color: Colors.green,)
                  : const Icon(Icons.error_outline_rounded, color: Colors.red,),
                isSuccess ?
                  Text("Success in ${kataEvent.kataEventResults[i].time} sec") :
                    Text("Error in ${kataEvent.kataEventResults[i].time} sec")
              ],
            )

          ],
        ),
      ));
    }
    return top;
  }

}