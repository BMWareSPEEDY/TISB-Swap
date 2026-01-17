import 'package:flutter/material.dart';
import 'package:eco_tisb/models/item.dart';
import 'package:eco_tisb/models/user_profile.dart';
import 'package:eco_tisb/services/supabase_service.dart';
import 'package:eco_tisb/utils/colors.dart';
import 'package:eco_tisb/widgets/custom_button.dart';

class ItemDetailsScreen extends StatefulWidget {
  final Item item;

  const ItemDetailsScreen({super.key, required this.item});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  UserProfile? _sellerProfile;
  bool _isLoadingSeller = true;

  @override
  void initState() {
    super.initState();
    _loadSellerProfile();
  }

  Future<void> _loadSellerProfile() async {
    final profile = await _supabaseService.getUserProfile(widget.item.sellerEmail);
    if (mounted) {
      setState(() {
        _sellerProfile = profile;
        _isLoadingSeller = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                widget.item.imageUrl ?? 'https://via.placeholder.com/400',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.item.title,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      _buildBadge(widget.item.conditionString, AppColors.primaryGreen),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildBadge(widget.item.category ?? 'General', Colors.blueGrey),
                      const SizedBox(width: 8),
                      if (widget.item.description?.contains('Grade:') ?? false)
                        _buildBadge(
                            widget.item.description!.split('Grade:')[1].split('|')[0].trim(),
                            Colors.orange
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildImpactCard(),
                  const SizedBox(height: 24),
                  const Text("Description", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    widget.item.description?.split('|').last.trim() ?? "No description provided.",
                    style: const TextStyle(fontSize: 16, color: AppColors.textSecondary, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  const Text("Listed By", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _buildSellerInfo(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _buildBottomAction(),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  Widget _buildImpactCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.2)),
      ),
      child: const Row(
        children: [
          Icon(Icons.eco, color: AppColors.primaryGreen, size: 30),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Eco Impact", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryGreen)),
                Text(
                  "By reusing this item, you save approx. 2.5kg of CO2 emissions.",
                  style: TextStyle(fontSize: 13, color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSellerInfo() {
    if (_isLoadingSeller) return const LinearProgressIndicator();

    // Safe handling of initials
    final String displayName = _sellerProfile?.fullName ?? "TISB User";
    final String initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : "U";

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primaryGreen,
            child: Text(initial, style: const TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(displayName, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text("${_sellerProfile?.points ?? 0} Eco-Points", style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
          const Spacer(),
          Text(widget.item.sellerEmail, style: const TextStyle(fontSize: 10, color: AppColors.textLight)),
        ],
      ),
    );
  }

  Widget _buildBottomAction() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: CustomButton(
        text: "I'm Interested",
        onPressed: () {
          // Add contact logic
        },
      ),
    );
  }
}