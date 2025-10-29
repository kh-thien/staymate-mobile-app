import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/contract_entity.dart';
import '../../domain/repositories/contract_repository.dart';
import '../models/contract_model.dart';

class ContractRepositoryImpl implements ContractRepository {
  final SupabaseClient _supabase;

  ContractRepositoryImpl({SupabaseClient? supabase})
    : _supabase = supabase ?? Supabase.instance.client;

  @override
  Future<String?> getTenantIdByUserId(String userId) async {
    try {
      final response = await _supabase
          .from('tenants')
          .select('id')
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return response['id'] as String?;
    } catch (e) {
      print('Error getting tenant ID: $e');
      return null;
    }
  }

  @override
  Future<List<ContractEntity>> getContractsByTenantId(String tenantId) async {
    try {
      final response = await _supabase
          .from('contracts')
          .select()
          .eq('tenant_id', tenantId)
          .order('created_at', ascending: false);

      final contracts = (response as List)
          .map((json) => ContractModel.fromJson(json))
          .toList();

      return contracts
          .map(
            (model) => ContractEntity(
              id: model.id,
              roomId: model.roomId,
              tenantId: model.tenantId,
              contractNumber: model.contractNumber,
              status: model.status,
              startDate: model.startDate,
              endDate: model.endDate,
              monthlyRent: model.monthlyRent,
              deposit: model.deposit,
              paymentCycle: model.paymentCycle,
              createdAt: model.createdAt,
            ),
          )
          .toList();
    } catch (e) {
      print('Error getting contracts: $e');
      return [];
    }
  }
}
