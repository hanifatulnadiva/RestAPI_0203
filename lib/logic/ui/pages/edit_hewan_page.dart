import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:restapi/data/models/hewan_model.dart';
import 'package:restapi/logic/bloc/hewan/hewan_bloc.dart';
import 'package:restapi/logic/bloc/hewan/hewan_event.dart';
import 'package:restapi/logic/bloc/hewan/hewan_state.dart';

class EditHomePage extends StatefulWidget {
  final HewanModel hewan;

  const EditHomePage({super.key, required this.hewan});

  @override
  State<EditHomePage> createState() => _EditHomePageState();
}

class _EditHomePageState extends State<EditHomePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _jenisController;
  late TextEditingController _tanggalLahirController;
  late TextEditingController _hargaController;
  late String _selectedStatus;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.hewan.nama);
    _jenisController = TextEditingController(text: widget.hewan.jenis);
    _tanggalLahirController = TextEditingController(text: widget.hewan.tanggalLahir);
    _hargaController = TextEditingController(text: widget.hewan.harga.toString());

    String statusdatabase =widget.hewan.status.trim().toLowerCase();
    if(statusdatabase == 'terjual'){
      _selectedStatus='Terjual';
    }else{
      _selectedStatus ='Tersedia';
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _jenisController.dispose();
    _tanggalLahirController.dispose();
    _hargaController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<HewanBloc>().add(
        UpdateHewan(
          widget.hewan.id, 
          {
            "nama": _namaController.text,
            "jenis": _jenisController.text,
            "tanggal_lahir": _tanggalLahirController.text, 
            "harga": int.parse(_hargaController.text),
            "status": _selectedStatus,
          }
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Edit Hewan",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1A237E), Color(0xFF4D1457)],
              ),
            ),
          ),

          SafeArea(
            child: BlocConsumer<HewanBloc, HewanState>(
              listener: (context, state) {
                if (state is HewanCreatedSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Data berhasil diperbarui!'), backgroundColor: Colors.green),
                  );
                  Navigator.pop(context); 
                } else if (state is HewanError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message), backgroundColor: Colors.redAccent),
                  );
                }
              },
              builder: (context, state) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white.withOpacity(0.15),
                          child: const Icon(Icons.pets, size: 40, color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        
                        const Text(
                          "Ubah informasi hewan dibawah ini",
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        const SizedBox(height: 32),

                        _buildGlassTextField(
                          controller: _namaController,
                          hint: "Nama",
                          icon: Icons.badge_outlined,
                          validator: (val) => val == null || val.isEmpty ? 'Nama wajib diisi' : null,
                        ),
                        const SizedBox(height: 16),

                        _buildGlassTextField(
                          controller: _jenisController,
                          hint: "Jenis (misal: kucing)",
                          icon: Icons.category_outlined, 
                          validator: (val) => val == null || val.isEmpty ? 'Jenis wajib diisi' : null,
                        ),
                        const SizedBox(height: 16),

                        _buildGlassTextField(
                          controller: _tanggalLahirController,
                          hint: "Tanggal Lahir",
                          icon: Icons.calendar_today_outlined,
                          readOnly: true,
                          onTap: () async {
                            DateTime today = DateTime.now();
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: today,
                              firstDate: DateTime(2000),
                              lastDate: today,
                            );
                            if (pickedDate != null) {
                              _tanggalLahirController.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                            }
                          },
                          validator: (val) => val == null || val.isEmpty ? 'Tanggal lahir wajib diisi' : null,
                        ),
                        const SizedBox(height: 16),

                        _buildGlassTextField(
                          controller: _hargaController,
                          hint: "Harga",
                          icon: Icons.attach_money,
                          keyboardType: TextInputType.number,
                          validator: (val) => val == null || val.isEmpty ? 'Harga wajib diisi' : null,
                        ),
                        const SizedBox(height: 24),

                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Status",
                            style: TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                        ),
                        const SizedBox(height: 8),
                        
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _selectedStatus = 'Tersedia'),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    color: _selectedStatus == 'Tersedia' 
                                        ? const Color(0xFF4CAF50)
                                        : Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: _selectedStatus == 'Tersedia' 
                                          ? Colors.transparent 
                                          : Colors.white.withOpacity(0.2),
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text('Tersedia', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _selectedStatus = 'Terjual'),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    color: _selectedStatus == 'Terjual' 
                                        ? const Color(0xFF9C4D82) 
                                        : Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: _selectedStatus == 'Terjual' 
                                          ? Colors.transparent 
                                          : Colors.white.withOpacity(0.2),
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text('Terjual', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),

                        state is HewanLoading
                          ? Center(
                              child: Lottie.asset('assets/loading.json', width: 100, height: 100),
                            )
                          : SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: _submitForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD08FD8), 
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 5,
                              ),
                              child: const Text(
                                "Simpan",
                                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        maxLines: maxLines,
        readOnly: readOnly,
        onTap: onTap,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          prefixIcon: Icon(icon, color: Colors.white70),
          border: InputBorder.none,
          errorStyle: const TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
      ),
    );
  }
}