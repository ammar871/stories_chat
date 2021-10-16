import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:stories_chat/domian/entityes/text_message_entity/contact_entity.dart';
import 'package:stories_chat/domian/usescases/get_device_numbers_usecase.dart';

part 'get_device_numbers_state.dart';



class GetDeviceNumbersCubit extends Cubit<GetDeviceNumbersState> {
  final GetDeviceNumberUseCase getDeviceNumberUseCase;
  GetDeviceNumbersCubit({required this.getDeviceNumberUseCase}) : super(GetDeviceNumbersInitial());

  Future<void> getDeviceNumbers()async{
    try{
      final contactNumbers=await getDeviceNumberUseCase.call();
      emit(GetDeviceNumbersLoaded(contacts: contactNumbers));
    }catch(_){
      emit(GetDeviceNumbersFailure());
    }
  }
}