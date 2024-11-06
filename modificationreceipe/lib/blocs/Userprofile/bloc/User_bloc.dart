import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logins/blocs/Userprofile/bloc/bloc.dart';
import 'package:logins/models/receipeDetail.dart' as models;
import 'package:logins/services/repository.dart';
import 'package:logins/services/api_provider.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final Repository repository;

  UserBloc({required this.repository}) : super(UserInitial()) {
    on<AppUserStarted>(_mapAppUserStartedToState);
  }

  Future<void> _mapAppUserStartedToState(
      AppUserStarted event,
      Emitter<UserState> emit,
      ) async {
    emit(UserLoading());
    try {
      final ProfileData profileData =
      await repository.apiProvider.fetchProfile();
      print("oj");

      final List<models.User> receipes = profileData.profile;
      print(receipes);
      emit(UserLoaded(receipes));

    } catch (error) {
      emit(UserError('Failed to fetch user profile'));
    }
  }
}
