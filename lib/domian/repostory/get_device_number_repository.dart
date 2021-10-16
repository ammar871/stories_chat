import 'package:stories_chat/domian/entityes/text_message_entity/contact_entity.dart';

abstract class GetDeviceNumberRepository{
  Future<List<ContactEntity>> getDeviceNumbers();
}