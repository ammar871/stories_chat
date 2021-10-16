import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:stories_chat/data/models/user_data.dart';

part 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  UsersCubit() : super(UsersInitial());
  List<UserData> users = [];

   getData()  {
    emit(Loading());
    users=[];
    FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {

      for (var doc in querySnapshot.docs) {
        UserData userData = UserData(
            name: doc['full_name'].toString(),
            image: doc['image'].toString(),
            phone: doc['phone'].toString());
        users.add(userData);

      }
     // print(users.length);
      emit(Success(users));
    });

  }
}
