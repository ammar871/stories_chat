import 'package:stories_chat/domian/entityes/user_entity/user_entity.dart';
import 'package:stories_chat/domian/repostory/firebase_repostory.dart';

class GetAllUserUseCase{
  final FirebaseRepository repository;

  GetAllUserUseCase({required this.repository});

  Stream<List<UserEntity>> call(){
    return repository.getAllUsers();
  }

}