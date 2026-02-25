import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/media_item_details_args.dart';

import '../../data/api/gallery_api.dart';
import '../../data/repositories/gallery_repository_impl.dart'; 
import '../../domain/repositories/gallery_repository.dart' as domain;
import '../bloc/gallery/gallery_bloc.dart';
import '../bloc/gallery/gallery_state.dart';
import '../theme/app_colors.dart';
import '../widgets/offline_widget.dart';
import '../widgets/gallery_item.dart';
import './details_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  late TabController _tabController;
  final domain.GalleryRepository _repository = GalleryRepositoryImpl(GalleryApi(Dio()));

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.activeTab,
          unselectedLabelColor: AppColors.inactiveTab,
          labelStyle: TextStyle(fontSize: 18, fontFamily: 'Roboto', fontWeight: FontWeight.w400),
          indicatorColor: AppColors.tabIndicator,
          indicatorWeight: 2.0,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: [Tab(text: 'New'), Tab(text: 'Popular')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _GalleryTab(repository: _repository, sort: 'new'),
          _GalleryTab(repository: _repository, sort: 'popular'),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 82,
      ),
    );
  }
}

class _GalleryTab extends StatefulWidget {
  final domain.GalleryRepository repository;
  final String sort;

  const _GalleryTab({required this.repository, required this.sort});

  @override
  __GalleryTabState createState() => __GalleryTabState();
}

class __GalleryTabState extends State<_GalleryTab> {
  late GalleryBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = GalleryBloc(
      repository: widget.repository,
      sort: widget.sort,
      onStateChanged: () {
        if (mounted) setState(() {});
      },
    );
    _bloc.loadFirstPage();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = _bloc.state;
    final authToken = state.authToken;

    if (state.status == GalleryStatus.error) {
      return FutureBuilder<List<ConnectivityResult>>(
        future: Connectivity().checkConnectivity(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.contains(ConnectivityResult.none)) {
            return OfflineWidget(onRetry: () => _bloc.loadFirstPage());
          }
          return Center(child: Text('Ошибка: ${state.errorMessage}'));
        },
      );
    }

    if (state.status == GalleryStatus.loading && state.items.isEmpty) {
      return Center(child: CircularProgressIndicator(color: AppColors.textSecondary));
    }

    return RefreshIndicator(
      onRefresh: () => _bloc.loadFirstPage(),
      color: AppColors.textSecondary,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1.0,
        ),
        padding: const EdgeInsets.all(16),
        itemCount: state.items.length + (state.hasReachedEnd ? 0 : 1),
        itemBuilder: (ctx, index) {
          if (index == state.items.length) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(color: AppColors.textSecondary),
              ),
            );
          }
          final item = state.items[index];
          return GestureDetector(
            onTap: () {
              final args = MediaItemDetailsArgs(
                item: item,
                authToken: authToken,
                repository: widget.repository, 
              );
              Navigator.pushNamed(context, DetailsPage.routeName, arguments: args);
            },
            child: GalleryItem(item: item, authToken: authToken),
          );
        },
        controller: _makeScrollController(),
      ),
    );
  }

  ScrollController _makeScrollController() {
    final controller = ScrollController();
    controller.addListener(() {
      if (controller.position.pixels >= controller.position.maxScrollExtent - 200) {
        _bloc.loadNextPage();
      }
    });
    return controller;
  }
}
