import 'dart:async';
import 'dart:io';

import 'package:file_support/file_support.dart';
import 'package:flutter/material.dart';


extension imgfile on File {
  Future<File?> get compressfile =>
      FileSupport().compressImage(this, quality: 30); //
}

extension IndexedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(E e, int i) f) {
    var i = 0;
    return map((e) => f(e, i++));
  }
}

extension m_string on String {
  bool get isvalidUrl {
    if (Uri.parse(this).isAbsolute) {
      return true;
    }
    return false;
  }

  String get camelCase => this.isEmpty
      ? ''
      : this.length > 0
          ? '${this[0].toUpperCase()}${this.substring(1)}'
          : '';

  String get capitalCase => this
      .replaceAll(RegExp(' +'), ' ')
      .split(" ")
      .map((str) => str.camelCase)
      .join(" ");

  bool get isCamelCase {
    if (this.characters.first == this.characters.first.toUpperCase()) {
      return true;
    } else {
      return false;
    }
  }

  dynamic fromMap(Map json) {
    return json['$this'];
  }


  bool isEmail() {
    RegExp regExp = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    return regExp.hasMatch(this);
  }

  bool isPhone() {
    String pattern =
        r'^(?:\(?)(\d{3})(?:[\).\s]?)(\d{3})(?:[-\.\s]?)(\d{4})(?!\d)$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(this);
  }
}




