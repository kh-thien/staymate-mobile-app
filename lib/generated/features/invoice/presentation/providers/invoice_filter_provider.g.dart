// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../../features/invoice/presentation/providers/invoice_filter_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Filter state for invoice tabs

@ProviderFor(InvoiceFilter)
const invoiceFilterProvider = InvoiceFilterProvider._();

/// Filter state for invoice tabs
final class InvoiceFilterProvider
    extends $NotifierProvider<InvoiceFilter, BillStatus?> {
  /// Filter state for invoice tabs
  const InvoiceFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'invoiceFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$invoiceFilterHash();

  @$internal
  @override
  InvoiceFilter create() => InvoiceFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BillStatus? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BillStatus?>(value),
    );
  }
}

String _$invoiceFilterHash() => r'f28d4db30a9c90257f33487a132f9dd6b46d3568';

/// Filter state for invoice tabs

abstract class _$InvoiceFilter extends $Notifier<BillStatus?> {
  BillStatus? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<BillStatus?, BillStatus?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BillStatus?, BillStatus?>,
              BillStatus?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
