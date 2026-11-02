import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'api.dart';

const forest = Color(0xFF0B3B2B);
const deepForest = Color(0xFF002B23);
const gold = Color(0xFFC9922E);
const cream = Color(0xFFFFFCF6);
const logoAsset = 'assets/images/logo.png';
const logoWhiteAsset = 'assets/images/logo_white.png';
const hero = 'assets/images/hero.png';
const club = 'assets/images/club.png';
const trophy = 'assets/images/trophy.png';

void main() => runApp(const FipApp());
void push(BuildContext c, Widget page) =>
    Navigator.push(c, MaterialPageRoute(builder: (_) => page));
void note(BuildContext c, String message) =>
    ScaffoldMessenger.of(c).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );

class FipApp extends StatelessWidget {
  const FipApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'FIP Zone E',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: cream,
      colorScheme: ColorScheme.fromSeed(
        seedColor: forest,
        primary: forest,
        secondary: gold,
        surface: cream,
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.playfairDisplay(
          fontWeight: FontWeight.w700,
          color: forest,
        ),
        displayMedium: GoogleFonts.playfairDisplay(
          fontWeight: FontWeight.w700,
          color: forest,
        ),
        displaySmall: GoogleFonts.playfairDisplay(
          fontWeight: FontWeight.w700,
          color: forest,
        ),
        headlineLarge: GoogleFonts.playfairDisplay(
          fontWeight: FontWeight.w700,
          color: forest,
        ),
        headlineMedium: GoogleFonts.playfairDisplay(
          fontWeight: FontWeight.w700,
          color: forest,
        ),
        headlineSmall: GoogleFonts.playfairDisplay(
          fontWeight: FontWeight.w700,
          fontSize: 25,
          color: forest,
        ),
        titleLarge: GoogleFonts.playfairDisplay(
          fontWeight: FontWeight.w700,
          fontSize: 19,
          color: forest,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 13,
          height: 1.45,
          color: const Color(0xFF52615A),
        ),
      ),
    ),
    home: const Splash(),
  );
}

class Splash extends StatefulWidget {
  const Splash({super.key});
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController ctrl;
  @override
  void initState() {
    super.initState();
    ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..forward();
    Timer(const Duration(milliseconds: 2000), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (_, __, ___) => const Onboarding(),
            transitionsBuilder:
                (_, a, __, child) => FadeTransition(opacity: a, child: child),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: deepForest,
    body: Stack(
      children: [
        Positioned.fill(
          child: AnimatedBuilder(
            animation: ctrl,
            builder: (_, child) {
              final s = 1.0 + ctrl.value * 0.08;
              return Transform.scale(scale: s, child: child);
            },
            child: Opacity(
              opacity: .18,
              child: Image.asset(
                hero,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: deepForest),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.0,
                colors: [
                  forest.withValues(alpha: .0),
                  deepForest.withValues(alpha: .7),
                ],
              ),
            ),
          ),
        ),
        Center(
          child: AnimatedBuilder(
            animation: ctrl,
            builder: (_, child) {
              final v = Curves.easeOutCubic.transform(ctrl.value);
              return Opacity(
                opacity: v,
                child: Transform.translate(
                  offset: Offset(0, (1 - v) * 20),
                  child: child,
                ),
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Brand(light: true, large: true),
                SizedBox(height: 28),
                Text(
                  'Polo unites nations,\nbuilds communities.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    height: 1.55,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 26),
                SizedBox(
                  width: 60,
                  child: LinearProgressIndicator(
                    minHeight: 3,
                    color: gold,
                    backgroundColor: Colors.white24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

// Reusable fade-in-up entrance for page content
class FadeIn extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  const FadeIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 450),
  });
  @override
  State<FadeIn> createState() => _FadeInState();
}

class _FadeInState extends State<FadeIn> with SingleTickerProviderStateMixin {
  late AnimationController c;
  @override
  void initState() {
    super.initState();
    c = AnimationController(vsync: this, duration: widget.duration);
    Future.delayed(widget.delay, () {
      if (mounted) c.forward();
    });
  }

  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: c,
    builder: (_, child) {
      final v = Curves.easeOutCubic.transform(c.value);
      return Opacity(
        opacity: v,
        child: Transform.translate(
          offset: Offset(0, (1 - v) * 14),
          child: child,
        ),
      );
    },
    child: widget.child,
  );
}

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final PageController _controller = PageController();
  int _page = 0;
  final _slides = const [
    (
      hero,
      'Global Polo\nCommunity',
      'Connecting nations, clubs and players across Zone E.',
      Icons.public_outlined,
    ),
    (
      trophy,
      'Tournaments\n& Events',
      'Stay up to date with upcoming tournaments, results and rankings.',
      Icons.emoji_events_outlined,
    ),
    (
      club,
      'People, Clubs\n& Development',
      'Explore players, clubs, ponies, officials and development programmes.',
      Icons.groups_2_outlined,
    ),
  ];

  void _next() {
    if (_page == _slides.length - 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Home()),
      );
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: deepForest,
    body: SafeArea(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed:
                  () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const Home()),
                  ),
              child: const Text(
                'Skip',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: _slides.length,
              onPageChanged: (value) => setState(() => _page = value),
              itemBuilder: (_, index) {
                final slide = _slides[index];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(24, 6, 24, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(slide.$1, fit: BoxFit.cover),
                              const DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Color(0xB8002B23),
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Container(
                                    padding: const EdgeInsets.all(11),
                                    decoration: BoxDecoration(
                                      color: gold,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      slide.$4,
                                      color: forest,
                                      size: 28,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        slide.$2,
                        style: GoogleFonts.playfairDisplay(
                          color: Colors.white,
                          fontSize: 30,
                          height: 1.08,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        slide.$3,
                        style: const TextStyle(
                          color: Color(0xFFD7E4DB),
                          fontSize: 15,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 5, 24, 28),
            child: Row(
              children: [
                Row(
                  children: List.generate(
                    _slides.length,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      margin: const EdgeInsets.only(right: 6),
                      height: 7,
                      width: i == _page ? 25 : 7,
                      decoration: BoxDecoration(
                        color: i == _page ? gold : Colors.white38,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  height: 48,
                  child: FilledButton(
                    onPressed: _next,
                    style: FilledButton.styleFrom(
                      backgroundColor: gold,
                      foregroundColor: forest,
                      padding: const EdgeInsets.symmetric(horizontal: 23),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _page == _slides.length - 1
                          ? 'Get started  →'
                          : 'Next  →',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

/// Shows a remote image from a possibly-relative API `path`, falling back to
/// [fallback] (or a plain forest tile) if the path is null/empty or the load
/// fails.
class RemoteImage extends StatelessWidget {
  final String? path;
  final BoxFit fit;
  final Widget? fallback;
  const RemoteImage({
    super.key,
    required this.path,
    this.fit = BoxFit.cover,
    this.fallback,
  });
  @override
  Widget build(BuildContext context) {
    final url = assetUrl(path);
    if (url == null) {
      return fallback ?? Container(color: forest.withValues(alpha: .08));
    }
    return Image.network(
      url,
      fit: fit,
      errorBuilder: (_, __, ___) =>
          fallback ?? Container(color: forest.withValues(alpha: .08)),
      loadingBuilder: (c, child, p) => p == null
          ? child
          : Container(
              color: const Color(0xFFF2F5F2),
              child: const Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
    );
  }
}

/// Circular player avatar: shows photo if available, otherwise first-initial
/// on a gold circle.
class PlayerAvatar extends StatelessWidget {
  final String? photoPath;
  final String name;
  final double size;
  const PlayerAvatar({
    super.key,
    required this.photoPath,
    required this.name,
    this.size = 48,
  });
  @override
  Widget build(BuildContext context) {
    final url = assetUrl(photoPath);
    final initial = name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : '?';
    final placeholder = Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(color: gold, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: size * 0.42,
        ),
      ),
    );
    if (url == null) return placeholder;
    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => placeholder,
        ),
      ),
    );
  }
}

/// Square club/federation badge: logo if available, otherwise a cream tile
/// stamped with the country-flag emoji.
class OrgBadge extends StatelessWidget {
  final String? logoPath;
  final String? countryIso;
  final double size;
  final double radius;
  const OrgBadge({
    super.key,
    required this.logoPath,
    required this.countryIso,
    this.size = 48,
    this.radius = 10,
  });
  @override
  Widget build(BuildContext context) {
    final url = assetUrl(logoPath);
    final placeholder = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4DC),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: const Color(0xFFE9D7A3)),
      ),
      alignment: Alignment.center,
      child: Text(
        flagEmoji(countryIso),
        style: TextStyle(fontSize: size * 0.55),
      ),
    );
    if (url == null) return placeholder;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: size,
        height: size,
        child: Image.network(
          url,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => placeholder,
        ),
      ),
    );
  }
}

class Brand extends StatelessWidget {
  final bool light, large;
  const Brand({super.key, this.light = false, this.large = false});
  @override
  Widget build(BuildContext context) {
    final height = large ? 80.0 : 40.0;
    return Image.asset(
      light ? logoWhiteAsset : logoAsset,
      height: height,
      fit: BoxFit.contain,
    );
  }
}

class Shell extends StatelessWidget {
  final String title;
  final Widget body;
  final int tab;
  final bool back;
  const Shell({
    super.key,
    required this.title,
    required this.body,
    this.tab = 0,
    this.back = true,
  });
  @override
  Widget build(BuildContext context) => Scaffold(
    drawer: const AppDrawer(),
    appBar: AppBar(
      backgroundColor: cream,
      surfaceTintColor: cream,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading:
          back
              ? IconButton(
                onPressed: () => Navigator.maybePop(context),
                icon: const Icon(Icons.arrow_back_ios_new, size: 19),
              )
              : null,
      title:
          back
              ? Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              )
              : const Brand(),
      actions: [
        IconButton(
          onPressed: () => push(context, const SearchPage()),
          icon: const Icon(Icons.search),
        ),
        Builder(
          builder:
              (drawerContext) => IconButton(
                onPressed: () => Scaffold.of(drawerContext).openDrawer(),
                icon: const Icon(Icons.menu_rounded),
              ),
        ),
      ],
    ),
    body: body,
    bottomNavigationBar: BottomBar(selected: tab),
  );
}

class BottomBar extends StatelessWidget {
  final int selected;
  const BottomBar({super.key, required this.selected});
  @override
  Widget build(BuildContext context) {
    final labels = ['Home', 'Explore', 'Tickets', 'Gallery', 'Profile'];
    final icons = [
      Icons.home_outlined,
      Icons.explore_outlined,
      Icons.confirmation_number_outlined,
      Icons.photo_library_outlined,
      Icons.person_outline,
    ];
    final pages = [
      const Home(),
      const ZonePage(),
      const TicketPage(),
      const GalleryPage(),
      const DashboardPage(),
    ];
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFDFE5DF))),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: List.generate(
            5,
            (i) => Expanded(
              child: InkWell(
                onTap:
                    () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => pages[i]),
                      (_) => false,
                    ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icons[i],
                        size: 20,
                        color: i == selected ? gold : forest,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        labels[i],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: i == selected ? gold : forest,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) => Drawer(
    width: 306,
    backgroundColor: deepForest,
    child: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 18, 16, 15),
            child: Row(
              children: [
                const Brand(light: true),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            height: 104,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              image: const DecorationImage(
                image: AssetImage(club),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: forest.withValues(alpha: .73),
              ),
              padding: const EdgeInsets.all(14),
              alignment: Alignment.bottomLeft,
              child: const Text(
                'The home of polo\nin Zone E',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  height: 1.1,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                drawerItem(context, Icons.home_outlined, 'Home', const Home()),
                drawerItem(
                  context,
                  Icons.public_outlined,
                  'Zone E',
                  const ZonePage(),
                ),
                drawerItem(
                  context,
                  Icons.account_balance_outlined,
                  'Federations',
                  const FederationsPage(),
                ),
                drawerItem(
                  context,
                  Icons.groups_2_outlined,
                  'Polo Network',
                  const NetworkPage(),
                ),
                drawerItem(
                  context,
                  Icons.emoji_events_outlined,
                  'Tournaments',
                  const TournamentsPage(),
                ),
                drawerItem(
                  context,
                  Icons.live_tv_outlined,
                  'Live & results',
                  const LiveResultsPage(),
                ),
                drawerItem(
                  context,
                  Icons.newspaper_outlined,
                  'News & stories',
                  const NewsPage(),
                ),
                drawerItem(
                  context,
                  Icons.bar_chart_outlined,
                  'Rankings',
                  const RankingsPage(),
                ),
                drawerItem(
                  context,
                  Icons.handshake_outlined,
                  'Partnerships',
                  const PartnershipsPage(),
                ),
                drawerItem(
                  context,
                  Icons.photo_library_outlined,
                  'Gallery',
                  const GalleryPage(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 46,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  push(context, const LoginPage());
                },
                style: FilledButton.styleFrom(
                  backgroundColor: gold,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.person_outline),
                label: const Text('Member login'),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget drawerItem(
  BuildContext context,
  IconData icon,
  String label,
  Widget page,
) => ListTile(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  leading: Icon(icon, color: Colors.white, size: 21),
  title: Text(
    label,
    style: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w600,
      fontSize: 14,
    ),
  ),
  trailing: const Icon(Icons.chevron_right, color: Color(0xFFBFD3C7)),
  onTap: () {
    Navigator.pop(context);
    push(context, page);
  },
);

void showMenuSheet(BuildContext context) => showModalBottomSheet(
  context: context,
  showDragHandle: true,
  backgroundColor: cream,
  builder:
      (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Brand(),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                menuChip(context, 'Zone E', Icons.public, const ZonePage()),
                menuChip(
                  context,
                  'Federations',
                  Icons.account_balance_outlined,
                  const FederationsPage(),
                ),
                menuChip(
                  context,
                  'Polo Network',
                  Icons.groups_2_outlined,
                  const NetworkPage(),
                ),
                menuChip(
                  context,
                  'Tournaments',
                  Icons.emoji_events_outlined,
                  const TournamentsPage(),
                ),
                menuChip(
                  context,
                  'Partnerships',
                  Icons.handshake_outlined,
                  const PartnershipsPage(),
                ),
                menuChip(
                  context,
                  'Member login',
                  Icons.person_outline,
                  const LoginPage(),
                ),
              ],
            ),
          ],
        ),
      ),
);
Widget menuChip(BuildContext c, String text, IconData icon, Widget page) =>
    ActionChip(
      avatar: Icon(icon, size: 18, color: forest),
      label: Text(text),
      onPressed: () {
        Navigator.pop(c);
        push(c, page);
      },
    );

class Home extends StatelessWidget {
  const Home({super.key});
  @override
  Widget build(BuildContext context) => Shell(
    back: false,
    title: '',
    body: ListView(
      padding: const EdgeInsets.fromLTRB(16, 5, 16, 24),
      children: [
        FadeIn(
          delay: const Duration(milliseconds: 80),
          child: HeroBanner(
            image: hero,
            eyebrow: 'POLO · PEOPLE · PARTNERSHIPS',
            title: 'Advancing Polo\nAcross Zone E',
            subtitle:
                'Uniting nations, clubs and communities to grow the sport.',
            action: 'Explore Zone E',
            onPressed: () => push(context, const ZonePage()),
          ),
        ),
        const SizedBox(height: 20),
        const FadeIn(delay: Duration(milliseconds: 180), child: _LiveStrip()),
        const SizedBox(height: 16),
        FadeIn(
          delay: const Duration(milliseconds: 240),
          child: const Heading('Discover FIP Zone E'),
        ),
        FadeIn(
          delay: const Duration(milliseconds: 280),
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 1.65,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: [
              QuickCard(
                Icons.account_balance_outlined,
                'Federations',
                'Member countries',
                () => push(context, const FederationsPage()),
              ),
              QuickCard(
                Icons.emoji_events_outlined,
                'Tournaments',
                'Events & fixtures',
                () => push(context, const TournamentsPage()),
              ),
              QuickCard(
                Icons.groups_2_outlined,
                'Polo network',
                'Players & clubs',
                () => push(context, const NetworkPage()),
              ),
              QuickCard(
                Icons.handshake_outlined,
                'Partnerships',
                'Grow together',
                () => push(context, const PartnershipsPage()),
              ),
            ],
          ),
        ),
        const SizedBox(height: 19),
        FadeIn(
          delay: const Duration(milliseconds: 340),
          child: Heading(
            'Upcoming tournaments',
            action: 'View all',
            onAction: () => push(context, const TournamentsPage()),
          ),
        ),
        FadeIn(
          delay: const Duration(milliseconds: 380),
          child: EventCard(onTap: () => push(context, const EventDetailPage())),
        ),
      ],
    ),
  );
}

// A home-screen banner that teases the live match and routes to Live & Results
class _LiveStrip extends StatelessWidget {
  const _LiveStrip();
  @override
  Widget build(BuildContext context) => InkWell(
    borderRadius: BorderRadius.circular(14),
    onTap: () => push(context, const LiveResultsPage()),
    child: Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [deepForest, forest],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: forest.withValues(alpha: .25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          const _PulseDot(),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LIVE · CAIRO OPEN',
                  style: TextStyle(
                    color: Color(0xFFFFD477),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: .6,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Cairo Royals 6 – 4 Dubai Falcons',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Chukka 4 · 05:12 remaining',
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: gold,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.play_arrow_rounded, color: Colors.white, size: 15),
                SizedBox(width: 2),
                Text(
                  'Watch',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class HeroBanner extends StatelessWidget {
  final String image, eyebrow, title, subtitle, action;
  final VoidCallback onPressed;
  const HeroBanner({
    super.key,
    required this.image,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.action,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(18),
    child: SizedBox(
      height: 284,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            image,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: forest),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0xE8003E32)],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(19),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eyebrow,
                  style: const TextStyle(
                    color: Color(0xFFFFD477),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: .4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    height: 1.05,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 40,
                  child: FilledButton(
                    onPressed: onPressed,
                    style: FilledButton.styleFrom(
                      backgroundColor: gold,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(action + '  →'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class Heading extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;
  const Heading(this.title, {super.key, this.action, this.onAction});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
        if (action != null)
          TextButton(onPressed: onAction, child: Text(action!)),
      ],
    ),
  );
}

class QuickCard extends StatelessWidget {
  final IconData icon;
  final String title, sub;
  final VoidCallback tap;
  const QuickCard(this.icon, this.title, this.sub, this.tap, {super.key});
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: tap,
    borderRadius: BorderRadius.circular(13),
    child: Ink(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFFE7E9E4)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF6E5),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, color: gold, size: 18),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  sub,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF627068),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class EventCard extends StatelessWidget {
  final VoidCallback onTap;
  const EventCard({super.key, required this.onTap});
  @override
  Widget build(BuildContext context) => Card(
    elevation: 0,
    color: Colors.white,
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 58,
            height: 80,
            color: gold,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '18',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'OCT',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dubai Open Polo Championship',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Dubai Polo Club, UAE',
                    style: TextStyle(fontSize: 11, color: Color(0xFF637067)),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF5ED),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: const Text(
                      'UPCOMING',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: forest,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 9),
            child: Icon(Icons.chevron_right),
          ),
        ],
      ),
    ),
  );
}

class ZonePage extends StatelessWidget {
  const ZonePage({super.key});
  @override
  Widget build(BuildContext context) => Shell(
    title: 'Zone E',
    tab: 1,
    body: ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        const PhotoHeader(
          image: club,
          title: 'Zone E',
          subtitle: 'Africa · Middle East · Asia',
        ),
        const SizedBox(height: 18),
        const Text(
          'About Zone E',
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 7),
        const Text(
          'FIP Zone E represents the polo community across Africa, the Middle East and Asia, working to develop the sport, support member nations and promote international collaboration.',
          style: TextStyle(
            fontSize: 13,
            color: Color(0xFF52615A),
            height: 1.45,
          ),
        ),
        const SizedBox(height: 17),
        GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1.65,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            StatCard('15+', 'Member nations', Icons.public),
            StatCard('120+', 'Polo clubs', Icons.home_work_outlined),
            StatCard('500+', 'Players & officials', Icons.groups_outlined),
            StatCard('8+', 'Annual tournaments', Icons.emoji_events_outlined),
          ],
        ),
        const SizedBox(height: 18),
        LinkTile(
          Icons.account_balance_outlined,
          'Federations directory',
          'Meet our national associations',
          () => push(context, const FederationsPage()),
        ),
        LinkTile(
          Icons.handshake_outlined,
          'Build with us',
          'Explore regional partnerships',
          () => push(context, const PartnershipsPage()),
        ),
      ],
    ),
  );
}

