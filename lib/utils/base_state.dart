class Result<T> {
  const Result._(); 

  const factory Result.init() = InitResult<T>;
  const factory Result.done() = DoneResult<T>;
  const factory Result.loading() = LoadingResult<T>;
  const factory Result.loadMore(T data) = LoadMoreResult<T>;
  const factory Result.success(T data) = SuccessResult<T>;
  const factory Result.error(String errorMsg) = ErrorResult<T>;

  T? getSuccessData() {
    if (this is SuccessResult) {
      return (this as SuccessResult<T>).data;
    } else if (this is LoadMoreResult) {
      return (this as LoadMoreResult<T>).data;
    }
    return null;
  }

  String getErrorMessage() {
    if (this is ErrorResult) {
      return (this as ErrorResult<T>).errorMsg;
    }
    return '';
  }
}

class InitResult<T> extends Result<T> {
  const InitResult() : super._();
}

class LoadingResult<T> extends Result<T> {
  const LoadingResult() : super._();
}

class LoadMoreResult<T> extends Result<T> {
  final T data;
  const LoadMoreResult(this.data) : super._();
}

class SuccessResult<T> extends Result<T> {
  final T data;
  const SuccessResult(this.data) : super._();
}
class ErrorResult<T> extends Result<T> {
  final String errorMsg;
  const ErrorResult(this.errorMsg) : super._();
}
class DoneResult<T> extends Result<T> {
  const DoneResult() : super._();
}
