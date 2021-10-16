import 'package:stories_chat/domian/entityes/text_message_entity/contact_entity.dart';
import 'package:contacts_service/contacts_service.dart';
abstract class LocalDataSource{
  Future<List<ContactEntity>> getDeviceNumbers();
}

class LocalDataSourceImpl implements LocalDataSource{
  @override
  Future<List<ContactEntity>> getDeviceNumbers()async {
    List<ContactEntity> contacts=[];
    final getContactsData= await ContactsService.getContacts();

    for (var myContact in getContactsData) {
      for (var phoneData in myContact.phones!) {
        contacts.add(ContactEntity(
          phoneNumber: phoneData.value!,
          label: myContact.displayName!, status: '', uid: '',
        ));
      }
    }
    return contacts;
  }

}