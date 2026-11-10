import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/edit_transaksi_controller.dart';
import '../controllers/pencatatan_controller.dart';
import '../models/kategori_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/top_nav_bar.dart';

class PencatatanView extends GetView<PencatatanController> {

  final bool isEdit;

  const PencatatanView({super.key, this.isEdit = false});

  @override
  PencatatanController get controller => isEdit
      ? Get.find<EditTransaksiController>()
      : Get.find<PencatatanController>();

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
                          isEdit ? 'Edit Transaksi' : 'Input Transaksi',
                          style: AppTextStyles.title.copyWith(fontSize: 22),
                        ),
                      ),
                      const SizedBox(height: 20),

                      CustomTextField(
                        label: 'Judul Transaksi',
                        hintText: 'Ikan',
                        controller: controller.judulController,
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        label: 'Nominal',
                        hintText: 'Rp28.000',
                        controller: controller.nominalController,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),

                      _buildTanggalSection(context),
                      const SizedBox(height: 16),

                      _buildKategoriDropdown(),
                      const SizedBox(height: 16),

                      const Divider(
                        color: AppColors.border,
                        thickness: 0.8,
                      ),

                      Obx(() {
                        if (!controller.isAdvancedOpen.value) {
                          return const SizedBox.shrink();
                        }
                        return _buildAdvancedFields();
                      }),

                      const SizedBox(height: 8),

                      // Tombol toggle Advance disembunyikan saat mode edit
                      if (!isEdit)
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
                            text: isEdit ? 'Simpan' : 'Enter',
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
        Text('Kategori', style: AppTextStyles.label),
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
        Obx(() {
          final path = controller.buktiPath.value;
          return InkWell(
            onTap: _showPilihSumberFoto,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: double.infinity,
              height: 110,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: path == null
  
                  ? const Icon(Icons.add, size: 36, color: AppColors.grey)
       
                  : Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.file(File(path), fit: BoxFit.cover),
                        Positioned(
                          top: 6,
                          right: 6,
                          child: GestureDetector(
                            onTap: controller.hapusFoto,
                            child: const CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.black54,
                              child: Icon(
                                Icons.close,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          );
        }),
        const SizedBox(height: 16),

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

  void _showPilihSumberFoto() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          color: AppColors.sheetWhite,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.camera_alt_outlined,
                  color: AppColors.textPrimary,
                ),
                title: Text('Kamera', style: AppTextStyles.input),
                onTap: () {
                  Get.back(); 
                  controller.ambilFoto(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library_outlined,
                  color: AppColors.textPrimary,
                ),
                title: Text('Galeri', style: AppTextStyles.input),
                onTap: () {
                  Get.back();
                  controller.ambilFoto(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
