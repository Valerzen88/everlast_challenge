import 'dart:convert';
import 'package:http/http.dart' as http;

class Lead {
  final int id;
  final String externalId;
  final String tenantId;
  final String name;
  final String? email;
  final String status;
  final String createdAt;

  Lead(this.id, this.externalId, this.tenantId, this.name, this.email, this.status, this.createdAt);

  factory Lead.fromJson(Map<String, dynamic> j) {
    return Lead(
      j['id'], j['external_id'], j['tenant_id'], j['name'], j['email'], j['status'], j['created_at']
    );
  }
}

class ApiClient {
  final String baseUrl;
  final String tenantId;

  ApiClient({required this.baseUrl, required this.tenantId});

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'X-Tenant-Id': tenantId,
  };

  Future<List<Lead>> listLeads() async {
    final resp = await http.get(Uri.parse('$baseUrl/api/v1/leads'), headers: _headers);
    if (resp.statusCode != 200) throw Exception('Failed to list leads');
    final List data = json.decode(resp.body);
    return data.map((e) => Lead.fromJson(e)).toList();
  }

  Future<Lead> createLead(String name, String? email) async {
    final body = json.encode({'name': name, 'email': email});
    final resp = await http.post(Uri.parse('$baseUrl/api/v1/leads'), headers: _headers, body: body);
    if (resp.statusCode != 200 && resp.statusCode != 201) throw Exception('Failed to create lead ${resp.body}');
    return Lead.fromJson(json.decode(resp.body));
  }

  Future<Lead> convertLead(int id) async {
    final resp = await http.post(Uri.parse('$baseUrl/api/v1/leads/$id/convert'), headers: _headers);
    if (resp.statusCode != 200) throw Exception('Failed to convert lead');
    return Lead.fromJson(json.decode(resp.body));
  }
}
