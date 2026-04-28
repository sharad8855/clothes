import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors.dart';
import '../../providers/measurement_provider.dart';
import '../../providers/package_provider.dart';
import '../order/assign_staff_wizard_screen.dart';

class MeasurementScreen extends StatelessWidget {
  const MeasurementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: _buildAppBar(context),
      body: const _MeasurementScreenBody(),
      bottomNavigationBar: const _BottomNavBar(),
      floatingActionButton: _buildFloatingChatButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.scaffoldBg,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.primaryDark),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Measurements',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Step',
                style: GoogleFonts.inter(
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              Row(
                children: [
                  Text(
                    '3 of 6',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Row(
                    children: List.generate(6, (index) {
                      final isActive = index == 2;
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 1.5),
                        width: isActive ? 12 : 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.primaryDark : AppColors.inputBg,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingChatButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xFF7C3AED), // Branded purple
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7C3AED).withValues(alpha: 0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Icon(
          Icons.chat_bubble_rounded,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}

class _MeasurementScreenBody extends StatelessWidget {
  const _MeasurementScreenBody();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _ProfileSummaryCard(),
          const SizedBox(height: 20),
          const _GenderAndUnitSelector(),
          const SizedBox(height: 20),
          const _AutoFillCard(),
          const SizedBox(height: 24),
          const _MeasurementGuideCard(),
          const SizedBox(height: 32),
          const _SectionHeader(title: 'Upper Body'),
          const SizedBox(height: 16),
          const _UpperBodyInputs(),
          const SizedBox(height: 32),
          const _SectionHeader(title: 'Lower Body'),
          const SizedBox(height: 16),
          const _LowerBodyInputs(),
          const SizedBox(height: 32),
          const _SectionHeader(title: 'Legs & Height'),
          const SizedBox(height: 16),
          const _LegInputs(),
          const SizedBox(height: 32),
          const _SectionHeader(title: 'Custom Measurements'),
          const SizedBox(height: 16),
          const _CustomMeasurementsSection(),
          const SizedBox(height: 24),
          const _FittingNotesInput(),
          const SizedBox(height: 24),
          const _CustomizeDetailsInput(),
          const SizedBox(height: 24),
          const _ExtraOptionsInput(),
          const SizedBox(height: 100), // padding for the FAB and Bottom Nav
        ],
      ),
    );
  }
}

class _ProfileSummaryCard extends StatelessWidget {
  const _ProfileSummaryCard();

  @override
  Widget build(BuildContext context) {
    final selectedCustomer = context.watch<PackageProvider>().selectedCustomer;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.inputBg,
                child: Text(
                  selectedCustomer?.initials ?? '?',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedCustomer?.fullName ?? 'Unknown Customer',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  Text(
                    selectedCustomer != null
                        ? '${selectedCustomer.countryCode} ${selectedCustomer.phoneNumber}'
                        : 'No contact information',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileDetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _ProfileDetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _AutoFillCard extends StatelessWidget {
  const _AutoFillCard();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MeasurementProvider>();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF3E8FF), Color(0xFFE9D5FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFF8B5CF6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.auto_awesome, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 12),
              Text(
                'Auto-Fill with AI',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Let AI extract measurements from a body\nphoto or text description for high-precision\nresults.',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: const Color(0xFF4B5563),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: provider.isExtracting ? null : () => _simulateAI(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5CF6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              icon: provider.isExtracting 
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.center_focus_strong, size: 18),
              label: Text(
                provider.isExtracting ? 'Extracting Data...' : 'Start AI Extraction',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MeasurementGuideCard extends StatelessWidget {
  const _MeasurementGuideCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9), // Light grayish for placeholder background
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            'MEASUREMENT GUIDE',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.textHint,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 16),
          // Mock measurement guide image
          Stack(
            alignment: Alignment.center,
            children: [
              Icon(Icons.checkroom_rounded, size: 100, color: AppColors.border),
              Positioned(
                top: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5CF6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Shoulder',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryDark,
          ),
        ),
      ],
    );
  }
}

class _UpperBodyInputs extends StatelessWidget {
  const _UpperBodyInputs();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MeasurementProvider>();
    return Column(
      children: [
        _MeasurementInput(label: 'Chest', controller: provider.chestController),
        _MeasurementInput(label: 'Bust (Optional)', controller: provider.bustController),
        _MeasurementInput(label: 'Shoulder', controller: provider.shoulderController),
        _MeasurementInput(label: 'Sleeve Length', controller: provider.sleeveController),
        _MeasurementInput(label: 'Arm Length', controller: provider.armLengthController),
        _MeasurementInput(label: 'Neck', controller: provider.neckController),
        _MeasurementInput(label: 'Front Length', controller: provider.lengthController),
      ],
    );
  }
}

class _LowerBodyInputs extends StatelessWidget {
  const _LowerBodyInputs();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MeasurementProvider>();
    return Column(
      children: [
        _MeasurementInput(label: 'Waist', controller: provider.waistController),
        _MeasurementInput(label: 'Hip', controller: provider.hipController),
        _MeasurementInput(label: 'Inseam', controller: provider.inseamController),
        _MeasurementInput(label: 'Outseam', controller: provider.outseamController),
      ],
    );
  }
}