class PhotoHeader extends StatelessWidget {
  final String image, title, subtitle;
  const PhotoHeader({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
  });
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: SizedBox(
      height: 155,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            image,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: forest),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0xDD002B23)],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class StatCard extends StatelessWidget {
  final String number, label;
  final IconData icon;
  const StatCard(this.number, this.label, this.icon, {super.key});
  @override
  Widget build(BuildContext context) => Card(
    color: Colors.white,
    elevation: 0,
    margin: const EdgeInsets.all(5),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: const BorderSide(color: Color(0xFFE6E9E5)),
    ),
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Icon(icon, color: gold, size: 21),
          const SizedBox(width: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                number,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 17,
                ),
              ),
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: Color(0xFF52615A)),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class LinkTile extends StatelessWidget {
  final IconData icon;
  final String title, detail;
  final VoidCallback onTap;
  const LinkTile(this.icon, this.title, this.detail, this.onTap, {super.key});
  @override
  Widget build(BuildContext context) => Card(
    elevation: 0,
    color: Colors.white,
    child: ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: const Color(0xFFFFF4DC),
        child: Icon(icon, color: gold),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      ),
      subtitle: Text(detail, style: const TextStyle(fontSize: 11)),
      trailing: const Icon(Icons.chevron_right),
    ),
  );
}

class FederationsPage extends StatefulWidget {
  const FederationsPage({super.key});
  @override
  State<FederationsPage> createState() => _FederationsPageState();
}

class _FederationsPageState extends State<FederationsPage> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    return Shell(
      title: 'Federations',
      body: ApiBuilder<List<Map<String, dynamic>>>(
        load: fetchFederations,
        onData: (c, rows) => _buildBody(c, rows),
      ),
    );
  }

  Widget _buildBody(BuildContext context, List<Map<String, dynamic>> rows) {
    final results =
        rows.where((f) {
          final name =
              ((f['legal_name'] ?? f['short_name'] ?? '') as String)
                  .toLowerCase();
          final country =
              ((f['country_name'] ?? f['country_iso'] ?? '') as String)
                  .toLowerCase();
          final q = query.toLowerCase();
          return q.isEmpty || name.contains(q) || country.contains(q);
        }).toList();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
          child: TextField(
            onChanged: (value) => setState(() => query = value),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search countries...',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children:
                ['All', 'Africa', 'Middle East', 'Asia']
                    .map(
                      (x) => Padding(
                        padding: const EdgeInsets.only(right: 7),
                        child: FilterChip(
                          label: Text(x, style: const TextStyle(fontSize: 11)),
                          selected: x == 'All',
                          onSelected: (_) {},
                        ),
                      ),
                    )
                    .toList(),
          ),
        ),
        if (results.isEmpty)
          const Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No federations found.',
                  style: TextStyle(fontSize: 13, color: Color(0xFF637067)),
                ),
              ),
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: results.length,
              itemBuilder: (_, i) {
                final r = results[i];
                final iso = r['country_iso'] as String?;
                final flag = flagEmoji(iso);
                final country =
                    (r['country_name'] ?? r['country_iso'] ?? 'Country')
                        as String;
                final name =
                    (r['legal_name'] ?? r['short_name'] ?? 'Federation')
                        as String;
                return Card(
                  elevation: 0,
                  color: Colors.white,
                  child: ListTile(
                    onTap:
                        () => push(
                          context,
                          CountryPage(flag: flag, country: country),
                        ),
                    leading: OrgBadge(
                      logoPath: r['logo_path'] as String?,
                      countryIso: iso,
                      size: 44,
                    ),
                    title: Text(
                      country,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(name, style: const TextStyle(fontSize: 11)),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

class CountryPage extends StatelessWidget {
  final String flag, country;
  const CountryPage({super.key, required this.flag, required this.country});
  @override
  Widget build(BuildContext context) => Shell(
    title: country,
    body: ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        PhotoHeader(
          image: hero,
          title: flag + '  ' + country,
          subtitle: 'National Polo Association',
        ),
        const SizedBox(height: 18),
        const Text(
          'Overview',
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 7),
        Text(
          'The ' +
              country +
              ' National Polo Association oversees the development and promotion of polo. The association works with clubs, players and stakeholders to support sustainable growth of the sport.',
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF52615A),
            height: 1.48,
          ),
        ),
        const SizedBox(height: 15),
        const InfoRow(
          Icons.verified_user_outlined,
          'Membership status',
          'FIP Zone E member',
        ),
        const InfoRow(
          Icons.location_on_outlined,
          'Regional office',
          'National association headquarters',
        ),
        const InfoRow(
          Icons.calendar_month_outlined,
          'Established',
          'Recognised FIP association',
        ),
        FilledButton(
          onPressed: () => push(context, const NetworkPage()),
          style: FilledButton.styleFrom(backgroundColor: forest),
          child: const Text('Explore polo network'),
        ),
      ],
    ),
  );
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String title, detail;
  const InfoRow(this.icon, this.title, this.detail, {super.key});
  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: CircleAvatar(
      backgroundColor: const Color(0xFFFFF4DC),
      child: Icon(icon, color: gold, size: 19),
    ),
    title: Text(
      title,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
    ),
    subtitle: Text(detail, style: const TextStyle(fontSize: 11)),
  );
}

