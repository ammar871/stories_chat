import 'package:stories_chat/domian/entityes/text_message_entity/contact_entity.dart';
import 'package:stories_chat/domian/repostory/get_device_number_repository.dart';

class GetDeviceNumberUseCase{
  final GetDeviceNumberRepository deviceNumberRepository;

  GetDeviceNumberUseCase({required this.deviceNumberRepository});

  Future<List<ContactEntity>> call()async{
    return deviceNumberRepository.getDeviceNumbers();
  }
}