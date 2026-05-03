import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restapi/logic/bloc/hewan/hewan_bloc.dart';
import 'package:restapi/logic/bloc/hewan/hewan_event.dart';
import 'package:restapi/logic/bloc/hewan/hewan_state.dart';
import 'package:lottie/lottie.dart';

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

  String? _selectedStatus;
  @override
  void dispose(){
    _namaController.dispose();
    _jenisController.dispose();
    _tanggalLahirController.dispose();
    _hargaController.dispose();
    super.dispose();
  }

  void _submitForm(){
    if(_formKey.currentState!.validate()){
      context.read<HewanBloc>().add(
        CreateHewan({
          "nama":_namaController.text,
          "jenis":_jenisController.text,
          "tanggal_lahir":_tanggalLahirController.text,
          "harga":double.parse(_hargaController.text),
          "status":_selectedStatus,
        })
      );
    }
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
                    const SnackBar(content: Text('Data berhasil ditambahkan'), backgroundColor: Colors.green),
                  );
                  context.read<HewanBloc>().add(FetchHewan());
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
                        const SizedBox(height: 30),
                        _buildGlassTextField(
                          controller:_namaController,
                          hint:"Nama Hewan",
                          icon:Icons.badge_outlined,
                          validator:(value){
                            if(value==null||value.isEmpty){
                              return 'nama hewan tidak boleh kosong';
                            }
                            if (value.length<2){
                              return 'nama minimal 2 karakter';
                            }
                            return null;
                          },
                        ),
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
                                      _tanggalLahirController.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
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
                          const SizedBox(height: 30),
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
              }
            )
          )
        ]
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
    bool readOnly=false,
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
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
      ),
    );
  }
  Widget _buildStatusButton(String status) {
    bool isSelected = _selectedStatus == status;
    Color getSelectedColor() {
      if (status == 'Tersedia') return const Color(0xFF4CAF50); 
      if (status == 'Terjual') return const Color(0xFF9C4D82); 
      return Colors.blue; 
    }

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedStatus = status;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? getSelectedColor() : Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isSelected ? Colors.transparent : Colors.white.withOpacity(0.2),
            ),
          ),
          child: Center(
            child: Text(
              status,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}