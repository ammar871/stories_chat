import 'package:stories_chat/domian/repostory/firebase_repostory.dart';

class GetCurrentUserUidUseCase{
  final FirebaseRepository repository;

  GetCurrentUserUidUseCase({required this.repository});

  Future<String> call() async {
    return await repository.getCurrentUid();
  }
}