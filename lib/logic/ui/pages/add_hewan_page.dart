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
            
            ],
          ),
        ),
      ),
    );
  }
}