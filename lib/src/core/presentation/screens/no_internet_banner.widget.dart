import 'package:flutter/material.dart';
import 'package:smart_reload_system_admin/src/core/services/connectivity.service.dart';


/// Wrap your app with this (via `MaterialApp.builder`) to show a slide-down
/// "No internet connection" banner whenever the device loses internet, and
/// auto-hide it when the connection comes back.
///
/// Usage:
/// ```dart
/// MaterialApp(
///   builder: (context, child) => NoInternetBanner(child: child!),
///   home: const HomePage(),
/// )
/// ```
class NoInternetBanner extends StatefulWidget {
  const NoInternetBanner({super.key, required this.child});

  final Widget child;

  @override
  State<NoInternetBanner> createState() => _NoInternetBannerState();
}

class _NoInternetBannerState extends State<NoInternetBanner> {
  late final ConnectivityService _service;
  bool _isOffline = false;
  bool _isRetrying = false;

  @override
  void initState() {
    super.initState();
    _service = ConnectivityService()..start();
    _service.onStatusChange.listen((online) {
      if (!mounted) return;
      setState(() {
        _isOffline = !online;
        if (online) _isRetrying = false;
      });
    });
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }

  Future<void> _retry() async {
    setState(() => _isRetrying = true);
    final online = await _service.checkNow();
    if (!mounted) return;
    setState(() {
      _isOffline = !online;
      _isRetrying = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        widget.child,
        Positioned(
          top: 10,
          left: 10,
          right: 10,
          child: AnimatedSlide(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
            offset: _isOffline ? Offset.zero : const Offset(0, -1.2),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _isOffline ? 1 : 0,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                  decoration: BoxDecoration(
                    color: Color(0xFF1B1F2A),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.wifi_off_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'No internet connection',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'Check your network and try again',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: _isRetrying ? null : _retry,
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.12),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isRetrying
                            ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}