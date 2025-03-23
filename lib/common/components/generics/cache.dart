import 'package:flutter/material.dart';

class Cache<T> extends StatefulWidget {
  const Cache({required this.builder, required this.value, super.key});

  final Widget Function(BuildContext context, T value) builder;
  final T value;

  @override
  _CacheState<T> createState() => _CacheState<T>();
}

class _CacheState<T> extends State<Cache<T>> {
  Widget? cache;
  T? previousValue;

  @override
  void dispose() {
    previousValue = null;
    cache = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (cache == null || widget.value != previousValue) {
      previousValue = widget.value;
      cache = Builder(
        builder: (context) => widget.builder(context, widget.value),
      );
    }
    return cache!;
  }
}
