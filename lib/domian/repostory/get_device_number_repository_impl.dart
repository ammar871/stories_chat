
import 'package:stories_chat/data/localdatabase/local_datasource.dart';
import 'package:stories_chat/domian/entityes/text_message_entity/contact_entity.dart';

import 'get_device_number_repository.dart';

class GetDeviceNumberRepositoryImpl implements GetDeviceNumberRepository{
  final LocalDataSource localDataSource;

  GetDeviceNumberRepositoryImpl({required this.localDataSource});
  @override
  Future<List<ContactEntity>> getDeviceNumbers() {
    return localDataSource.getDeviceNumbers();
  }

}