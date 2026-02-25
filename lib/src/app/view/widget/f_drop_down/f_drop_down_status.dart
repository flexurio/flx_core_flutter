enum Status {
  progress(0),
  error(-1),
  loaded(1);

  const Status(this.value);

  final int value;

  bool get isProgress => this == Status.progress;
  bool get isError => this == Status.error;
  bool get isLoaded => this == Status.loaded;
}
