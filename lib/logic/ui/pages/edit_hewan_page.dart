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
    );
        }
}