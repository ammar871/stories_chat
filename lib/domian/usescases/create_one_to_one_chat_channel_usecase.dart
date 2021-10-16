import 'package:stories_chat/domian/repostory/firebase_repostory.dart';

class CreateOneToOneChatChannelUseCase{
  final FirebaseRepository repository;

  CreateOneToOneChatChannelUseCase({required this.repository});

  Future<void> call(String uid,String otherUid)async{
    return repository.createOneToOneChatChannel(uid, otherUid);
  }
}