class NetworkPage extends StatelessWidget {
  const NetworkPage({super.key});
  @override
  Widget build(BuildContext context) => Shell(
    title: 'Polo Network',
    tab: 1,
    body: ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        const PhotoHeader(
          image: hero,
          title: 'Polo Network',
          subtitle: 'Players, clubs, ponies and officials',
        ),
        const SizedBox(height: 16),
        const TextField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Search players, clubs...',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 18),
        Heading(
          'Featured players',
          action: 'View all',
          onAction: () => push(context, const PlayersListPage()),
        ),
        SizedBox(
          height: 148,
          child: ApiBuilder<List<Map<String, dynamic>>>(
            load: fetchPlayers,
            onLoading: (_) => const SizedBox.shrink(),
            onError: (_, __, ___) => const SizedBox.shrink(),
            onData: (c, rows) {
              final top = rows.take(6).toList();
              if (top.isEmpty) {
                return Center(
                  child: Text(
                    'No players yet.',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                );
              }
              return ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (final p in top) PlayerCard.fromApi(p),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Heading(
          'Featured clubs',
          action: 'View all',
          onAction: () => push(context, const ClubsListPage()),
        ),
        HeroBanner(
          image: club,
          eyebrow: 'ESTABLISHED 1925',
          title: 'Regional Clubs',
          subtitle: 'Explore member clubs across Zone E.',
          action: 'View clubs',
          onPressed: () => push(context, const ClubsListPage()),
        ),
      ],
    ),
  );
}

class PlayerCard extends StatelessWidget {
  final String name, country;
  final String? countryIso, photoPath;
  const PlayerCard(this.name, this.country,
      {super.key, this.countryIso, this.photoPath});

  factory PlayerCard.fromApi(Map<String, dynamic> p) {
    final legal = (p['legal_name'] ?? '') as String;
    final name = legal.trim().isNotEmpty
        ? legal
        : [
            (p['first_name'] ?? '') as String,
            (p['surname'] ?? '') as String,
          ].where((s) => s.trim().isNotEmpty).join(' ');
    return PlayerCard(
      name,
      (p['nationality_name'] ?? p['nationality_iso'] ?? '') as String,
      countryIso: p['nationality_iso'] as String?,
      photoPath: p['photo_path'] as String?,
    );
  }

  @override
  Widget build(BuildContext context) => Container(
    width: 128,
    margin: const EdgeInsets.only(right: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFE7E9E4)),
    ),
    padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: PlayerAvatar(photoPath: photoPath, name: name, size: 60),
        ),
        const SizedBox(height: 10),
        Text(
          name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              fontSize: 11, fontWeight: FontWeight.w800, height: 1.15,
              color: forest),
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Text(flagEmoji(countryIso), style: const TextStyle(fontSize: 11)),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                country,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 10, color: Color(0xFF67736D)),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class TournamentsPage extends StatelessWidget {
  const TournamentsPage({super.key});
  static const _monthAbbr = [
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC',
  ];
  @override
  Widget build(BuildContext context) => Shell(
    title: 'Tournaments',
    body: ApiBuilder<List<Map<String, dynamic>>>(
      load: fetchTournaments,
      onData: (c, rows) => _buildList(c, rows),
      onError: (c, _, retry) => _buildList(c, const [], errorRetry: retry),
    ),
  );

  Widget _buildList(
    BuildContext context,
    List<Map<String, dynamic>> rows, {
    VoidCallback? errorRetry,
  }) {
    final today = DateTime.now();
    final upcoming =
        rows.where((t) {
            final d = DateTime.tryParse((t['starts_on'] ?? '') as String);
            return d != null &&
                d.isAfter(today.subtract(const Duration(days: 1)));
          }).toList()
          ..sort(
            (a, b) =>
                (a['starts_on'] as String).compareTo(b['starts_on'] as String),
          );

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        const PhotoHeader(
          image: trophy,
          title: 'Tournaments',
          subtitle: 'Calendar, fixtures, results and rankings',
        ),
        const SizedBox(height: 16),
        LinkTile(
          Icons.calendar_month_outlined,
          'Tournament calendar',
          'View all upcoming events',
          () => push(context, const CalendarPage()),
        ),
        LinkTile(
          Icons.emoji_events_outlined,
          'Upcoming tournaments',
          'See what is coming up',
          () => push(context, const CalendarPage()),
        ),
        LinkTile(
          Icons.bar_chart_outlined,
          'Results & standings',
          'View results and tables',
          () => push(context, const StandingsPage()),
        ),
        const SizedBox(height: 12),
        const Heading('Next up'),
        if (errorRetry != null)
          _InlineBanner(
            text: 'Could not load upcoming tournaments.',
            onRetry: errorRetry,
          )
        else if (upcoming.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                'No upcoming tournaments.',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ),
          )
        else
          for (final t in upcoming.take(10)) ...[
            _ApiEventCard(
              tournament: t,
              monthAbbr: _monthAbbr,
              onTap: () => push(context, const EventDetailPage()),
            ),
            const SizedBox(height: 10),
          ],
      ],
    );
  }
}

class _ApiEventCard extends StatelessWidget {
  final Map<String, dynamic> tournament;
  final List<String> monthAbbr;
  final VoidCallback onTap;
  const _ApiEventCard({
    required this.tournament,
    required this.monthAbbr,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final d = DateTime.tryParse((tournament['starts_on'] ?? '') as String);
    final day = d?.day ?? 0;
    final mon = d != null ? monthAbbr[d.month - 1] : '';
    final name = (tournament['name'] ?? 'Tournament') as String;
    final venue = [
      tournament['venue_name'],
      tournament['venue_city'],
    ].whereType<String>().where((s) => s.isNotEmpty).join(', ');
    final state = ((tournament['state'] ?? 'upcoming') as String).toUpperCase();
    return Card(
      elevation: 0,
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: 58,
              height: 80,
              color: gold,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    day == 0 ? '--' : '$day',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    mon,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      venue.isEmpty ? '—' : venue,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF637067),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF5ED),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        state,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: forest,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 9),
              child: Icon(Icons.chevron_right),
            ),
          ],
        ),
      ),
    );
  }
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});
  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime month = DateTime.now();
  int? selectedDay;

  static const _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  static const _monthAbbr = [
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC',
  ];

  List<_CalEvent> _eventsForMonth(List<Map<String, dynamic>> tournaments) {
    final out = <_CalEvent>[];
    for (final t in tournaments) {
      final startsOn = (t['starts_on'] ?? '') as String;
      if (startsOn.isEmpty) continue;
      final d = DateTime.tryParse(startsOn);
      if (d == null) continue;
      if (d.year != month.year || d.month != month.month) continue;
      out.add(
        _CalEvent(
          d.day,
          (t['name'] ?? '') as String,
          [
            t['venue_name'],
            t['venue_city'],
          ].whereType<String>().where((s) => s.isNotEmpty).join(', '),
        ),
      );
    }
    out.sort((a, b) => a.day.compareTo(b.day));
    return out;
  }

  void _changeMonth(int delta) {
    setState(() {
      month = DateTime(month.year, month.month + delta);
      selectedDay = null;
    });
  }

  @override
  Widget build(BuildContext context) => Shell(
    title: 'Tournament calendar',
    body: ApiBuilder<List<Map<String, dynamic>>>(
      key: ValueKey('cal-${month.year}-${month.month}'),
      load: fetchTournaments,
      onData: (c, tournaments) => _buildBody(c, _eventsForMonth(tournaments)),
      onError:
          (c, _, retry) => _buildBody(
            c,
            const <_CalEvent>[],
            banner: _InlineBanner(
              text: 'Showing an empty month (API offline).',
              onRetry: retry,
            ),
          ),
    ),
  );

  Widget _buildBody(
    BuildContext context,
    List<_CalEvent> events, {
    Widget? banner,
  }) {
    final firstWeekdayMon =
        DateTime(month.year, month.month, 1).weekday; // 1=Mon
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final leading = firstWeekdayMon - 1;
    final totalCells = ((leading + daysInMonth + 6) ~/ 7) * 7;
    final eventDays = events.map((e) => e.day).toSet();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (banner != null) ...[banner, const SizedBox(height: 12)],
        _CalendarCard(
          title: '${_monthNames[month.month - 1]} ${month.year}',
          onPrev: () => _changeMonth(-1),
          onNext: () => _changeMonth(1),
          child: Column(
            children: [
              const _WeekdayHeader(),
              const SizedBox(height: 6),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: totalCells,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  childAspectRatio: 1,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                ),
                itemBuilder: (_, i) {
                  final dayNum = i - leading + 1;
                  if (dayNum < 1 || dayNum > daysInMonth) {
                    return const SizedBox.shrink();
                  }
                  final hasEvent = eventDays.contains(dayNum);
                  final isSelected = selectedDay == dayNum;
                  return _DayCell(
                    day: dayNum,
                    hasEvent: hasEvent,
                    selected: isSelected,
                    onTap: () => setState(() => selectedDay = dayNum),
                  );
                },
              ),
              const SizedBox(height: 12),
              const _CalendarLegend(),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Heading('Events this month'),
        if (events.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                'No tournaments scheduled this month.',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ),
          )
        else
          for (int i = 0; i < events.length; i++) ...[
            if (i > 0) const SizedBox(height: 10),
            _EventListTile(
              event: events[i],
              monthAbbr: _monthAbbr[month.month - 1],
              highlighted: selectedDay == events[i].day,
              onTap: () => push(context, const EventDetailPage()),
            ),
          ],
      ],
    );
  }
}

class _InlineBanner extends StatelessWidget {
  final String text;
  final VoidCallback onRetry;
  const _InlineBanner({required this.text, required this.onRetry});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
    decoration: BoxDecoration(
      color: const Color(0xFFFFF4DC),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFE9D7A3)),
    ),
    child: Row(
      children: [
        const Icon(
          Icons.cloud_off_outlined,
          size: 16,
          color: Color(0xFF8E6E1D),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF8E6E1D),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        TextButton(
          onPressed: onRetry,
          style: TextButton.styleFrom(
            foregroundColor: forest,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            minimumSize: const Size(0, 28),
          ),
          child: const Text(
            'Retry',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
          ),
        ),
      ],
    ),
  );
}

class _CalEvent {
  final int day;
  final String title, venue;
  const _CalEvent(this.day, this.title, this.venue);
}

class _CalendarCard extends StatelessWidget {
  final String title;
  final VoidCallback onPrev, onNext;
  final Widget child;
  const _CalendarCard({
    required this.title,
    required this.onPrev,
    required this.onNext,
    required this.child,
  });
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0xFFE8EEE9)),
      boxShadow: [
        BoxShadow(
          color: forest.withValues(alpha: .05),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: Column(
      children: [
        Row(
          children: [
            _navBtn(Icons.chevron_left, onPrev),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: GoogleFonts.playfairDisplay().fontFamily,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: forest,
                ),
              ),
            ),
            _navBtn(Icons.chevron_right, onNext),
          ],
        ),
        const SizedBox(height: 6),
        child,
      ],
    ),
  );

  Widget _navBtn(IconData icon, VoidCallback onTap) => Material(
    color: const Color(0xFFF4F7F4),
    shape: const CircleBorder(),
    child: InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 20, color: forest),
      ),
    ),
  );
}

class _WeekdayHeader extends StatelessWidget {
  const _WeekdayHeader();
  @override
  Widget build(BuildContext context) {
    const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return Row(
      children: [
        for (int i = 0; i < 7; i++)
          Expanded(
            child: Center(
              child: Text(
                labels[i],
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: i >= 5 ? gold : const Color(0xFF8C9A91),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  final int day;
  final bool hasEvent, selected;
  final VoidCallback onTap;
  const _DayCell({
    required this.day,
    required this.hasEvent,
    required this.selected,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color fg;
    final Border? border;
    if (selected) {
      bg = forest;
      fg = Colors.white;
      border = null;
    } else if (hasEvent) {
      bg = gold.withValues(alpha: .14);
      fg = forest;
      border = Border.all(color: gold, width: 1.2);
    } else {
      bg = Colors.transparent;
      fg = forest;
      border = null;
    }
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          border: border,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              '$day',
              style: TextStyle(
                fontSize: 13,
                fontWeight:
                    hasEvent || selected ? FontWeight.w700 : FontWeight.w500,
                color: fg,
              ),
            ),
            if (hasEvent && !selected)
              Positioned(
                bottom: 4,
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: gold,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CalendarLegend extends StatelessWidget {
  const _CalendarLegend();
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _legendDot(gold, 'Event day'),
      const SizedBox(width: 18),
      _legendDot(forest, 'Selected'),
    ],
  );
  Widget _legendDot(Color color, String label) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      const SizedBox(width: 6),
      Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Color(0xFF637067),
        ),
      ),
    ],
  );
}

class _EventListTile extends StatelessWidget {
  final _CalEvent event;
  final String monthAbbr;
  final bool highlighted;
  final VoidCallback onTap;
  const _EventListTile({
    required this.event,
    required this.monthAbbr,
    required this.highlighted,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(14),
    child: InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: highlighted ? gold : const Color(0xFFE8EEE9),
            width: highlighted ? 1.4 : 1,
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 64,
              decoration: BoxDecoration(
                color: gold,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${event.day}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    monthAbbr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: forest,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    event.venue,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF637067),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF5ED),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: const Text(
                      'UPCOMING',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: forest,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF9BA8A1)),
          ],
        ),
      ),
    ),
  );
}

class EventDetailPage extends StatelessWidget {
  const EventDetailPage({super.key});
  @override
  Widget build(BuildContext context) => Shell(
    title: 'Event',
    tab: 2,
    body: ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        const PhotoHeader(
          image: hero,
          title: 'Dubai Open Polo\nChampionship',
          subtitle: '18–20 October 2026 · Dubai Polo Club, UAE',
        ),
        const SizedBox(height: 18),
        const Text(
          'About the event',
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 7),
        const Text(
          'FIP Zone E presents the polo community across Africa, the Middle East and Asia. Three days of exceptional polo, hospitality and international competition.',
          style: TextStyle(
            fontSize: 13,
            color: Color(0xFF52615A),
            height: 1.48,
          ),
        ),
        const SizedBox(height: 18),
        const InfoRow(Icons.schedule, 'Schedule', '18–20 October 2026'),
        const InfoRow(
          Icons.location_on_outlined,
          'Venue',
          'Dubai Polo Club, United Arab Emirates',
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 48,
          child: FilledButton(
            onPressed: () => push(context, const TicketPage()),
            style: FilledButton.styleFrom(backgroundColor: gold),
            child: const Text('Book tickets  →'),
          ),
        ),
      ],
    ),
  );
}

class TicketPage extends StatefulWidget {
  const TicketPage({super.key});
  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  int ticketCount = 1;
  @override
  Widget build(BuildContext context) => Shell(
    title: 'Select your tickets',
    tab: 2,
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const StepperDots(1),
        const SizedBox(height: 17),
        const Text(
          'Choose your tickets',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 13),
        ticket(
          'General admission',
          'Access to general viewing areas',
          'AED 50',
        ),
        ticket(
          'Grandstand seating',
          'Reserved seating with best views',
          'AED 150',
        ),
        ticket('VIP hospitality', 'Lounge, food & beverages', 'AED 350'),
        const SizedBox(height: 15),
        SizedBox(
          height: 47,
          child: FilledButton(
            onPressed: () => push(context, const AttendeePage()),
            style: FilledButton.styleFrom(backgroundColor: gold),
            child: const Text('Continue  →'),
          ),
        ),
      ],
    ),
  );
  Widget ticket(String title, String description, String price) => Card(
    elevation: 0,
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(13),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF637067),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed:
                        () => setState(
                          () =>
                              ticketCount =
                                  ticketCount > 0 ? ticketCount - 1 : 0,
                        ),
                    icon: const Icon(Icons.remove_circle_outline, size: 19),
                  ),
                  Text(ticketCount.toString()),
                  IconButton(
                    onPressed: () => setState(() => ticketCount++),
                    icon: const Icon(
                      Icons.add_circle_outline,
                      size: 19,
                      color: gold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class StepperDots extends StatelessWidget {
  final int step;
  const StepperDots(this.step, {super.key});
  @override
  Widget build(BuildContext context) => Row(
    children: List.generate(
      4,
      (i) => Expanded(
        child: Row(
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: i < step ? forest : const Color(0xFFEAF0EA),
              child: Text(
                (i + 1).toString(),
                style: TextStyle(
                  fontSize: 10,
                  color: i < step ? Colors.white : forest,
                ),
              ),
            ),
            if (i < 3) const Expanded(child: Divider(color: Color(0xFFD6DDD6))),
          ],
        ),
      ),
    ),
  );
}

