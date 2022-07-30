import 'package:codelink_mobile/core/ioc/definitions/user/user_service.interface.dart';
import 'package:codelink_mobile/core/ioc/ioc.dart';
import 'package:codelink_mobile/core/models/common/service_response.dart';
import 'package:codelink_mobile/shared/styles/app_styles.dart';
import 'package:codelink_mobile/shared/widgets/buttons/my_text_button.dart';
import 'package:flutter/material.dart';

typedef FollowChange = void Function(bool follow);

class FollowButton extends StatefulWidget {
  String userId;
  bool isFollow;
  FollowChange followChange;

  FollowButton({Key? key, required this.userId, required this.isFollow, required this.followChange});

  @override
  State<StatefulWidget> createState() {
    return _FollowButtonState(isFollow);
  }
}

class _FollowButtonState extends State<FollowButton> {
  final IUserService _userService = getIt.get<IUserService>();
  ValueNotifier<bool> userIsFollow = ValueNotifier(false);

  bool isFollow;
  _FollowButtonState(this.isFollow);

  Future<void> follow() async {
    ServiceResponse<bool> serviceResponse = await _userService.follow(widget.userId);
    if (serviceResponse.hasError) {
      return;
    }

    bool hasChange = serviceResponse.data!;
    if (hasChange) {
      userIsFollow.value = true;
      isFollow = true;
    }
  }

  Future<void> unfollow() async {
    ServiceResponse<bool> serviceResponse = await _userService.unfollow(widget.userId);
    if (serviceResponse.hasError) {
      return;
    }

    bool hasChange = serviceResponse.data!;
    if (hasChange) {
      userIsFollow.value = false;
      isFollow = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: userIsFollow,
      builder: (BuildContext context, bool value, Widget? child) {
        if (isFollow) {
          return MyTextButton(
            bgColor: kPrimaryColor,
            onPressed: () async {
              await unfollow();
              widget.followChange(false);
              userIsFollow.notifyListeners();
            },
            buttonName: 'Unfollow',
          );
        } else {
          return MyTextButton(
            bgColor: kPrimaryColor,
            onPressed: () async {
              await follow();
              widget.followChange(true);
              userIsFollow.notifyListeners();
            },
            buttonName: 'Follow',
          );
        }
      }
    );

  }

}