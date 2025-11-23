// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../../features/invoice/presentation/providers/invoice_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provide Supabase client

@ProviderFor(supabaseClient)
const supabaseClientProvider = SupabaseClientProvider._();

/// Provide Supabase client

final class SupabaseClientProvider
    extends $FunctionalProvider<SupabaseClient, SupabaseClient, SupabaseClient>
    with $Provider<SupabaseClient> {
  /// Provide Supabase client
  const SupabaseClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'supabaseClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$supabaseClientHash();

  @$internal
  @override
  $ProviderElement<SupabaseClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SupabaseClient create(Ref ref) {
    return supabaseClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SupabaseClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SupabaseClient>(value),
    );
  }
}

String _$supabaseClientHash() => r'834a58d6ae4b94e36f4e04a10d8a7684b929310e';

/// Provide datasource

@ProviderFor(invoiceRemoteDatasource)
const invoiceRemoteDatasourceProvider = InvoiceRemoteDatasourceProvider._();

/// Provide datasource

final class InvoiceRemoteDatasourceProvider
    extends
        $FunctionalProvider<
          InvoiceRemoteDatasource,
          InvoiceRemoteDatasource,
          InvoiceRemoteDatasource
        >
    with $Provider<InvoiceRemoteDatasource> {
  /// Provide datasource
  const InvoiceRemoteDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'invoiceRemoteDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$invoiceRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<InvoiceRemoteDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InvoiceRemoteDatasource create(Ref ref) {
    return invoiceRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InvoiceRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InvoiceRemoteDatasource>(value),
    );
  }
}

String _$invoiceRemoteDatasourceHash() =>
    r'a81009c87b14fa2c1907c84c815ede052d8e313c';

/// Provide repository

@ProviderFor(invoiceRepository)
const invoiceRepositoryProvider = InvoiceRepositoryProvider._();

/// Provide repository

final class InvoiceRepositoryProvider
    extends
        $FunctionalProvider<
          InvoiceRepository,
          InvoiceRepository,
          InvoiceRepository
        >
    with $Provider<InvoiceRepository> {
  /// Provide repository
  const InvoiceRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'invoiceRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$invoiceRepositoryHash();

  @$internal
  @override
  $ProviderElement<InvoiceRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InvoiceRepository create(Ref ref) {
    return invoiceRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InvoiceRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InvoiceRepository>(value),
    );
  }
}

String _$invoiceRepositoryHash() => r'4df9245524325ced87566185d7e317c768aac8dd';

/// Get all invoices

@ProviderFor(invoices)
const invoicesProvider = InvoicesProvider._();

/// Get all invoices

final class InvoicesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Invoice>>,
          List<Invoice>,
          FutureOr<List<Invoice>>
        >
    with $FutureModifier<List<Invoice>>, $FutureProvider<List<Invoice>> {
  /// Get all invoices
  const InvoicesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'invoicesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$invoicesHash();

  @$internal
  @override
  $FutureProviderElement<List<Invoice>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Invoice>> create(Ref ref) {
    return invoices(ref);
  }
}

String _$invoicesHash() => r'c66fe061e535cd98760599cc142da0ee66fd1bba';

/// Stream invoices with realtime updates

@ProviderFor(invoicesStream)
const invoicesStreamProvider = InvoicesStreamProvider._();

/// Stream invoices with realtime updates

final class InvoicesStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Invoice>>,
          List<Invoice>,
          Stream<List<Invoice>>
        >
    with $FutureModifier<List<Invoice>>, $StreamProvider<List<Invoice>> {
  /// Stream invoices with realtime updates
  const InvoicesStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'invoicesStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$invoicesStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<Invoice>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Invoice>> create(Ref ref) {
    return invoicesStream(ref);
  }
}

String _$invoicesStreamHash() => r'7ec9193c2165a44c9cd656cea33bfedad53ea240';

/// Get invoice detail

@ProviderFor(invoiceDetail)
const invoiceDetailProvider = InvoiceDetailFamily._();

/// Get invoice detail

