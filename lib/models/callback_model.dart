class CallbackModel {
  List<String> selectedGenre;
  int? selectedStartYear;
  int? selectedEndYear;

  CallbackModel({
    required this.selectedGenre,
    this.selectedStartYear,
    this.selectedEndYear,
  });
}
