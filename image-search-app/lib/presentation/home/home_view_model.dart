import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_search/data/data_source/result.dart';
import 'package:image_search/domain/model/photo.dart';
import 'package:image_search/domain/use_case/get_photos_use_case.dart';
import 'package:image_search/presentation/home/home_state.dart';
import 'package:image_search/presentation/home/home_ui_event.dart';

class HomeViewModel with ChangeNotifier {
  final GetPhotosUseCase getPhotosUseCase;

  HomeState _state = HomeState([], false);

  HomeState get state => _state;

  final _eventController = StreamController<HomeUiEvent>();

  Stream<HomeUiEvent> get eventStream => _eventController.stream;

  HomeViewModel(this.getPhotosUseCase);

  Future<void> fetch(String query) async {
    _state = state.copyWith(isLoading: true);
    notifyListeners();

    final Result<List<Photo>> result = await getPhotosUseCase(query);

    switch (result) {
      case Success(:final data):
        _state = state.copyWith(photos: data);
        notifyListeners();
      case Error(:final e):
        _eventController.add(HomeUiEvent.showSnackBar(e));
    }
    _state = state.copyWith(isLoading: false);
    notifyListeners();
  }
}
