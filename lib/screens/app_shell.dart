import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/app_state.dart';
import '../widgets/layout/mobile_navbar.dart';
import '../widgets/layout/desktop_sidebar.dart';
import '../widgets/layout/top_alerts.dart';

class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    final routerState = GoRouterState.of(context);
    state.syncIndexWithRoute(routerState.matchedLocation);

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = constraints.maxWidth > 900;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              Row(
                children: [
                  if (isDesktop)
                    DesktopSidebar(state: state),
                  Expanded(child: child),
                ],
              ),
              if (!isDesktop)
                Positioned(
                  top: MediaQuery.of(context).padding.top + AppConstants.spacing4,
                  right: AppConstants.spacing4,
                  child: const TopAlerts(),
                ),
            ],
          ),
          bottomNavigationBar: isDesktop ? null : MobileNavbar(state: state),
        );
      },
    );
  }
}
