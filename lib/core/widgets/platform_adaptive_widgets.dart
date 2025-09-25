import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PlatformAdaptiveWidget extends StatelessWidget {
  final Widget child;
  final Widget? webChild;
  final Widget? mobileChild;
  final Widget? desktopChild;

  const PlatformAdaptiveWidget({
    super.key,
    required this.child,
    this.webChild,
    this.mobileChild,
    this.desktopChild,
  });

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return webChild ?? child;
    }

    if (kIsWeb == false) {
      try {
        if (Platform.isAndroid || Platform.isIOS) {
          return mobileChild ?? child;
        }
        if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
          return desktopChild ?? child;
        }
      } catch (e) {
        // Fallback en cas d'erreur Platform
      }
    }

    return child;
  }
}

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, BoxConstraints constraints)
      builder;
  final double mobileBreakpoint;
  final double tabletBreakpoint;
  final double desktopBreakpoint;

  const ResponsiveBuilder({
    super.key,
    required this.builder,
    this.mobileBreakpoint = 600,
    this.tabletBreakpoint = 900,
    this.desktopBreakpoint = 1200,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return builder(context, constraints);
      },
    );
  }

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 900;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 900;
  }

  static int getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) return 5; // Desktop large
    if (width >= 900) return 4; // Desktop
    if (width >= 600) return 3; // Tablet
    return 2; // Mobile
  }
}

class PlatformAdaptiveScaffold extends StatelessWidget {
  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;

  const PlatformAdaptiveScaffold({
    super.key,
    required this.body,
    this.title,
    this.actions,
    this.bottomNavigationBar,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    if (kIsWeb == false) {
      try {
        if (Platform.isIOS) {
          return CupertinoPageScaffold(
            navigationBar: title != null
                ? CupertinoNavigationBar(
                    middle: Text(title!),
                    trailing: actions != null && actions!.isNotEmpty
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: actions!,
                          )
                        : null,
                  )
                : null,
            child: body,
          );
        }
      } catch (e) {
        // Fallback vers Material Design
      }
    }

    return Scaffold(
      appBar: title != null
          ? AppBar(
              title: Text(title!),
              actions: actions,
            )
          : null,
      body: body,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }
}