class TextInput extends StatelessWidget {
  final String label, hint;
  const TextInput(this.label, this.hint, {super.key});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 11),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 5),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 12),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(color: Color(0xFFDDE4DD)),
            ),
          ),
        ),
      ],
    ),
  );
}

class AttendeePage extends StatelessWidget {
  const AttendeePage({super.key});
  @override
  Widget build(BuildContext context) => Shell(
    title: 'Attendee details',
    tab: 2,
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const StepperDots(2),
        const SizedBox(height: 18),
        const Text(
          'Attendee details',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 15),
        const TextInput('Full name', 'Enter full name'),
        const TextInput('Email address', 'name@example.com'),
        const TextInput('Phone number', '+234 812 345 6789'),
        const SizedBox(height: 12),
        const Text(
          'Attendee 2 (optional)',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
        const TextInput('Full name', 'Enter full name'),
        const SizedBox(height: 15),
        SizedBox(
          height: 47,
          child: FilledButton(
            onPressed: () => push(context, const PaymentPage()),
            style: FilledButton.styleFrom(backgroundColor: gold),
            child: const Text('Continue  →'),
          ),
        ),
      ],
    ),
  );
}

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});
  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool terms = false;
  @override
  Widget build(BuildContext context) => Shell(
    title: 'Payment',
    tab: 2,
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const StepperDots(3),
        const SizedBox(height: 18),
        const Text(
          'Payment method',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 15),
        Card(
          elevation: 0,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                const Row(
                  children: [
                    Icon(Icons.credit_card, color: forest),
                    SizedBox(width: 8),
                    Text(
                      'Credit / Debit Card',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Spacer(),
                    Text(
                      'VISA  •  MC',
                      style: TextStyle(
                        fontSize: 10,
                        color: gold,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const TextInput('Card number', '1234 5678 9012 3456'),
                const TextInput('Name on card', 'John Doe'),
                const Row(
                  children: [
                    Expanded(child: TextInput('Expiry date', 'MM / YY')),
                    SizedBox(width: 12),
                    Expanded(child: TextInput('CVV', '123')),
                  ],
                ),
              ],
            ),
          ),
        ),
        CheckboxListTile(
          value: terms,
          onChanged: (v) => setState(() => terms = v ?? false),
          title: const Text(
            'I agree to the Terms & Conditions',
            style: TextStyle(fontSize: 11),
          ),
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
        ),
        SizedBox(
          height: 47,
          child: FilledButton(
            onPressed:
                terms ? () => push(context, const ConfirmationPage()) : null,
            style: FilledButton.styleFrom(backgroundColor: gold),
            child: const Text('Pay AED 208  →'),
          ),
        ),
      ],
    ),
  );
}

class ConfirmationPage extends StatelessWidget {
  const ConfirmationPage({super.key});
  @override
  Widget build(BuildContext context) => Shell(
    title: 'Confirmation',
    tab: 2,
    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 35,
              backgroundColor: forest,
              child: Icon(Icons.check, size: 42, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              'Booking confirmed!',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your tickets have been successfully booked.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Color(0xFF52615A)),
            ),
            const SizedBox(height: 20),
            const Text(
              'Order number\n#FIPZE-20261018-4587',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                height: 1.7,
              ),
            ),
            const SizedBox(height: 26),
            SizedBox(
              width: double.infinity,
              height: 47,
              child: FilledButton(
                onPressed: () => push(context, const MyTicketsPage()),
                style: FilledButton.styleFrom(backgroundColor: gold),
                child: const Text('View my tickets'),
              ),
            ),
            const SizedBox(height: 9),
            SizedBox(
              width: double.infinity,
              height: 47,
              child: OutlinedButton(
                onPressed: () => note(context, 'Calendar event added.'),
                child: const Text('Add to calendar'),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class MyTicketsPage extends StatelessWidget {
  const MyTicketsPage({super.key});
  @override
  Widget build(BuildContext context) => Shell(
    title: 'My tickets',
    tab: 2,
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Your e-ticket',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(17),
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: forest,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Column(
                  children: [
                    Text(
                      'DUBAI OPEN POLO CHAMPIONSHIP',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '18–20 October 2026 · Dubai Polo Club',
                      style: TextStyle(color: Colors.white70, fontSize: 10),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              const Icon(Icons.qr_code_2, size: 156, color: Colors.black),
              const SizedBox(height: 10),
              const Text(
                'John Doe\nGeneral Admission',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => note(context, 'Ticket download prepared.'),
                  style: FilledButton.styleFrom(backgroundColor: forest),
                  icon: const Icon(Icons.download),
                  label: const Text('Download ticket'),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});
  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  String category = 'All';

  @override
  Widget build(BuildContext context) {
    return Shell(
      title: 'Gallery',
      tab: 3,
      body: ApiBuilder<Map<String, dynamic>>(
        load: fetchGallery,
        onData: (c, snap) => _buildBody(c, snap),
      ),
    );
  }

  Widget _buildBody(BuildContext context, Map<String, dynamic> snap) {
    final items = (snap['data'] as List? ?? const [])
        .cast<Map<String, dynamic>>()
        .toList();
    final cats = <String>[
      'All',
      ...((snap['categories'] as List? ?? const []).whereType<String>()),
    ];
    final shown = category == 'All'
        ? items
        : items.where((p) => p['category'] == category).toList();
    return Column(
      children: [
        SizedBox(
          height: 48,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            scrollDirection: Axis.horizontal,
            children: [
              for (final x in cats)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FilterChip(
                    label: Text(x, style: const TextStyle(fontSize: 11)),
                    selected: x == category,
                    onSelected: (_) => setState(() => category = x),
                  ),
                ),
            ],
          ),
        ),
        if (shown.isEmpty)
          const Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No photos in this category yet.',
                  style: TextStyle(fontSize: 13, color: Color(0xFF637067)),
                ),
              ),
            ),
          )
        else
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: shown.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 9,
                mainAxisSpacing: 9,
                childAspectRatio: .95,
              ),
              itemBuilder: (_, i) {
                final item = shown[i];
                final path = item['image_path'] as String?;
                final title = (item['title'] ?? '') as String;
                return InkWell(
                  onTap: () => push(
                    context,
                    PhotoPreview(
                      imagePath: path,
                      caption: (item['caption'] ?? title) as String,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: RemoteImage(path: path),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

class PhotoPreview extends StatelessWidget {
  final String? imagePath;
  final String caption;
  const PhotoPreview({
    super.key,
    required this.imagePath,
    this.caption = '',
  });
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      title: Text(caption.isEmpty ? 'Photo' : caption, maxLines: 1,
          overflow: TextOverflow.ellipsis),
    ),
    body: Center(
      child: InteractiveViewer(
        child: RemoteImage(path: imagePath, fit: BoxFit.contain),
      ),
    ),
    bottomNavigationBar: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () => note(context, 'Liked image.'),
              icon: const Icon(Icons.favorite_border, color: Colors.white),
            ),
            IconButton(
              onPressed: () => note(context, 'Share options opened.'),
              icon: const Icon(Icons.share_outlined, color: Colors.white),
            ),
            IconButton(
              onPressed: () => note(context, 'Saved to your collection.'),
              icon: const Icon(Icons.bookmark_border, color: Colors.white),
            ),
          ],
        ),
      ),
    ),
  );
}

class PartnershipsPage extends StatelessWidget {
  const PartnershipsPage({super.key});
  @override
  Widget build(BuildContext context) => Shell(
    title: 'Partnerships',
    body: ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        const PhotoHeader(
          image: club,
          title: 'Building stronger\npartnerships through polo',
          subtitle: 'Collaborate to support the growth of polo',
        ),
        const SizedBox(height: 16),
        LinkTile(
          Icons.workspace_premium_outlined,
          'Sponsorship opportunities',
          'Put your brand in the game',
          () => push(context, const PartnerFormPage()),
        ),
        LinkTile(
          Icons.business_outlined,
          'Commercial partnerships',
          'Create shared value',
          () => push(context, const PartnerFormPage()),
        ),
        LinkTile(
          Icons.volunteer_activism_outlined,
          'Development partnerships',
          'Invest in the sport',
          () => push(context, const PartnerFormPage()),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 47,
          child: FilledButton(
            onPressed: () => push(context, const PartnerFormPage()),
            style: FilledButton.styleFrom(backgroundColor: gold),
            child: const Text('Become a partner  →'),
          ),
        ),
      ],
    ),
  );
}

class PartnerFormPage extends StatelessWidget {
  const PartnerFormPage({super.key});
  @override
  Widget build(BuildContext context) => Shell(
    title: 'Become a partner',
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Tell us about your organisation and explore partnership opportunities.',
          style: TextStyle(fontSize: 13, color: Color(0xFF52615A)),
        ),
        const SizedBox(height: 18),
        const TextInput('Full name', 'Your name'),
        const TextInput('Organisation / company', 'Organisation name'),
        const TextInput('Business email', 'name@company.com'),
        const TextInput('Country', 'Select a country'),
        const TextInput('Partnership interest', 'Select an option'),
        SizedBox(
          height: 47,
          child: FilledButton(
            onPressed:
                () => note(
                  context,
                  'Thank you — your enquiry has been submitted.',
                ),
            style: FilledButton.styleFrom(backgroundColor: gold),
            child: const Text('Submit enquiry  →'),
          ),
        ),
      ],
    ),
  );
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) => Shell(
    title: 'Player sign in',
    tab: 4,
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 20),
        const Text(
          'Player sign in',
          style: TextStyle(fontSize: 27, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        const Text(
          'Access your player record, registrations and tickets.',
          style: TextStyle(fontSize: 13, color: Color(0xFF52615A)),
        ),
        const SizedBox(height: 25),
        const TextInput('Email address', 'name@example.com'),
        const TextInput('Password', 'Enter your password'),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Forgot password?',
                style: TextStyle(fontSize: 11, color: forest),
              ),
            ),
            TextButton(
              onPressed: () => note(context, 'Password reset link requested.'),
              child: const Text('Reset'),
            ),
          ],
        ),
        const SizedBox(height: 7),
        SizedBox(
          height: 47,
          child: FilledButton(
            onPressed: () => push(context, const DashboardPage()),
            style: FilledButton.styleFrom(backgroundColor: forest),
            child: const Text('Sign in  →'),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Player accounts are issued by your club or federation.',
              style: TextStyle(fontSize: 11),
            ),
            TextButton(
              onPressed:
                  () => note(
                    context,
                    'Please contact your federation administrator for player access.',
                  ),
              child: const Text('Need access?'),
            ),
          ],
        ),
      ],
    ),
  );
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  @override
  Widget build(BuildContext context) => Shell(
    title: 'Player home',
    tab: 4,
    body: ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: forest,
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: gold,
                    child: Icon(Icons.sports_score, color: forest, size: 28),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'WELCOME BACK',
                          style: TextStyle(
                            color: Color(0xFFFFD477),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: .8,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'John Doe',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'FIP player • Nigeria',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.verified_rounded,
                    color: Color(0xFFFFD477),
                    size: 22,
                  ),
                ],
              ),
              SizedBox(height: 16),
              Divider(color: Color(0x335CE0B1), height: 1),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.badge_outlined,
                    color: Color(0xFFFFD477),
                    size: 17,
                  ),
                  SizedBox(width: 7),
                  Text(
                    'FIP-ZE-002184',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Spacer(),
                  Text(
                    'Active player',
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Row(
          children: [
            Expanded(child: DashStat('2', 'Fixtures')),
            Expanded(child: DashStat('5', 'Tickets')),
            Expanded(child: DashStat('3', 'Registrations')),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          'PLAYER AREA',
          style: TextStyle(
            fontSize: 11,
            color: Color(0xFF8E6E1D),
            fontWeight: FontWeight.w800,
            letterSpacing: .8,
          ),
        ),
        const SizedBox(height: 8),
        LinkTile(
          Icons.badge_outlined,
          'Player profile',
          'FIP ID, handicap, club and federation',
          () => push(context, const ProfileEditPage()),
        ),
        LinkTile(
          Icons.how_to_reg_outlined,
          'My registrations',
          'Tournament entries and upcoming fixtures',
          () => push(context, const PlayerRegistrationsPage()),
        ),
        LinkTile(
          Icons.confirmation_number_outlined,
          'My tickets',
          'View your e-tickets',
          () => push(context, const MyTicketsPage()),
        ),
        LinkTile(
          Icons.notifications_none,
          'Notifications',
          'Fixture, ticket and registration updates',
          () => push(context, const NotificationsPage()),
        ),
        LinkTile(
          Icons.lock_outline,
          'Player account',
          'Security, notifications and preferences',
          () => push(context, const SettingsPage()),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: () => push(context, const LoginPage()),
          icon: const Icon(Icons.logout),
          label: const Text('Log out'),
        ),
      ],
    ),
  );
}

class PlayerRegistrationsPage extends StatelessWidget {
  const PlayerRegistrationsPage({super.key});

