import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signalr_core/signalr_core.dart';
import '../utils/snackbar_get.dart';
import '../view_models/auth_view_model.dart';
import '../view_models/job_view_model.dart';

class SignalRService extends GetxService {
  late HubConnection _hubConnection;
  final RxBool isConnected = false.obs;
  bool _isEventHandlerRegistered = false;

  final Rx<Map<String, dynamic>> refreshJobApplications = Rx<Map<String, dynamic>>({'jobId': null, 'refresh': false});

  HubConnection get hubConnection => _hubConnection;

  @override
  void onInit() {
    super.onInit();
    _startConnection();
  }

  Future<void> _startConnection() async {
    _hubConnection = HubConnectionBuilder()
        .withUrl('https://192.168.1.6:5001/serviceHub')
        .build();

    _hubConnection.onclose((error) {
      isConnected.value = false;
      Get.snackbar(
        'Disconnected',
        'SignalR connection was lost!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    });

    await _registerEventHandlers();

    await _hubConnection.start();
    isConnected.value = true;

    // Get.snackbar(
    //   'Connected',
    //   'SignalR connection established successfully!',
    //   snackPosition: SnackPosition.BOTTOM,
    //   backgroundColor: Colors.green,
    //   colorText: Colors.white,
    // );
  }

  Future<void> _registerEventHandlers() async {
    if (!_isEventHandlerRegistered) {
      hubConnection.on('createdApplication', (arguments) async {
        if (await _hasRole('Admin')) {
          if (arguments != null && arguments.isNotEmpty) {
            SnackbarUtils.showSuccessSnackbar('An application for your job ${arguments[0]} was created.');
            refreshJobApplications.value = {'jobId': arguments[0], 'refresh': true};
          }
        } else if (await _hasRole('Employer') && arguments != null && arguments.isNotEmpty && await _isJobOwner(arguments[0])) {
          print('Arguments: $arguments'); // Debug print statement
          SnackbarUtils.showSuccessSnackbar('An application for your job ${arguments[0]} was created.');
          refreshJobApplications.value = {'jobId': arguments[0], 'refresh': true};
        }
      });


      _hubConnection.on('updatedApplication', (arguments) async {
        if (await _hasRole('Admin')) {
          if (arguments != null && arguments.isNotEmpty) {
            SnackbarUtils.showSuccessSnackbar('An application for your job ${arguments[0]} was updated.');
            refreshJobApplications.value = {'jobId': arguments[0], 'refresh': true};
          }
        } else if (await _hasRole('Employer') && arguments != null && arguments.isNotEmpty && await _isJobOwner(arguments[0])) {
          SnackbarUtils.showSuccessSnackbar('An application for your job ${arguments[0]} was updated.');
          refreshJobApplications.value = {'jobId': arguments[0], 'refresh': true};
        }
      });

      _hubConnection.on('deletedApplication', (arguments) async {
        if (await _hasRole('Admin')) {
          if (arguments != null && arguments.isNotEmpty) {
            SnackbarUtils.showSuccessSnackbar('An application for your job ${arguments[0]} was deleted.');
            refreshJobApplications.value = {'jobId': arguments[0], 'refresh': true};
          }
        } else if (await _hasRole('Employer') && arguments != null && arguments.isNotEmpty && await _isJobOwner(arguments[0])) {
          SnackbarUtils.showSuccessSnackbar('An application for your job = ${arguments[0]} was deleted.');
          refreshJobApplications.value = {'jobId': arguments[0], 'refresh': true};
        }
      });

      _isEventHandlerRegistered = true;
    }
  }

  Future<bool> _isJobOwner(int jobId) async {
    final AuthViewModel authViewModel = Get.find<AuthViewModel>();
    final JobViewModel jobViewModel = Get.find<JobViewModel>();
    await jobViewModel.fetchJobsPostByEmployer(authViewModel.userId.value);
    return jobViewModel.postedJobs.any((job) => job.id == jobId);
  }

  Future<bool> _hasRole(String role) async {
    final AuthViewModel authViewModel = Get.find<AuthViewModel>();
    return authViewModel.role.value == role;
  }

  @override
  void onClose() {
    _hubConnection.stop();
    super.onClose();
  }
}