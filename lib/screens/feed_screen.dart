import 'package:hangout/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../core/theme.dart';
import '../providers/hangout_provider.dart';
import '../widgets/hangout_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<HangoutProvider>(
        builder: (context, provider, child) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 600;
              final isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 1024;
              final isDesktop = constraints.maxWidth >= 1024;
              
              int crossAxisCount;
              if (isDesktop) {
                crossAxisCount = 3;
              } else if (isTablet) {
                crossAxisCount = 2;
              } else {
                crossAxisCount = 1;
              }

              return CustomScrollView(
                slivers: [
                  // Modern App Bar
                  SliverAppBar(
                    floating: true,
                    pinned: true,
                    expandedHeight: isMobile ? 100 : 140,
                    backgroundColor: AppColors.surface,
                    elevation: 0,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        'Discover Hangouts',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontSize: isMobile ? 24 : 32,
                          letterSpacing: -0.5,
                        ),
                      ),
                      titlePadding: EdgeInsets.fromLTRB(
                        AppConstants.spacing6,
                        0,
                        AppConstants.spacing6,
                        isMobile ? 12 : 16,
                      ),
                      expandedTitleScale: 1.2,
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(right: AppConstants.spacing4),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(LucideIcons.slidersHorizontal, color: AppColors.trustBlue),
                          tooltip: 'Filters',
                        ),
                      ),
                    ],
                  ),
                  
                  // Loading State
                  if (provider.isLoading)
                    const SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                              color: AppColors.trustBlue,
                              strokeWidth: 3,
                            ),
                            SizedBox(height: AppConstants.spacing5),
                            Text(
                              'Finding hangouts near you...',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  // Empty State
                  else if (provider.hangouts.isEmpty)
                    SliverFillRemaining(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(AppConstants.spacing6),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceDim,
                                  borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                                ),
                                child: const Icon(
                                  LucideIcons.map,
                                  size: 50,
                                  color: AppColors.textPlaceholder,
                                ),
                              ),
                              SizedBox(height: AppConstants.spacing5),
                              Text(
                                'No hangouts nearby',
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: AppConstants.spacing3),
                              Text(
                                'Be the first to create one and start connecting with people',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              SizedBox(height: AppConstants.spacing6),
                              ElevatedButton.icon(
                                onPressed: () => context.push('/create'),
                                icon: const Icon(LucideIcons.plus),
                                label: const Text('Create Hangout'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  // Hangouts Grid/List
                  else
                    SliverPadding(
                      padding: EdgeInsets.all(isMobile ? AppConstants.spacing4 : AppConstants.spacing6),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: isMobile ? AppConstants.spacing4 : AppConstants.spacing5,
                          mainAxisSpacing: isMobile ? AppConstants.spacing4 : AppConstants.spacing5,
                          mainAxisExtent: isMobile ? 320 : (isTablet ? 300 : 320),
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final hangout = provider.hangouts[index];
                            return HangoutCard(
                              hangout: hangout,
                              onTap: () => context.push('/hangout/${hangout.id}'),
                            )
                              .animate()
                              .fadeIn(
                                delay: (index * 50).ms,
                                duration: 400.ms,
                              )
                              .scale(
                                begin: const Offset(0.95, 0.95),
                                end: const Offset(1, 1),
                                curve: Curves.easeOutCubic,
                              );
                          },
                          childCount: provider.hangouts.length,
                        ),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
