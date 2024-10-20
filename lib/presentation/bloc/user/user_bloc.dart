import 'package:equatable/equatable.dart';
import 'package:shareindia/domain/entities/master_data_entities.dart';
import 'package:shareindia/domain/usecase/user_usecase.dart';
import '../../../core/error/failures.dart';
import '../../../domain/entities/api_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/user_entity.dart';

part 'user_state.dart';

class UserBloc extends Cubit<UserState> {
  final UserUseCase userUseCase;
  UserBloc({required this.userUseCase}) : super(Init());

  Future<LoginEntity> validateUser(Map<String, dynamic> requestParams) async {
    final result = await userUseCase.validateUser(requestParams: requestParams);
    return (result.fold(
        (l) => LoginEntity(), (r) => r.entity ?? LoginEntity()));
  }

  Future<UserEntity> getUserData(Map<String, dynamic> requestParams) async {
    final result = await userUseCase.getUserData(requestParams: requestParams);
    return result.fold((l) => UserEntity(), (r) => r.entity ?? UserEntity());
  }

  Future<ListEntity> getDirectoryEmployees({
    required Map<String, dynamic> requestParams,
  }) async {
    //emit(OnMasterDataLoading());
    final result =
        await userUseCase.getDirectoryEmployees(requestParams: requestParams);
    return result.fold((l) => ListEntity(), (r) => r.entity ?? ListEntity());
  }

  Future<void> setVaction({required Map<String, dynamic> requestParams}) async {
    emit(OnLoginLoading());
    final result =
        await userUseCase.updateVactionStatus(requestParams: requestParams);
    emit(result.fold((l) => OnLoginApiError(message: _getErrorMessage(l)), (r) {
      return UpdateVactionStatus(updateVactionStatus: r.entity?.value);
    }));
  }

  String _getErrorMessage(Failure failure) {
    return failure.errorMessage;
  }
}