  @override
  Widget build(BuildContext context) => Shell(
    title: 'My registrations',
    tab: 4,
    body: ListView(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
      children: [
        const Text(
          'Your polo calendar',
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 5),
        const Text(
          'Confirmed tournament entries and player fixtures.',
          style: TextStyle(fontSize: 13, color: Color(0xFF52615A)),
        ),
        const SizedBox(height: 18),
        _registrationCard(
          context,
          'Dubai Open Polo Championship',
          '18–20 October 2026 • Dubai Polo Club',
          'Confirmed entry',
          hero,
          Icons.verified_rounded,
        ),
        _registrationCard(
          context,
          'Lagos International Polo Cup',
          '02–05 November 2026 • Lagos Polo Club',
          'Fixture pending',
          club,
          Icons.schedule_outlined,
        ),
        _registrationCard(
          context,
          'Zone E Invitational',
          '15 November 2026 • Cairo, Egypt',
          'Registration received',
          trophy,
          Icons.assignment_turned_in_outlined,
        ),
      ],
    ),
  );

  Widget _registrationCard(
    BuildContext context,
    String title,
    String detail,
    String status,
    String image,
    IconData icon,
  ) => Card(
    elevation: 0,
    margin: const EdgeInsets.only(bottom: 12),
    clipBehavior: Clip.antiAlias,
    color: Colors.white,
    child: InkWell(
      onTap: () => push(context, const TournamentsPage()),
      child: Row(
        children: [
          SizedBox(
            width: 92,
            height: 112,
            child: Image.asset(image, fit: BoxFit.cover),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    detail,
                    style: const TextStyle(
                      fontSize: 11,
                      height: 1.35,
                      color: Color(0xFF52615A),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(icon, size: 15, color: forest),
                      const SizedBox(width: 5),
                      Text(
                        status,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: forest,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 8),
            child: Icon(Icons.chevron_right, color: Color(0xFF52615A)),
          ),
        ],
      ),
    ),
  );
}

class DashStat extends StatelessWidget {
  final String number, label;
  const DashStat(this.number, this.label, {super.key});
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        number,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: forest,
        ),
      ),
      Text(
        label,
        style: const TextStyle(fontSize: 10, color: Color(0xFF52615A)),
      ),
    ],
  );
}

class FeaturePage extends StatelessWidget {
  final String title;
  final String image;
  final String intro;
  const FeaturePage({
    super.key,
    required this.title,
    required this.image,
    required this.intro,
  });

  @override
  Widget build(BuildContext context) => Shell(
    title: title,
    body: ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
      children: [
        PhotoHeader(image: image, title: title, subtitle: 'FIP Zone E'),
        const SizedBox(height: 20),
        Text(
          intro,
          style: const TextStyle(
            fontSize: 15,
            height: 1.5,
            color: Color(0xFF52615A),
          ),
        ),
        const SizedBox(height: 22),
        const Heading('Featured updates'),
        FeatureStory(
          icon: Icons.sports_score_outlined,
          title: 'Zone E Championship series',
          detail:
              'Fixtures, scores and recaps from the region’s most exciting polo events.',
        ),
        FeatureStory(
          icon: Icons.groups_2_outlined,
          title: 'People of polo',
          detail:
              'Meet the players, officials and club teams building the game.',
        ),
        FeatureStory(
          icon: Icons.emoji_events_outlined,
          title: 'Season highlights',
          detail: 'Results, recognition and moments worth celebrating.',
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 48,
          child: FilledButton.icon(
            onPressed: () => note(context, 'You are up to date.'),
            style: FilledButton.styleFrom(backgroundColor: forest),
            icon: const Icon(Icons.notifications_active_outlined),
            label: const Text('Get updates'),
          ),
        ),
      ],
    ),
  );
}

class FeatureStory extends StatelessWidget {
  final IconData icon;
  final String title, detail;
  const FeatureStory({
    super.key,
    required this.icon,
    required this.title,
    required this.detail,
  });
  @override
  Widget build(BuildContext context) => Card(
    elevation: 0,
    margin: const EdgeInsets.only(bottom: 10),
    color: Colors.white,
    child: ListTile(
      contentPadding: const EdgeInsets.all(12),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFFFF4DC),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: gold),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(detail, style: const TextStyle(fontSize: 12, height: 1.35)),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => note(context, 'Opening $title'),
    ),
  );
}

// =============================================================
// Search — real-time filter across the app's catalog
// =============================================================
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String q = '';
  static const _trending = [
    'Dubai Open',
    'Cairo Royals',
    'UAE Polo Federation',
    'Rankings',
    'Lagos Stallions',
  ];
  static const _index = <(IconData, String, String, String)>[
    (
      Icons.emoji_events_outlined,
      'Dubai Open Polo Championship',
      'Tournament · 18 Oct',
      'tournament',
    ),
    (
      Icons.emoji_events_outlined,
      'Cairo Open',
      'Tournament · 24 Oct',
      'tournament',
    ),
    (Icons.sports, 'Amine El Fassi', 'Player · Morocco', 'player'),
    (Icons.sports, 'Jamen Okoro', 'Player · Nigeria', 'player'),
    (Icons.sports, 'Maya Khalid', 'Player · UAE', 'player'),
    (Icons.home_work_outlined, 'Dubai Polo Club', 'Club · UAE', 'club'),
    (Icons.home_work_outlined, 'Guards Polo Lagos', 'Club · Nigeria', 'club'),
    (
      Icons.account_balance_outlined,
      'Morocco Polo Association',
      'Federation',
      'fed',
    ),
    (
      Icons.account_balance_outlined,
      'UAE Polo Federation',
      'Federation',
      'fed',
    ),
    (Icons.newspaper_outlined, 'Zone E Championship series', 'News', 'news'),
    (Icons.bar_chart_outlined, 'Zone E Rankings 2026', 'Rankings', 'rankings'),
  ];
  @override
  Widget build(BuildContext context) {
    final results =
        _index
            .where(
              (e) =>
                  q.length < 2
                      ? false
                      : e.$2.toLowerCase().contains(q.toLowerCase()),
            )
            .toList();
    return Shell(
      title: 'Search',
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              autofocus: true,
              onChanged: (v) => setState(() => q = v),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                suffixIcon:
                    q.isEmpty
                        ? null
                        : IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () => setState(() => q = ''),
                        ),
                hintText: 'Search players, clubs, events...',
                filled: true,
                fillColor: Colors.white,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child:
                  q.length < 2
                      ? _SearchEmpty(
                        trending: _trending,
                        onTap: (t) => setState(() => q = t),
                      )
                      : results.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 44,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'No matches for "$q"',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      )
                      : ListView.builder(
                        itemCount: results.length,
                        itemBuilder: (_, i) {
                          final r = results[i];
                          return ListTile(
                            onTap: () => _openResult(context, r.$4),
                            leading: CircleAvatar(
                              backgroundColor: const Color(0xFFFFF4DC),
                              child: Icon(r.$1, color: gold, size: 18),
                            ),
                            title: Text(
                              r.$2,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            subtitle: Text(
                              r.$3,
                              style: const TextStyle(fontSize: 11),
                            ),
                            trailing: const Icon(Icons.chevron_right),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }

  void _openResult(BuildContext c, String kind) {
    switch (kind) {
      case 'tournament':
        push(c, const EventDetailPage());
        break;
      case 'player':
        push(c, const PlayersListPage());
        break;
      case 'club':
        push(c, const ClubsListPage());
        break;
      case 'fed':
        push(c, const FederationsPage());
        break;
      case 'news':
        push(c, const NewsPage());
        break;
      case 'rankings':
        push(c, const RankingsPage());
        break;
    }
  }
}

class _SearchEmpty extends StatelessWidget {
  final List<String> trending;
  final ValueChanged<String> onTap;
  const _SearchEmpty({required this.trending, required this.onTap});
  @override
  Widget build(BuildContext context) => ListView(
    children: [
      const Text(
        'Trending',
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: 8),
      Wrap(
        spacing: 7,
        runSpacing: 7,
        children: [
          for (final t in trending)
            ActionChip(
              avatar: const Icon(Icons.trending_up, size: 15, color: gold),
              label: Text(t, style: const TextStyle(fontSize: 11)),
              onPressed: () => onTap(t),
            ),
        ],
      ),
      const SizedBox(height: 18),
      const Text(
        'Try searching for',
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: 6),
      const Text(
        '• A player or coach by name\n• A polo club or ground\n• A tournament or event\n• A member federation',
        style: TextStyle(fontSize: 12, color: Color(0xFF52615A), height: 1.6),
      ),
    ],
  );
}

// =============================================================
// Live & Results
// =============================================================
class LiveResultsPage extends StatefulWidget {
  const LiveResultsPage({super.key});
  @override
  State<LiveResultsPage> createState() => _LiveResultsPageState();
}

class _LiveResultsPageState extends State<LiveResultsPage>
    with SingleTickerProviderStateMixin {
  late TabController tc;
  @override
  void initState() {
    super.initState();
    tc = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Shell(
    title: 'Live & Results',
    body: Column(
      children: [
        const _LiveFeaturedMatch(),
        Container(
          margin: const EdgeInsets.fromLTRB(16, 10, 16, 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE7E9E4)),
          ),
          child: TabBar(
            controller: tc,
            labelColor: forest,
            unselectedLabelColor: const Color(0xFF637067),
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              color: const Color(0xFFFFF4DC),
              borderRadius: BorderRadius.circular(12),
            ),
            dividerColor: Colors.transparent,
            labelStyle: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
            tabs: const [
              Tab(text: 'LIVE'),
              Tab(text: 'UPCOMING'),
              Tab(text: 'RESULTS'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: tc,
            children: const [_LiveTab(), _UpcomingTab(), _ResultsTab()],
          ),
        ),
      ],
    ),
  );
}

class _LiveFeaturedMatch extends StatelessWidget {
  const _LiveFeaturedMatch();
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
    height: 196,
    child: Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Image.asset(
            hero,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: deepForest),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  deepForest.withValues(alpha: .88),
                  forest.withValues(alpha: .78),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const _PulseDot(),
                  const SizedBox(width: 7),
                  const Text(
                    'LIVE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: .8,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .14),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'CHUKKA 4 · 05:12',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'CAIRO OPEN',
                    style: TextStyle(
                      color: Color(0xFFFFD477),
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: .4,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Expanded(
                    child: _MatchSide('🇪🇬', 'Cairo Royals', '6'),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .16),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'VS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: _MatchSide(
                      '🇦🇪',
                      'Dubai Falcons',
                      '4',
                      right: true,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                height: 36,
                child: FilledButton.icon(
                  onPressed: () => note(context, 'Opening live stream...'),
                  style: FilledButton.styleFrom(
                    backgroundColor: gold,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                  icon: const Icon(Icons.play_arrow_rounded, size: 18),
                  label: const Text(
                    'Watch stream',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _MatchSide extends StatelessWidget {
  final String flag, team, score;
  final bool right;
  const _MatchSide(this.flag, this.team, this.score, {this.right = false});
  @override
  Widget build(BuildContext context) {
    final info = [
      Text(flag, style: const TextStyle(fontSize: 22)),
      const SizedBox(height: 2),
      Text(
        team,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          height: 1.1,
        ),
        textAlign: right ? TextAlign.right : TextAlign.left,
      ),
    ];
    final scoreW = Text(
      score,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 34,
        fontWeight: FontWeight.w800,
        height: 1,
      ),
    );
    return Row(
      mainAxisAlignment:
          right ? MainAxisAlignment.end : MainAxisAlignment.start,
      children:
          right
              ? [
                scoreW,
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: info,
                ),
              ]
              : [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: info,
                ),
                const SizedBox(width: 10),
                scoreW,
              ],
    );
  }
}

class _PulseDot extends StatefulWidget {
  const _PulseDot();
  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late AnimationController c;
  @override
  void initState() {
    super.initState();
    c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: c,
    builder: (_, __) {
      final t = c.value;
      return SizedBox(
        width: 16,
        height: 16,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: (1 - t).clamp(0, 1),
              child: Container(
                width: 16 * (0.5 + t * 0.9),
                height: 16 * (0.5 + t * 0.9),
                decoration: const BoxDecoration(
                  color: Color(0xFFFF4A4A),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFFFF3B3B),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      );
    },
  );
}

class _LiveTab extends StatelessWidget {
  const _LiveTab();
  @override
  Widget build(BuildContext context) => ApiBuilder<Map<String, dynamic>>(
    load: fetchLive,
    onData: (c, snap) {
      final matches =
          (snap['matches'] as List? ?? const [])
              .cast<Map<String, dynamic>>()
              .where((m) => m['is_live'] == true)
              .toList();
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (matches.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Text(
                  'No live matches right now.',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ),
            )
          else
            for (final m in matches)
              _LiveMatchCard(
                ((m['home'] as Map?)?['name'] ?? '—') as String,
                ((m['away'] as Map?)?['name'] ?? '—') as String,
                '${m['home_score'] ?? 0}',
                '${m['away_score'] ?? 0}',
                _liveLabel(m),
              ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              matches.isEmpty
                  ? 'Pull back later for live scores'
                  : 'More matches start soon',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
            ),
          ),
        ],
      );
    },
  );

  static String _liveLabel(Map<String, dynamic> m) {
    final chukka = m['current_chukka'];
    final clock = m['clock'] as Map?;
    final elapsed = clock?['elapsed_seconds'];
    if (chukka != null && elapsed is num) {
      final s = elapsed.round();
      final mm = (s ~/ 60).toString().padLeft(2, '0');
      final ss = (s % 60).toString().padLeft(2, '0');
      return 'Chukka $chukka · $mm:$ss';
    }
    return (m['state'] ?? 'in_progress').toString().toUpperCase();
  }
}

class _LiveMatchCard extends StatelessWidget {
  final String teamA, teamB, scoreA, scoreB, state;
  const _LiveMatchCard(
    this.teamA,
    this.teamB,
    this.scoreA,
    this.scoreB,
    this.state,
  );
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xFFE7E9E4)),
    ),
    child: Column(
      children: [
        Row(
          children: [
            const _PulseDot(),
            const SizedBox(width: 7),
            const Text(
              'LIVE',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: Color(0xFFFF3B3B),
                letterSpacing: .8,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              state,
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF637067),
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: () => note(context, 'Match shared'),
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(Icons.share_outlined, size: 15),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Text(
                teamA,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              scoreA,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: forest,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: Text(
                teamB,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              scoreB,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Color(0xFF637067),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _UpcomingTab extends StatelessWidget {
  const _UpcomingTab();
  @override
  Widget build(BuildContext context) => ApiBuilder<Map<String, dynamic>>(
    load: fetchLive,
    onData: (c, snap) {
      final matches =
          (snap['matches'] as List? ?? const [])
              .cast<Map<String, dynamic>>()
              .where((m) => m['state'] == 'scheduled')
              .toList();
      if (matches.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Text(
              'No upcoming matches today.',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ),
        );
      }
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [for (final m in matches) _ApiUpcomingCard(match: m)],
      );
    },
  );
}

class _ApiUpcomingCard extends StatelessWidget {
  final Map<String, dynamic> match;
  const _ApiUpcomingCard({required this.match});
  @override
  Widget build(BuildContext context) {
    final home = (match['home'] as Map?)?['name'] ?? '—';
    final away = (match['away'] as Map?)?['name'] ?? '—';
    final venue = (match['field'] ?? '') as String;
    final sched = match['scheduled_at']?.toString() ?? '';
    final d = DateTime.tryParse(sched);
    final date =
        d == null
            ? sched
            : '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';
    final time =
        d == null
            ? ''
            : '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
    return _UpcomingCard(
      '🏳️',
      home as String,
      '🏳️',
      away as String,
      date,
      time,
      venue,
    );
  }
}

class _UpcomingCard extends StatelessWidget {
  final String flagA, teamA, flagB, teamB, date, time, venue;
  const _UpcomingCard(
    this.flagA,
    this.teamA,
    this.flagB,
    this.teamB,
    this.date,
    this.time,
    this.venue,
  );
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xFFE7E9E4)),
    ),
    child: Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF4DC),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                date,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF8E6E1D),
                ),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              time,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF637067),
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.location_on_outlined,
              size: 12,
              color: Colors.grey.shade500,
            ),
            const SizedBox(width: 2),
            Flexible(
              child: Text(
                venue,
                style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 11),
        Row(
          children: [
            Text(flagA, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                teamA,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: forest.withValues(alpha: .08),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'VS',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: forest,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                teamB,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            const SizedBox(width: 8),
            Text(flagB, style: const TextStyle(fontSize: 24)),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 34,
          child: OutlinedButton.icon(
            onPressed: () => note(context, 'Reminder set'),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: forest.withValues(alpha: .25)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: const Icon(
              Icons.notifications_active_outlined,
              size: 14,
              color: forest,
            ),
            label: const Text(
              'Set reminder',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: forest,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class _ResultsTab extends StatelessWidget {
  const _ResultsTab();
  @override
  Widget build(BuildContext context) => ApiBuilder<List<Map<String, dynamic>>>(
    load: fetchResults,
    onData: (c, rows) {
      if (rows.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Text(
              'No results yet.',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ),
        );
      }
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final r in rows)
            _ResultCard(
              '🏳️',
              (r['home_team'] ?? '—') as String,
              '🏳️',
              (r['away_team'] ?? '—') as String,
              '${r['home_score'] ?? 0}',
              '${r['away_score'] ?? 0}',
              (r['tournament'] ?? '') as String,
            ),
        ],
      );
    },
  );
}

class _ResultCard extends StatelessWidget {
  final String flagA, teamA, flagB, teamB, scoreA, scoreB, context_;
  const _ResultCard(
    this.flagA,
    this.teamA,
    this.flagB,
    this.teamB,
    this.scoreA,
    this.scoreB,
    this.context_,
  );
  @override
  Widget build(BuildContext context) {
    final a = int.parse(scoreA), b = int.parse(scoreB);
    final winnerA = a > b, winnerB = b > a;
    textStyle(bool w) => TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      color: w ? forest : const Color(0xFF637067),
    );
    scoreStyle(bool w) => TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w800,
      color: w ? forest : Colors.grey.shade500,
    );
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE7E9E4)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                context_,
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF8E6E1D),
                  fontWeight: FontWeight.w800,
                  letterSpacing: .4,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF5ED),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'FT',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: forest,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(flagA, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Expanded(child: Text(teamA, style: textStyle(winnerA))),
              Text(scoreA, style: scoreStyle(winnerA)),
            ],
          ),
          const SizedBox(height: 3),
          Row(
            children: [
              Text(flagB, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Expanded(child: Text(teamB, style: textStyle(winnerB))),
              Text(scoreB, style: scoreStyle(winnerB)),
            ],
          ),
        ],
      ),
    );
  }
}

