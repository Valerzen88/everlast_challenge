import 'package:flutter/material.dart';
import 'api.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Configure base URL & tenant id here for demo
  final api = ApiClient(baseUrl: 'http://10.0.2.2:8000', tenantId: 'demo_tenant');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRM Demo',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: HomePage(api: api),
    );
  }
}

class HomePage extends StatefulWidget {
  final ApiClient api;
  HomePage({required this.api});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Lead>> _leadsFuture;

  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _leadsFuture = widget.api.listLeads();
  }

  void refresh() {
    setState(() {
      _leadsFuture = widget.api.listLeads();
    });
  }

  Future<void> createLead() async {
    final name = nameCtrl.text.trim();
    final email = emailCtrl.text.trim().isEmpty ? null : emailCtrl.text.trim();
    if (name.isEmpty) return;
    try {
      await widget.api.createLead(name, email);
      nameCtrl.clear();
      emailCtrl.clear();
      refresh();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lead created')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> convertLead(int id) async {
    try {
      await widget.api.convertLead(id);
      refresh();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Converted')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Widget buildLeadTile(Lead l) {
    return ListTile(
      title: Text(l.name),
      subtitle: Text('${l.email ?? "—"} • ${l.status}'),
      trailing: l.status == 'new'
          ? ElevatedButton(onPressed: () => convertLead(l.id), child: Text('Convert'))
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CRM Demo - Leads'),
        actions: [IconButton(icon: Icon(Icons.refresh), onPressed: refresh)],
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(controller: nameCtrl, decoration: InputDecoration(labelText: 'Name')),
            TextField(controller: emailCtrl, decoration: InputDecoration(labelText: 'Email (optional)')),
            SizedBox(height: 8),
            ElevatedButton(onPressed: createLead, child: Text('Create Lead')),
            SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Lead>>(
                future: _leadsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
                  if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
                  final leads = snapshot.data ?? [];
                  if (leads.isEmpty) return Center(child: Text('No leads yet'));
                  return ListView(children: leads.map(buildLeadTile).toList());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