final class InvoiceDetailProvider
    extends $FunctionalProvider<AsyncValue<Invoice>, Invoice, FutureOr<Invoice>>
    with $FutureModifier<Invoice>, $FutureProvider<Invoice> {
  /// Get invoice detail
  const InvoiceDetailProvider._({
    required InvoiceDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'invoiceDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$invoiceDetailHash();

  @override
  String toString() {
    return r'invoiceDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Invoice> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Invoice> create(Ref ref) {
    final argument = this.argument as String;
    return invoiceDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is InvoiceDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$invoiceDetailHash() => r'64e507f7836c6fcdde7be67d07956a35a93d6210';

/// Get invoice detail

final class InvoiceDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Invoice>, String> {
  const InvoiceDetailFamily._()
    : super(
        retry: null,
        name: r'invoiceDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Get invoice detail

  InvoiceDetailProvider call(String billId) =>
      InvoiceDetailProvider._(argument: billId, from: this);

  @override
  String toString() => r'invoiceDetailProvider';
}

/// Get invoices by status (with filtering)

@ProviderFor(invoicesByStatus)
const invoicesByStatusProvider = InvoicesByStatusFamily._();

/// Get invoices by status (with filtering)

final class InvoicesByStatusProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Invoice>>,
          List<Invoice>,
          FutureOr<List<Invoice>>
        >
    with $FutureModifier<List<Invoice>>, $FutureProvider<List<Invoice>> {
  /// Get invoices by status (with filtering)
  const InvoicesByStatusProvider._({
    required InvoicesByStatusFamily super.from,
    required BillStatus? super.argument,
  }) : super(
         retry: null,
         name: r'invoicesByStatusProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$invoicesByStatusHash();

  @override
  String toString() {
    return r'invoicesByStatusProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Invoice>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Invoice>> create(Ref ref) {
    final argument = this.argument as BillStatus?;
    return invoicesByStatus(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is InvoicesByStatusProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$invoicesByStatusHash() => r'060ba40ff6812e2737bda6f2b877b4bd775b9480';

/// Get invoices by status (with filtering)

final class InvoicesByStatusFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Invoice>>, BillStatus?> {
  const InvoicesByStatusFamily._()
    : super(
        retry: null,
        name: r'invoicesByStatusProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Get invoices by status (with filtering)

  InvoicesByStatusProvider call(BillStatus? status) =>
      InvoicesByStatusProvider._(argument: status, from: this);

  @override
  String toString() => r'invoicesByStatusProvider';
}

/// Get upcoming invoices (unpaid/processing/overdue with dueDate within 3 days)

@ProviderFor(upcomingInvoices)
const upcomingInvoicesProvider = UpcomingInvoicesProvider._();

/// Get upcoming invoices (unpaid/processing/overdue with dueDate within 3 days)

final class UpcomingInvoicesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Invoice>>,
          List<Invoice>,
          FutureOr<List<Invoice>>
        >
    with $FutureModifier<List<Invoice>>, $FutureProvider<List<Invoice>> {
  /// Get upcoming invoices (unpaid/processing/overdue with dueDate within 3 days)
  const UpcomingInvoicesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'upcomingInvoicesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$upcomingInvoicesHash();

  @$internal
  @override
  $FutureProviderElement<List<Invoice>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Invoice>> create(Ref ref) {
    return upcomingInvoices(ref);
  }
}

String _$upcomingInvoicesHash() => r'faacc713ddab967d95e2d7a05e77c3a118708dd4';

/// Get landlord's payment account for an invoice

@ProviderFor(landlordPaymentAccount)
const landlordPaymentAccountProvider = LandlordPaymentAccountFamily._();

/// Get landlord's payment account for an invoice

final class LandlordPaymentAccountProvider
    extends
        $FunctionalProvider<
          AsyncValue<PaymentAccount?>,
          PaymentAccount?,
          FutureOr<PaymentAccount?>
        >
    with $FutureModifier<PaymentAccount?>, $FutureProvider<PaymentAccount?> {
  /// Get landlord's payment account for an invoice
  const LandlordPaymentAccountProvider._({
    required LandlordPaymentAccountFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'landlordPaymentAccountProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$landlordPaymentAccountHash();

  @override
  String toString() {
    return r'landlordPaymentAccountProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<PaymentAccount?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PaymentAccount?> create(Ref ref) {
    final argument = this.argument as String;
    return landlordPaymentAccount(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LandlordPaymentAccountProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$landlordPaymentAccountHash() =>
    r'52dce559a466470817ea34006b56e09894b9bcb4';

/// Get landlord's payment account for an invoice

final class LandlordPaymentAccountFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<PaymentAccount?>, String> {
  const LandlordPaymentAccountFamily._()
    : super(
        retry: null,
        name: r'landlordPaymentAccountProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Get landlord's payment account for an invoice

  LandlordPaymentAccountProvider call(String billId) =>
      LandlordPaymentAccountProvider._(argument: billId, from: this);

  @override
  String toString() => r'landlordPaymentAccountProvider';
}

/// Get payment account from payment (receiving_account)

@ProviderFor(paymentAccountFromPayment)
const paymentAccountFromPaymentProvider = PaymentAccountFromPaymentFamily._();

/// Get payment account from payment (receiving_account)

final class PaymentAccountFromPaymentProvider
    extends
        $FunctionalProvider<
          AsyncValue<PaymentAccount?>,
          PaymentAccount?,
          FutureOr<PaymentAccount?>
        >
    with $FutureModifier<PaymentAccount?>, $FutureProvider<PaymentAccount?> {
  /// Get payment account from payment (receiving_account)
  const PaymentAccountFromPaymentProvider._({
    required PaymentAccountFromPaymentFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'paymentAccountFromPaymentProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$paymentAccountFromPaymentHash();

  @override
  String toString() {
    return r'paymentAccountFromPaymentProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<PaymentAccount?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PaymentAccount?> create(Ref ref) {
    final argument = this.argument as String;
    return paymentAccountFromPayment(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PaymentAccountFromPaymentProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$paymentAccountFromPaymentHash() =>
    r'204a459dc133788c6469639b31c548fb4c6bf402';

/// Get payment account from payment (receiving_account)

final class PaymentAccountFromPaymentFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<PaymentAccount?>, String> {
  const PaymentAccountFromPaymentFamily._()
    : super(
        retry: null,
        name: r'paymentAccountFromPaymentProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Get payment account from payment (receiving_account)

  PaymentAccountFromPaymentProvider call(String billId) =>
      PaymentAccountFromPaymentProvider._(argument: billId, from: this);

  @override
  String toString() => r'paymentAccountFromPaymentProvider';
}