// =============================================================
// News & Stories
// =============================================================
class NewsPage extends StatefulWidget {
  const NewsPage({super.key});
  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  String cat = 'All';
  static const _cats = ['All', 'Tournaments', 'Players', 'Clubs', 'Zone E'];
  static const _stories = <(String, String, String, String, String, String)>[
    (
      'Tournaments',
      'Dubai Open crowns a new champion in epic final',
      'Al Habtoor stormed home with a 12-7 win over Casablanca Guards in a thrilling final chukka.',
      '2 hours ago',
      '4 min read',
      hero,
    ),
    (
      'Players',
      'Amine El Fassi: "Polo in Africa has never looked better"',
      'Morocco\'s rising star reflects on a breakthrough season and the next generation of talent.',
      'Yesterday',
      '6 min read',
      trophy,
    ),
    (
      'Clubs',
      'Guards Polo Lagos opens new academy wing',
      'A dedicated youth program welcomes 40 cadets into the sport this season.',
      '2 days ago',
      '3 min read',
      club,
    ),
    (
      'Zone E',
      'Zone E to host a record 12 international events in 2027',
      'The regional calendar expands with new fixtures in Egypt, UAE and Pakistan.',
      '3 days ago',
      '5 min read',
      hero,
    ),
    (
      'Players',
      'Maya Khalid breaks UAE handicap record',
      'The 24-year-old becomes the highest-ranked female player in the region.',
      '1 week ago',
      '4 min read',
      trophy,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final shown =
        cat == 'All' ? _stories : _stories.where((s) => s.$1 == cat).toList();
    return Shell(
      title: 'News & Stories',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
        children: [
          _FeaturedStory(_stories.first),
          const SizedBox(height: 16),
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (final c in _cats)
                  Padding(
                    padding: const EdgeInsets.only(right: 7),
                    child: ChoiceChip(
                      label: Text(c, style: const TextStyle(fontSize: 11)),
                      selected: cat == c,
                      onSelected: (_) => setState(() => cat = c),
                      selectedColor: forest,
                      labelStyle: TextStyle(
                        color: cat == c ? Colors.white : forest,
                        fontWeight: FontWeight.w700,
                      ),
                      backgroundColor: Colors.white,
                      side: BorderSide(color: forest.withValues(alpha: .2)),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          for (final s in shown.skip(cat == 'All' ? 1 : 0)) _NewsCard(s),
        ],
      ),
    );
  }
}

class _FeaturedStory extends StatelessWidget {
  final (String, String, String, String, String, String) s;
  const _FeaturedStory(this.s);
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => _openStory(context, s),
    borderRadius: BorderRadius.circular(18),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        height: 230,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              s.$6,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: forest),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xEE002B23)],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: gold,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      s.$1.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: .6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 9),
                  Text(
                    s.$2,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      height: 1.2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: Colors.white.withValues(alpha: .8),
                        size: 11,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${s.$4} · ${s.$5}',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: .85),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _NewsCard extends StatelessWidget {
  final (String, String, String, String, String, String) s;
  const _NewsCard(this.s);
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => _openStory(context, s),
    borderRadius: BorderRadius.circular(14),
    child: Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE7E9E4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 90,
              height: 90,
              child: Image.asset(
                s.$6,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: forest),
              ),
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.$1.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 9,
                    color: Color(0xFF8E6E1D),
                    fontWeight: FontWeight.w800,
                    letterSpacing: .6,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  s.$2,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  s.$3,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF52615A),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 11,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '${s.$4} · ${s.$5}',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

void _openStory(
  BuildContext context,
  (String, String, String, String, String, String) s,
) {
  push(context, NewsDetailPage(story: s));
}

