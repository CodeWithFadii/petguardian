import 'dart:developer';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petguardian/resources/constants/constants.dart';
import 'package:petguardian/resources/utils.dart';

class SubscriptionController extends GetxController {
  final InAppPurchase _iap = InAppPurchase.instance;
  final RxList<ProductDetails> products = <ProductDetails>[].obs;
  final RxBool isAvailable = false.obs;
  final RxBool purchasePending = false.obs;
  final Rx<ProductDetails?> selectedProduct = Rx<ProductDetails?>(null);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  Future<void> _initialize() async {
    isAvailable.value = await _iap.isAvailable();
    if (isAvailable.value) {
      await _loadProducts();
      _iap.purchaseStream.listen(_onPurchaseUpdated);
    }
  }

  Future<void> _loadProducts() async {
    const Set<String> _kIds = {'monthly', 'weekly'};
    final ProductDetailsResponse response = await _iap.queryProductDetails(_kIds);
    if (response.notFoundIDs.isNotEmpty) {
      log('Products not found: ${response.notFoundIDs}');
    }
    products.assignAll(response.productDetails);
    if (products.isNotEmpty && selectedProduct.value == null) {
      selectedProduct.value = products.first;
    }
  }

  void buy(ProductDetails product) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  void _onPurchaseUpdated(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased) {
        // Handle successful purchase
        _handleSuccessfulPurchase(purchase);
      } else if (purchase.status == PurchaseStatus.error) {
        log('Purchase error: ${purchase.error}');
        Get.snackbar('Error', 'Purchase failed: ${purchase.error?.message}');
      } else if (purchase.status == PurchaseStatus.canceled) {
        log('Purchase canceled');
        Get.snackbar('Canceled', 'Purchase was canceled');
      }

      if (purchase.pendingCompletePurchase) {
        _iap.completePurchase(purchase);
      }
    }
  }

  Future<void> _handleSuccessfulPurchase(PurchaseDetails purchase) async {
    loaderC.showLoader();
    try {
      final user = _auth.currentUser;
      if (user == null) {
        log('No authenticated user found');
        Get.snackbar('Error', 'Please sign in to complete the purchase');
        return;
      }

      // Determine plan duration based on selected product
      final selected = selectedProduct.value;
      if (selected == null) {
        log('No selected product');
        return;
      }

      DateTime planEndDate;
      if (selected.id == 'monthly') {
        planEndDate = DateTime.now().add(Duration(days: 30)); // 30 days for monthly
      } else if (selected.id == 'weekly') {
        planEndDate = DateTime.now().add(Duration(days: 7)); // 7 days for weekly
      } else {
        log('Unknown product ID: ${selected.id}');
        return;
      }

      // Update Firestore user document
      await _firestore.collection('users').doc(user.uid).update({
        'isPaid': true,
        'planEndDate': Timestamp.fromDate(planEndDate),
      }); // Use merge to avoid overwriting other fields
      await Utils.uploadNotificationToFirebase(
        title: 'Subscription activated',
        body: 'Your ${selected.id} subscription activated',
      );
      await userC.getCurrentUserData();
      Get.back();
      Get.snackbar('Success', 'Subscription activated successfully!');
      log('Firestore updated: isPaid=true, planEndDate=$planEndDate');
    } catch (e) {
      log('Error updating Firestore: $e');
      Get.snackbar('Error', 'Failed to update subscription status');
    } finally {
      loaderC.hideLoader();
    }
  }

  void selectProduct(ProductDetails product) {
    selectedProduct.value = product;
  }
}
