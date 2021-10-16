import 'package:stories_chat/domian/repostory/firebase_repostory.dart';

class SignOutUseCase{
  final FirebaseRepository repository;

  SignOutUseCase({required this.repository});

  Future<void> call() async {
    return await repository.signOut();
  }

}