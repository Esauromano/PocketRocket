import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class GPXFileManager extends StatefulWidget {
  const GPXFileManager({Key? key}) : super(key: key);

  @override
  _GPXFileManagerState createState() => _GPXFileManagerState();
}

class _GPXFileManagerState extends State<GPXFileManager> {
  List<FileSystemEntity> _files = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    setState(() => _isLoading = true);
    final directory = await getApplicationDocumentsDirectory();
    final files = directory
        .listSync()
        .where((file) => file.path.endsWith('.gpx'))
        .toList();
    files
        .sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));
    setState(() {
      _files = files;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GPX Files'),
        backgroundColor: const Color(0xFFFFD700),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _files.isEmpty
              ? const Center(child: Text('No GPX files found'))
              : RefreshIndicator(
                  onRefresh: _loadFiles,
                  child: ListView.builder(
                    itemCount: _files.length,
                    itemBuilder: (context, index) {
                      final file = _files[index];
                      final fileName = file.path.split('/').last;
                      final fileStats = file.statSync();
                      final fileDate = DateFormat('yyyy-MM-dd HH:mm')
                          .format(fileStats.modified);
                      return ListTile(
                        title: Text(fileName),
                        subtitle: Text(fileDate),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.share),
                              onPressed: () => _shareFile(file.path),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteFile(file),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  void _shareFile(String path) {
    Share.shareXFiles([XFile(path)], text: 'Sharing GPX file');
  }

  void _deleteFile(FileSystemEntity file) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete File'),
          content: const Text('Are you sure you want to delete this file?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                file.deleteSync();
                Navigator.of(context).pop();
                _loadFiles();
              },
            ),
          ],
        );
      },
    );
  }
}
