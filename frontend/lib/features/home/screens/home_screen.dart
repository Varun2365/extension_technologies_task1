import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_1_attendance/theme/colors.dart';
import 'package:task_1_attendance/core/storage_service.dart';
import 'package:task_1_attendance/app/app_routes.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_state.dart';
import '../bloc/home_events.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(LoadHomeData());
  }

  String _getTodayStatus(HomeLoaded state) {
    if (state.isCheckedOut) return 'Present';
    if (state.isCheckedIn) return 'Checked In';
    return 'Absent';
  }

  Color _getStatusColor(HomeLoaded state) {
    if (state.isCheckedOut) return Colors.green;
    if (state.isCheckedIn) return Colors.orange;
    return Colors.red;
  }

  IconData _getStatusIcon(HomeLoaded state) {
    if (state.isCheckedOut) return Icons.check_circle;
    if (state.isCheckedIn) return Icons.access_time;
    return Icons.cancel;
  }

  Future<void> _logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Logout', style: TextStyle(color: ColorPalette.accent)),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await StorageService.clearToken();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
      }
    }
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback? onPressed,
    required bool isLoading,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorPalette.accent,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey[300],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          elevation: 2,
        ),
        onPressed: onPressed,
        icon: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : Icon(icon, size: 20),
        label: Text(isLoading ? 'Processing...' : label),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Extension Technologies', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          backgroundColor: ColorPalette.accent,
          foregroundColor: Colors.white,
          elevation: 0,
          actions: [IconButton(icon: const Icon(Icons.logout), onPressed: _logout, tooltip: 'Logout')],
        ),
        body: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is HomeError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading || state is HomeInitial) {
                return const Center(child: CircularProgressIndicator(color: ColorPalette.accent));
              }
              
              if (state is HomeError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.message),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () => context.read<HomeBloc>().add(LoadHomeData()),
                          icon: const Icon(Icons.refresh, size: 20),
                          label: const Text('Retry'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorPalette.accent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            elevation: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              
              if (state is HomeLoaded) {
                final isLoading = state is HomeLoading;
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [ColorPalette.accent, ColorPalette.accent.withOpacity(0.8), Colors.white],
                      stops: const [0.0, 0.15, 0.15],
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCard(child: _buildWelcomeCard(state)),
                        const SizedBox(height: 20),
                        _buildCard(child: _buildStatusCard(state)),
                        const SizedBox(height: 20),
                        _buildActionButton(
                          label: 'Check In',
                          icon: Icons.login,
                          onPressed: (state.isCheckedIn || isLoading) ? null : () => context.read<HomeBloc>().add(CheckInPressed()),
                          isLoading: isLoading,
                        ),
                        const SizedBox(height: 12),
                        _buildActionButton(
                          label: 'Check Out',
                          icon: Icons.logout,
                          onPressed: (state.isCheckedIn && !state.isCheckedOut && !isLoading) ? () => context.read<HomeBloc>().add(CheckOutPressed()) : null,
                          isLoading: isLoading,
                        ),
                        const SizedBox(height: 24),
                        Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800])),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(child: _buildQuickActionButton('Attendance', Icons.calendar_today, () => Navigator.pushNamed(context, AppRoutes.attendanceList))),
                            const SizedBox(width: 12),
                            Expanded(child: _buildQuickActionButton('Leaves', Icons.event_note, () => Navigator.pushNamed(context, AppRoutes.leaveList))),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: _buildQuickActionButton('Apply for Leave', Icons.add_circle_outline, () => Navigator.pushNamed(context, AppRoutes.leaveApply)),
                        ),
                      ],
                    ),
                  ),
                );
              }
              
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(HomeLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: ColorPalette.accent.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(Icons.person, color: ColorPalette.accent, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Welcome back,', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                  const SizedBox(height: 4),
                  Text(state.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              Icon(Icons.email_outlined, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(state.email, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: _StatCard(label: 'Present Days', value: state.totalPresentDays.toString(), icon: Icons.calendar_today)),
            const SizedBox(width: 12),
            Expanded(child: _StatCard(label: 'Leaves', value: state.totalLeaves.toString(), icon: Icons.event_note)),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusCard(HomeLoaded state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Today's Status", style: TextStyle(fontSize: 14, color: Colors.grey[600])),
            const SizedBox(height: 8),
            Text(_getTodayStatus(state), style: TextStyle(fontSize: 28, color: ColorPalette.accent, fontWeight: FontWeight.bold)),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: _getStatusColor(state).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: Icon(_getStatusIcon(state), color: _getStatusColor(state), size: 32),
        ),
      ],
    );
  }

  Widget _buildQuickActionButton(String label, IconData icon, VoidCallback onPressed) {
    return SizedBox(
      height: 50,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20, color: Colors.white),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorPalette.accent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          elevation: 2,
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorPalette.accent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: ColorPalette.accent.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: ColorPalette.accent,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: ColorPalette.accent,
            ),
          ),
        ],
      ),
    );
  }
}

