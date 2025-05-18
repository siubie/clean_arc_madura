import 'package:clean_arc_madura/features/auth/presentation/pages/login.dart';
import 'package:clean_arc_madura/service_locator.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'core/network/dio_client.dart';
import 'core/constants/api_urls.dart';

void main() {
  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toko Madura',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const LoginPage(),
    );
  }
}

class ApiTestPage extends StatefulWidget {
  const ApiTestPage({super.key, required this.title});

  final String title;

  @override
  State<ApiTestPage> createState() => _ApiTestPageState();
}

class _ApiTestPageState extends State<ApiTestPage> {
  final DioClient _dioClient = DioClient();
  String _connectionStatus = 'Not tested yet';
  String _loginStatus = 'Not tested yet';
  String _httpLoginStatus = 'Not tested yet';
  String _createBookStatus = 'Not tested yet';
  String _externalApiStatus = 'Not tested yet';
  bool _isLoading = false;
  bool _isLoginLoading = false;
  bool _isHttpLoginLoading = false;
  bool _isCreateBookLoading = false;
  bool _isExternalApiLoading = false;

  Future<void> _testApiConnection() async {
    setState(() {
      _isLoading = true;
      _connectionStatus = 'Testing connection...';
    });

    try {
      // Using the book endpoint for testing
      final response = await _dioClient.get(ApiUrls.book);

      setState(() {
        _isLoading = false;
        _connectionStatus =
            'Connection successful!\nStatus code: ${response.statusCode}\nData: ${response.data}';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _connectionStatus = 'Connection failed: ${e.toString()}';
      });
    }
  }

  Future<void> _testLogin() async {
    setState(() {
      _isLoginLoading = true;
      _loginStatus = 'Testing login with Dio...';
    });

    try {
      // Login data
      final loginData = {'email': 'admin@admin.com', 'password': ''};

      // Post request to login endpoint
      final response = await _dioClient.post(ApiUrls.login, data: loginData);

      setState(() {
        _isLoginLoading = false;
        _loginStatus =
            'Login successful!\nStatus code: ${response.statusCode}\nData: ${response.data}';
      });
    } catch (e) {
      setState(() {
        _isLoginLoading = false;
        _loginStatus = 'Login failed: ${e.toString()}';
      });
    }
  }

  Future<void> _testHttpLogin() async {
    setState(() {
      _isHttpLoginLoading = true;
      _httpLoginStatus = 'Testing login with HTTP package...';
    });

    try {
      // Login data
      final loginData = {'email': 'admin@admin.com', 'password': ''};

      // Print detailed info for debugging
      print('HTTP Request URL: ${ApiUrls.login}');
      print('HTTP Request Body: ${jsonEncode(loginData)}');

      // Post request to login endpoint using http package
      final response = await http.post(
        Uri.parse(ApiUrls.login),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(loginData),
      );

      setState(() {
        _isHttpLoginLoading = false;
        _httpLoginStatus =
            'HTTP Login response:\nStatus code: ${response.statusCode}\nBody: ${response.body}';
      });

      // Print detailed response for debugging
      print('HTTP Response status: ${response.statusCode}');
      print('HTTP Response body: ${response.body}');
    } catch (e) {
      print('HTTP Exception: $e');
      setState(() {
        _isHttpLoginLoading = false;
        _httpLoginStatus = 'HTTP Login failed: ${e.toString()}';
      });
    }
  }

  Future<void> _testCreateBook() async {
    setState(() {
      _isCreateBookLoading = true;
      _createBookStatus = 'Creating book with Dio...';
    });

    try {
      // Book data
      final bookData = {
        'title': 'Flutter Testing Book',
        'author': 'API Tester',
      };

      // Convert to FormData for Dio
      final formData = FormData.fromMap(bookData);
      // Post request to create a book
      final response = await _dioClient.post(ApiUrls.book);

      setState(() {
        _isCreateBookLoading = false;
        _createBookStatus =
            'Book created successfully!\nStatus code: ${response.statusCode}\nData: ${response.data}';
      });

      // Print response for debugging
      print('Book Create Response status: ${response.statusCode}');
      print('Book Create Response data: ${response.data}');
    } catch (e) {
      print('Book Create Exception: $e');
      setState(() {
        _isCreateBookLoading = false;
        _createBookStatus = 'Book creation failed: ${e.toString()}';
      });
    }
  }

