import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Мои Заметки',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const NotesPage(),
    );
  }
}

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final List<String> _notes = [];
  
  final TextEditingController _textController = TextEditingController();

  void _addNote() {
    if (_textController.text.isNotEmpty) {
      setState(() {
        _notes.add(_textController.text);
        _textController.clear();
      });
    }
  }

  void _deleteNote(int index) {
    setState(() {
      _notes.removeAt(index);
    });
  }

  void _editNote(int index) {
    final TextEditingController editController = TextEditingController(text: _notes[index]);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Редактировать заметку'),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(hintText: "Введите новый текст"),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                if (editController.text.isNotEmpty) {
                  setState(() {
                    _notes[index] = editController.text;
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Список Заметок'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      labelText: 'Новая заметка',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addNote,
                  child: const Text('Сохранить'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            Expanded(
              child: _notes.isEmpty
                  ? const Center(child: Text('Заметок пока нет'))
                  : ListView.builder(
                      itemCount: _notes.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            title: Text(_notes[index]),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _editNote(index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteNote(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}