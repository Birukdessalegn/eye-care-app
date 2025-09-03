import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/reminder_service.dart';

class ReminderSettingsScreen extends StatefulWidget {
  const ReminderSettingsScreen({super.key});

  @override
  _ReminderSettingsScreenState createState() => _ReminderSettingsScreenState();
}

class _ReminderSettingsScreenState extends State<ReminderSettingsScreen> {
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);
  bool _isEnabled = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadReminderSettings();
  }

  Future<void> _loadReminderSettings() async {
    final reminderService = Provider.of<ReminderService>(context, listen: false);
    await reminderService.loadReminderSettings();
    
    setState(() {
      _isEnabled = reminderService.isEnabled;
      if (reminderService.reminderTime != null) {
        _selectedTime = reminderService.reminderTime!;
      }
    });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _toggleReminder(bool value) async {
    setState(() {
      _isLoading = true;
    });

    final reminderService = Provider.of<ReminderService>(context, listen: false);
    
    try {
      if (value) {
        await reminderService.scheduleDailyReminder(_selectedTime);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reminder enabled successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        await reminderService.cancelReminder();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reminder disabled'),
            backgroundColor: Colors.blue,
          ),
        );
      }
      
      setState(() {
        _isEnabled = value;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminder Settings'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Set a daily reminder to take breaks and do eye exercises:',
                    style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                  ),
                  const SizedBox(height: 20),
                  SwitchListTile(
                    title: const Text('Enable Reminders', style: TextStyle(fontWeight: FontWeight.bold)),
                    value: _isEnabled,
                    onChanged: _toggleReminder,
                    activeColor: Colors.blue,
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    title: const Text('Reminder Time', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      _selectedTime.format(context),
                      style: const TextStyle(fontSize: 18, color: Colors.blue),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.access_time, color: Colors.blue),
                      onPressed: _isEnabled ? () => _selectTime(context) : null,
                    ),
                    onTap: _isEnabled ? () => _selectTime(context) : null,
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Tips for reducing eye strain:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  const SizedBox(height: 15),
                  _buildTipTile(
                    Icons.computer,
                    'Follow the 20-20-20 rule',
                    'Every 20 minutes, look at something 20 feet away for 20 seconds',
                  ),
                  _buildTipTile(
                    Icons.lightbulb_outline,
                    'Proper lighting',
                    'Ensure proper lighting and reduce screen glare',
                  ),
                  _buildTipTile(
                    Icons.zoom_out_map,
                    'Maintain distance',
                    'Keep your screen at arm\'s length distance',
                  ),
                  _buildTipTile(
                    Icons.blur_on,
                    'Adjust text size',
                    'Increase text size for comfortable reading',
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTipTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      minLeadingWidth: 0,
    );
  }
}