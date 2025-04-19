import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:McDonalds/providers/user_provider.dart';
import 'package:McDonalds/utils/rocket_theme.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).loadUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RocketColors.background,
      body: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          final isLoading = userProvider.isLoading;
          final user = userProvider.currentUser;

          return Skeletonizer(
            enabled: isLoading,
            containersColor: Colors.grey[300],
            effect: ShimmerEffect(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
            ),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  expandedHeight: 200,
                  pinned: true,
                  stretch: true,
                  backgroundColor: const Color(0xFFDA291C),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFDA291C), Color(0xFFFF1C1C)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    title: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white24,
                          child:
                              user?.photoUrl != null
                                  ? ClipOval(
                                    child: Image.network(
                                      user!.photoUrl!,
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                  : const Icon(
                                    Icons.person,
                                    size: 24,
                                    color: Colors.white,
                                  ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.name ?? 'Usuario',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (user?.email != null)
                              Text(
                                user!.email!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildRewardsCard(),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildQuickActions(),
                            const SizedBox(height: 24),
                            const Text(
                              'Configuración',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF333333),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildSettingTile(
                              icon: Icons.notifications,
                              title: 'Notificaciones',
                              trailing: Switch(
                                value: user?.hasNotificationsEnabled ?? false,
                                onChanged:
                                    (value) =>
                                        userProvider.toggleNotifications(value),
                                activeColor: RocketColors.primary,
                              ),
                            ),
                            _buildSettingTile(
                              icon: Icons.lock,
                              title: 'Privacidad',
                              subtitle: 'Controla tus datos personales',
                              onTap:
                                  () =>
                                      Navigator.pushNamed(context, '/privacy'),
                            ),
                            _buildSettingTile(
                              icon: Icons.help,
                              title: 'Ayuda',
                              subtitle: 'Preguntas frecuentes y soporte',
                              onTap:
                                  () => Navigator.pushNamed(context, '/help'),
                            ),
                            _buildSettingTile(
                              icon: Icons.info,
                              title: 'Acerca de',
                              subtitle: 'Información de McDonald\'s',
                              onTap:
                                  () => Navigator.pushNamed(context, '/about'),
                            ),
                          ],
                        ),
                      ),
                      if (user != null) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Información Personal',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF333333),
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildInfoCard(user),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRewardsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.amber[700]!, Colors.amber[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.amber[200]!.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'MyMcDonald\'s Rewards',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.star, size: 16, color: Colors.white),
                    SizedBox(width: 4),
                    Text(
                      '2,500 pts',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: 0.7,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            '500 pts más para tu próxima recompensa',
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final List<Map<String, dynamic>> actions = [
      {
        'icon': Icons.receipt_long,
        'label': 'Pedidos',
        'color': const Color(0xFF2196F3), // Color azul fijo
      },
      {
        'icon': Icons.favorite,
        'label': 'Favoritos',
        'color': const Color(0xFFE57373), // Color rojo claro fijo
      },
      {
        'icon': Icons.location_on,
        'label': 'Direcciones',
        'color': const Color(0xFF66BB6A), // Color verde fijo
      },
      {
        'icon': Icons.payment,
        'label': 'Pagos',
        'color': const Color(0xFF9575CD), // Color morado fijo
      },
    ];

    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: actions.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final action = actions[index];
          final Color color = action['color'] as Color;

          return Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(action['icon'] as IconData, color: color, size: 28),
              ),
              const SizedBox(height: 8),
              Text(
                action['label'] as String,
                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: RocketColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: RocketColors.primary),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF333333),
        ),
      ),
      subtitle:
          subtitle != null
              ? Text(
                subtitle,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              )
              : null,
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildInfoCard(user) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          if (user.phoneNumber != null)
            _buildInfoRow(Icons.phone, 'Teléfono', user.phoneNumber!),
          if (user.address != null) ...[
            const SizedBox(height: 16),
            _buildInfoRow(
              Icons.location_on,
              'Dirección de Entrega',
              user.address!,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: RocketColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: RocketColors.primary, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(fontSize: 16, color: Color(0xFF333333)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
