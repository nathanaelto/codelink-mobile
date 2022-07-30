import 'package:codelink_mobile/core/ioc/definitions/kata_event/kata_event_service.interface.dart';
import 'package:codelink_mobile/core/ioc/ioc.dart';
import 'package:codelink_mobile/core/models/common/service_response.dart';
import 'package:codelink_mobile/core/models/kata_event/kata_event.dart';
import 'package:codelink_mobile/in_app_view/kata_event_views/widgets/kata_event_card.dart';
import 'package:codelink_mobile/shared/styles/size_configs.dart';
import 'package:codelink_mobile/shared/widgets/toast.dart';
import 'package:flutter/material.dart';

class KataEventView extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _KataEventViewState();
}

class _KataEventViewState extends State<KataEventView> {
  final IKataEventService _kataEventService = getIt.get<IKataEventService>();
  late List<KataEvent> kataEvents;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Challenges"),
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(color: Color(0xFF0A0A36), fontSize: 25),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: FutureBuilder(
          future: initView(),
          builder: (BuildContext context, AsyncSnapshot<Widget> snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              );
            }

            return snap.data!;
          },
        ),
      ),
    );
  }

  Future<Widget> initView() async {
    ServiceResponse<List<KataEvent>> serviceResponse = await _kataEventService.getAllKataEvent();
    if (serviceResponse.hasError) {
      Toast.show(serviceResponse.error!, context, duration: 5, backgroundColor: Colors.red);
      return Container();
    }
    kataEvents = serviceResponse.data!;
    return displayContent();
  }

  Widget displayContent() {
    return ListView.builder(
      itemCount: kataEvents.length,
        shrinkWrap: true,
        padding: const EdgeInsets.all(5),
        scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () { },
          child: KataEventCard(kataEvent: kataEvents[index]),
        );
      }
    );
  }

}