part of 'update_user_info_bloc.dart';

abstract class UpdateUserInfoEvent extends Equatable {
  const UpdateUserInfoEvent();

  @override
  List<Object> get props=> [];

}

class UploadPicture extends UpdateUserInfoEvent {
  final String file;
  final String userID;
  const UploadPicture(this.file,this.userID);

  @override
  List<Object> get props => [file,userID];
}