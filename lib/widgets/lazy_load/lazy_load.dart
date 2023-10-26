
import 'package:flutter/material.dart';

class LazyLoad extends StatefulWidget {
  final Widget child;

  const LazyLoad({super.key, required this.child});

  @override
  State<LazyLoad> createState() => _LazyLoadState();
}

class _LazyLoadState extends State<LazyLoad> {
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _loaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loaded ? widget.child : const SizedBox.shrink();
  }
}
