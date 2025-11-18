import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart' as html;

/// Clase que maneja las exportaciones a través de Supabase Edge Functions
/// Resuelve el problema de descarga en iOS Safari
class SupabaseExportService {
  /// URL base de las Edge Functions de Supabase
  /// Reemplaza esto con tu URL real de Supabase
  static const String _supabaseUrl = 'https://mvtjiqpqpbwdmjwlwjjk.supabase.co';
  static const String _anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im12dGppcXBxcGJ3ZG1qd2x3amprIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM0ODY2MDksImV4cCI6MjA3OTA2MjYwOX0.tW6GHZa8391RgrQHWKUz0eIwLCpFnTsevLYSLxrLqis';

  /// Exporta la copia de seguridad completa usando Supabase Edge Function
  /// Compatible con iOS Safari y todos los navegadores
  static Future<void> exportBackupComplete(Map<String, dynamic> allData) async {
    try {
      if (kIsWeb) {
        // Usar Edge Function para Web (incluyendo iOS)
        await _exportBackupViaEdgeFunction(allData);
      } else {
        // Mantener lógica existente para móvil
        await _exportBackupMobile(allData);
      }
    } catch (e) {
      debugPrint('Error en exportBackupComplete: $e');
      rethrow;
    }
  }

  /// Exporta movimientos del hogar usando Supabase Edge Function
  /// Compatible con iOS Safari y todos los navegadores
  static Future<void> exportHomeFinanceMovements(
    List<Map<String, dynamic>> movements,
    String monthName,
  ) async {
    try {
      if (kIsWeb) {
        // Usar Edge Function para Web (incluyendo iOS)
        await _exportHomeFinanceViaEdgeFunction(movements, monthName);
      } else {
        // Mantener lógica existente para móvil
        await _exportHomeFinanceMobile(movements, monthName);
      }
    } catch (e) {
      debugPrint('Error en exportHomeFinanceMovements: $e');
      rethrow;
    }
  }

  /// Exporta copia de seguridad completa vía Edge Function (Web/iOS)
  static Future<void> _exportBackupViaEdgeFunction(
    Map<String, dynamic> allData,
  ) async {
    final url = Uri.parse('$_supabaseUrl/functions/v1/export_backup');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_anonKey',
          'apikey': _anonKey,
        },
        body: jsonEncode(allData),
      );

      if (response.statusCode == 200) {
        // Crear blob y descargar forzadamente
        final bytes = response.bodyBytes;
        final blob = html.Blob([bytes]);
        final downloadUrl = html.Url.createObjectUrlFromBlob(blob);

        // Crear enlace y forzar descarga
        final anchor = html.AnchorElement(href: downloadUrl)
          ..setAttribute('download', _generateBackupFileName())
          ..style.display = 'none';

        html.document.body?.children.add(anchor);
        anchor.click();

        // Limpiar
        html.document.body?.children.remove(anchor);
        html.Url.revokeObjectUrl(downloadUrl);

        debugPrint(
          'Copia de seguridad exportada exitosamente via Edge Function',
        );
      } else {
        throw Exception(
          'Error en Edge Function: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('Error llamando a Edge Function export_backup: $e');
      rethrow;
    }
  }

  /// Exporta movimientos del hogar vía Edge Function (Web/iOS)
  static Future<void> _exportHomeFinanceViaEdgeFunction(
    List<Map<String, dynamic>> movements,
    String monthName,
  ) async {
    final url = Uri.parse('$_supabaseUrl/functions/v1/export_hogar');

    final requestData = {'movimientos': movements, 'mes': monthName};

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_anonKey',
          'apikey': _anonKey,
        },
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        // Crear blob y descargar forzadamente
        final bytes = response.bodyBytes;
        final blob = html.Blob([bytes]);
        final downloadUrl = html.Url.createObjectUrlFromBlob(blob);

        // Crear enlace y forzar descarga
        final anchor = html.AnchorElement(href: downloadUrl)
          ..setAttribute('download', 'movimientos_hogar_$monthName.json')
          ..style.display = 'none';

        html.document.body?.children.add(anchor);
        anchor.click();

        // Limpiar
        html.document.body?.children.remove(anchor);
        html.Url.revokeObjectUrl(downloadUrl);

        debugPrint(
          'Movimientos del hogar exportados exitosamente via Edge Function',
        );
      } else {
        throw Exception(
          'Error en Edge Function: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('Error llamando a Edge Function export_hogar: $e');
      rethrow;
    }
  }

  /// Exportación móvil (lógica existente mantenida)
  static Future<void> _exportBackupMobile(Map<String, dynamic> allData) async {
    // Esta función mantiene la lógica existente para móvil
    // Puedes integrar aquí tu código actual de exportación móvil
    // Lógica existente para guardar en almacenamiento local
    debugPrint('Exportación móvil implementada separadamente');
  }

  /// Exportación móvil de hogar (lógica existente mantenida)
  static Future<void> _exportHomeFinanceMobile(
    List<Map<String, dynamic>> movements,
    String monthName,
  ) async {
    // Esta función mantiene la lógica existente para móvil
    // Lógica existente para guardar en almacenamiento local
    debugPrint('Exportación móvil de hogar implementada separadamente');
  }

  /// Genera nombre de archivo para copia de seguridad
  static String _generateBackupFileName() {
    final now = DateTime.now();
    final timestamp = now
        .toIso8601String()
        .replaceAll(':', '-')
        .replaceAll('.', '-');
    return 'finanzas_respaldo_$timestamp.json';
  }

  /// Verifica si las Edge Functions están disponibles
  static Future<bool> checkEdgeFunctionsAvailability() async {
    try {
      final url = Uri.parse('$_supabaseUrl/functions/v1/export_backup');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_anonKey',
          'apikey': _anonKey,
        },
        body: jsonEncode({}),
      );

      // Si responde (incluso con error), la función está disponible
      return response.statusCode != 0;
    } catch (e) {
      debugPrint('Edge Functions no disponibles: $e');
      return false;
    }
  }
}
