import 'package:stories_chat/domian/repostory/firebase_repostory.dart';

class IsSignInUsesCase {
  final FirebaseRepository repository;

  IsSignInUsesCase({required this.repository});

  Future<bool> isSignIn() async {
    return await repository.isSignIn();
  }
}
