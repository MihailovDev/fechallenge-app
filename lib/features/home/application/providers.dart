/// This files contains the simple riverpod providers.
/// Currently we have a simple provider for the AirportRepository and the HomePageViewModel.

import 'package:fechallenge/features/home/data/airport_repository.dart';
import 'package:fechallenge/features/home/domain/home_page_state.dart';
import 'package:fechallenge/features/home/presentation/home_page_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;


final airportRepositoryProvider = Provider<AirportRepository>((ref) {
  return AirportRepository(
    client: http.Client(),
  );
});

final homePageViewModelProvider = StateNotifierProvider<HomePageViewModel, HomePageState>((ref) {
  return HomePageViewModel(ref);
});
