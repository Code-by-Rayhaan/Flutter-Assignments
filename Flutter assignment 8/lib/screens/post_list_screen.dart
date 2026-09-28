import 'package:flutter/material.dart';
import '../models/fetch_result.dart';
import '../models/post.dart';
import '../services/post_repository.dart';
import '../widgets/cache_status_badge.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';
import '../widgets/post_card.dart';

/// Main screen displaying the list of posts fetched using FutureBuilder,
/// with SharedPreferences caching indicators and controls.
class PostListScreen extends StatefulWidget {
  final PostRepository? repository;

  const PostListScreen({super.key, this.repository});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  late final PostRepository _repository;
  late Future<FetchResult> _postsFuture;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? PostRepository();
    // Initialize the future once in initState according to Flutter FutureBuilder best practices
    _postsFuture = _repository.fetchPosts();

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Triggers a live API fetch and updates the future
  Future<void> _fetchLive() async {
    setState(() {
      _postsFuture = _repository.fetchPosts();
    });
  }

  /// Forces reading solely from local SharedPreferences cache
  void _loadFromCache() {
    setState(() {
      _postsFuture = _repository.fetchPosts(cacheOnly: true);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Loading from SharedPreferences cache...'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  /// Simulates offline network state to demonstrate cache recovery
  void _simulateOffline() {
    setState(() {
      _postsFuture = _repository.fetchPosts(simulateOffline: true);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Simulating offline mode...'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  /// Clears the SharedPreferences cache
  Future<void> _clearCache() async {
    await _repository.clearCache();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('SharedPreferences cache cleared successfully.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'JSONPlaceholder Posts',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              'FutureBuilder + SharedPreferences',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh from API',
            onPressed: _fetchLive,
          ),
          PopupMenuButton<String>(
            tooltip: 'Options & Cache Controls',
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (value) {
              switch (value) {
                case 'live':
                  _fetchLive();
                  break;
                case 'cache':
                  _loadFromCache();
                  break;
                case 'offline':
                  _simulateOffline();
                  break;
                case 'clear':
                  _clearCache();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'live',
                child: Row(
                  children: [
                    Icon(Icons.cloud_download_outlined, size: 20),
                    SizedBox(width: 10),
                    Text('Fetch Live (API)'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'cache',
                child: Row(
                  children: [
                    Icon(Icons.storage_outlined, size: 20),
                    SizedBox(width: 10),
                    Text('Load Cache Only'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'offline',
                child: Row(
                  children: [
                    Icon(Icons.wifi_off_rounded, size: 20),
                    SizedBox(width: 10),
                    Text('Simulate Offline Fallback'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline_rounded,
                        color: Colors.red, size: 20),
                    SizedBox(width: 10),
                    Text(
                      'Clear Local Cache',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder<FetchResult>(
        future: _postsFuture,
        builder: (context, snapshot) {
          // 1. Loading State
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingView();
          }

          // 2. Error State
          if (snapshot.hasError) {
            return ErrorView(
              error: snapshot.error!,
              onRetry: _fetchLive,
              onLoadCache: _loadFromCache,
            );
          }

          // 3. Success State with Data
          if (snapshot.hasData) {
            final FetchResult result = snapshot.data!;
            final List<Post> allPosts = result.posts;

            // Apply search filter
            final List<Post> filteredPosts = _searchQuery.isEmpty
                ? allPosts
                : allPosts.where((post) {
                    final titleMatch =
                        post.title.toLowerCase().contains(_searchQuery);
                    final bodyMatch =
                        post.body.toLowerCase().contains(_searchQuery);
                    final idMatch = post.id.toString() == _searchQuery;
                    return titleMatch || bodyMatch || idMatch;
                  }).toList();

            return RefreshIndicator(
              onRefresh: _fetchLive,
              child: CustomScrollView(
                slivers: [
                  // Status Banner
                  SliverToBoxAdapter(
                    child: CacheStatusBadge(
                      result: result,
                      totalCount: allPosts.length,
                      displayedCount: filteredPosts.length,
                      onRefresh: _fetchLive,
                    ),
                  ),

                  // Search Bar
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 6.0,
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search posts by title, body, or ID...',
                          prefixIcon: const Icon(Icons.search_rounded),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear_rounded),
                                  onPressed: () => _searchController.clear(),
                                )
                              : null,
                          filled: true,
                          fillColor: theme.colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.35),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 16.0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Empty State when filter yields 0 matches
                  if (filteredPosts.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 48,
                              color: theme.disabledColor,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No posts match "$_searchQuery"',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.disabledColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    // Post List Items
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final post = filteredPosts[index];
                          return PostCard(post: post);
                        },
                        childCount: filteredPosts.length,
                      ),
                    ),

                  const SliverToBoxAdapter(
                    child: SizedBox(height: 24),
                  ),
                ],
              ),
            );
          }

          // Fallback if neither loading, error, nor data
          return const Center(child: Text('No data found.'));
        },
      ),
    );
  }
}
