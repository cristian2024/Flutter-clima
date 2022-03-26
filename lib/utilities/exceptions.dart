class AccountBlockedException implements Exception {
  String cause;

  AccountBlockedException({
    required this.cause,
  });
}

class NotFoundException implements Exception {
  String cause;

  NotFoundException({
    required this.cause,
  });
}
