import 'dart:io';

void main() {
  performTasks();
}

void performTasks()  {
  Future task2data;

  task1();
  task2data = task2();
  task3(task2data);
  task4();
}

void task1() {
  String result = 'task 1 data';
  print('Task 1 complete');
}

Future task2() async {
  String result = "";

  await Future.delayed(Duration(seconds: 3), () {
    result = 'task 2 data';
    print('Task 2 complete');
  });

  return await result;
}

Future<void> task3(Future task2data) async {
  String x = await task2data;
  String result = 'task 3 data';
  print('Task 3 complete with ${x}');
}

void task4() {
  String result = 'task 4 data';
  print('Task 4 complete');
}