  Future<void> _testExternalApi() async {
    setState(() {
      _isExternalApiLoading = true;
      _externalApiStatus = 'Testing external API with Dio...';
    });

    try {
      // External API URL
      const String externalApiUrl = 'https://dummyjson.com/auth/login';

      // Login data for dummy API
      final loginData = {'username': 'a', 'password': 'b'};

      // Print request details for debugging
      print('External API URL: $externalApiUrl');
      print('External API Body: ${jsonEncode(loginData)}');

      // Post request to external API
      final response = await _dioClient.post(externalApiUrl, data: loginData);

      setState(() {
        _isExternalApiLoading = false;
        _externalApiStatus =
            'External API successful!\nStatus code: ${response.statusCode}\nData: ${response.data}';
      });

      // Print response for debugging
      print('External API Response status: ${response.statusCode}');
      print('External API Response data: ${response.data}');
    } catch (e) {
      print('External API Exception: $e');
      setState(() {
        _isExternalApiLoading = false;
        _externalApiStatus = 'External API failed: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'API Connection Test',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _testApiConnection,
                    child: const Text('Test GET API Connection'),
                  ),
                const SizedBox(height: 30),
                const Text(
                  'Connection Status:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color:
                        _connectionStatus.contains('successful')
                            ? Colors.green.shade100
                            : _connectionStatus.contains('failed')
                            ? Colors.red.shade100
                            : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _connectionStatus,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color:
                          _connectionStatus.contains('successful')
                              ? Colors.green.shade900
                              : _connectionStatus.contains('failed')
                              ? Colors.red.shade900
                              : Colors.grey.shade800,
                    ),
                  ),
                ),

                // External API Test Section
                const SizedBox(height: 40),
                const Text(
                  'External API Test (DummyJSON)',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                if (_isExternalApiLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _testExternalApi,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Test External API'),
                  ),
                const SizedBox(height: 30),
                const Text(
                  'External API Status:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color:
                        _externalApiStatus.contains('successful')
                            ? Colors.green.shade100
                            : _externalApiStatus.contains('failed')
                            ? Colors.red.shade100
                            : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _externalApiStatus,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color:
                          _externalApiStatus.contains('successful')
                              ? Colors.green.shade900
                              : _externalApiStatus.contains('failed')
                              ? Colors.red.shade900
                              : Colors.grey.shade800,
                    ),
                  ),
                ),

                const SizedBox(height: 40),
                const Text(
                  'Login API Test (Dio)',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                if (_isLoginLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _testLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Test Dio Login'),
                  ),
                const SizedBox(height: 30),
                const Text(
                  'Dio Login Status:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color:
                        _loginStatus.contains('successful')
                            ? Colors.green.shade100
                            : _loginStatus.contains('failed')
                            ? Colors.red.shade100
                            : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _loginStatus,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color:
                          _loginStatus.contains('successful')
                              ? Colors.green.shade900
                              : _loginStatus.contains('failed')
                              ? Colors.red.shade900
                              : Colors.grey.shade800,
                    ),
                  ),
                ),

                // HTTP Package Test Section
                const SizedBox(height: 40),
                const Text(
                  'Login API Test (HTTP)',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                if (_isHttpLoginLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _testHttpLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Test HTTP Login'),
                  ),
                const SizedBox(height: 30),
                const Text(
                  'HTTP Login Status:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color:
                        _httpLoginStatus.contains('200')
                            ? Colors.green.shade100
                            : _httpLoginStatus.contains('failed')
                            ? Colors.red.shade100
                            : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _httpLoginStatus,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color:
                          _httpLoginStatus.contains('200')
                              ? Colors.green.shade900
                              : _httpLoginStatus.contains('failed')
                              ? Colors.red.shade900
                              : Colors.grey.shade800,
                    ),
                  ),
                ),

                // Create Book Test Section
                const SizedBox(height: 40),
                const Text(
                  'Create Book Test (Dio)',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                if (_isCreateBookLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _testCreateBook,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Test Create Book'),
                  ),
                const SizedBox(height: 30),
                const Text(
                  'Create Book Status:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color:
                        _createBookStatus.contains('successfully')
                            ? Colors.green.shade100
                            : _createBookStatus.contains('failed')
                            ? Colors.red.shade100
                            : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _createBookStatus,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color:
                          _createBookStatus.contains('successfully')
                              ? Colors.green.shade900
                              : _createBookStatus.contains('failed')
                              ? Colors.red.shade900
                              : Colors.grey.shade800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
