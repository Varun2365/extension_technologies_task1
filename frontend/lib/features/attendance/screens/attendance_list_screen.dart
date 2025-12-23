import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_1_attendance/theme/colors.dart';
import '../bloc/attendance_bloc.dart';
import '../bloc/attendance_event.dart';
import '../bloc/attendance_state.dart';

class AttendanceListScreen extends StatefulWidget {
  const AttendanceListScreen({super.key});

  @override
  State<AttendanceListScreen> createState() => _AttendanceListScreenState();
}

class _AttendanceListScreenState extends State<AttendanceListScreen> {
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    _fromDate = startOfMonth;
    _toDate = now;
    _loadAttendance();
  }

  void _loadAttendance() {
    if (_fromDate != null && _toDate != null) {
      context.read<AttendanceBloc>().add(
            LoadAttendanceList(
              from: _fromDate!.toIso8601String().split('T')[0],
              to: _toDate!.toIso8601String().split('T')[0],
            ),
          );
    }
  }

  Future<void> _selectFromDate() async {
    final maxDate = _toDate?.subtract(const Duration(days: 30)) ?? DateTime.now();
    final firstDate = maxDate.isBefore(DateTime(2020)) ? DateTime(2020) : maxDate;
    
    final picked = await showDatePicker(
      context: context,
      initialDate: _fromDate ?? DateTime.now(),
      firstDate: firstDate,
      lastDate: _toDate ?? DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _fromDate = picked;
        if (_toDate != null) {
          final daysDifference = _toDate!.difference(_fromDate!).inDays;
          if (daysDifference > 30) {
            _toDate = _fromDate!.add(const Duration(days: 30));
          } else if (_toDate!.isBefore(_fromDate!)) {
            _toDate = _fromDate;
          }
        }
      });
      _loadAttendance();
    }
  }

  Future<void> _selectToDate() async {
    if (_fromDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select from date first')),
      );
      return;
    }

    final maxDate = _fromDate!.add(const Duration(days: 30));
    final lastDate = maxDate.isAfter(DateTime.now()) ? DateTime.now() : maxDate;

    final picked = await showDatePicker(
      context: context,
      initialDate: _toDate ?? _fromDate!,
      firstDate: _fromDate!,
      lastDate: lastDate,
    );
    if (picked != null) {
      final daysDifference = picked.difference(_fromDate!).inDays;
      if (daysDifference > 30) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Date range cannot exceed 30 days')),
        );
        return;
      }
      setState(() {
        _toDate = picked;
      });
      _loadAttendance();
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'NA';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}${date.month}${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  String _formatTime(String? timeStr) {
    if (timeStr == null) return 'NA';
    try {
      final date = DateTime.parse(timeStr);
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return timeStr;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Attendance List',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: ColorPalette.accent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[50],
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _selectFromDate,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: ColorPalette.accent.withOpacity(0.5)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, size: 20, color: ColorPalette.accent),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('From', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                Text(
                                  _fromDate == null
                                      ? 'Select date'
                                      : '${_fromDate!.day}${_fromDate!.month}${_fromDate!.year}',
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: _selectToDate,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: ColorPalette.accent.withOpacity(0.5)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, size: 20, color: ColorPalette.accent),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('To', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                Text(
                                  _toDate == null
                                      ? 'Select date'
                                      : '${_toDate!.day}${_toDate!.month}${_toDate!.year}',
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<AttendanceBloc, AttendanceState>(
              builder: (context, state) {
                if (state is AttendanceLoading || state is AttendanceInitial) {
                  return const Center(
                    child: CircularProgressIndicator(color: ColorPalette.accent),
                  );
                } else if (state is AttendanceError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.message),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: _loadAttendance,
                            icon: const Icon(Icons.refresh, size: 20),
                            label: const Text('Retry'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorPalette.accent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              elevation: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (state is AttendanceLoaded) {
                  List<Map<String, dynamic>> allDates = [];
                  
                  String? fromDateStr = state.fromDate;
                  String? toDateStr = state.toDate;
                  
                  if (fromDateStr == null || toDateStr == null) {
                    if (_fromDate != null && _toDate != null) {
                      fromDateStr = _fromDate!.toIso8601String().split('T')[0];
                      toDateStr = _toDate!.toIso8601String().split('T')[0];
                    }
                  }
                  
                  if (fromDateStr != null && toDateStr != null) {
                    try {
                      final from = DateTime.parse(fromDateStr);
                      final to = DateTime.parse(toDateStr);
                      final fromDate = DateTime(from.year, from.month, from.day);
                      final toDate = DateTime(to.year, to.month, to.day);
                      
                      final attendanceMap = <String, Map<String, dynamic>>{};
                      for (var record in state.attendanceList) {
                        String? dateStr = record['date']?.toString() ?? 
                                         record['checkInTime']?.toString().split('T')[0] ??
                                         record['checkOutTime']?.toString().split('T')[0];
                        if (dateStr != null) {
                          try {
                            final date = DateTime.parse(dateStr);
                            final key = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                            attendanceMap[key] = record;
                          } catch (e) {
                          }
                        }
                      }
                      
                      final leaveDates = <String>{};
                      for (var leave in state.leaveList) {
                        final status = leave['status']?.toString().toLowerCase();
                        if (status == 'approved') {
                          final leaveFromStr = leave['fromDate']?.toString();
                          final leaveToStr = leave['toDate']?.toString();
                          if (leaveFromStr != null && leaveToStr != null) {
                            try {
                              final leaveFrom = DateTime.parse(leaveFromStr);
                              final leaveTo = DateTime.parse(leaveToStr);
                              var current = DateTime(leaveFrom.year, leaveFrom.month, leaveFrom.day);
                              final end = DateTime(leaveTo.year, leaveTo.month, leaveTo.day);
                              
                              while (!current.isAfter(end)) {
                                final key = '${current.year}-${current.month.toString().padLeft(2, '0')}-${current.day.toString().padLeft(2, '0')}';
                                leaveDates.add(key);
                                current = current.add(const Duration(days: 1));
                              }
                            } catch (e) {
                            }
                          }
                        }
                      }
                      
                      var currentDate = fromDate;
                      final endDate = toDate.add(const Duration(days: 1));
                      
                      while (currentDate.isBefore(endDate)) {
                        final key = '${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}';
                        final dateStr = currentDate.toIso8601String().split('T')[0];
                        final record = attendanceMap[key];
                        
                        if (record != null) {
                          final recordWithDate = Map<String, dynamic>.from(record);
                          recordWithDate['date'] = dateStr;
                          allDates.add(recordWithDate);
                        } else if (leaveDates.contains(key)) {
                          allDates.add({
                            'date': dateStr,
                            'status': 'leave',
                          });
                        } else {
                          allDates.add({
                            'date': dateStr,
                            'status': 'absent',
                          });
                        }
                        
                        currentDate = currentDate.add(const Duration(days: 1));
                      }
                    } catch (e) {
                      allDates = state.attendanceList;
                    }
                  } else {
                    allDates = state.attendanceList;
                  }
                  
                  int totalDays = 0;
                  if (fromDateStr != null && toDateStr != null) {
                    try {
                      final from = DateTime.parse(fromDateStr);
                      final to = DateTime.parse(toDateStr);
                      totalDays = to.difference(from).inDays + 1;
                    } catch (e) {
                      totalDays = allDates.length;
                    }
                  } else {
                    totalDays = allDates.length;
                  }
                  
                  if (allDates.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('No records found for selected date range'),
                          if (_fromDate != null && _toDate != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Selected: ${_fromDate!.day}${_fromDate!.month}${_fromDate!.year} to ${_toDate!.day}${_toDate!.month}${_toDate!.year}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            Text(
                              'Total days: ${_toDate!.difference(_fromDate!).inDays + 1}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        color: Colors.grey[100],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Days: $totalDays',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            if (_fromDate != null && _toDate != null)
                              Text(
                                '${_fromDate!.day}${_fromDate!.month}${_fromDate!.year} - ${_toDate!.day}${_toDate!.month}${_toDate!.year}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                ),
                              ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: allDates.length,
                    itemBuilder: (context, index) {
                      final record = allDates[index];
                      final isLeave = record['status'] == 'leave';
                      final isAbsent = record['status'] == 'absent';
                      final hasCheckIn = record['checkInTime'] != null;
                      final hasCheckOut = record['checkOutTime'] != null;
                      
                      String status;
                      Color statusColor;
                      
                      if (isLeave) {
                        status = 'LEAVE';
                        statusColor = Colors.blue;
                      } else if (hasCheckIn && hasCheckOut) {
                        status = 'PRESENT';
                        statusColor = Colors.green;
                      } else if (hasCheckIn) {
                        status = 'CHECKED IN';
                        statusColor = Colors.orange;
                      } else {
                        status = 'ABSENT';
                        statusColor = Colors.red;
                      }
                      
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _formatDate(record['date']?.toString()),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: statusColor.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      status,
                                      style: TextStyle(
                                        color: statusColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (!isLeave && !isAbsent) ...[
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _InfoRow(
                                        label: 'Check In',
                                        value: _formatTime(record['checkInTime']?.toString()),
                                      ),
                                    ),
                                    Expanded(
                                      child: _InfoRow(
                                        label: 'Check Out',
                                        value: _formatTime(record['checkOutTime']?.toString()),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                        },
                      ),
                      ),
                    ],
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

