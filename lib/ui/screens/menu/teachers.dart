import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goipvc/models/teacher.dart';
import 'package:goipvc/providers/data_providers.dart';

class TeachersScreen extends ConsumerStatefulWidget {
  const TeachersScreen({super.key});

  @override
  TeachersScreenState createState() => TeachersScreenState();
}

class TeachersScreenState extends ConsumerState<TeachersScreen> {
  List<Teacher> _filteredTeachers = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterTeachers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterTeachers() {
    final query = _searchController.text.toLowerCase();
    final teachers = ref.read(teachersProvider).asData?.value ?? [];
    setState(() {
      _filteredTeachers = teachers
          .where((teacher) => teacher.name!.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final teachersAsyncValue = ref.watch(teachersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Corpo Docente"),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Pesquisar docente...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          // List of teachers
          Expanded(
            child: teachersAsyncValue.when(
              data: (teachers) {
                _filterTeachers();
                return ListView.builder(
                  itemCount: _filteredTeachers.length,
                  itemBuilder: (context, index) {
                    final teacher = _filteredTeachers[index];
                    return ListTile(
                      title: Text(teacher.name ?? "Desconhecido"),
                      subtitle: Text(teacher.email ?? "Sem email"),
                      leading: Icon(Icons.person),
                      onTap: () {
                        // TODO: Missing Navigation
                      },
                    );
                  },
                );
              },
              loading: () => Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Erro: $error')),
            ),
          ),
        ],
      ),
    );
  }
}
