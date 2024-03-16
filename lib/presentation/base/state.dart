class AppState<T> {
  T? data;
  String? error;
  AppState({this.data, this.error});
  AppState.success(this.data);
  AppState.error(this.error);
  AppState.loading();

  bool get isLoading => error == null && data == null;
  bool get isSuccess => data != null;
  bool get isError => error != null;
}
