import 'package:stories_chat/domian/repostory/firebase_repostory.dart';

class GetOneToOneSingleUserChatChannelUseCase{
  final FirebaseRepository repository;

  GetOneToOneSingleUserChatChannelUseCase({required this.repository});

  Future<String> call(String uid,String otherUid)async{
    return await repository.getOneToOneSingleUserChannelId(uid, otherUid);
  }
}