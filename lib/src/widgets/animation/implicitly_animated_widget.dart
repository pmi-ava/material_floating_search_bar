import 'package:flutter/material.dart'
    hide ImplicitlyAnimatedWidget, ImplicitlyAnimatedWidgetState;

// ignore_for_file: public_member_api_docs

/// A base Widget for implicit animations.
abstract class ImplicitlyAnimatedWidget extends StatefulWidget {
  final Duration duration;
  final Curve curve;
  const ImplicitlyAnimatedWidget(
    Key? key,
    this.duration,
    this.curve,
  ) : super(key: key);
}

abstract class ImplicitlyAnimatedWidgetState<T,
        W extends ImplicitlyAnimatedWidget> extends State<W>
    with TickerProviderStateMixin {
  late final _controller = AnimationController(
    duration: widget.duration,
    vsync: this,
  )
    ..value = 1.0
    ..addListener(
      () => setState(
        () => value = lerp(oldValue, newValue, _animation.value),
      ),
    );

  late var _animation = CurvedAnimation(
    curve: widget.curve,
    parent: _controller,
  );

  T get newValue;
  late T value = newValue;
  late T oldValue = newValue;

  @override
  void didUpdateWidget(W oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }

    if (oldWidget.curve != widget.curve) {
      _animation = CurvedAnimation(
        curve: widget.curve,
        parent: _controller,
      );
    }

    if (value != newValue) {
      oldValue = value;

      _controller
        ..reset()
        ..forward();
    }
  }

  T lerp(T a, T b, double t);

  @override
  void didChangeDependencies() {
    _controller.removeListener(() {});
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
