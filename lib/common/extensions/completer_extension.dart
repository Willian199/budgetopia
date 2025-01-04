import 'dart:async';

/// Extensão que adiciona callbacks ao Completer
extension CompleterWithCallbacks<T> on Completer<T> {
  /// Adiciona um callback para o sucesso
  void onComplete(void Function(T value) callback) {
    future.then((value) => callback(value));
  }

  /// Adiciona um callback para erro
  void onCompleteError(void Function(Object error, StackTrace stackTrace) callback) {
    future.onError<Object>((error, stackTrace) {
      callback(error, stackTrace);
      return Future<T>.error(error, stackTrace);
    });
  }

  /// Configura callbacks para o momento da conclusão com sucesso e erro
  void on({
    void Function(T value)? onComplete,
    void Function(Object error, StackTrace stackTrace)? onCompleteError,
  }) {
    this.onComplete((value) {
      if (onComplete != null) {
        onComplete(value);
      }
    });

    this.onCompleteError((error, stackTrace) {
      if (onCompleteError != null) {
        onCompleteError(error, stackTrace);
      }
    });
  }

  /// Construtor de facilidades: Cria um Completer com callbacks configurados
  static Completer<T> withCallbacks<T>({
    void Function(T value)? onComplete,
    void Function(Object error, StackTrace stackTrace)? onCompleteError,
  }) {
    final completer = Completer<T>();
    completer.on(
      onComplete: onComplete,
      onCompleteError: onCompleteError,
    );
    return completer;
  }
}
