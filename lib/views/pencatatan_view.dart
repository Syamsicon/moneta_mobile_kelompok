import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pencatatan_controller.dart';
import '../models/kategori_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/top_nav_bar.dart';

class PencatatanView extends GetView<PencatatanController> {
  const PencatatanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            Obx(
              () => TopNavBar(
                selectedIndex: controller.selectedNavIndex.value,
                onNavTap: controller.changeNavIndex,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.sheetWhite,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Input Transaksi',
                          style: AppTextStyles.title.copyWith(fontSize: 22),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 1. Judul Transaksi
                      CustomTextField(
                        label: 'Judul Transaksi',
                        hintText: 'Ikan',
                        controller: controller.judulController,
                      ),
                      const SizedBox(height: 16),

                      // 2. Nominal (di bawah Judul, di atas Tanggal)
                      CustomTextField(
                        label: 'Nominal',
                        hintText: 'Rp28.000',
                        controller: controller.nominalController,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),

                      // 3. Tanggal
                      _buildTanggalSection(context),
                      const SizedBox(height: 16),

                      // 4. Nama / Kategori Dropdown
                      _buildKategoriDropdown(),
                      const SizedBox(height: 16),

                      const Divider(
                        color: AppColors.border,
                        thickness: 0.8,
                      ),

                      // Bagian Advance Fields (Expandable)
                      Obx(() {
                        if (!controller.isAdvancedOpen.value) {
                          return const SizedBox.shrink();
                        }
                        return _buildAdvancedFields();
                      }),

                      const SizedBox(height: 8),

                      // Tombol Toggle Advance Fields
                      Center(
                        child: InkWell(
                          onTap: controller.toggleAdvanced,
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            child: Obx(
                              () => Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Advance Fields',
                                    style: AppTextStyles.label.copyWith(
                                      color: AppColors.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Icon(
                                    controller.isAdvancedOpen.value
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                    color: AppColors.grey,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Tombol Keluar & Enter
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomButton(
                            text: 'Keluar',
                            isOutlined: true,
                            width: 110,
                            height: 38,
                            onPressed: () => Get.back(),
                          ),
                          const SizedBox(width: 12),
                          CustomButton(
                            text: 'Enter',
                            width: 110,
                            height: 38,
                            onPressed: controller.simpanTransaksi,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTanggalSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tanggal', style: AppTextStyles.label),
            const SizedBox(height: 2),
            Obx(
              () => Text(
                controller.formattedDate,
                style: controller.selectedDate.value == null
                    ? AppTextStyles.placeholder.copyWith(fontSize: 12)
                    : AppTextStyles.input.copyWith(fontSize: 12),
              ),
            ),
          ],
        ),
        InkWell(
          onTap: () => controller.pilihTanggal(context),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(
                  () => Text(
                    controller.selectedDate.value == null
                        ? 'Pilih Tanggal'
                        : controller.formattedDate,
                    style: controller.selectedDate.value == null
                        ? AppTextStyles.placeholder.copyWith(fontSize: 13)
                        : AppTextStyles.input.copyWith(fontSize: 13),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.keyboard_arrow_down,
                  size: 18,
                  color: AppColors.textPrimary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKategoriDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Nama', style: AppTextStyles.label),
        const SizedBox(height: 6),
        Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border, width: 1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<KategoriModel>(
                value: controller.selectedKategori.value,
                isExpanded: true,
                hint: Text(
                  'Filter...',
                  style: AppTextStyles.input.copyWith(fontSize: 13),
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.textPrimary,
                ),
                items: controller.daftarKategori.map((kat) {
                  return DropdownMenuItem<KategoriModel>(
                    value: kat,
                    child: Row(
                      children: [
                        Icon(kat.icon, size: 18, color: kat.color),
                        const SizedBox(width: 8),
                        Text(kat.name, style: AppTextStyles.input),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: controller.pilihKategori,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAdvancedFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),

        // 1. Deskripsi (dipindah ke bagian Advance Fields sesuai kesepakatan)
        Text('Deskripsi', style: AppTextStyles.label),
        const SizedBox(height: 6),
        TextField(
          controller: controller.deskripsiController,
          maxLines: 3,
          style: AppTextStyles.input,
          decoration: InputDecoration(
            hintText: 'Kucing terbang diatas genteng...',
            hintStyle: AppTextStyles.placeholder,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border, width: 1),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // 2. Bukti Transaksi
        Text('Bukti', style: AppTextStyles.label),
        const SizedBox(height: 2),
        Obx(
          () => Text(
            controller.buktiPath.value == null
                ? 'belum dipilih...'
                : 'Foto bukti telah dipilih',
            style: AppTextStyles.placeholder.copyWith(fontSize: 12),
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: () {
            Get.snackbar(
              'Bukti Transaksi',
              'Fitur Kamera & Galeri akan diaktifkan pada step berikutnya',
              snackPosition: SnackPosition.BOTTOM,
              margin: const EdgeInsets.all(16),
            );
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: double.infinity,
            height: 110,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.add,
              size: 36,
              color: AppColors.grey,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // 3. Lokasi Transaksi
        CustomTextField(
          label: 'Lokasi Transaksi',
          hintText: 'Lokasi Kejadian...',
          controller: controller.lokasiController,
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          height: 135,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.bottomRight,
          child: OutlinedButton(
            onPressed: controller.pilihLokasiDummy,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textPrimary,
              side: const BorderSide(color: AppColors.border, width: 1),
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              minimumSize: const Size(0, 32),
            ),
            child: Text(
              'Pilih Lokasi...',
              style: AppTextStyles.buttonSecondary.copyWith(fontSize: 12),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
