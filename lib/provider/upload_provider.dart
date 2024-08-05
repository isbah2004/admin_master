import 'dart:convert';
import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lcpl_admin/model/documentmodel.dart';
import 'package:lcpl_admin/utils/constants.dart';

class AppwriteServices extends ChangeNotifier {
  bool _pickerLoading = false, _uploadLoading = false;
  bool get pickerLoading => _pickerLoading;
  bool get uploadLoading => _uploadLoading;
  String? _url, _publicId, _signature;
  String? get url => _url;
  String? get signature => _signature;
  String? get publicId => _publicId;
  File? _file;
  File? get file => _file;

  Future<void> pickFile() async {
    _pickerLoading = true;
    notifyListeners();
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      _file = File(result.files.single.path!);
    } else {
      _file = null;
    }
    _pickerLoading = false;
    notifyListeners();
  }
}

class AppProvider extends ChangeNotifier {
  Client client = Client();
  late Account account;
  late Databases databases;
  late bool _isLoading;
  List<ListItem>? _listItem;

  bool get isLoading => _isLoading;
  List<ListItem>? get listItem => _listItem;

  AppProvider() {
    _isLoading = true;
    initialize();
  }

  initialize() {
    client
      ..setEndpoint(Constants.endpoint)
      ..setProject(Constants.projectid);

    account = Account(client);
    databases = Databases(client);
    createAnon();
  }

  createAnon() async {
    try {
      await account.get();
    } catch (_) {
      await account.createAnonymousSession();
      _isLoading = false;
      notifyListeners();
    }
  }

  createDocument(String newTitle, String newSubtitle, context) async {
    try {
      final response = await databases.createDocument(
          databaseId: Constants.databaseID,
          collectionId: Constants.collectionID,
          documentId: ID.unique(),
          data: {
            'title': 'name',
            'subtitle': 'subname',
            'newTitle': 'newTitle'
          });
      if (response.data.isNotEmpty) {
        await listDocument();
        Navigator.pop(context);
      }
    } catch (e) {
      rethrow;
    }
  }

  listDocument() async {
    try {
      final response = await databases.listDocuments(
          databaseId: Constants.databaseID,
          collectionId: Constants.collectionID);
      _listItem = response.documents
          .map((listitem) => ListItem.fromJson(listitem.data))
          .toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  updateDocument(
      String documentId, String updateTitle, String updateSubtitle) async {
    try {
      await databases.updateDocument(
          databaseId: Constants.databaseID,
          collectionId: Constants.collectionID,
          documentId: documentId,
          data: {'title': updateTitle, 'subtitle': updateSubtitle});
    } catch (e) {
      rethrow;
    }
  }

  removeReminder(String documentID, int index) async {
    try {
      await databases.deleteDocument(
          databaseId: Constants.databaseID,
          collectionId: Constants.collectionID,
          documentId: documentID);
      _listItem!.removeAt(index);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
