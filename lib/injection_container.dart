import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:stories_chat/domian/usescases/get_current_useeruid_usescase.dart';
import 'package:stories_chat/domian/usescases/is_signin_usescases.dart';

import 'bissnus_logic/communication/communication_cubit.dart';
import 'bissnus_logic/get_divice_number/get_device_numbers_cubit.dart';
import 'bissnus_logic/my_chat/my_chat_cubit.dart';
import 'bissnus_logic/profile/profile_cubit.dart';
import 'bissnus_logic/user/user_cubit.dart';
import 'data/datasource/firebase_remote_datasource.dart';
import 'data/datasource/firebase_remote_datasours.dart';
import 'data/localdatabase/local_datasource.dart';
import 'domian/repostory/firebase_repository_imp.dart';
import 'domian/repostory/firebase_repostory.dart';
import 'domian/repostory/get_device_number_repository.dart';
import 'domian/repostory/get_device_number_repository_impl.dart';
import 'domian/usescases/add_to_my_chat_usecase..dart';
import 'domian/usescases/create_one_to_one_chat_channel_usecase.dart';
import 'domian/usescases/get_all_user_usecase..dart';
import 'domian/usescases/get_create_current_user_usescases.dart';
import 'domian/usescases/get_device_numbers_usecase.dart';
import 'domian/usescases/get_my_chat_usecase.dart';
import 'domian/usescases/get_one_to_one_single_user_chat_channel_usecase.dart';
import 'domian/usescases/get_text_messages_usecase.dart';
import 'domian/usescases/send_text_message_usecase.dart';

final sl = GetIt.instance;

Future<void> init() async {

  //blc
  sl.registerFactory<CommunicationCubit>(() => CommunicationCubit(
    addToMyChatUseCase: sl.call(),
    getOneToOneSingleUserChatChannelUseCase: sl.call(),
    getTextMessagesUseCase: sl.call(),
    sendTextMessageUseCase: sl.call(),
  ));

  sl.registerFactory<ProfileCubit>(() => ProfileCubit());
  sl.registerFactory<MyChatCubit>(() => MyChatCubit(
    getMyChatUseCase: sl.call(),
  ));

  sl.registerFactory<GetDeviceNumbersCubit>(
          () => GetDeviceNumbersCubit(getDeviceNumberUseCase: sl.call()));

  sl.registerFactory<UserCubit>(() => UserCubit(
    createOneToOneChatChannelUseCase: sl.call(),
    getAllUserUseCase: sl.call(),
  ));


  //
  // sl.registerLazySingleton<FirebaseRemoteDataSource>(
  //         () => FirebaseRemoteDataSourceImpl(
  //       auth: sl.call(),
  //       fireStore: sl.call(),
  //     ));
  //uses case

  sl.registerLazySingleton<GetCreateCurrentUserUseCase>(
      () => GetCreateCurrentUserUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetCurrentUserUidUseCase>(
      () => GetCurrentUserUidUseCase(repository: sl.call()));
  sl.registerLazySingleton<IsSignInUsesCase>(
      () => IsSignInUsesCase(repository: sl.call()));

  sl.registerLazySingleton<GetAllUserUseCase>(
      () => GetAllUserUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetMyChatUseCase>(
      () => GetMyChatUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetTextMessagesUseCase>(
      () => GetTextMessagesUseCase(repository: sl.call()));
  sl.registerLazySingleton<SendTextMessageUseCase>(
      () => SendTextMessageUseCase(repository: sl.call()));
  sl.registerLazySingleton<AddToMyChatUseCase>(
      () => AddToMyChatUseCase(repository: sl.call()));
  sl.registerLazySingleton<CreateOneToOneChatChannelUseCase>(
      () => CreateOneToOneChatChannelUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetOneToOneSingleUserChatChannelUseCase>(
      () => GetOneToOneSingleUserChatChannelUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetDeviceNumberUseCase>(
      () => GetDeviceNumberUseCase(deviceNumberRepository: sl.call()));

  //repository
  sl.registerLazySingleton<FirebaseRepository>(
      () => FirebaseRepositoryImpl(sl.call()));
  sl.registerLazySingleton<GetDeviceNumberRepository>(
      () => GetDeviceNumberRepositoryImpl(
            localDataSource: sl.call(),
          ));

  //remote data
  sl.registerLazySingleton<FirebaseRemoteDatasource>(
      () => FirebaseRemoteDatasourceImpl(sl.call(), sl.call()));
  sl.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl());
  //External

  final auth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance;
  sl.registerLazySingleton(() => auth);
  sl.registerLazySingleton(() => fireStore);
}
