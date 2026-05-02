import 'package:flutter/material.dart';

class AddHewanPage extends StatefulWidget {
  const AddHewanPage({super.key});

  @override
  State<AddHewanPage> createState() => _AddHewanPageState();
}

class _AddHewanPageState extends State<AddHewanPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController=TextEditingController();
  final _jenisController=TextEditingController();
  final _tanggalLahirController=TextEditingController();
  final _hargaController=TextEditingController();
  final _statusController=TextEditingController();

  String _selectedStatus ='Tersedia';
  final List<String>_statusOptions = ['Tersedia', 'Terjual'];
  @override
  void dispose(){
    _namaController.dispose();
    _jenisController.dispose();
    _tanggalLahirController.dispose();
    _hargaController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Tambah Hewan",
          style: TextStyle(color:Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color:Colors.white),
      ),
      body:Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF1A237E), Color(0xFFAD1457)],
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
          ),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),

                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.pets,
                  size: 50,
                  color:Colors.white,
                ),
              ),
              const SizedBox(height: 20,),
              Text(
                "Lengkapi informasi hewan dibawah ini",
                style:TextStyle(
                  color:Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 30,),
              _buildGlassTextField(
                controller:_namaController,
                hint:"Nama Hewan",
                Icon(Icons.badge_outlined),
                validator:(value){
                  if(value==null||value.isEmpty){
                    return 'nama hewan tidak boleh kosong';
                  }
                  if (value.length<2){
                    return 'nama minimal 2 karakter';
                  }
                  return null;
                },
                const SizedBox(height: 16),
                _buildGlassTextField(
                  controller: _jenisController,
                  hint: "Jenis Hewan (Kucing, Sapi, dll)",
                  icon: Icons.category_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Jenis hewan tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16,),
                Row(
                  children: [
                    Expanded(
                      child: _buildGlassTextField(
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
                          _tanggalLahirController.text =
                              "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                          }
                        },
                        validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Tanggal lahir wajib diisi';
                        }

                        try {
                          List<String> parts = value.split('/');
                          DateTime inputDate = DateTime(
                            int.parse(parts[2]),
                            int.parse(parts[1]),
                            int.parse(parts[0]),
                          );

                          if (inputDate.isAfter(DateTime.now())) {
                            return 'Tidak boleh melebihi hari ini';
                          }
                        } catch (e) {
                          return 'Format tanggal tidak valid';
                        }
                        return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildGlassTextField(
                  controller: _hargaController,
                  hint: "Harga (Rp)",
                  icon: Icons.attach_money,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Harga wajib diisi';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Masukkan angka';
                    }
                    if (double.parse(value) <= 0) {
                      return 'Harga harus lebih dari 0';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Status",
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _buildStatusButton('Tersedia'),
                        const SizedBox(width: 10),
                        _buildStatusButton('Terjual'),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}