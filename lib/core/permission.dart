import 'package:simple_permissions/simple_permissions.dart';


/// Class for request Android OS permission
class OperatingSystemPermission {

  /// Permission 
  Permission permission;

  /// requestUserPermission in Android devices
  Future<void> requestAndroidUserPermission() async {
    
    final bool isCameraAccessed = await SimplePermissions.checkPermission(Permission.Camera);
    final bool isReadContactsAccessed = await SimplePermissions.checkPermission(Permission.ReadContacts);
    final bool isWriteContactsAccessed = await SimplePermissions.checkPermission(Permission.WriteContacts);
    final bool isExternalDriveAccessed = await SimplePermissions.checkPermission(Permission.ReadExternalStorage);
    final bool isReadSmsAccessed = await SimplePermissions.checkPermission(Permission.ReadSms);
    final bool isWriteSmsAccessed = await SimplePermissions.checkPermission(Permission.SendSMS);
    final bool isAandroidCoarseLocationAccessed = await SimplePermissions.checkPermission(Permission.AccessCoarseLocation);
    final bool isAndroidFineLocationAccessed = await SimplePermissions.checkPermission(Permission.AccessFineLocation);
    final bool isMicrophoneAccessed = await SimplePermissions.checkPermission(Permission.RecordAudio);

    if (!isCameraAccessed) {
      await SimplePermissions.requestPermission(Permission.Camera);
    } // else Do nothing

    if (!isReadContactsAccessed || !isWriteContactsAccessed) {
      await SimplePermissions.requestPermission(Permission.ReadContacts);
      await SimplePermissions.requestPermission(Permission.WriteContacts);
    } // else Do nothing

    if (!isExternalDriveAccessed) {
      await SimplePermissions.requestPermission(Permission.ReadExternalStorage); 
    } // else Do nothing

    if (!isReadSmsAccessed || !isWriteSmsAccessed) {
      await SimplePermissions.requestPermission(Permission.ReadSms);
      await SimplePermissions.requestPermission(Permission.SendSMS);
    } // else Do nothing

    if (!isAndroidFineLocationAccessed || !isAandroidCoarseLocationAccessed) {
      /// this only works on Android devices
      await SimplePermissions.requestPermission(Permission.AccessCoarseLocation);
      await SimplePermissions.requestPermission(Permission.AccessFineLocation);
    } // else Do nothing

    if (!isMicrophoneAccessed) {
      await SimplePermissions.requestPermission(Permission.RecordAudio);
    } // else Do nothing
  }

  /// requestUserPermission in iOS devices
  Future<void> requestIOSUserPermission() async {
    final bool isCameraAccessed = await SimplePermissions.checkPermission(Permission.Camera);
    final bool isReadContactsAccessed = await SimplePermissions.checkPermission(Permission.ReadContacts);
    final bool isWriteContactsAccessed = await SimplePermissions.checkPermission(Permission.WriteContacts);
    final bool isPhotoLibAccessed = await SimplePermissions.checkPermission(Permission.PhotoLibrary);
    final bool isReadSmsAccessed = await SimplePermissions.checkPermission(Permission.ReadSms);
    final bool isWriteSmsAccessed = await SimplePermissions.checkPermission(Permission.SendSMS);
    final bool isAlwaysLocationAccessed = await SimplePermissions.checkPermission(Permission.AlwaysLocation);
    final bool isMicrophoneAccessed = await SimplePermissions.checkPermission(Permission.RecordAudio);

    // * Coded spereately and sort One by one as requested by Apple.inc,
    // * if using constructors, will be suspend. Any slight adjustment will be effected on
    // * Apple Security Policies, even if it is working on Android.

    if (!isCameraAccessed) {
      await SimplePermissions.requestPermission(Permission.Camera);
    } // else Do nothing

    if (!isReadContactsAccessed || !isWriteContactsAccessed) {
      await SimplePermissions.requestPermission(Permission.ReadContacts);
      await SimplePermissions.requestPermission(Permission.WriteContacts);
    } // else Do nothing

    if (!isPhotoLibAccessed) {
      await SimplePermissions.requestPermission(Permission.PhotoLibrary);
    } // else Do nothing

    if (!isReadSmsAccessed || !isWriteSmsAccessed) {
      await SimplePermissions.requestPermission(Permission.ReadSms);
      await SimplePermissions.requestPermission(Permission.SendSMS);
    } // else Do nothing

    if (!isAlwaysLocationAccessed) {
      /// ios_location this only works in IOS Devices
      await SimplePermissions.requestPermission(Permission.AlwaysLocation);
    } // else Do nothing

    if (!isMicrophoneAccessed) {
      await SimplePermissions.requestPermission(Permission.RecordAudio);
    } // else Do nothing
  }
}