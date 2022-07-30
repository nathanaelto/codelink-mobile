import 'package:codelink_mobile/authentication/login_view.dart';
import 'package:codelink_mobile/core/ioc/definitions/authentication/authentication.dao.interface.dart';
import 'package:codelink_mobile/core/ioc/definitions/blog/blog_service.interface.dart';
import 'package:codelink_mobile/core/ioc/definitions/user/user_service.interface.dart';
import 'package:codelink_mobile/core/ioc/ioc.dart';
import 'package:codelink_mobile/core/models/articles/article.dart';
import 'package:codelink_mobile/core/models/articles/fetch_articles_response.dart';
import 'package:codelink_mobile/core/models/common/service_response.dart';
import 'package:codelink_mobile/core/models/user/get_user_response.dart';
import 'package:codelink_mobile/core/models/user/is_follow_response.dart';
import 'package:codelink_mobile/core/models/user/user.dart';
import 'package:codelink_mobile/in_app_view/profile_views/widgets/follow_button.dart';
import 'package:codelink_mobile/in_app_view/profile_views/widgets/numbers_widget.dart';
import 'package:codelink_mobile/shared/styles/app_styles.dart';
import 'package:codelink_mobile/shared/styles/size_configs.dart';
import 'package:codelink_mobile/shared/widgets/buttons/my_text_button.dart';
import 'package:codelink_mobile/shared/widgets/toast.dart';
import 'package:flutter/material.dart';


class ProfileView extends StatefulWidget {
  String? userId;
  ProfileView({Key? key, this.userId}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {

  final IUserService _userService = getIt.get<IUserService>();
  final IAuthenticationDao _authenticationDao = getIt.get<IAuthenticationDao>();
  ValueNotifier<bool> followersAreChange = ValueNotifier(false);

  final double coverHeight = 280;
  final double profileHeight = 144;

  bool isMe = false;
  bool isFollow = false;
  late String myUserId;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: FutureBuilder(
        future: fetchUser(widget.userId),
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
      ),
    );
  }

  Future<void> checkFollow(String userId) async {
    ServiceResponse<IsFollowResponse> serviceResponse = await _userService.isFollow(userId);

    if (serviceResponse.hasError) {
      return;
    }
    IsFollowResponse isFollowResponse = serviceResponse.data!;

    isFollow = isFollowResponse.data.isFollowUser;
  }

  Future<Widget> fetchUser(String? userId) async {
    late ServiceResponse<GetUserResponse> serviceResponse;
    if (userId == null) {
      isMe = true;
      serviceResponse = await _userService.getMe();
    } else {
      serviceResponse = await _userService.getUserById(userId);
    }

    if (serviceResponse.hasError) {
      Toast.show(serviceResponse.error!, context, duration: 5, backgroundColor: Colors.red);
      return Container();
    }

    GetUserResponse getUserResponse = serviceResponse.data!;
    User user = getUserResponse.data.user;

    String? userIdStored = await _authenticationDao.getUserId();
    if (userIdStored == null) {
      Toast.show(serviceResponse.error!, context, duration: 5, backgroundColor: Colors.red);
      return Container();
    }
    myUserId = userIdStored;

    if (!isMe) {
      await checkFollow(user.id);
    }

    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        buildTop(user),
        buildContent(user),
      ],
    );
  }

  Widget buildTop(User user) {
    String urlImage = user.imageUrl ?? "https://www.creativefabrica.com/wp-content/uploads/2020/01/26/cowboy-avatar-icon-Graphics-1-1-580x387.png";
    final top = coverHeight - profileHeight / 2;
    final bottom = profileHeight / 2;
    if (!isMe) {
      return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Stack(
            children: [
              Container(
                  margin: EdgeInsets.only(bottom: bottom),
                  child: buildCoverImage()
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_back_ios,
                        color: Theme.of(context).primaryColor, size: 25
                      ),
                      const Text(
                          "back",
                          style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: top,
            child: buildProfileImage(urlImage),
          ),
        ],
      );
    }
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
            margin: EdgeInsets.only(bottom: bottom),
            child: buildCoverImage()
        ),
        Positioned(
          top: top,
          child: buildProfileImage(urlImage),
        ),
      ],
    );

  }

  Widget buildCoverImage() => Container(
        color: Colors.grey,
        child: Image.network(
            "https://images.unsplash.com/photo-1542831371-29b0f74f9713?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80",
            width: double.infinity,
            height: coverHeight,
            fit: BoxFit.cover),
      );

  Widget buildProfileImage(String url) {
    if (url.isEmpty) {
      return CircleAvatar(
        radius: profileHeight / 2,
        backgroundColor: Colors.grey.shade800,
        backgroundImage: const AssetImage("assets/images/default-profile-image.jpg"),
      );
    }
    return CircleAvatar(
      radius: profileHeight / 2,
      backgroundColor: Colors.grey.shade800,
      backgroundImage: NetworkImage(url),
    );
  }

  Widget buildContent(User user) => Column(
        children: [
          const SizedBox(height: 8),
          Text(
            user.username,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 16),
          ValueListenableBuilder(
            valueListenable: followersAreChange,
            builder: (BuildContext context, bool value, Widget? child) {
              return NumbersWidget(user: user, isMe: isMe,);
            }
          ),
          const SizedBox(height: 16),
          !isMe ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: FollowButton(
              userId: user.id,
              isFollow: isFollow,
              followChange: (bool userIsFollow) {
                if (userIsFollow) {
                  user.followers.add(myUserId);
                } else {
                  user.followers.remove(myUserId);
                }
                followersAreChange.value = !followersAreChange.value;
                followersAreChange.notifyListeners();
              },
            )
          ) : Container(),
          const Divider(),
          buildInfo(user),
          isMe ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: MyTextButton(
              buttonName: "Logout",
              onPressed: () async {
                await logout();
              },
              bgColor: kPrimaryColor
            ),
          ) : Container(),
        ],
      );

  Widget buildInfo(User user) {
    if (isMe) {
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
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Text("Email :",
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16),),
                  Text(user.email,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ]
              ),
            ),
          ],
        ),
      );
    }
    return Container();
  }

  Future<void> logout() async {
    ServiceResponse<bool> serviceResponse = await _userService.logout();

    if (serviceResponse.hasError) {
      Toast.show(serviceResponse.error!, context, duration: 5, backgroundColor: Colors.red);
      return;
    }

    await _authenticationDao.deleteAll();

    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const LoginView()));
  }
}



