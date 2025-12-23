import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_1_attendance/theme/colors.dart';
import '../bloc/leave_bloc.dart';
import '../bloc/leave_event.dart';
import '../bloc/leave_state.dart';

class LeaveApplyScreen extends StatefulWidget {
  const LeaveApplyScreen({super.key});

  @override
  State<LeaveApplyScreen> createState() => _LeaveApplyScreenState();
}

class _LeaveApplyScreenState extends State<LeaveApplyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  DateTime? _fromDate;
  DateTime? _toDate;
  String _selectedType = 'sick';

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _fromDate = picked;
        if (_toDate != null && _toDate!.isBefore(_fromDate!)) {
          _toDate = null;
        }
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    if (_fromDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select from date first')),
      );
      return;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: _fromDate ?? DateTime.now(),
      firstDate: _fromDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _toDate = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_fromDate == null || _toDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select both dates')),
        );
        return;
      }

      context.read<LeaveBloc>().add(
            ApplyLeave(
              fromDate: _fromDate!.toIso8601String().split('T')[0],
              toDate: _toDate!.toIso8601String().split('T')[0],
              type: _selectedType,
              reason: _reasonController.text.trim(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Apply for Leave',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: ColorPalette.accent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocListener<LeaveBloc, LeaveState>(
        listener: (context, state) {
          if (state is LeaveSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is LeaveError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedType,
                  decoration: InputDecoration(
                    labelText: 'Leave Type',
                    labelStyle: TextStyle(color: ColorPalette.accent),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    prefixIcon: Icon(Icons.event_note, color: ColorPalette.accent),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: ColorPalette.accent.withOpacity(0.5)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: ColorPalette.accent.withOpacity(0.5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(color: ColorPalette.accent, width: 2),
                    ),
                  ),
                  dropdownColor: Colors.white,
                  style: const TextStyle(color: Colors.black87),
                  items: const [
                    DropdownMenuItem(value: 'sick', child: Text('Sick Leave')),
                    DropdownMenuItem(value: 'casual', child: Text('Casual Leave')),
                    DropdownMenuItem(value: 'other', child: Text('Other')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value!;
                    });
                  },
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () => _selectFromDate(context),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'From Date',
                      labelStyle: TextStyle(color: ColorPalette.accent),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      prefixIcon: Icon(Icons.calendar_today, color: ColorPalette.accent),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: ColorPalette.accent.withOpacity(0.5)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: ColorPalette.accent.withOpacity(0.5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(color: ColorPalette.accent, width: 2),
                      ),
                    ),
                    child: Text(
                      _fromDate == null
                          ? 'Select date'
                          : '${_fromDate!.day}${_fromDate!.month}${_fromDate!.year}',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () => _selectToDate(context),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'To Date',
                      labelStyle: TextStyle(color: ColorPalette.accent),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      prefixIcon: Icon(Icons.calendar_today, color: ColorPalette.accent),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: ColorPalette.accent.withOpacity(0.5)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: ColorPalette.accent.withOpacity(0.5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(color: ColorPalette.accent, width: 2),
                      ),
                    ),
                    child: Text(
                      _toDate == null
                          ? 'Select date'
                          : '${_toDate!.day}${_toDate!.month}${_toDate!.year}',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _reasonController,
                  cursorColor: ColorPalette.accent,
                  style: const TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                    labelText: 'Reason',
                    labelStyle: TextStyle(color: ColorPalette.accent),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    hintText: 'Enter reason for leave',
                    prefixIcon: Icon(Icons.note, color: ColorPalette.accent),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: ColorPalette.accent.withOpacity(0.5)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: ColorPalette.accent.withOpacity(0.5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(color: ColorPalette.accent, width: 2),
                    ),
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a reason';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                BlocBuilder<LeaveBloc, LeaveState>(
                  builder: (context, state) {
                    final isLoading = state is LeaveLoading;
                    return SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorPalette.accent,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          elevation: 2,
                        ),
                        onPressed: isLoading ? null : _submitForm,
                        icon: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.send, size: 20),
                        label: Text(isLoading ? 'Submitting...' : 'Submit'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

