import '../../../../base/export_view.dart';

class ComingSoonPage extends StatefulWidget {
  const ComingSoonPage({super.key});

  @override
  State<ComingSoonPage> createState() => _ComingSoonPageState();
}

class _ComingSoonPageState extends State<ComingSoonPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: VColor.primary,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [VColor.primary, Color(0xCC00786F)],
            ),
          ),
        ),
        automaticallyImplyLeading: true,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0x26FFFFFF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const HugeIcon(
                icon: HugeIcons.strokeRoundedUser,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            VText(
              'Profil',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ],
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            mainAxisAlignment: .center,
            children: [
              // Animated Icon
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      VColor.primary.withValues(alpha: 0.1),
                      const Color(0xCC00786F).withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 0.8 + (_animationController.value * 0.2),
                      child: child,
                    );
                  },
                  child: const HugeIcon(
                    icon: HugeIcons.strokeRoundedShield02,
                    color: VColor.primary,
                    size: 80,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Main Text
              VText(
                'Fitur Profil',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                align: TextAlign.center,
              ),
              const SizedBox(height: 12),
              VText(
                'Sedang Dikembangkan',
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: VColor.primary,
                align: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Description
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: VText(
                  'Kami sedang mempersiapkan fitur profil yang luar biasa untuk Anda. Tunggu pembaruan berikutnya!',
                  fontSize: 16,
                  color: const Color(0xFF72678A),
                  align: TextAlign.center,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
