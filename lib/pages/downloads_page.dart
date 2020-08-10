import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rutorrentflutter/components/file_tile.dart';

class DownloadsPage extends StatefulWidget {
  @override
  _DownloadsPageState createState() => _DownloadsPageState();
}

class _DownloadsPageState extends State<DownloadsPage> {
  List<FileSystemEntity> filesList = [];
  String _homeDirectory;
  String directory;

  @override
  void initState() {
    super.initState();
    _initFilesList();
  }

  _initFilesList() async{
    _homeDirectory = (await getExternalStorageDirectory()).path;
    directory = _homeDirectory;
    _syncFiles();
  }

  _syncFiles(){
    setState(() {
      filesList = Directory("$directory/").listSync();
    });
  }

  Future<bool> _onBackPress() async{
    if(directory!=_homeDirectory) {
      String temp = directory.substring(0, directory.lastIndexOf('/'));
      directory = temp.substring(0,temp.lastIndexOf('/')+1);
      _syncFiles();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPress,
      child: Scaffold(
        body: Container(
            child: Column(
          children: <Widget>[
              ListTile(
                title: Text(
                'Files (${filesList.length})',
                style: TextStyle(fontWeight: FontWeight.w600),
                ),
            ),
             Expanded(
              child: ListView.builder(
                itemCount: filesList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: (){
                      if(filesList[index] is Directory) {
                        directory = filesList[index].path + '/';
                        _syncFiles();
                      }
                    },
                    leading: Icon(filesList[index] is Directory?Icons.folder:FileTile.getFileIcon(filesList[index].path)),
                    title: Text(filesList[index]
                        .path
                        .substring(filesList[index].path.lastIndexOf('/') + 1),
                    style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),),
                  );
                },
              ),
            ),
          ],
        )),
      ),
    );
  }
}
