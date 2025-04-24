import 'package:McDonalds/models/product_model.dart';
import 'package:McDonalds/providers/categories_provider.dart';
import 'package:McDonalds/providers/survey_provider.dart';
import 'package:McDonalds/providers/user_provider.dart';
import 'package:McDonalds/screens/category_screen.dart';
import 'package:McDonalds/screens/coupons_screen.dart';
import 'package:McDonalds/screens/menu_screen.dart';
import 'package:McDonalds/screens/orders_history_screen.dart';
import 'package:McDonalds/screens/product_detail_screen.dart';
import 'package:McDonalds/screens/profile_screen.dart';
import 'package:McDonalds/screens/search_screen.dart';
import 'package:McDonalds/screens/happy_meals_screen.dart';
import 'package:McDonalds/services/image_cache_service.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:McDonalds/providers/products_provider.dart';
import 'package:McDonalds/screens/home_screen.dart';
import 'package:McDonalds/screens/game_screen.dart';
import 'package:McDonalds/utils/rocket_theme.dart';
import 'package:McDonalds/providers/cart_provider.dart';
import 'package:McDonalds/services/storage_service.dart';
import 'package:McDonalds/providers/onboarding_provider.dart';
import 'package:McDonalds/widgets/onboarding_overlay.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:McDonalds/models/survey_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:McDonalds/services/notification_service.dart';
import 'package:McDonalds/services/navigation_service.dart';
import 'package:McDonalds/screens/about_screen.dart';
import 'package:McDonalds/screens/help_screen.dart';
import 'package:McDonalds/screens/privacy_screen.dart';
import 'package:McDonalds/screens/cart_screen.dart';
import 'package:McDonalds/models/cart_item_model.dart'; // Agregar esta importación
import 'package:timezone/data/latest.dart' as tz;
import 'package:McDonalds/screens/login_screen.dart';

Future<void> main() async {
  // Asegurar que Flutter esté inicializado primero
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Inicializar Firebase antes que otros servicios
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Inicializar timezone
    tz.initializeTimeZones();

    // Inicializar Hive para almacenamiento local
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(SurveyAdapter());
    }

    // Inicializar servicios en orden
    await StorageService.init();
    await ImageCacheService.init();
    await NotificationService.init();
  } catch (e) {
    debugPrint('Error durante la inicialización: $e');
  }

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
        ChangeNotifierProxyProvider<ProductsProvider, CartProvider>(
          create:
              (context) => CartProvider(
                Provider.of<ProductsProvider>(context, listen: false),
                context,
              ),
          update:
              (context, productsProvider, previous) =>
                  previous ?? CartProvider(productsProvider, context),
        ),
        ChangeNotifierProvider(create: (_) => SurveyProvider()),
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        navigatorKey: NavigationService.navigatorKey,
        title: 'McDonalds',
        debugShowCheckedModeBanner: false,
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
        initialRoute: '/',
        routes: {
          '/':
              (context) => Consumer2<UserProvider, OnboardingProvider>(
                builder: (context, userProvider, onboardingProvider, child) {
                  // Esperamos a que ambos providers estén inicializados
                  if (!userProvider.isInitialized ||
                      !onboardingProvider.isInitialized) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Si no hay onboarding completado, mostrar onboarding
                  if (!onboardingProvider.isCompleted) {
                    return const OnboardingOverlay();
                  }

                  // Si no hay token guardado, mostrar login
                  if (!userProvider.isAuthenticated) {
                    return const LoginScreen();
                  }

                  // Si tenemos onboarding y token, programar el envío al servidor
                  if (onboardingProvider.form != null &&
                      userProvider.token != null) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      onboardingProvider.completeOnboarding(context);
                    });
                  }

                  // Mostrar la app principal
                  return const MainApp();
                },
              ),
          '/login': (context) => const LoginScreen(),
          '/search': (context) => const SearchScreen(),
          '/menu': (context) => const MenuScreen(),
          '/happy_meals': (context) => const HappyMealsScreen(),
          '/category': (context) {
            final args = ModalRoute.of(context)?.settings.arguments;
            if (args is! String) return const SizedBox.shrink();
            return CategoryScreen(categoryId: args);
          },
          '/privacy': (context) => const PrivacyScreen(),
          '/help': (context) => const HelpScreen(),
          '/about': (context) => const AboutScreen(),
          '/cart': (context) => const CartScreen(),
          '/orders': (context) => const OrdersHistoryScreen(),
        },
        onGenerateRoute: (RouteSettings settings) {
          if (settings.name == '/product_detail') {
            if (settings.arguments is Map) {
              final args = settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (context) {
                  final mainAppState =
                      context.findAncestorStateOfType<MainAppState>();
                  return ProductDetailScreen(
                    product: args['product'] as Product,
                    cartItem: args['cartItem'] as CartItem?,
                    tabController: mainAppState?.tabController,
                    currentIndexNotifier: mainAppState?.currentIndexNotifier,
                  );
                },
              );
            }

            if (settings.arguments is Product) {
              return MaterialPageRoute(
                builder: (context) {
                  final mainAppState =
                      context.findAncestorStateOfType<MainAppState>();
                  return ProductDetailScreen(
                    product: settings.arguments as Product,
                    tabController: mainAppState?.tabController,
                    currentIndexNotifier: mainAppState?.currentIndexNotifier,
                  );
                },
              );
            }
          }
          return null;
        },
      ),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});
  @override
  State<MainApp> createState() => MainAppState();
}

class MainAppState extends State<MainApp> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ValueNotifier<int> _currentIndexNotifier = ValueNotifier<int>(0);
  late List<Widget> _screens;
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(true);

  TabController get tabController => _tabController;
  ValueNotifier<int> get currentIndexNotifier => _currentIndexNotifier;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SurveyProvider>(context, listen: false).init();
      // No es necesario llamar a init() ya que OnboardingProvider se inicializa en su constructor
    });
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabChange);
    _screens = [
      const HomeScreen(),
      GameScreen(
        tabController: _tabController,
        currentIndexNotifier: _currentIndexNotifier,
      ),
      const ProfileScreen(),
      const CouponsScreen(),
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
      length: 4,
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
                    _buildNavIcon(currentIndex, 2, Icons.gamepad),
                    _buildNavIcon(currentIndex, 3, Icons.person),
                    _buildNavIcon(currentIndex, 4, Icons.card_giftcard),
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
