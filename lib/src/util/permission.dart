// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';

import 'package:aquavista/src/util/dialogs.dart';

Future<bool> checkPermissions(BuildContext context) async {
  if (await permissionStatusHandler(
      context, Permission.location, 'localización')) {
    if (await permissionStatusHandler(
        context, Permission.storage, 'Almacenamiento')) {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}

Future<bool> permissionStatusHandler(
    BuildContext context, Permission permission, String permissionName) async {
  PermissionStatus status = await permission.request();
  if (status != PermissionStatus.granted) {
    switch (status) {
      case PermissionStatus.denied:
        {
          await permissionStatusHandler(context, permission, permissionName);
        }
        break;
      case PermissionStatus.restricted:
        await permissionRequiredDialog(context, permissionName);
        await openAppSettings();
        break;
      case PermissionStatus.limited:
        await permissionRequiredDialog(context, permissionName);
        await openAppSettings();
        break;
      case PermissionStatus.permanentlyDenied:
        await permissionRequiredDialog(context, permissionName);
        await openAppSettings();
        break;
      default:
    }
  }
  return status.isGranted;
}

Future<void> permissionRequiredDialog(
        BuildContext context, String permissionName) async =>
    await transactionFailed(context, 'Permiso Requerido',
        'El siguiente permiso es requerido y obligatorio: $permissionName. Favor de habilitar el permiso en las opciones de este dispositivo.');
