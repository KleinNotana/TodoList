import 'package:hive/hive.dart';

class HiveService {
  // Define the name of your box
  final String boxName = 'todo_list_box';

  HiveService._privateConstructor();
  static final HiveService _instance = HiveService._privateConstructor();
  static HiveService get instance => _instance;

  // Open a box
  Future openBox() async {
    return await Hive.openBox(boxName);
  }

  // Get a value from the box
  Future get(String key) async {
    var box = await Hive.openBox(boxName);
    return box.get(key);
  }

  // Put a value in the box
  Future put(String key, dynamic value) async {
    var box = await Hive.openBox(boxName);
    box.put(key, value);
  }

  // Delete a value from the box
  Future delete(String key) async {
    var box = await Hive.openBox(boxName);
    box.delete(key);
  }

  // Close the box
  Future closeBox() async {
    var box = await Hive.openBox(boxName);
    box.close();
  }
}