class _LegInputs extends StatelessWidget {
  const _LegInputs();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MeasurementProvider>();
    return Column(
      children: [
        _MeasurementInput(label: 'Thigh', controller: provider.thighController),
        _MeasurementInput(label: 'Knee', controller: provider.kneeController),
        _MeasurementInput(label: 'Calf', controller: provider.calfController),
        _MeasurementInput(label: 'Ankle', controller: provider.ankleController),
        _MeasurementInput(label: 'Total Height', controller: provider.heightController),
      ],
    );
  }
}

class _CustomMeasurementsSection extends StatelessWidget {
  const _CustomMeasurementsSection();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MeasurementProvider>();
    final customFields = provider.customFields ?? [];

    return Column(
      children: [
        ...customFields.asMap().entries.map((entry) {
          int idx = entry.key;
          var field = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _MiniInput(label: 'Label', controller: field['label'], hint: 'e.g. Wrist'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: _MiniInput(label: 'Value', controller: field['value'], hint: '00.0', isNumeric: true),
                ),
                IconButton(
                  onPressed: () => provider.removeCustomField(idx),
                  icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent, size: 20),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: provider.addCustomField,
          icon: const Icon(Icons.add_circle_outline, size: 18),
          label: const Text('Add Custom Measurement'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryDark,
            side: const BorderSide(color: AppColors.primaryDark),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}

class _MiniInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final bool isNumeric;

  const _MiniInput({
    required this.label,
    required this.controller,
    required this.hint,
    this.isNumeric = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.inputBg)),
          child: TextFormField(
            controller: controller,
            keyboardType: isNumeric ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500),
            decoration: InputDecoration(hintText: hint, border: InputBorder.none, hintStyle: GoogleFonts.inter(color: AppColors.textHint)),
          ),
        ),
      ],
    );
  }
}

class _MeasurementInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const _MeasurementInput({required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextFormField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: '00.0',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'inches',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FittingNotesInput extends StatelessWidget {
  const _FittingNotesInput();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MeasurementProvider>();
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Additional Fitting Notes',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextFormField(
              controller: provider.notesController,
              maxLines: 4,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'e.g. Prefer tighter fit around\nwaist, extra allowance for\ncuffing...',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
                hintStyle: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textHint,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomizeDetailsInput extends StatelessWidget {
  const _CustomizeDetailsInput();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MeasurementProvider>();
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9), // Match the AddStaff mock input grey
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.tune_outlined, size: 16, color: AppColors.primaryDark),
              const SizedBox(width: 8),
              Text(
                'Customize Details',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextFormField(
              controller: provider.customizeDetailsController,
              maxLines: 4,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'e.g. Monograms, hidden pockets, specific button colors...',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
                hintStyle: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textHint,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExtraOptionsInput extends StatelessWidget {
  const _ExtraOptionsInput();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MeasurementProvider>();
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.add_task_rounded, size: 16, color: AppColors.primaryDark),
              const SizedBox(width: 8),
              Text(
                'Extra Options & Services',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextFormField(
              controller: provider.extraOptionsController,
              maxLines: 4,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'e.g. Rush order requested, premium lining, matching pocket square...',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
                hintStyle: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textHint,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 16 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg,
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            final customer = context.read<PackageProvider>().selectedCustomer;
            if (customer == null) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a customer first')));
              return;
            }
            
            await context.read<MeasurementProvider>().submitMeasurements(context, customer.id);
            
            if (context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AssignStaffWizardScreen()),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryDark,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Next: Assign Staff',
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _GenderAndUnitSelector extends StatelessWidget {
  const _GenderAndUnitSelector();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MeasurementProvider>();
    // Use fallback values in case of hot reload state mismatch
    final gender = (provider.gender ?? 'male').toUpperCase();
    final unit = (provider.measurementUnit ?? 'inch').toUpperCase();

    return Row(
      children: [
        Expanded(
          child: _SelectorCard(
            label: 'Gender',
            value: gender,
            options: const ['MALE', 'FEMALE', 'OTHER'],
            onChanged: (val) => provider.gender = val!.toLowerCase(),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SelectorCard(
            label: 'Unit',
            value: unit,
            options: const ['INCH', 'CM'],
            onChanged: (val) => provider.measurementUnit = val!.toLowerCase(),
          ),
        ),
      ],
    );
  }
}

class _SelectorCard extends StatelessWidget {
  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  const _SelectorCard({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.inputBg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
          ),
          DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            icon: const Icon(Icons.keyboard_arrow_down, size: 18),
            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
            items: options.map((String opt) {
              return DropdownMenuItem<String>(
                value: opt,
                child: Text(opt),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

void _simulateAI(BuildContext context) {
  final p = context.read<MeasurementProvider>();
  p.chestController.text = "95.5";
  p.bustController.text = "90.0";
  p.waistController.text = "80.0";
  p.shoulderController.text = "42.0";
  p.sleeveController.text = "62.0";
  p.armLengthController.text = "58.0";
  p.neckController.text = "38.0";
  p.hipController.text = "90.0";
  p.thighController.text = "55.0";
  p.kneeController.text = "38.0";
  p.calfController.text = "35.0";
  p.ankleController.text = "22.0";
  p.heightController.text = "175.0";
  p.notesController.text = "Extracted via AI Analysis";
  
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('AI auto-filled measurements detected!')),
  );
}