class NewsDetailPage extends StatelessWidget {
  final (String, String, String, String, String, String) story;
  const NewsDetailPage({super.key, required this.story});
  @override
  Widget build(BuildContext context) => Shell(
    title: 'Story',
    body: ListView(
      padding: const EdgeInsets.only(bottom: 28),
      children: [
        SizedBox(
          height: 220,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                story.$6,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: forest),
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xB3000000)],
                  ),
                ),
              ),
              Positioned(
                left: 16,
                bottom: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: gold,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    story.$1.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: .6,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                story.$2,
                style: const TextStyle(
                  fontSize: 22,
                  height: 1.2,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const CircleAvatar(
                    radius: 13,
                    backgroundColor: forest,
                    child: Icon(Icons.edit, color: Colors.white, size: 13),
                  ),
                  const SizedBox(width: 7),
                  const Text(
                    'FIP Zone E Editorial',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${story.$4} · ${story.$5}',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                story.$3,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.55,
                  color: Color(0xFF2A3630),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Across the region, momentum is building. New clubs are opening, more young players are stepping onto the field, and partnerships continue to grow the game at every level. Zone E remains a vibrant home for the sport — one match, one story, one community at a time.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.65,
                  color: Color(0xFF52615A),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed:
                        () => note(context, 'Added to your reading list'),
                    icon: const Icon(Icons.bookmark_add_outlined, size: 16),
                    label: const Text('Save'),
                  ),
                  const SizedBox(width: 9),
                  OutlinedButton.icon(
                    onPressed: () => note(context, 'Share options'),
                    icon: const Icon(Icons.share_outlined, size: 16),
                    label: const Text('Share'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// =============================================================
// Rankings
// =============================================================
class RankingsPage extends StatefulWidget {
  const RankingsPage({super.key});
  @override
  State<RankingsPage> createState() => _RankingsPageState();
}

class _RankingsPageState extends State<RankingsPage>
    with SingleTickerProviderStateMixin {
  late TabController tc;
  @override
  void initState() {
    super.initState();
    tc = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tc.dispose();
    super.dispose();
  }

  static const _players = <(String, String, String, int)>[
    ('🇲🇦', 'Amine El Fassi', 'Morocco', 10),
    ('🇦🇪', 'Rashid Al Marri', 'UAE', 9),
    ('🇳🇬', 'Jamen Okoro', 'Nigeria', 9),
    ('🇵🇰', 'Hassan Khan', 'Pakistan', 8),
    ('🇪🇬', 'Omar Nabil', 'Egypt', 7),
    ('🇮🇷', 'Reza Bahrami', 'Iran', 7),
    ('🇦🇪', 'Maya Khalid', 'UAE', 6),
    ('🇲🇦', 'Youssef Bennani', 'Morocco', 6),
  ];
  static const _clubs = <(String, String, String, int)>[
    ('🇦🇪', 'Dubai Polo Club', 'UAE', 2450),
    ('🇳🇬', 'Guards Polo Lagos', 'Nigeria', 2180),
    ('🇲🇦', 'Royal Rabat Polo', 'Morocco', 2050),
    ('🇵🇰', 'Lahore Polo Club', 'Pakistan', 1980),
    ('🇪🇬', 'Cairo Polo Club', 'Egypt', 1890),
    ('🇮🇷', 'Isfahan Polo', 'Iran', 1700),
    ('🇦🇪', 'Al Habtoor Polo', 'UAE', 1690),
  ];
  static const _nations = <(String, String, int)>[
    ('🇦🇪', 'United Arab Emirates', 4580),
    ('🇲🇦', 'Morocco', 4210),
    ('🇳🇬', 'Nigeria', 3990),
    ('🇵🇰', 'Pakistan', 3870),
    ('🇪🇬', 'Egypt', 3620),
    ('🇮🇷', 'Iran', 3410),
  ];

  @override
  Widget build(BuildContext context) => Shell(
    title: 'Rankings',
    body: Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(16, 10, 16, 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE7E9E4)),
          ),
          child: TabBar(
            controller: tc,
            labelColor: forest,
            unselectedLabelColor: const Color(0xFF637067),
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              color: const Color(0xFFFFF4DC),
              borderRadius: BorderRadius.circular(12),
            ),
            dividerColor: Colors.transparent,
            labelStyle: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
            tabs: const [
              Tab(text: 'PLAYERS'),
              Tab(text: 'CLUBS'),
              Tab(text: 'NATIONS'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: tc,
            children: [
              _RankList(
                unit: 'HCP',
                entries:
                    _players
                        .map((p) => (p.$1, p.$2, p.$3, p.$4.toString()))
                        .toList(),
              ),
              _RankList(
                unit: 'PTS',
                entries:
                    _clubs
                        .map((p) => (p.$1, p.$2, p.$3, p.$4.toString()))
                        .toList(),
              ),
              _RankList(
                unit: 'PTS',
                entries:
                    _nations
                        .map((p) => (p.$1, p.$2, '', p.$3.toString()))
                        .toList(),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _RankList extends StatelessWidget {
  final String unit;
  final List<(String, String, String, String)> entries;
  const _RankList({required this.unit, required this.entries});
  @override
  Widget build(BuildContext context) {
    final top3 = entries.take(3).toList();
    final rest = entries.skip(3).toList();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _Podium(top3: top3, unit: unit),
        const SizedBox(height: 14),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE7E9E4)),
          ),
          child: Column(
            children: [
              for (int i = 0; i < rest.length; i++)
                _RankRow(
                  rank: i + 4,
                  entry: rest[i],
                  unit: unit,
                  last: i == rest.length - 1,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Podium extends StatelessWidget {
  final List<(String, String, String, String)> top3;
  final String unit;
  const _Podium({required this.top3, required this.unit});
  @override
  Widget build(BuildContext context) {
    if (top3.length < 3) return const SizedBox();
    return SizedBox(
      height: 240,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(child: _PodStep(top3[1], 2, unit, height: 95)),
          Expanded(child: _PodStep(top3[0], 1, unit, height: 128)),
          Expanded(child: _PodStep(top3[2], 3, unit, height: 70)),
        ],
      ),
    );
  }
}

class _PodStep extends StatelessWidget {
  final (String, String, String, String) e;
  final int rank;
  final String unit;
  final double height;
  const _PodStep(this.e, this.rank, this.unit, {required this.height});
  @override
  Widget build(BuildContext context) {
    final medal =
        rank == 1
            ? gold
            : (rank == 2 ? const Color(0xFFB0B6B2) : const Color(0xFFC78B4A));
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (rank == 1) const Icon(Icons.emoji_events, color: gold, size: 24),
        if (rank == 1) const SizedBox(height: 2),
        CircleAvatar(
          radius: rank == 1 ? 28 : 22,
          backgroundColor: Colors.white,
          child: CircleAvatar(
            radius: rank == 1 ? 26 : 20,
            backgroundColor: const Color(0xFFF2F5F0),
            child: Text(e.$1, style: TextStyle(fontSize: rank == 1 ? 26 : 22)),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          e.$2,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
        ),
        if (e.$3.isNotEmpty)
          Text(
            e.$3,
            style: TextStyle(fontSize: 9, color: Colors.grey.shade600),
          ),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [medal, medal.withValues(alpha: .55)],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$rank',
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                '${e.$4} $unit',
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RankRow extends StatelessWidget {
  final int rank;
  final (String, String, String, String) entry;
  final String unit;
  final bool last;
  const _RankRow({
    required this.rank,
    required this.entry,
    required this.unit,
    required this.last,
  });
  @override
  Widget build(BuildContext context) {
    final move = rank % 3; // fake: 0=same,1=up,2=down
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
      decoration: BoxDecoration(
        border:
            last
                ? null
                : const Border(bottom: BorderSide(color: Color(0xFFEFF1EE))),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(
              '$rank',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: Color(0xFF52615A),
              ),
            ),
          ),
          Icon(
            move == 1
                ? Icons.arrow_upward
                : (move == 2 ? Icons.arrow_downward : Icons.remove),
            size: 11,
            color:
                move == 1
                    ? const Color(0xFF2EA86B)
                    : (move == 2
                        ? const Color(0xFFE05454)
                        : Colors.grey.shade500),
          ),
          const SizedBox(width: 8),
          Text(entry.$1, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.$2,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (entry.$3.isNotEmpty)
                  Text(
                    entry.$3,
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                  ),
              ],
            ),
          ),
          Text(
            '${entry.$4} $unit',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: forest,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================
// Players directory
// =============================================================
class PlayersListPage extends StatefulWidget {
  const PlayersListPage({super.key});
  @override
  State<PlayersListPage> createState() => _PlayersListPageState();
}

class _PlayersListPageState extends State<PlayersListPage> {
  String q = '';
  String band = 'All';
  static const _bands = ['All', '10 goals', '7–9', '4–6', '0–3'];

  bool _bandMatch(double h) {
    switch (band) {
      case '10 goals':
        return h == 10;
      case '7–9':
        return h >= 7 && h <= 9;
      case '4–6':
        return h >= 4 && h <= 6;
      case '0–3':
        return h >= 0 && h <= 3;
      default:
        return true;
    }
  }

  double _hcp(Map<String, dynamic> p) {
    final raw = p['handicap'];
    if (raw is num) return raw.toDouble();
    if (raw is String) return double.tryParse(raw) ?? 0;
    return 0;
  }

  String _fullName(Map<String, dynamic> p) {
    final legal = (p['legal_name'] ?? '') as String;
    if (legal.trim().isNotEmpty) return legal;
    final first = (p['first_name'] ?? '') as String;
    final sur = (p['surname'] ?? '') as String;
    return [first, sur].where((s) => s.trim().isNotEmpty).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Shell(
      title: 'Players',
      body: ApiBuilder<List<Map<String, dynamic>>>(
        load: fetchPlayers,
        onData: (c, rows) => _buildBody(c, rows),
      ),
    );
  }

  Widget _buildBody(BuildContext context, List<Map<String, dynamic>> rows) {
    final query = q.toLowerCase();
    final shown = rows.where((p) {
      final name = _fullName(p).toLowerCase();
      final number = ((p['public_number'] ?? '') as String).toLowerCase();
      return _bandMatch(_hcp(p)) &&
          (query.isEmpty || name.contains(query) || number.contains(query));
    }).toList();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 7),
          child: TextField(
            onChanged: (v) => setState(() => q = v),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search players...',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 36,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              for (final b in _bands)
                Padding(
                  padding: const EdgeInsets.only(right: 7),
                  child: ChoiceChip(
                    label: Text(b, style: const TextStyle(fontSize: 11)),
                    selected: band == b,
                    onSelected: (_) => setState(() => band = b),
                    selectedColor: forest,
                    labelStyle: TextStyle(
                      color: band == b ? Colors.white : forest,
                      fontWeight: FontWeight.w700,
                    ),
                    backgroundColor: Colors.white,
                    side: BorderSide(color: forest.withValues(alpha: .2)),
                  ),
                ),
            ],
          ),
        ),
        if (shown.isEmpty)
          const Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No players match your search.',
                  style: TextStyle(fontSize: 13, color: Color(0xFF637067)),
                ),
              ),
            ),
          )
        else
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: shown.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 220,
                mainAxisSpacing: 11,
                crossAxisSpacing: 11,
                mainAxisExtent: 220,
              ),
              itemBuilder: (_, i) {
                final p = shown[i];
                return _PlayerTile(
                  name: _fullName(p),
                  countryIso: p['nationality_iso'] as String?,
                  countryName:
                      (p['nationality_name'] ?? p['nationality_iso'] ?? '')
                          as String,
                  publicNumber: (p['public_number'] ?? '') as String,
                  photoPath: p['photo_path'] as String?,
                  handicap: _hcp(p),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _PlayerTile extends StatelessWidget {
  final String name, countryName, publicNumber;
  final String? countryIso, photoPath;
  final double handicap;
  const _PlayerTile({
    required this.name,
    required this.countryIso,
    required this.countryName,
    required this.publicNumber,
    required this.photoPath,
    required this.handicap,
  });

  String get _hcpLabel {
    final rounded = handicap.toStringAsFixed(0);
    return handicap == double.parse(rounded)
        ? '$rounded HCP'
        : '${handicap.toStringAsFixed(1)} HCP';
  }

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => note(context, 'Opening $name'),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE7E9E4)),
          ),
          clipBehavior: Clip.antiAlias,
          padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  PlayerAvatar(photoPath: photoPath, name: name, size: 54),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: gold,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Text(
                      _hcpLabel,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                  color: forest,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    flagEmoji(countryIso),
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      countryName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF637067),
                      ),
                    ),
                  ),
                ],
              ),
              if (publicNumber.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  publicNumber,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF9BA8A1),
                    fontWeight: FontWeight.w700,
                    letterSpacing: .4,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
}

// =============================================================
// Clubs directory
// =============================================================
class ClubsListPage extends StatelessWidget {
  const ClubsListPage({super.key});
  @override
  Widget build(BuildContext context) => Shell(
        title: 'Clubs',
        body: ApiBuilder<List<Map<String, dynamic>>>(
          load: fetchClubs,
          onData: (c, rows) => ListView(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
            children: [
              const PhotoHeader(
                image: club,
                title: 'Zone E Clubs',
                subtitle: 'Member clubs across the region',
              ),
              const SizedBox(height: 15),
              if (rows.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                      'No clubs available yet.',
                      style: TextStyle(fontSize: 13, color: Color(0xFF637067)),
                    ),
                  ),
                )
              else
                for (final r in rows) _ClubTile(r),
            ],
          ),
        ),
      );
}

class _ClubTile extends StatelessWidget {
  final Map<String, dynamic> c;
  const _ClubTile(this.c);
  @override
  Widget build(BuildContext context) {
    final name = (c['legal_name'] ?? c['short_name'] ?? 'Club') as String;
    final country =
        (c['country_name'] ?? c['country_iso'] ?? '') as String;
    final iso = c['country_iso'] as String?;
    final federation = (c['federation'] ?? '') as String;
    final members = c['members'];
    final teams = c['teams'];
    return InkWell(
      onTap: () => note(context, 'Opening $name'),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        margin: const EdgeInsets.only(bottom: 11),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFFE7E9E4)),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            OrgBadge(
              logoPath: c['logo_path'] as String?,
              countryIso: iso,
              size: 72,
              radius: 12,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                      color: forest,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Text(flagEmoji(iso),
                          style: const TextStyle(fontSize: 13)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          country,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF637067),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (federation.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      federation,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 10, color: Color(0xFF9BA8A1)),
                    ),
                  ],
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      if (members is num)
                        _MiniStat(Icons.groups_outlined, '$members members'),
                      if (members is num && teams is num && teams > 0)
                        const SizedBox(width: 11),
                      if (teams is num && teams > 0)
                        _MiniStat(Icons.shield_outlined, '$teams teams'),
                    ],
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 2),
              child: Icon(Icons.chevron_right),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String text;
  const _MiniStat(this.icon, this.text);
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 11, color: gold),
      const SizedBox(width: 3),
      Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          color: Color(0xFF52615A),
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}

// =============================================================
// Results & standings
// =============================================================
class StandingsPage extends StatefulWidget {
  const StandingsPage({super.key});
  @override
  State<StandingsPage> createState() => _StandingsPageState();
}

class _StandingsPageState extends State<StandingsPage>
    with SingleTickerProviderStateMixin {
  late TabController tc;
  @override
  void initState() {
    super.initState();
    tc = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tc.dispose();
    super.dispose();
  }

  static const _table = <(String, String, int, int, int, int, int)>[
    ('🇦🇪', 'Dubai Polo Club', 6, 5, 1, 0, 16),
    ('🇳🇬', 'Guards Polo Lagos', 6, 4, 1, 1, 13),
    ('🇲🇦', 'Rabat Royals', 6, 3, 2, 1, 11),
    ('🇵🇰', 'Lahore Lancers', 6, 3, 1, 2, 10),
    ('🇪🇬', 'Cairo Royals', 6, 2, 2, 2, 8),
    ('🇮🇷', 'Isfahan Blue', 6, 1, 1, 4, 4),
  ];

  @override
  Widget build(BuildContext context) => Shell(
    title: 'Results & Standings',
    body: Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(16, 10, 16, 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE7E9E4)),
          ),
          child: TabBar(
            controller: tc,
            labelColor: forest,
            unselectedLabelColor: const Color(0xFF637067),
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              color: const Color(0xFFFFF4DC),
              borderRadius: BorderRadius.circular(12),
            ),
            dividerColor: Colors.transparent,
            labelStyle: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
            tabs: const [Tab(text: 'LEAGUE TABLE'), Tab(text: 'MATCH RESULTS')],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: tc,
            children: [
              ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE7E9E4)),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF4F8F4),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(14),
                            ),
                          ),
                          child: const Row(
                            children: [
                              SizedBox(
                                width: 22,
                                child: Text(
                                  '#',
                                  style: _StandingsHeadStyle.textStyle,
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Team',
                                  style: _StandingsHeadStyle.textStyle,
                                ),
                              ),
                              SizedBox(
                                width: 22,
                                child: Text(
                                  'P',
                                  textAlign: TextAlign.center,
                                  style: _StandingsHeadStyle.textStyle,
                                ),
                              ),
                              SizedBox(
                                width: 22,
                                child: Text(
                                  'W',
                                  textAlign: TextAlign.center,
                                  style: _StandingsHeadStyle.textStyle,
                                ),
                              ),
                              SizedBox(
                                width: 22,
                                child: Text(
                                  'D',
                                  textAlign: TextAlign.center,
                                  style: _StandingsHeadStyle.textStyle,
                                ),
                              ),
                              SizedBox(
                                width: 22,
                                child: Text(
                                  'L',
                                  textAlign: TextAlign.center,
                                  style: _StandingsHeadStyle.textStyle,
                                ),
                              ),
                              SizedBox(
                                width: 28,
                                child: Text(
                                  'Pts',
                                  textAlign: TextAlign.center,
                                  style: _StandingsHeadStyle.textStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                        for (int i = 0; i < _table.length; i++)
                          _StandingsRow(
                            pos: i + 1,
                            row: _table[i],
                            last: i == _table.length - 1,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _LegendDot(color: forest, label: 'Champion'),
                      const SizedBox(width: 14),
                      _LegendDot(
                        color: Color(0xFFC9922E),
                        label: 'Playoff spot',
                      ),
                    ],
                  ),
                ],
              ),
              const _ResultsTab(),
            ],
          ),
        ),
      ],
    ),
  );
}

class _StandingsHeadStyle {
  static const textStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w800,
    color: Color(0xFF52615A),
  );
}

