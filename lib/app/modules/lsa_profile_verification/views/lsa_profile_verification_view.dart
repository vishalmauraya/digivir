import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/lsa_profile_verification_controller.dart';
import 'widgets/byt_friction_indicator.dart';
import 'widgets/byt_primary_button.dart';
import 'widgets/byt_status_banner.dart';
import 'widgets/byt_text_field.dart';


class LSAProfileVerificationView extends GetView<LSAProfileVerificationController> {
  const LSAProfileVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LSA Profile Verification'),
      ),
      body: SafeArea(
        child: Form(
          key: controller.formKey,
          child: ListView(
            // ListView (not SingleChildScrollView+Column) so the screen
            // stays smooth/performant if the form grows with more fields.
            padding: const EdgeInsets.all(20),
            children: <Widget>[
              _SectionHeader(
                title: 'Identity',
                subtitle: 'Basic contact details for the LSA applicant.',
              ),
              const SizedBox(height: 16),
              BytTextField(
                label: 'Full Name',
                hint: 'e.g. Amara Okafor',
                controller: controller.fullNameController,
                focusNode: controller.fullNameFocusNode,
                onChanged: controller.onPrimaryFieldInteraction,
              ),
              const SizedBox(height: 8),
              Obx(
                () => Align(
                  alignment: Alignment.centerLeft,
                  child: BytFrictionIndicator(
                    count: controller.frictionEventCount.value,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              BytTextField(
                label: 'Email',
                hint: 'name@example.com',
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              BytTextField(
                label: 'Phone',
                hint: '+234 800 000 0000',
                controller: controller.phoneController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 28),
              _SectionHeader(
                title: 'Certification',
                subtitle: 'Verification & lineage details.',
              ),
              const SizedBox(height: 16),
              BytTextField(
                label: 'Certification Number',
                hint: 'e.g. LSA-CERT-2026-00931',
                controller: controller.certificationController,
              ),
              const SizedBox(height: 16),
              BytTextField(
                label: 'Years of Experience',
                hint: 'e.g. 4',
                controller: controller.yearsController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              BytTextField(
                label: 'Short Bio',
                hint: 'Brief summary of your LSA experience',
                controller: controller.bioController,
                maxLines: 3,
                required: false,
              ),
              const SizedBox(height: 16),
              BytTextField(
                label: 'Predecessor ID',
                hint: 'Upstream record ID (data lineage)',
                controller: controller.predecessorIdController,
              ),
              const SizedBox(height: 28),
              Obx(
                () => BytPrimaryButton(
                  label: 'Submit for Verification',
                  isLoading: controller.isSubmitting,
                  onPressed: controller.submit,
                ),
              ),
              const SizedBox(height: 20),
              Obx(
                () => controller.status.value == ViewStatus.idle
                    ? const SizedBox.shrink()
                    : BytStatusBanner(
                        status: controller.status.value,
                        message: controller.statusMessage.value,
                        traceId: controller.lastTraceId.value,
                      ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
