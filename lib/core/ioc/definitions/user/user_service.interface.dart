import 'package:codelink_mobile/core/models/common/service_response.dart';
import 'package:codelink_mobile/core/models/user/get_user_response.dart';
import 'package:codelink_mobile/core/models/user/is_follow_response.dart';

abstract class IUserService {
  Future<ServiceResponse<GetUserResponse>> getMe();
  Future<ServiceResponse<GetUserResponse>> getUserById(String userId);
  Future<ServiceResponse<IsFollowResponse>> isFollow(String userId);
  Future<ServiceResponse<bool>> follow(String userId);
  Future<ServiceResponse<bool>> unfollow(String userId);
  Future<ServiceResponse<bool>> logout();
}