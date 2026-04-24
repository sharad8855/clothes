import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../providers/add_customer_provider.dart';
import '../../utils/localization/localization_extension.dart';
import '../package/package_screen.dart';
import 'widgets/confirm_customer_bottom_sheet.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddCustomerProvider(),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        appBar: _buildAppBar(context),
        body: Consumer<AddCustomerProvider>(
          builder: (context, provider, child) {
            return SafeArea(
              child: Form(
                key: _formKey,
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildContactDetailsCard(provider),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                    _buildBottomButton(provider),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.primary),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        context.addCustomer,
        style: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryDark,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Save action
          },
          child: Text(
            context.save,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryDark,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactDetailsCard(AddCustomerProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E7FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.person_outline_rounded,
                  color: AppColors.primaryDark,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                context.contactDetails,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            context.fullName,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: provider.fullName,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: provider.setFullName,
            decoration: InputDecoration(
              hintText: context.fullNameHint,
              prefixIcon: const Icon(Icons.person_outline, size: 18),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return context.pleaseEnterFullName;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Text(
            context.phoneNumberLabel,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            keyboardType: TextInputType.number,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: provider.setPhoneNumber,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            decoration: InputDecoration(
              hintText: context.enter10DigitNumber,
              prefixIcon: const Icon(Icons.phone, size: 18),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return context.pleaseFillRequiredFields;
              }
              if (value.length != 10) {
                return context.phoneMustBe10Digits;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Text(
            context.emailAddressLabel,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            onChanged: provider.setEmailAddress,
            decoration: InputDecoration(
              hintText: context.emailHint,
              prefixIcon: const Icon(Icons.email, size: 18),
              errorText: provider.emailError,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(AddCustomerProvider provider) {
    return Positioned(
      bottom: 24,
      left: 20,
      right: 20,
      child: ElevatedButton(
        onPressed: provider.isLoading ? null : () => _onSavePressed(provider),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (provider.isLoading)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            else ...[
              const Icon(Icons.person_add, size: 20),
              const SizedBox(width: 8),
              Text(
                context.saveCustomer,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _onSavePressed(AddCustomerProvider provider) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Show confirmation bottom sheet first
    final shouldSave = await ConfirmCustomerBottomSheet.show(context, provider);

    // Only proceed to save if confirmed
    if (shouldSave == true) {
      try {
        final success = await provider.saveCustomer();
        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.customerAddedSuccessfully),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const PackageScreen()),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${context.errorPrefix}: $e'),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }
}
