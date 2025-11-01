// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../../features/invoice/presentation/providers/filtered_invoices_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provide filtered invoices based on selected tab

@ProviderFor(filteredInvoices)
const filteredInvoicesProvider = FilteredInvoicesProvider._();

/// Provide filtered invoices based on selected tab

final class FilteredInvoicesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Invoice>>,
          List<Invoice>,
          FutureOr<List<Invoice>>
        >
    with $FutureModifier<List<Invoice>>, $FutureProvider<List<Invoice>> {
  /// Provide filtered invoices based on selected tab
  const FilteredInvoicesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredInvoicesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredInvoicesHash();

  @$internal
  @override
  $FutureProviderElement<List<Invoice>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Invoice>> create(Ref ref) {
    return filteredInvoices(ref);
  }
}

String _$filteredInvoicesHash() => r'03cfd4258788bbee255c3c81b174ed1f3037db6b';

/// Provide filtered invoices stream with realtime updates

@ProviderFor(filteredInvoicesStream)
const filteredInvoicesStreamProvider = FilteredInvoicesStreamProvider._();

/// Provide filtered invoices stream with realtime updates

final class FilteredInvoicesStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Invoice>>,
          List<Invoice>,
          Stream<List<Invoice>>
        >
    with $FutureModifier<List<Invoice>>, $StreamProvider<List<Invoice>> {
  /// Provide filtered invoices stream with realtime updates
  const FilteredInvoicesStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredInvoicesStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredInvoicesStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<Invoice>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Invoice>> create(Ref ref) {
    return filteredInvoicesStream(ref);
  }
}

String _$filteredInvoicesStreamHash() =>
    r'1e6a2b54882e3bab9f203397993f94aec0289d3e';
