import 'package:McDonalds/models/product_model.dart';
import 'package:McDonalds/providers/categories_provider.dart';
import 'package:McDonalds/providers/survey_provider.dart';
import 'package:McDonalds/screens/category_screen.dart';
import 'package:McDonalds/screens/menu_screen.dart';
import 'package:McDonalds/screens/product_detail_screen.dart';
import 'package:McDonalds/screens/search_screen.dart';
import 'package:McDonalds/services/image_cache_service.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:McDonalds/providers/products_provider.dart';
import 'package:McDonalds/screens/home_screen.dart';
import 'package:McDonalds/screens/game_screen.dart';
import 'package:McDonalds/screens/demo_screen.dart';
import 'package:McDonalds/utils/rocket_theme.dart';
import 'package:McDonalds/providers/cart_provider.dart';
import 'package:McDonalds/services/storage_service.dart';
import 'package:McDonalds/providers/onboarding_provider.dart';
import 'package:McDonalds/widgets/onboarding_overlay.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:McDonalds/models/survey_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Registrar el adapter
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(SurveyAdapter());
  }

  await StorageService.init();
  await ImageCacheService.init();

  runApp(const MyMcApp());
}

class MyMcApp extends StatelessWidget {
  const MyMcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductsProvider()),
        ChangeNotifierProvider(create: (_) => CategoriesProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => SurveyProvider()),
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'McDonald\'s App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: RocketColors.primary,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: RocketColors.background,
        appBarTheme: AppBarTheme(
          backgroundColor: RocketColors.secondary,
          titleTextStyle: RocketTextStyles.headline2.copyWith(
            color: Colors.white,
          ),
        ),
      ),
      home: Consumer<OnboardingProvider>(
        builder: (context, onboardingProvider, child) {
          return Stack(
            children: [
              const MainApp(),
              if (!onboardingProvider.isCompleted) const OnboardingOverlay(),
            ],
          );
        },
      ),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/search':
            return MaterialPageRoute(builder: (_) => const SearchScreen());
          case '/menu':
            return MaterialPageRoute(builder: (_) => const MenuScreen());
          case '/category':
            final categoryId = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => CategoryScreen(categoryId: categoryId),
            );
          case '/product_detail':
            final product = settings.arguments as Product;
            return MaterialPageRoute(
              builder: (_) => ProductDetailScreen(product: product),
            );
          default:
            return null;
        }
      },
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ValueNotifier<int> _currentIndexNotifier = ValueNotifier<int>(0);
  late List<Widget> _screens;
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SurveyProvider>(context, listen: false).init();
      // No es necesario llamar a init() ya que OnboardingProvider se inicializa en su constructor
    });
    _tabController = TabController(length: 6, vsync: this);
    _tabController.addListener(_handleTabChange);
    _screens = [
      const HomeScreen(),
      const Center(child: Text('Formulario IA')),
      GameScreen(
        tabController: _tabController,
        currentIndexNotifier: _currentIndexNotifier,
      ),
      const Center(child: Text('Pedidos')),
      const Center(child: Text('Mi Cuenta')),
      const DemoScreen(),
    ];
    _simulateInitialLoad();
  }

  void _handleTabChange() {
    if (_tabController.index != _currentIndexNotifier.value) {
      _currentIndexNotifier.value = _tabController.index;
      _isLoading.value = true;
      Future.delayed(const Duration(seconds: 1), () {
        _isLoading.value = false;
      });
    }
  }

  void _simulateInitialLoad() {
    Future.delayed(const Duration(milliseconds: 100), () {
      _isLoading.value = false;
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _currentIndexNotifier.dispose();
    _isLoading.dispose();
    super.dispose();
  }

  Widget _buildNavIcon(int currentIndex, int index, IconData icon) {
    return Icon(
      icon,
      size: 30,
      color: currentIndex == index ? Colors.white : RocketColors.offIcons,
    );
  }

  Widget _buildSkeletonizedContent(Widget screen) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isLoading,
      builder: (context, isLoading, child) {
        return Skeletonizer(
          enabled: isLoading,
          containersColor: Colors.grey[300],
          effect: ShimmerEffect(
            baseColor: Colors.grey[400]!,
            highlightColor: Colors.grey[200]!,
          ),
          child: screen,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Stack(
        children: [
          Scaffold(
            bottomNavigationBar: ValueListenableBuilder<int>(
              valueListenable: _currentIndexNotifier,
              builder: (context, currentIndex, child) {
                return CurvedNavigationBar(
                  key: const ValueKey('curved_navigation_bar'),
                  animationCurve: Curves.easeOutCirc,
                  animationDuration: const Duration(milliseconds: 500),
                  backgroundColor: Colors.transparent,
                  color: RocketColors.backgroundBar,
                  buttonBackgroundColor: RocketColors.secondary,
                  height: 70,
                  index: currentIndex,
                  items: <Widget>[
                    _buildNavIcon(currentIndex, 0, Icons.home),
                    _buildNavIcon(currentIndex, 1, Icons.auto_fix_high),
                    _buildNavIcon(currentIndex, 2, Icons.gamepad),
                    _buildNavIcon(currentIndex, 3, Icons.shopping_bag),
                    _buildNavIcon(currentIndex, 4, Icons.person),
                    _buildNavIcon(currentIndex, 5, Icons.settings),
                  ],
                  onTap: (index) {
                    _tabController.index = index;
                    _currentIndexNotifier.value = index;
                  },
                );
              },
            ),
            body: ValueListenableBuilder<int>(
              valueListenable: _currentIndexNotifier,
              builder: (context, currentIndex, _) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.easeIn,
                  switchOutCurve: Curves.easeOut,
                  transitionBuilder: (child, animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: IndexedStack(
                    key: ValueKey<int>(currentIndex),
                    index: currentIndex,
                    children:
                        _screens.map((screen) {
                          return KeyedSubtree(
                            key: ValueKey(screen.hashCode),
                            child: _buildSkeletonizedContent(screen),
                          );
                        }).toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
