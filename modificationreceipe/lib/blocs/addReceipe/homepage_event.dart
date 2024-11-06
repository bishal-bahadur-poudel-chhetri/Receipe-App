// homepage_event.dart

import 'package:equatable/equatable.dart';
import 'package:flutter/src/widgets/framework.dart';

abstract class AddReceipeEvent extends Equatable {
  const AddReceipeEvent();

  @override
  List<Object> get props => [];
}

class NavigateToNewPageEvent extends AddReceipeEvent {
  final BuildContext context;

  NavigateToNewPageEvent(this.context);
}

class UploadPhotoEvent extends AddReceipeEvent {
  final String filePath;

  UploadPhotoEvent(this.filePath);

  @override
  List<Object> get props => [filePath];
}