class _StandingsRow extends StatelessWidget {
  final int pos;
  final (String, String, int, int, int, int, int) row;
  final bool last;
  const _StandingsRow({
    required this.pos,
    required this.row,
    required this.last,
  });
  @override
  Widget build(BuildContext context) {
    Color? indicator;
    if (pos == 1)
      indicator = forest;
    else if (pos <= 4)
      indicator = gold;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        border:
            last
                ? null
                : const Border(bottom: BorderSide(color: Color(0xFFEFF1EE))),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 22,
            child: Row(
              children: [
                Container(
                  width: 3,
                  height: 20,
                  decoration: BoxDecoration(
                    color: indicator ?? Colors.transparent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '$pos',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(row.$1, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              row.$2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
          _cell('${row.$3}'),
          _cell('${row.$4}'),
          _cell('${row.$5}'),
          _cell('${row.$6}'),
          SizedBox(
            width: 28,
            child: Text(
              '${row.$7}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: forest,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cell(String s) => SizedBox(
    width: 22,
    child: Text(
      s,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 12, color: Color(0xFF52615A)),
    ),
  );
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 9,
        height: 9,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      const SizedBox(width: 5),
      Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xFF52615A),
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}

// =============================================================
// Notifications
// =============================================================
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});
  static const _items = <(IconData, String, String, String, bool)>[
    (
      Icons.sports_score_outlined,
      'Match update',
      'Cairo Royals lead Dubai Falcons 6-4 heading into chukka 5.',
      '12m ago',
      true,
    ),
    (
      Icons.confirmation_number_outlined,
      'Ticket confirmed',
      'Your Dubai Open booking (FIPZE-20261018-4587) is confirmed.',
      '1h ago',
      true,
    ),
    (
      Icons.emoji_events_outlined,
      'New tournament',
      'The Cairo Open opens registration for Zone E clubs.',
      'Yesterday',
      false,
    ),
    (
      Icons.handshake_outlined,
      'Partner update',
      'Al Habtoor Group renews their Zone E sponsorship for 2027.',
      'Yesterday',
      false,
    ),
    (
      Icons.newspaper_outlined,
      'New story',
      '"Polo in Africa has never looked better" — our interview with Amine El Fassi.',
      '2 days ago',
      false,
    ),
    (
      Icons.bar_chart_outlined,
      'Rankings updated',
      'Zone E monthly rankings for October are live.',
      '4 days ago',
      false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final today =
        _items
            .where(
              (i) =>
                  i.$4.endsWith('ago') &&
                  (i.$4.contains('m') || i.$4.contains('h')),
            )
            .toList();
    final earlier = _items.where((i) => !today.contains(i)).toList();
    return Shell(
      title: 'Notifications',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              const Text(
                'Your updates',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => note(context, 'All notifications marked read'),
                child: const Text('Mark all read'),
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (today.isNotEmpty) ...[
            _groupHeader('Today'),
            for (final n in today) _NotifTile(n),
          ],
          if (earlier.isNotEmpty) ...[
            const SizedBox(height: 10),
            _groupHeader('Earlier'),
            for (final n in earlier) _NotifTile(n),
          ],
        ],
      ),
    );
  }

  Widget _groupHeader(String s) => Padding(
    padding: const EdgeInsets.fromLTRB(2, 6, 0, 6),
    child: Text(
      s.toUpperCase(),
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w800,
        color: Color(0xFF8E6E1D),
        letterSpacing: .6,
      ),
    ),
  );
}

class _NotifTile extends StatelessWidget {
  final (IconData, String, String, String, bool) n;
  const _NotifTile(this.n);
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: n.$5 ? const Color(0xFFFBF8ED) : Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xFFE7E9E4)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF4DC),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(n.$1, color: gold, size: 20),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      n.$2,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  if (n.$5)
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: gold,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                n.$3,
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.4,
                  color: Color(0xFF52615A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                n.$4,
                style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// =============================================================
// Settings
// =============================================================
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool pushAlerts = true,
      emailDigest = false,
      matchAlerts = true,
      darkMode = false;
  String region = 'Zone E', language = 'English';
  @override
  Widget build(BuildContext context) => Shell(
    title: 'Settings',
    body: ListView(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
      children: [
        _profileHeader(),
        const SizedBox(height: 18),
        _section('ACCOUNT'),
        _tile(
          Icons.person_outline,
          'Profile details',
          'Edit your personal information',
          onTap: () => push(context, const ProfileEditPage()),
        ),
        _tile(
          Icons.lock_outline,
          'Password & security',
          'Change password, two-factor',
          onTap: () => note(context, 'Security settings coming soon'),
        ),
        _tile(
          Icons.credit_card_outlined,
          'Payment methods',
          'Cards for ticket purchases',
          onTap: () => note(context, 'Payment methods coming soon'),
        ),
        const SizedBox(height: 18),
        _section('NOTIFICATIONS'),
        _switch(
          'Push alerts',
          'Match, booking and news alerts',
          pushAlerts,
          (v) => setState(() => pushAlerts = v),
        ),
        _switch(
          'Match alerts',
          'Live scores and goal updates',
          matchAlerts,
          (v) => setState(() => matchAlerts = v),
        ),
        _switch(
          'Email digest',
          'A weekly round-up every Monday',
          emailDigest,
          (v) => setState(() => emailDigest = v),
        ),
        const SizedBox(height: 18),
        _section('PREFERENCES'),
        _switch('Dark mode', 'Switch to a darker theme', darkMode, (v) {
          setState(() => darkMode = v);
          note(context, 'Dark mode preference saved');
        }),
        _tile(
          Icons.public,
          'Default region',
          region,
          onTap: () => _pickRegion(),
        ),
        _tile(
          Icons.translate,
          'Language',
          language,
          onTap: () => _pickLanguage(),
        ),
        const SizedBox(height: 18),
        _section('ABOUT'),
        _tile(
          Icons.shield_outlined,
          'Privacy policy',
          '',
          onTap: () => push(context, const PrivacyPolicyPage()),
        ),
        _tile(
          Icons.description_outlined,
          'Terms of service',
          '',
          onTap: () => note(context, 'Terms of service'),
        ),
        _tile(Icons.info_outline, 'Version', 'FIP Zone E v1.0.0'),
        const SizedBox(height: 16),
        SizedBox(
          height: 46,
          child: OutlinedButton.icon(
            onPressed: () => note(context, 'Logged out'),
            icon: const Icon(Icons.logout),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFC94A4A),
              side: const BorderSide(color: Color(0xFFF0C7C7)),
            ),
            label: const Text('Log out'),
          ),
        ),
      ],
    ),
  );

  Widget _profileHeader() => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xFFE7E9E4)),
    ),
    child: Row(
      children: [
        const CircleAvatar(
          radius: 24,
          backgroundColor: forest,
          child: Icon(Icons.person, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'John Doe',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 2),
              Text(
                'john.doe@example.com',
                style: TextStyle(fontSize: 11, color: Color(0xFF637067)),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => push(context, const ProfileEditPage()),
          icon: const Icon(Icons.edit_outlined, color: forest),
        ),
      ],
    ),
  );

  Widget _section(String label) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 2, 0, 7),
    child: Text(
      label,
      style: const TextStyle(
        fontSize: 10,
        color: Color(0xFF8E6E1D),
        fontWeight: FontWeight.w800,
        letterSpacing: .8,
      ),
    ),
  );

  Widget _tile(
    IconData icon,
    String title,
    String sub, {
    VoidCallback? onTap,
  }) => Container(
    margin: const EdgeInsets.only(bottom: 7),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(11),
      border: Border.all(color: const Color(0xFFEFF1EE)),
    ),
    child: ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: const Color(0xFFFFF4DC),
        child: Icon(icon, color: gold, size: 17),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
      ),
      subtitle:
          sub.isEmpty
              ? null
              : Text(
                sub,
                style: const TextStyle(fontSize: 11, color: Color(0xFF637067)),
              ),
      trailing: onTap == null ? null : const Icon(Icons.chevron_right),
    ),
  );

  Widget _switch(
    String title,
    String sub,
    bool v,
    ValueChanged<bool> onChanged,
  ) => Container(
    margin: const EdgeInsets.only(bottom: 7),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(11),
      border: Border.all(color: const Color(0xFFEFF1EE)),
    ),
    child: SwitchListTile(
      value: v,
      onChanged: onChanged,
      activeColor: gold,
      title: Text(
        title,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
      ),
      subtitle: Text(
        sub,
        style: const TextStyle(fontSize: 11, color: Color(0xFF637067)),
      ),
    ),
  );

  void _pickRegion() async {
    final r = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (c) => Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Default region',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                for (final x in const [
                  'Zone E',
                  'Africa',
                  'Middle East',
                  'Asia',
                ])
                  ListTile(
                    title: Text(x),
                    onTap: () => Navigator.pop(c, x),
                    trailing:
                        region == x
                            ? const Icon(Icons.check, color: gold)
                            : null,
                  ),
              ],
            ),
          ),
    );
    if (r != null) setState(() => region = r);
  }

  void _pickLanguage() async {
    final r = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (c) => Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Language',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                for (final x in const [
                  'English',
                  'Français',
                  'العربية',
                  'اردو',
                ])
                  ListTile(
                    title: Text(x),
                    onTap: () => Navigator.pop(c, x),
                    trailing:
                        language == x
                            ? const Icon(Icons.check, color: gold)
                            : null,
                  ),
              ],
            ),
          ),
    );
    if (r != null) setState(() => language = r);
  }
}

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) => Shell(
    title: 'Privacy policy',
    body: ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      children: const [
        Text('FIP Zone E Privacy Policy', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700, color: forest)),
        SizedBox(height: 5),
        Text('Last updated: 2 November 2026', style: TextStyle(color: Color(0xFF637067))),
        SizedBox(height: 18),
        Text('This policy explains how the FIP Zone E Polo Association handles information when you use the FIP Zone E website and mobile application.'),
        _PrivacyHeading('Information we handle'),
        Text('The app requests public content from our servers, including tournaments, scores, federations, players, clubs and gallery items. To return this content, our server and hosting infrastructure process basic connection information in real time, such as your IP address, request time, requested resource and basic network information. FIP Zone E does not retain this connection information or use it for analytics, profiling, advertising or abuse prevention; it is processed only as needed to deliver the requested content.'),
        SizedBox(height: 10),
        Text('If you contact us, use a member account, submit an enquiry or register for an event, we may handle information you provide, such as your name, email address, phone number, country, account credentials (stored as a protected password hash), and your message or registration details.'),
        SizedBox(height: 10),
        Text('For website ticket purchases, payment details needed to process and reconcile a transaction may be shared with Flutterwave. Card or bank credentials are handled by the payment provider and are not stored by FIP Zone E.'),
        SizedBox(height: 10),
        Text('The app requires internet access to load content. It does not request access to precise location, contacts, camera, microphone, photos or files, and does not use advertising identifiers or push notification services.'),
        _PrivacyHeading('How information is used and shared'),
        Text('We use information to provide the services you request, respond to enquiries, manage accounts or events, process payments, secure the services and meet legal obligations. As needed, information is shared with our hosting and infrastructure providers, transactional email providers, Flutterwave for payments, relevant federations or event organisers, and authorities when legally required. We do not sell personal information or use app data for advertising or behavioural profiling.'),
        _PrivacyHeading('Retention and your choices'),
        Text('We retain information as needed to provide services, keep appropriate records, resolve disputes and meet legal or security requirements. You may request access to, correction of or deletion of your information, subject to applicable law and record keeping obligations. Contact info@fipzonee.org. Do not send your password.'),
        _PrivacyHeading('Children and international processing'),
        Text('The services are not designed to collect personal information directly from children. FIP Zone E and its service providers may process information in countries other than your own, with safeguards applied where required.'),
        _PrivacyHeading('Policy changes and contact'),
        Text('We may update this policy as our services or practices change. The current full policy is available at https://fipzone.com/privacy.php. For privacy questions or requests, contact info@fipzonee.org.'),
      ],
    ),
  );
}

class _PrivacyHeading extends StatelessWidget {
  final String text;
  const _PrivacyHeading(this.text);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 24, bottom: 8),
    child: Text(text, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: forest)),
  );
}

// =============================================================
// Profile edit
// =============================================================
class ProfileEditPage extends StatelessWidget {
  const ProfileEditPage({super.key});
  @override
  Widget build(BuildContext context) => Shell(
    title: 'Player profile',
    body: ListView(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 26),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: forest,
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Row(
            children: [
              CircleAvatar(
                radius: 34,
                backgroundColor: gold,
                child: Icon(Icons.sports_score, color: forest, size: 36),
              ),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'John Doe',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'FIP Player ID  •  FIP-ZE-002184',
                      style: TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.verified_rounded,
                          color: Color(0xFFFFD477),
                          size: 16,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Verified player',
                          style: TextStyle(
                            color: Color(0xFFFFD477),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 21),
        const Text(
          'PLAYER RECORD',
          style: TextStyle(
            fontSize: 11,
            color: Color(0xFF8E6E1D),
            fontWeight: FontWeight.w800,
            letterSpacing: .8,
          ),
        ),
        const SizedBox(height: 8),
        const PlayerRecordTile(Icons.speed_outlined, 'Handicap', '4 goals'),
        const PlayerRecordTile(
          Icons.home_work_outlined,
          'Current club',
          'Lagos Polo Club',
        ),
        const PlayerRecordTile(
          Icons.flag_outlined,
          'National federation',
          'Nigeria Polo Association',
        ),
        const PlayerRecordTile(Icons.public_outlined, 'Nationality', 'Nigeria'),
        const SizedBox(height: 16),
        const Text(
          'CONTACT DETAILS',
          style: TextStyle(
            fontSize: 11,
            color: Color(0xFF8E6E1D),
            fontWeight: FontWeight.w800,
            letterSpacing: .8,
          ),
        ),
        const SizedBox(height: 8),
        const PlayerRecordTile(
          Icons.email_outlined,
          'Email',
          'john.doe@example.com',
        ),
        const PlayerRecordTile(
          Icons.phone_outlined,
          'Phone',
          '+234 812 345 6789',
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF6E4),
            borderRadius: BorderRadius.circular(13),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, color: gold, size: 20),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Your playing identity, handicap and club are verified by your federation. Contact them to request changes to your player record.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: Color(0xFF52615A),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 47,
          child: FilledButton(
            onPressed:
                () => note(
                  context,
                  'Your federation administrator can help with player record changes.',
                ),
            style: FilledButton.styleFrom(backgroundColor: gold),
            child: const Text('Request profile update'),
          ),
        ),
      ],
    ),
  );
}

class PlayerRecordTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const PlayerRecordTile(this.icon, this.label, this.value, {super.key});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(13),
      border: Border.all(color: const Color(0xFFE9EAE6)),
    ),
    child: Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: const BoxDecoration(
            color: Color(0xFFFFF2D5),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: gold),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: Color(0xFF637067)),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
