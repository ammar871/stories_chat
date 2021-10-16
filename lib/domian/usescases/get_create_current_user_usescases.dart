import 'package:stories_chat/domian/entityes/user_entity/user_entity.dart';
import 'package:stories_chat/domian/repostory/firebase_repostory.dart';

class GetCreateCurrentUserUseCase{

  final FirebaseRepository repository;

  GetCreateCurrentUserUseCase({required this.repository});

  Future<void> call(UserEntity userEntity) async {
  return await repository.getCreateCurrentUser(userEntity);
  }
  }
