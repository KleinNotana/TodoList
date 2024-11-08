import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todolist/models/todotask.dart';

class AddNewTodoModalBottom extends StatefulWidget {
  final Function(TodotaskModel) onAdd;

  AddNewTodoModalBottom({required this.onAdd});

  @override
  _AddNewTodoModalBottomState createState() => _AddNewTodoModalBottomState();
}

class _AddNewTodoModalBottomState extends State<AddNewTodoModalBottom> {
  final _formKey = GlobalKey<FormState>();
  final _titleFocusNode = FocusNode();
  String _title = '';
  String? _description;
  DateTime? _dueDate = DateTime.now(); // Initialize with today's date
  DateTime? _reminderDate;
  int _priority = 5; // Changed initial value to 1

  @override
  void initState() {
    super.initState();
    // Request focus on the title field when the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _titleFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _titleFocusNode.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newTask = TodotaskModel(
        title: _title,
        description: _description,
        dueDate: _dueDate ?? DateTime.now(), // Use today's date if _dueDate is null
        reminderDate: _reminderDate,
        createdDate: DateTime.now(),
        priority: _priority,
      );
      widget.onAdd(newTask);
      Navigator.of(context).pop();
    }
  }

  Future<void> _selectDate(
      BuildContext context, Function(DateTime) onDateSelected) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      onDateSelected(picked);
    }
  }

  Future<void> _selectDateTime(BuildContext context, Function(DateTime) onDateTimeSelected) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
  
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
      );
  
      if (pickedTime != null) {
        final DateTime pickedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        onDateTimeSelected(pickedDateTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
                TextFormField(
                focusNode: _titleFocusNode,
                decoration: InputDecoration(
                  hintText: 'Title',
                  border: InputBorder.none, // Remove border
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0), // Add padding
                  hintStyle: TextStyle(fontSize: 18.0), // Increase font size
                ),
                style: TextStyle(fontSize: 18.0), // Increase font size
                validator: (value) {
                  if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
                ),
                TextFormField(
                decoration: InputDecoration(
                  hintText: 'Description',
                  border: InputBorder.none, // Remove border
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0), // Add padding
                ),
                onSaved: (value) {
                  _description = value;
                },
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ElevatedButton.icon(
                    onPressed: () => _selectDateTime(context, (date) {
                      setState(() {
                        _reminderDate = date;
                      });
                    }),
                    icon: Icon(Icons.calendar_today),
                    label: Text('Reminder'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Handle due date selection
                      _selectDate(context, (date) {
                        setState(() {
                          _dueDate = date;
                        });
                      });
                    },
                    icon: Icon(Icons.event),
                    label: Text(_dueDate == null
                      ? 'Due date'
                      : _dueDate!.difference(DateTime.now()).inDays == 0
                        ? 'Today'
                        : '${DateFormat.MMMd().format(_dueDate!)}'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Handle priority selection
                    },
                    icon: Icon(Icons.priority_high),
                    label: DropdownButton<int>(
                      value: _priority,
                      items: [1, 2, 3, 4, 5]
                          .map((priority) => DropdownMenuItem<int>(
                                value: priority,
                                child: Text('P$priority'),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _priority = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Change background color
                    foregroundColor: Colors.white, // Change text color
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0), // Adjust padding
                    textStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold), // Adjust font size and make bold
                  ),
                  child: Text('Add Task'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
