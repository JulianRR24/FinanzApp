// 📦 main.dart - App completa reestructurada con un diseño moderno y minimalista
// Todo el código original está aquí, reorganizado para mayor claridad y con una nueva UI.

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:excel/excel.dart' hide Border;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';

// Formateador de moneda global para toda la aplicación
final formatoMoneda = NumberFormat.currency(
  locale: 'es_CO',
  symbol: '\$',
  decimalDigits: 0,
);

//==============================================================================
// 🎨 SECCIÓN DE TEMA Y ESTILOS GLOBALES
//==============================================================================

class TemaApp {
  static const Color _colorPrimario = Color(0xFF00897B); // Teal oscuro
  static const Color _colorAcentoClaro = Color(0xFF4DB6AC); // Teal claro
  static const Color _colorAcentoOscuro = Color(0xFF80CBC4); // Teal más claro para modo oscuro
  static const Color _colorError = Color(0xFFD32F2F);
  static const Color _colorAdvertencia = Color(0xFFFFA000);

  // --- TEMA CLARO ---
  static ThemeData get temaClaro {
    final temaBase = ThemeData.light(useMaterial3: true);
    return temaBase.copyWith(
      primaryColor: _colorPrimario,
      scaffoldBackgroundColor: const Color(0xFFF5F5F5), // Un gris muy claro
      colorScheme: ColorScheme.fromSeed(
        seedColor: _colorPrimario,
        primary: _colorPrimario,
        secondary: _colorAcentoClaro,
        error: _colorError,
        brightness: Brightness.light,
        surface: const Color(0xFFF5F5F5),
      ),
      textTheme: GoogleFonts.interTextTheme(temaBase.textTheme).apply(
        bodyColor: const Color(0xFF333333),
        displayColor: const Color(0xFF333333),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: temaBase.scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 1,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: const IconThemeData(color: _colorPrimario),
        titleTextStyle: GoogleFonts.inter(
          color: const Color(0xFF333333),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _colorPrimario, width: 2),
        ),
        labelStyle: GoogleFonts.inter(color: Colors.grey[600]),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _colorPrimario,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0.5,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey[200]!, width: 1),
        ),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        iconColor: _colorPrimario,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _colorPrimario,
        foregroundColor: Colors.white,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: const Color(0xFFF5F5F5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  // --- TEMA OSCURO ---
  static ThemeData get temaOscuro {
    final temaBase = ThemeData.dark(useMaterial3: true);
    return temaBase.copyWith(
      primaryColor: _colorAcentoOscuro,
      scaffoldBackgroundColor: const Color(0xFF121212),
      colorScheme: ColorScheme.fromSeed(
        seedColor: _colorPrimario,
        primary: _colorAcentoOscuro,
        secondary: _colorAcentoOscuro,
        error: _colorError,
        brightness: Brightness.dark,
        surface: const Color(0xFF121212),
      ),
      textTheme: GoogleFonts.interTextTheme(temaBase.textTheme).apply(
        bodyColor: const Color(0xFFE0E0E0),
        displayColor: const Color(0xFFE0E0E0),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        scrolledUnderElevation: 1,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: const IconThemeData(color: _colorAcentoOscuro),
        titleTextStyle: GoogleFonts.inter(
          color: const Color(0xFFE0E0E0),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2C2C2C),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _colorAcentoOscuro, width: 2),
        ),
        labelStyle: GoogleFonts.inter(color: Colors.grey[400]),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _colorAcentoOscuro,
          foregroundColor: const Color(0xFF121212),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        color: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey[800]!, width: 1),
        ),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        iconColor: _colorAcentoOscuro,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _colorAcentoOscuro,
        foregroundColor: Color(0xFF121212),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}

//==============================================================================
// 🚀 SECCIÓN PRINCIPAL DE LA APP (main, MyApp)
//==============================================================================

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final directorioAppDoc = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(directorioAppDoc.path);

  // Apertura de todas las cajas de Hive
  await Hive.openBox('debitos');
  await Hive.openBox('bancos'); // Renombrado de 'accounts'
  await Hive.openBox('movimientos'); // Renombrado de 'transactions'
  await Hive.openBox('notas'); // Renombrado de 'notes'
  await Hive.openBox('ajustes'); // Renombrado de 'settings'
  await Hive.openBox('metas'); // Renombrado de 'goals'
  await Hive.openBox('cuentasUVT');
  await Hive.openBox('uvtValoresIniciales');
  await Hive.openBox('bienesUVT');
  await Hive.openBox('fechaDeclaracionUVT');
  await Hive.openBox('categorias');
  await Hive.openBox('uvt');
  await Hive.openBox('recordatorios'); // Nueva caja para recordatorios

  await initializeDateFormatting('es', null);
  await ejecutarDebitosAutomaticos();

  runApp(const MiApp()); // Renombrado de MyApp
}

class MiApp extends StatelessWidget { // Renombrado de MyApp
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finanzas Personales',
      debugShowCheckedModeBanner: false,
      theme: TemaApp.temaClaro, // Renombrado de AppTheme.lightTheme
      darkTheme: TemaApp.temaOscuro, // Renombrado de AppTheme.darkTheme
      themeMode: ThemeMode.system, // Opciones: .light, .dark, .system
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', ''), // Español
      ],
      // Definición de rutas para una navegación más limpia
      initialRoute: '/home', // Inicia directamente en la pantalla principal
      routes: {
        // '/': (context) => const EnvoltorioPermisos(), // Eliminada la pantalla de permisos
        '/home': (context) => const PantallaInicio(), // Renombrado de HomeScreen
        '/add_account': (context) => const PantallaAgregarCuenta(), // Renombrado de AddAccountScreen
        '/add_transaction': (context) => const PantallaAgregarMovimiento(), // Renombrado de AddTransactionScreen
        '/history': (context) => const PantallaHistorialMovimientos(), // Renombrado de TransactionHistoryScreen
        '/notes': (context) => const PantallaNotas(), // Renombrado de NotesScreen
        '/debits': (context) => const PantallaDebitos(), // Renombrado de DebitosScreen
        '/budget': (context) => const PantallaPresupuesto(), // Renombrado de BudgetScreen
        '/uvt_control': (context) => const PantallaControlUVT(), // Renombrado de ControlUVTScreen
        '/backup': (context) => const PantallaCopiaSeguridad(), // Renombrado de BackupScreen
        '/debug': (context) => const PantallaDepuracionHive(), // Renombrado de HiveDebugScreen
        '/reminders': (context) => const PantallaRecordatorios(), // Nueva ruta para recordatorios
      },
    );
  }
}

//==============================================================================
// 🏠 PANTALLA PRINCIPAL (HomeScreen)
//==============================================================================

class PantallaInicio extends StatefulWidget { // Renombrado de HomeScreen
  const PantallaInicio({super.key});

  @override
  EstadoPantallaInicio createState() => EstadoPantallaInicio(); // Renombrado de HomeScreenState
}

class EstadoPantallaInicio extends State<PantallaInicio> with SingleTickerProviderStateMixin { // Renombrado de HomeScreenState
  final cajaBancos = Hive.box('bancos'); // Renombrado de accountsBox

  @override
  void initState() {
    super.initState();
    sincronizarOrdenCuentas(); // Renombrado de syncOrdenCuentas
  }

  void sincronizarOrdenCuentas() { // Renombrado de syncOrdenCuentas
    final cajaAjustes = Hive.box('ajustes'); // Renombrado de settingsBox
    final llavesActuales = cajaBancos.keys.cast<int>().toList();
    final ordenGuardado = cajaAjustes.get('ordenCuentas');

    if (ordenGuardado == null) {
      cajaAjustes.put('ordenCuentas', llavesActuales);
    } else {
      final orden = List<int>.from(ordenGuardado);
      final llavesFaltantes = llavesActuales.where((k) => !orden.contains(k)).toList();
      if (llavesFaltantes.isNotEmpty) {
        cajaAjustes.put('ordenCuentas', [...orden, ...llavesFaltantes]);
      }
      final llavesExistentes = orden.where((k) => llavesActuales.contains(k)).toList();
      if (llavesExistentes.length != orden.length) {
        cajaAjustes.put('ordenCuentas', llavesExistentes);
      }
    }
  }

  Map<String, double> obtenerResumenMensual() { // Renombrado de getMonthlySummary
    final cajaMovimientos = Hive.box('movimientos'); // Renombrado de txBox
    final ahora = DateTime.now();
    double ingresos = 0;
    double gastos = 0;

    for (var mov in cajaMovimientos.values) {
      final fechaMov = DateTime.parse(mov['date']);
      if (fechaMov.year == ahora.year && fechaMov.month == ahora.month) {
        if (mov['type'] == 'Ingreso') {
          ingresos += mov['amount'];
        } else if (mov['type'] == 'Gasto') {
          gastos += mov['amount'];
        }
      }
    }
    return {'ingresos': ingresos, 'gastos': gastos, 'balance': ingresos - gastos};
  }

  Map<int, double> _calcularTotalesDebitos() { // Renombrado de _calculateDebitTotals
    final cajaDebitos = Hive.box('debitos');
    Map<int, double> totales = {for (var key in cajaBancos.keys) key as int: 0.0};

    for (var debito in cajaDebitos.values) {
      final idCuenta = debito['cuentaId'];
      final monto = debito['monto'] as double;
      if (totales.containsKey(idCuenta)) {
        totales[idCuenta] = (totales[idCuenta] ?? 0.0) + monto;
      }
    }
    return totales;
  }

  double obtenerBalanceTotal() { // Renombrado de getTotalBalance
    return cajaBancos.values.fold(0.0, (sum, acc) => sum + (acc['balance'] ?? 0.0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notes_outlined),
            tooltip: 'Notas',
            onPressed: () => Navigator.pushNamed(context, '/notes'),
          ),
          IconButton(
            icon: const Icon(Icons.history_outlined),
            tooltip: 'Historial',
            onPressed: () => Navigator.pushNamed(context, '/history'),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('bancos').listenable(), // Renombrado de accounts
        builder: (context, Box box, _) {
          sincronizarOrdenCuentas(); // Asegura el orden en cada rebuild // Renombrado de syncOrdenCuentas
          final cajaAjustes = Hive.box('ajustes'); // Renombrado de settingsBox
          final orden = List<int>.from(cajaAjustes.get('ordenCuentas', defaultValue: box.keys.cast<int>().toList()));
          final ordenValido = orden.where((k) => box.containsKey(k)).toList();
          final bancos = {for (var k in ordenValido) k: box.get(k)}; // Renombrado de accounts

          final totalesDebitos = _calcularTotalesDebitos(); // Renombrado de debitTotals
          final bancosConDebitos = ordenValido.where((key) => (totalesDebitos[key] ?? 0.0) > 0).toList(); // Renombrado de accountsWithDebits

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                const SizedBox(height: 8),
                _construirTarjetaBalanceTotal(obtenerBalanceTotal()), // Renombrado de _buildTotalBalanceCard, getTotalBalance
                const SizedBox(height: 16),
                _construirTarjetaResumenMensual(obtenerResumenMensual()), // Renombrado de _buildMonthlySummaryCard, getMonthlySummary
                const SizedBox(height: 24),
                _construirEncabezadoSeccion('Mis Cuentas', Icons.account_balance_wallet_outlined), // Renombrado de _buildSectionHeader
                _construirListaCuentasReordenables(bancos), // Renombrado de _buildReorderableAccountList, accounts
                const SizedBox(height: 24),
                if (bancosConDebitos.isNotEmpty) ...[ // Renombrado de accountsWithDebits
                  _construirEncabezadoSeccion('Próximos Débitos', Icons.event_repeat_outlined), // Renombrado de _buildSectionHeader
                  _construirResumenDebitos(bancosConDebitos, totalesDebitos), // Renombrado de _buildDebitsSummary, accountsWithDebits, debitTotals
                  const SizedBox(height: 24),
                ],
                // Nueva ficha de resumen para recordatorios
                _construirTarjetaRecordatoriosProximos(),
                const SizedBox(height: 24),
                _construirTarjetaNotasRecientes(), // Renombrado de _buildRecentNotesCard
                const SizedBox(height: 100), // Espacio para el FAB
              ],
            ),
          );
        },
      ),
      floatingActionButton: _construirDialVelocidad(), // Renombrado de _buildSpeedDial
    );
  }

  Widget _construirEncabezadoSeccion(String titulo, IconData icono) { // Renombrado de _buildSectionHeader
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icono, color: Theme.of(context).colorScheme.primary, size: 20),
          const SizedBox(width: 8),
          Text(
            titulo,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _construirTarjetaBalanceTotal(double balanceTotal) { // Renombrado de _buildTotalBalanceCard
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SALDO TOTAL',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${formatoMoneda.format(balanceTotal)}', // Renombrado de formatCurrency
              style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _construirTarjetaResumenMensual(Map<String, double> resumen) { // Renombrado de _buildMonthlySummaryCard
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resumen de ${DateFormat.yMMMM('es').format(DateTime.now())}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(height: 24),
            _construirFilaResumen('Ingresos', resumen['ingresos']!, Colors.green.shade600), // Renombrado de _buildSummaryRow
            _construirFilaResumen('Gastos', resumen['gastos']!, Colors.red.shade600), // Renombrado de _buildSummaryRow
            const Divider(height: 24),
            _construirFilaResumen('Balance del Mes', resumen['balance']!, Theme.of(context).textTheme.bodyLarge!.color!, esNegrita: true), // Renombrado de _buildSummaryRow, isBold
          ],
        ),
      ),
    );
  }

  Widget _construirFilaResumen(String titulo, double monto, Color color, {bool esNegrita = false}) { // Renombrado de _buildSummaryRow, isBold
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(titulo, style: Theme.of(context).textTheme.bodyLarge),
          Text(
            '\$${formatoMoneda.format(monto)}', // Renombrado de formatCurrency
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: color,
                fontWeight: esNegrita ? FontWeight.bold : FontWeight.normal
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirListaCuentasReordenables(Map<int, dynamic> bancos) { // Renombrado de _buildReorderableAccountList, accounts
    return ReorderableListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      onReorder: (indiceAntiguo, nuevoIndice) {
        if (nuevoIndice > indiceAntiguo) nuevoIndice--;
        final cajaAjustes = Hive.box('ajustes'); // Renombrado de settingsBox
        final llavesVisibles = bancos.keys.toList();
        final llaveMovida = llavesVisibles.removeAt(indiceAntiguo);
        llavesVisibles.insert(nuevoIndice, llaveMovida);
        cajaAjustes.put('ordenCuentas', llavesVisibles);
        setState(() {});
      },
      children: bancos.entries.map((entrada) {
        final cuenta = entrada.value; // Renombrado de acc
        return Card(
          key: ValueKey(entrada.key),
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(26), // ~10% opacity
              child: Icon(Icons.account_balance, color: Theme.of(context).colorScheme.primary),
            ),
            title: Text(cuenta['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: Text(
              '\$${formatoMoneda.format(cuenta['balance'])}', // Renombrado de formatCurrency
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PantallaEditarCuenta(llaveCuenta: entrada.key)), // Renombrado de EditAccountScreen, accountKey
              ).then((_) => setState(() {}));
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _construirResumenDebitos(List<int> bancosConDebitos, Map<int, double> totalesDebitos) { // Renombrado de _buildDebitsSummary, accountsWithDebits, debitTotals
    final cajaDebitos = Hive.box('debitos');
    return Column(
      children: bancosConDebitos.map((key) {
        final cuenta = cajaBancos.get(key); // Renombrado de acc, accountsBox
        final totalDebitoCuenta = totalesDebitos[key]!;
        final balance = cuenta['balance'] as double;
        final suficiente = balance >= totalDebitoCuenta;
        final colorEstado = suficiente ? Colors.green.shade600 : TemaApp._colorAdvertencia; // Renombrado de AppTheme._warningColor

        final debito = cajaDebitos.values.firstWhere((d) => d['cuentaId'] == key, orElse: () => null);
        String diasRestantesTexto = '';
        if (debito != null && debito['proximaFecha'] != null) {
          final proximaFecha = DateTime.parse(debito['proximaFecha']);
          final diasRestantes = proximaFecha.difference(DateTime.now()).inDays;
          if (diasRestantes == 0) {
            diasRestantesTexto = ' (Hoy)';
          } else if (diasRestantes > 0) {
            diasRestantesTexto = ' (Faltan $diasRestantes días)';
          } else {
            diasRestantesTexto = ' (Vencido hace ${diasRestantes.abs()} días)';
          }
        }


        return Card(
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: colorEstado.withAlpha(26),
              child: Icon(suficiente ? Icons.check_circle_outline : Icons.warning_amber_rounded, color: colorEstado),
            ),
            title: Text(cuenta['name'], style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text('Débitos: \$${formatoMoneda.format(totalDebitoCuenta)}$diasRestantesTexto'), // Renombrado de formatCurrency
            trailing: Text(
              '\$${formatoMoneda.format(balance)}', // Renombrado de formatCurrency
              style: TextStyle(color: colorEstado, fontWeight: FontWeight.w600, fontSize: 15),
            ),
          ),
        );
      }).toList(),
    );
  }

  // Nuevo widget para la tarjeta de recordatorios
  Widget _construirTarjetaRecordatoriosProximos() {
    final cajaRecordatorios = Hive.box('recordatorios');
    final ahora = DateTime.now();

    final recordatoriosConFechaProxima = cajaRecordatorios.toMap().entries.map((entrada) {
      final recordatorio = entrada.value;
      final proximaFecha = _calcularProximaFechaRecordatorio(recordatorio);
      return MapEntry(entrada.key, {'data': recordatorio, 'proximaFecha': proximaFecha});
    }).where((entrada) {
      // Solo mostrar recordatorios cuya próxima fecha es futura o de hoy
      return entrada.value['proximaFecha'] != null &&
          (entrada.value['proximaFecha'] as DateTime).isAfter(ahora.subtract(const Duration(days: 1)));
    }).toList();

    recordatoriosConFechaProxima.sort((a, b) =>
        (a.value['proximaFecha'] as DateTime).compareTo(b.value['proximaFecha'] as DateTime));

    if (recordatoriosConFechaProxima.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _construirEncabezadoSeccion('Próximos Recordatorios', Icons.alarm_on_outlined),
        Card(
          child: Column(
            children: [
              ...recordatoriosConFechaProxima.take(3).map((entrada) {
                final recordatorio = entrada.value['data'];
                final proximaFecha = entrada.value['proximaFecha'] as DateTime;
                final diasRestantes = proximaFecha.difference(ahora).inDays;
                final tieneValor = recordatorio['valor'] != null && recordatorio['valor'] > 0;

                Color colorIcono;
                if (diasRestantes <= 0) { // Vencido o hoy
                  colorIcono = TemaApp._colorError;
                } else if (diasRestantes <= 7) {
                  colorIcono = TemaApp._colorAdvertencia;
                } else if (diasRestantes <= 15) {
                  colorIcono = Colors.amber.shade600;
                } else if (diasRestantes <= 30) {
                  colorIcono = Colors.lightBlue.shade600;
                } else {
                  colorIcono = Theme.of(context).colorScheme.primary;
                }

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: colorIcono.withAlpha(26),
                    child: Icon(Icons.alarm_on_outlined, color: colorIcono),
                  ),
                  title: Text(
                    recordatorio['nombre'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${DateFormat('dd MMM y', 'es').format(proximaFecha)} '
                        '${tieneValor ? ' - \$${formatoMoneda.format(recordatorio['valor'])}' : ''}'
                        '${diasRestantes >= 0 ? ' (faltan $diasRestantes días)' : ' (Vencido)'}',
                  ),
                  onTap: () => Navigator.pushNamed(context, '/reminders'),
                );
              }).toList(),
              if (recordatoriosConFechaProxima.length > 3)
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/reminders'),
                  child: const Text('Ver todos los recordatorios'),
                )
            ],
          ),
        ),
      ],
    );
  }

  Widget _construirTarjetaNotasRecientes() { // Renombrado de _buildRecentNotesCard
    final cajaNotas = Hive.box('notas'); // Renombrado de notesBox
    final notasRecientes = cajaNotas.values.toList().reversed.take(3).toList();
    if(notasRecientes.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _construirEncabezadoSeccion('Notas Recientes', Icons.edit_note_outlined), // Renombrado de _buildSectionHeader
        Card(
          child: Column(
            children: [
              ...notasRecientes.map((nota) => ListTile( // Renombrado de note
                title: Text(
                  nota, // Renombrado de note
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color),
                ),
                onTap: () => Navigator.pushNamed(context, '/notes'),
              )),
              if(cajaNotas.length > 3) // Renombrado de notesBox
                TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/notes'),
                    child: const Text('Ver todas las notas')
                )
            ],
          ),
        ),
      ],
    );
  }

  SpeedDial _construirDialVelocidad() { // Renombrado de _buildSpeedDial
    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close,
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      overlayColor: Colors.black,
      overlayOpacity: 0.4,
      spacing: 12,
      spaceBetweenChildren: 12,
      children: [
        _construirHijoDialVelocidad(Icons.add_card_outlined, 'Registrar Movimiento', () => Navigator.pushNamed(context, '/add_transaction')), // Renombrado de _buildSpeedDialChild
        _construirHijoDialVelocidad(Icons.account_balance_outlined, 'Agregar Cuenta', () => Navigator.pushNamed(context, '/add_account')), // Renombrado de _buildSpeedDialChild
        _construirHijoDialVelocidad(Icons.event_repeat_outlined, 'Débitos Automáticos', () => Navigator.pushNamed(context, '/debits')), // Renombrado de _buildSpeedDialChild
        _construirHijoDialVelocidad(Icons.alarm_on_outlined, 'Recordatorios', () => Navigator.pushNamed(context, '/reminders')), // Nuevo hijo para Recordatorios
        _construirHijoDialVelocidad(Icons.pie_chart_outline, 'Presupuesto & Metas', () => Navigator.pushNamed(context, '/budget')), // Renombrado de _buildSpeedDialChild
        _construirHijoDialVelocidad(Icons.assignment_outlined, 'Control UVT / DIAN', () => Navigator.pushNamed(context, '/uvt_control')), // Renombrado de _buildSpeedDialChild
        _construirHijoDialVelocidad(Icons.backup_outlined, 'Copia de Seguridad', () => Navigator.pushNamed(context, '/backup'), color: Colors.blueGrey), // Renombrado de _buildSpeedDialChild
        _construirHijoDialVelocidad(Icons.bug_report_outlined, 'Depurar Hive', () => Navigator.pushNamed(context, '/debug'), color: Colors.orange.shade800), // Renombrado de _buildSpeedDialChild
      ],
    );
  }

  SpeedDialChild _construirHijoDialVelocidad(IconData icono, String etiqueta, VoidCallback alTocar, {Color? color}) { // Renombrado de _buildSpeedDialChild, onTap
    return SpeedDialChild(
      child: Icon(icono),
      label: etiqueta,
      backgroundColor: color ?? Theme.of(context).colorScheme.secondary,
      foregroundColor: Colors.white,
      labelStyle: const TextStyle(fontWeight: FontWeight.w500),
      onTap: alTocar,
    );
  }
}

//==============================================================================
// ➕ PANTALLA PARA AGREGAR CUENTA (AddAccountScreen)
//==============================================================================

class PantallaAgregarCuenta extends StatefulWidget { // Renombrado de AddAccountScreen
  const PantallaAgregarCuenta({super.key});

  @override
  EstadoPantallaAgregarCuenta createState() => EstadoPantallaAgregarCuenta(); // Renombrado de AddAccountScreenState
}

class EstadoPantallaAgregarCuenta extends State<PantallaAgregarCuenta> { // Renombrado de AddAccountScreenState
  final _claveFormulario = GlobalKey<FormState>(); // Renombrado de _formKey
  final controladorNombre = TextEditingController(); // Renombrado de nameController
  final controladorSaldo = TextEditingController(); // Renombrado de balanceController

  void _guardarCuenta() async { // Renombrado de _saveAccount
    if (_claveFormulario.currentState!.validate()) {
      final nombre = controladorNombre.text.trim(); // Renombrado de nameController.text
      final saldo = double.tryParse(controladorSaldo.text) ?? 0.0; // Renombrado de balanceController.text

      final cajaBancos = Hive.box('bancos'); // Renombrado de accountsBox
      final cajaAjustes = Hive.box('ajustes'); // Renombrado de settingsBox

      final nuevaLlave = await cajaBancos.add({
        'name': nombre,
        'balance': saldo,
        'cards': [],
        'linkedAccounts': [],
      });

      final ordenActual = List<int>.from(cajaAjustes.get('ordenCuentas', defaultValue: []));
      ordenActual.add(nuevaLlave);
      cajaAjustes.put('ordenCuentas', ordenActual);

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva Cuenta')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _claveFormulario, // Renombrado de _formKey
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: controladorNombre, // Renombrado de nameController
                decoration: const InputDecoration(labelText: 'Nombre de la Cuenta o Banco'),
                validator: (valor) => (valor == null || valor.isEmpty) ? 'El nombre es obligatorio' : null, // Renombrado de value
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controladorSaldo, // Renombrado de balanceController
                decoration: const InputDecoration(labelText: 'Saldo Inicial', prefixText: '\$ '),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (valor) { // Renombrado de value
                  if (valor == null || valor.isEmpty) return 'El saldo es obligatorio';
                  if (double.tryParse(valor) == null) return 'Ingresa un número válido';
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: const Icon(Icons.save_alt_outlined),
                label: const Text('Guardar Cuenta'),
                onPressed: _guardarCuenta, // Renombrado de _saveAccount
              )
            ],
          ),
        ),
      ),
    );
  }
}

//==============================================================================
// ✏️ PANTALLA PARA EDITAR CUENTA (EditAccountScreen)
//==============================================================================
class PantallaEditarCuenta extends StatefulWidget { // Renombrado de EditAccountScreen
  final int llaveCuenta; // Renombrado de accountKey
  const PantallaEditarCuenta({super.key, required this.llaveCuenta}); // Renombrado de accountKey

  @override
  EstadoPantallaEditarCuenta createState() => EstadoPantallaEditarCuenta();
}

class EstadoPantallaEditarCuenta extends State<PantallaEditarCuenta> {
  final controladorNombre = TextEditingController(); // Renombrado de nameController
  final cajaBancos = Hive.box('bancos'); // Renombrado de accountsBox
  late Map _cuenta; // Renombrado de _account

  @override
  void initState() {
    super.initState();
    _cargarDatosCuenta(); // Renombrado de _loadAccountData
  }

  void _cargarDatosCuenta() { // Renombrado de _loadAccountData
    _cuenta = cajaBancos.get(widget.llaveCuenta); // Renombrado de accountKey
    controladorNombre.text = _cuenta['name'];
  }

  void _guardarCambios() { // Renombrado de _saveChanges
    cajaBancos.put(widget.llaveCuenta, { // Renombrado de accountKey
      'name': controladorNombre.text.trim(), // Renombrado de nameController.text
      'balance': _cuenta['balance'],
      'cards': _cuenta['cards'] ?? [],
      'linkedAccounts': [],
    });
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _eliminarCuenta() async { // Renombrado de _deleteAccount
    final confirmado = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('¿Eliminar cuenta?'),
          content: Text('Estás a punto de eliminar "${_cuenta['name']}". Esta acción no se puede deshacer.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
            TextButton(
                style: TextButton.styleFrom(foregroundColor: TemaApp._colorError), // Renombrado de AppTheme._errorColor
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Eliminar')
            ),
          ],
        )
    );

    if(confirmado == true) {
      cajaBancos.delete(widget.llaveCuenta); // Renombrado de accountKey
      // Opcional: limpiar la key del orden de cuentas
      final cajaAjustes = Hive.box('ajustes'); // Renombrado de settingsBox
      final orden = List<int>.from(cajaAjustes.get('ordenCuentas', defaultValue: []));
      orden.remove(widget.llaveCuenta); // Renombrado de accountKey
      cajaAjustes.put('ordenCuentas', orden);
      if(mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Cuenta'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: TemaApp._colorError), // Renombrado de AppTheme._colorError
            tooltip: 'Eliminar Cuenta',
            onPressed: _eliminarCuenta, // Renombrado de _deleteAccount
          )
        ],
      ),
      body: ValueListenableBuilder(
          valueListenable: cajaBancos.listenable(keys: [widget.llaveCuenta]), // Renombrado de accountsBox, accountKey
          builder: (context, box, _) {
            _cargarDatosCuenta(); // Recargar datos por si cambian // Renombrado de _loadAccountData
            final List tarjetas = _cuenta['cards'] ?? []; // Renombrado de cards
            final List cuentasVinculadas = _cuenta['linkedAccounts'] ?? []; // Renombrado de linkedAccounts

            return ListView(
              padding: const EdgeInsets.all(16),
              children: <Widget>[
                // --- Sección de Edición de Nombre ---
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          controller: controladorNombre, // Renombrado de nameController
                          decoration: const InputDecoration(labelText: 'Nombre de la Cuenta'),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _guardarCambios, // Renombrado de _saveChanges
                          child: const Text('Guardar Nombre'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // --- Sección de Tarjetas Guardadas ---
                _construirEncabezadoSeccionEditable('Tarjetas Guardadas', Icons.credit_card_outlined, () async { // Renombrado de _buildSectionHeader
                  final tarjeta = await Navigator.push<Map<String, String>>( // Renombrado de card
                      context, MaterialPageRoute(builder: (_) => PantallaAgregarTarjeta())); // Renombrado de AddCardScreen
                  if (tarjeta != null) {
                    final tarjetasActualizadas = [...tarjetas, tarjeta]; // Renombrado de updatedCards, cards
                    cajaBancos.put(widget.llaveCuenta, {..._cuenta, 'cards': tarjetasActualizadas}); // Renombrado de accountKey, _account, updatedCards
                  }
                }),
                if (tarjetas.isEmpty) // Renombrado de cards
                  const Center(child: Padding(padding: EdgeInsets.all(16.0), child: Text('No hay tarjetas guardadas.')))
                else
                  ...tarjetas.asMap().entries.map((entrada) => _construirTileTarjeta(entrada.key, entrada.value)), // Renombrado de cards, _buildCardTile, entry
                const SizedBox(height: 24),

                // --- Sección de Cuentas Asociadas ---
                _construirEncabezadoSeccionEditable('Cuentas Asociadas', Icons.people_outline, () async { // Renombrado de _buildSectionHeader
                  final nuevaCuenta = await Navigator.push<Map<String, String>>( // Renombrado de newAccount
                      context, MaterialPageRoute(builder: (_) => const PantallaAgregarCuentaVinculada())); // Renombrado de AddLinkedAccountScreen
                  if (nuevaCuenta != null) {
                    final cuentasActualizadas = [...cuentasVinculadas, nuevaCuenta]; // Renombrado de updatedAccounts, linkedAccounts, newAccount
                    cajaBancos.put(widget.llaveCuenta, {..._cuenta, 'linkedAccounts': cuentasActualizadas}); // Renombrado de accountKey, _account, updatedAccounts
                  }
                }),
                if (cuentasVinculadas.isEmpty) // Renombrado de linkedAccounts
                  const Center(child: Padding(padding: EdgeInsets.all(16.0), child: Text('No hay cuentas asociadas.')))
                else
                  ...cuentasVinculadas.asMap().entries.map((entrada) => _construirTileCuentaVinculada(entrada.key, entrada.value)), // Renombrado de linkedAccounts, _buildLinkedAccountTile, entry
              ],
            );
          }),
    );
  }

  Widget _construirEncabezadoSeccionEditable(String titulo, IconData icono, VoidCallback alAgregar) { // Renombrado de _buildSectionHeader, onAdd
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(titulo, style: Theme.of(context).textTheme.titleLarge),
        IconButton.filledTonal(
          icon: const Icon(Icons.add),
          tooltip: 'Agregar',
          onPressed: alAgregar, // Renombrado de onAdd
        )
      ],
    );
  }

  Widget _construirTileTarjeta(int indice, Map tarjeta) { // Renombrado de _buildCardTile, index, card
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(tarjeta['name'] ?? 'Tarjeta sin nombre', style: const TextStyle(fontWeight: FontWeight.bold)), // Renombrado de card
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _construirCampoCopiable('Número', tarjeta['number']), // Renombrado de _buildCopyableField, card
            _construirCampoCopiable('Vence', tarjeta['expiry']), // Renombrado de _buildCopyableField, card
            _construirCampoCopiable('CVV', tarjeta['cvv']), // Renombrado de _buildCopyableField, card
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (valor) async { // Renombrado de value
            if (valor == 'Editar') {
              final tarjetaActualizada = await Navigator.push<Map<String, String>>( // Renombrado de updatedCard
                context,
                MaterialPageRoute(builder: (_) => PantallaAgregarTarjeta(datosIniciales: Map<String, String>.from(tarjeta))), // Renombrado de AddCardScreen, initialData, card
              );
              if (tarjetaActualizada != null) {
                final tarjetasActuales = List.from(_cuenta['cards']); // Renombrado de currentCards, _account
                tarjetasActuales[indice] = tarjetaActualizada; // Renombrado de index, updatedCard
                cajaBancos.put(widget.llaveCuenta, {..._cuenta, 'cards': tarjetasActuales}); // Renombrado de accountKey, _account, currentCards
              }
            } else if (valor == 'Eliminar') {
              final tarjetasActuales = List.from(_cuenta['cards']); // Renombrado de currentCards, _account
              tarjetasActuales.removeAt(indice); // Renombrado de index
              cajaBancos.put(widget.llaveCuenta, {..._cuenta, 'cards': tarjetasActuales}); // Renombrado de accountKey, _account, currentCards
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'Editar', child: Text('Editar')),
            const PopupMenuItem(value: 'Eliminar', child: Text('Eliminar')),
          ],
        ),
      ),
    );
  }

  Widget _construirTileCuentaVinculada(int indice, Map cuenta) { // Renombrado de _buildLinkedAccountTile, index
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(cuenta['nombre']?.isNotEmpty == true ? cuenta['nombre'] : 'Cuenta sin nombre', style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tipo: ${cuenta['tipo']}'),
            _construirCampoCopiable('Número', cuenta['numero']), // Renombrado de _buildCopyableField
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (valor) async { // Renombrado de value
            if (valor == 'Editar') {
              final cuentaActualizada = await _mostrarDialogoEditarCuentaVinculada(cuenta); // Renombrado de updatedAccount, _showEditLinkedAccountDialog
              if (cuentaActualizada != null) {
                final cuentasActuales = List.from(_cuenta['linkedAccounts']); // Renombrado de currentAccounts, _account
                cuentasActuales[indice] = cuentaActualizada; // Renombrado de index, updatedAccount
                cajaBancos.put(widget.llaveCuenta, {..._cuenta, 'linkedAccounts': cuentasActuales}); // Renombrado de accountKey, _account, currentAccounts
              }
            } else if (valor == 'Eliminar') {
              final cuentasActuales = List.from(_cuenta['linkedAccounts']); // Renombrado de currentAccounts, _account
              cuentasActuales.removeAt(indice); // Renombrado de index
              cajaBancos.put(widget.llaveCuenta, {..._cuenta, 'linkedAccounts': cuentasActuales}); // Renombrado de accountKey, _account, currentCards
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'Editar', child: Text('Editar')),
            const PopupMenuItem(value: 'Eliminar', child: Text('Eliminar')),
          ],
        ),
      ),
    );
  }

  Future<Map<String, String>?> _mostrarDialogoEditarCuentaVinculada(Map cuenta) async { // Renombrado de _showEditLinkedAccountDialog
    final controladorNombre = TextEditingController(text: cuenta['nombre']); // Renombrado de nombreCtrl
    final controladorNumero = TextEditingController(text: cuenta['numero']); // Renombrado de numeroCtrl
    String tipo = cuenta['tipo'];

    return showDialog<Map<String, String>>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, establecerEstadoDialogo) { // Renombrado de setDialogState
          return AlertDialog(
            title: const Text('Editar Cuenta Asociada'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: controladorNombre, decoration: const InputDecoration(labelText: 'Nombre')), // Renombrado de nombreCtrl
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: tipo,
                    decoration: const InputDecoration(labelText: 'Tipo de Cuenta'),
                    items: ['Ahorro', 'Corriente', 'Llave'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (val) => establecerEstadoDialogo(() => tipo = val!), // Renombrado de setDialogState
                  ),
                  const SizedBox(height: 16),
                  TextField(controller: controladorNumero, decoration: const InputDecoration(labelText: 'Número')), // Renombrado de numeroCtrl
                ],
              ),
            ),
            actions: [
              TextButton(child: const Text('Cancelar'), onPressed: () => Navigator.pop(context)),
              ElevatedButton(
                child: const Text('Guardar'),
                onPressed: () {
                  Navigator.pop(context, {
                    'nombre': controladorNombre.text.trim(), // Renombrado de nombreCtrl
                    'tipo': tipo,
                    'numero': controladorNumero.text.trim(), // Renombrado de numeroCtrl
                  });
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _construirCampoCopiable(String etiqueta, String? valor) { // Renombrado de _buildCopyableField, label, value
    if (valor == null || valor.isEmpty) return const SizedBox.shrink();
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: valor)); // Renombrado de value
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('$etiqueta copiado al portapapeles.'), // Renombrado de label
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Row(
          children: [
            Text('$etiqueta: ', style: const TextStyle(fontWeight: FontWeight.w500)), // Renombrado de label
            Expanded(child: Text(valor, overflow: TextOverflow.ellipsis)), // Renombrado de value
            const Icon(Icons.copy_all_outlined, size: 14, color: Colors.grey)
          ],
        ),
      ),
    );
  }
}

//==============================================================================
// 💳 PANTALLAS DE AGREGAR TARJETA Y CUENTA ASOCIADA
//==============================================================================
class PantallaAgregarTarjeta extends StatelessWidget { // Renombrado de AddCardScreen
  final Map<String, String>? datosIniciales; // Renombrado de initialData
  PantallaAgregarTarjeta({super.key, this.datosIniciales}); // Renombrado de initialData

  final controladorNombreTarjeta = TextEditingController(); // Renombrado de cardNameController
  final controladorNumero = TextEditingController(); // Renombrado de numberController
  final controladorVencimiento = TextEditingController(); // Renombrado de expiryController
  final controladorCvv = TextEditingController(); // Renombrado de cvvController

  @override
  Widget build(BuildContext context) {
    if (datosIniciales != null) { // Renombrado de initialData
      controladorNombreTarjeta.text = datosIniciales!['name'] ?? ''; // Renombrado de cardNameController, initialData
      controladorNumero.text = datosIniciales!['number'] ?? ''; // Renombrado de numberController, initialData
      controladorVencimiento.text = datosIniciales!['expiry'] ?? ''; // Renombrado de expiryController, initialData
      controladorCvv.text = datosIniciales!['cvv'] ?? ''; // Renombrado de cvvController, initialData
    }

    return Scaffold(
      appBar: AppBar(title: Text(datosIniciales == null ? 'Nueva Tarjeta' : 'Editar Tarjeta')), // Renombrado de initialData
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(controller: controladorNombreTarjeta, decoration: const InputDecoration(labelText: 'Nombre de la tarjeta (Ej: "Visa Gold")')), // Renombrado de cardNameController
            const SizedBox(height: 16),
            TextField(controller: controladorNumero, decoration: const InputDecoration(labelText: 'Número de tarjeta'), keyboardType: TextInputType.number), // Renombrado de numberController
            const SizedBox(height: 16),
            TextField(controller: controladorVencimiento, decoration: const InputDecoration(labelText: 'Fecha de vencimiento (MM/AA)')), // Renombrado de expiryController
            const SizedBox(height: 16),
            TextField(controller: controladorCvv, decoration: const InputDecoration(labelText: 'CVV'), keyboardType: TextInputType.number), // Renombrado de cvvController
            const SizedBox(height: 32),
            ElevatedButton(
              child: const Text('Guardar Tarjeta'),
              onPressed: () {
                Navigator.pop(context, {
                  'name': controladorNombreTarjeta.text.trim(), // Renombrado de cardNameController
                  'number': controladorNumero.text.trim(), // Renombrado de numberController
                  'expiry': controladorVencimiento.text.trim(), // Renombrado de expiryController
                  'cvv': controladorCvv.text.trim(), // Renombrado de cvvController
                });
              },
            )
          ],
        ),
      ),
    );
  }
}

class PantallaAgregarCuentaVinculada extends StatefulWidget { // Renombrado de AddLinkedAccountScreen
  const PantallaAgregarCuentaVinculada({super.key});

  @override
  EstadoPantallaAgregarCuentaVinculada createState() => EstadoPantallaAgregarCuentaVinculada(); // Renombrado de AddLinkedAccountScreenState
}

class EstadoPantallaAgregarCuentaVinculada extends State<PantallaAgregarCuentaVinculada> { // Renombrado de AddLinkedAccountScreenState
  final controladorNombre = TextEditingController(); // Renombrado de nombreController
  final controladorNumero = TextEditingController(); // Renombrado de numeroController
  String tipoCuenta = 'Ahorro';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva Cuenta Asociada')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(controller: controladorNombre, decoration: const InputDecoration(labelText: 'Nombre (ej: "Juan Pérez")')), // Renombrado de nombreController
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: tipoCuenta,
              decoration: const InputDecoration(labelText: 'Tipo de Cuenta'),
              items: ['Ahorro', 'Corriente', 'Llave'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) => setState(() => tipoCuenta = val!),
            ),
            const SizedBox(height: 16),
            TextField(controller: controladorNumero, decoration: const InputDecoration(labelText: 'Número de cuenta'), keyboardType: TextInputType.number), // Renombrado de numeroController
            const SizedBox(height: 32),
            ElevatedButton(
              child: const Text('Guardar Cuenta'),
              onPressed: () {
                Navigator.pop(context, {
                  'nombre': controladorNombre.text.trim(), // Renombrado de nombreController
                  'tipo': tipoCuenta,
                  'numero': controladorNumero.text.trim(), // Renombrado de numeroController
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}


//==============================================================================
// 💸 PANTALLAS DE GESTIÓN DE TRANSACCIONES (Agregar, Editar, Historial)
//==============================================================================
class PantallaAgregarMovimiento extends StatefulWidget { // Renombrado de AddTransactionScreen
  const PantallaAgregarMovimiento({super.key});
  @override
  EstadoPantallaAgregarMovimiento createState() => EstadoPantallaAgregarMovimiento(); // Renombrado de AddTransactionScreenState
}

class EstadoPantallaAgregarMovimiento extends State<PantallaAgregarMovimiento> { // Renombrado de AddTransactionScreenState
  final _claveFormulario = GlobalKey<FormState>(); // Renombrado de _formKey
  String tipo = 'Gasto'; // Renombrado de type
  double monto = 0; // Renombrado de amount
  int? cuentaSeleccionada; // Renombrado de selectedAccount
  int? cuentaDestino; // Renombrado de destinationAccount
  String descripcion = ''; // Renombrado de description
  DateTime fechaSeleccionada = DateTime.now();
  bool yaReflejado = false;
  final controladorMonto = TextEditingController(); // Renombrado de amountController
  final controladorDescripcion = TextEditingController(); // Renombrado de descController

  void _guardarMovimiento() { // Renombrado de _saveTransaction
    if (!_claveFormulario.currentState!.validate()) return; // Renombrado de _formKey
    _claveFormulario.currentState!.save(); // Renombrado de _formKey
    if (monto <= 0) return;

    final cajaBancos = Hive.box('bancos'); // Renombrado de accountsBox
    if (tipo == 'Ingreso' || tipo == 'Gasto') {
      if (cuentaSeleccionada == null) return; // Renombrado de selectedAccount
      final cuenta = cajaBancos.get(cuentaSeleccionada!); // Renombrado de acc, selectedAccount
      if (!yaReflejado) {
        final nuevoSaldo = tipo == 'Ingreso' ? cuenta['balance'] + monto : cuenta['balance'] - monto;
        cajaBancos.put(cuentaSeleccionada!, {...cuenta, 'balance': nuevoSaldo}); // Renombrado de selectedAccount, acc
      }
      Hive.box('movimientos').add({ // Renombrado de transactions
        'type': tipo, 'amount': monto, 'account': cuenta['name'], 'description': descripcion,
        'date': fechaSeleccionada.toIso8601String(), 'reflejado': yaReflejado,
      });
    } else if (tipo == 'Transferencia') {
      if (cuentaSeleccionada == null || cuentaDestino == null) return; // Renombrado de selectedAccount, destinationAccount
      final cuentaOrigen = cajaBancos.get(cuentaSeleccionada!); // Renombrado de fromAcc, selectedAccount
      final cuentaDestinoObj = cajaBancos.get(cuentaDestino!); // Renombrado de toAcc, destinationAccount
      if (!yaReflejado) {
        cajaBancos.put(cuentaSeleccionada!, {...cuentaOrigen, 'balance': cuentaOrigen['balance'] - monto}); // Renombrado de selectedAccount, fromAcc
        cajaBancos.put(cuentaDestino!, {...cuentaDestinoObj, 'balance': cuentaDestinoObj['balance'] + monto}); // Renombrado de destinationAccount, toAcc
      }
      Hive.box('movimientos').add({ // Renombrado de transactions
        'type': 'Transferencia', 'amount': monto, 'from': cuentaOrigen['name'], 'to': cuentaDestinoObj['name'],
        'description': descripcion, 'date': fechaSeleccionada.toIso8601String(), 'reflejado': yaReflejado,
      });
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bancos = Hive.box('bancos'); // Renombrado de accounts
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo Movimiento')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _claveFormulario, // Renombrado de _formKey
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: tipo, // Renombrado de type
                decoration: const InputDecoration(labelText: 'Tipo de Movimiento'),
                items: ['Gasto', 'Ingreso', 'Transferencia'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() {
                  tipo = val!; cuentaSeleccionada = null; cuentaDestino = null; // Renombrado de type, selectedAccount, destinationAccount
                }),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controladorMonto, // Renombrado de amountController
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Monto', prefixText: '\$ '),
                onSaved: (val) => monto = double.tryParse(val ?? '0') ?? 0, // Renombrado de amount
                validator: (val) {
                  if (val == null || val.isEmpty || (double.tryParse(val) ?? 0) <= 0) {
                    return 'Ingresa un monto válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              if (tipo != 'Transferencia') // Renombrado de type
                DropdownButtonFormField<int>(
                  value: cuentaSeleccionada, // Renombrado de selectedAccount
                  hint: const Text('Seleccionar cuenta'),
                  decoration: const InputDecoration(labelText: 'Cuenta'),
                  isExpanded: true,
                  items: bancos.keys.map<DropdownMenuItem<int>>((key) => DropdownMenuItem<int>(
                      value: key, child: Text(bancos.get(key)['name']))
                  ).toList(),
                  onChanged: (val) => setState(() => cuentaSeleccionada = val), // Renombrado de selectedAccount
                  validator: (val) => val == null ? 'Selecciona una cuenta' : null,
                ),
              if (tipo == 'Transferencia') ...[ // Renombrado de type
                DropdownButtonFormField<int>(
                  value: cuentaSeleccionada, // Renombrado de selectedAccount
                  hint: const Text('Cuenta Origen'),
                  decoration: const InputDecoration(labelText: 'Desde'),
                  isExpanded: true,
                  items: bancos.keys.map<DropdownMenuItem<int>>((key) => DropdownMenuItem<int>(
                      value: key, child: Text('Desde: ${bancos.get(key)['name']}'))
                  ).toList(),
                  onChanged: (val) => setState(() => cuentaSeleccionada = val), // Renombrado de selectedAccount
                  validator: (val) => val == null ? 'Selecciona origen' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  value: cuentaDestino, // Renombrado de destinationAccount
                  hint: const Text('Cuenta Destino'),
                  decoration: const InputDecoration(labelText: 'Hacia'),
                  isExpanded: true,
                  items: bancos.keys.where((key) => key != cuentaSeleccionada).map<DropdownMenuItem<int>>((key) => DropdownMenuItem<int>( // Renombrado de selectedAccount
                      value: key, child: Text('Hacia: ${bancos.get(key)['name']}'))
                  ).toList(),
                  onChanged: (val) => setState(() => cuentaDestino = val), // Renombrado de destinationAccount
                  validator: (val) => val == null ? 'Selecciona destino' : null,
                ),
              ],
              const SizedBox(height: 16),
              TextFormField(
                controller: controladorDescripcion, // Renombrado de descController
                decoration: const InputDecoration(labelText: 'Descripción (opcional)'),
                onSaved: (val) => descripcion = val?.trim() ?? '', // Renombrado de description
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Fecha del movimiento'),
                subtitle: Text(DateFormat('EEEE, d MMM y', 'es').format(fechaSeleccionada)),
                trailing: const Icon(Icons.calendar_today_outlined),
                onTap: () async {
                  final seleccionada = await showDatePicker( // Renombrado de picked
                    context: context, initialDate: fechaSeleccionada,
                    firstDate: DateTime(DateTime.now().year - 5), lastDate: DateTime.now(),
                    locale: const Locale('es'),
                  );
                  if (seleccionada != null) setState(() => fechaSeleccionada = seleccionada); // Renombrado de picked
                },
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('No afectar saldo'),
                subtitle: const Text('Marcar si el movimiento ya se reflejó en el banco.'),
                value: yaReflejado,
                onChanged: (val) => setState(() => yaReflejado = val),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: const Icon(Icons.save_alt_outlined),
                label: const Text('Guardar Movimiento'),
                onPressed: _guardarMovimiento, // Renombrado de _saveTransaction
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PantallaEditarMovimiento extends StatefulWidget { // Renombrado de EditTransactionScreen
  final dynamic llaveMovimiento; // Renombrado de txKey
  final Map datosMovimiento; // Renombrado de txData
  const PantallaEditarMovimiento({super.key, required this.llaveMovimiento, required this.datosMovimiento}); // Renombrado de txKey, txData
  @override
  @override
  EstadoPantallaEditarMovimiento createState() => EstadoPantallaEditarMovimiento(); // Renombrado de EditTransactionScreenState
}

class EstadoPantallaEditarMovimiento extends State<PantallaEditarMovimiento> { // Renombrado de EditTransactionScreenState
  late String tipo; // Renombrado de type
  late double monto; // Renombrado de amount
  late String descripcion; // Renombrado de description
  late DateTime fechaSeleccionada;
  late bool yaReflejado;
  late double montoOriginal; // Renombrado de originalAmount
  late bool reflejadoOriginal; // Renombrado de originalReflejado
  final _controladorMonto = TextEditingController(); // Renombrado de _amountController
  final _controladorDescripcion = TextEditingController(); // Renombrado de _descController

  @override
  void initState() {
    super.initState();
    tipo = widget.datosMovimiento['type']; // Renombrado de txData
    monto = widget.datosMovimiento['amount']; // Renombrado de txData
    descripcion = widget.datosMovimiento['description'] ?? ''; // Renombrado de txData
    fechaSeleccionada = DateTime.parse(widget.datosMovimiento['date']); // Renombrado de txData
    yaReflejado = widget.datosMovimiento['reflejado'] == true; // Renombrado de txData
    montoOriginal = monto; // Renombrado de originalAmount
    reflejadoOriginal = yaReflejado; // Renombrado de originalReflejado
    _controladorMonto.text = monto.toStringAsFixed(0); // Renombrado de _amountController
    _controladorDescripcion.text = descripcion; // Renombrado de _descController
  }

  void _revertirMovimientoOriginal() { // Renombrado de _revertOriginalTransaction
    if (reflejadoOriginal) return; // Renombrado de originalReflejado
    final cajaCuentas = Hive.box('bancos'); // Renombrado de accBox, accounts
    if (tipo == 'Ingreso' || tipo == 'Gasto') {
      final llaveCuenta = _encontrarLlaveCuentaPorNombre(widget.datosMovimiento['account']); // Renombrado de accKey, txData, _findAccountKeyByName
      if (llaveCuenta == null) return;
      final cuenta = cajaCuentas.get(llaveCuenta); // Renombrado de acc
      final balanceOriginal = cuenta['balance'] + (tipo == 'Ingreso' ? -montoOriginal : montoOriginal); // Renombrado de originalAmount
      cajaCuentas.put(llaveCuenta, {...cuenta, 'balance': balanceOriginal}); // Renombrado de acc
    } else if (tipo == 'Transferencia') {
      final llaveOrigen = _encontrarLlaveCuentaPorNombre(widget.datosMovimiento['from']); // Renombrado de fromKey, txData, _findAccountKeyByName
      final llaveDestino = _encontrarLlaveCuentaPorNombre(widget.datosMovimiento['to']); // Renombrado de toKey, txData, _findAccountKeyByName
      if (llaveOrigen == null || llaveDestino == null) return;
      final cuentaOrigen = cajaCuentas.get(llaveOrigen); // Renombrado de fromAcc
      final cuentaDestino = cajaCuentas.get(llaveDestino); // Renombrado de toAcc
      cajaCuentas.put(llaveOrigen, {...cuentaOrigen, 'balance': cuentaOrigen['balance'] + montoOriginal}); // Renombrado de fromAcc, originalAmount
      cajaCuentas.put(llaveDestino, {...cuentaDestino, 'balance': cuentaDestino['balance'] - montoOriginal}); // Renombrado de toAcc, originalAmount
    }
  }

  void _aplicarNuevoMovimiento() { // Renombrado de _applyNewTransaction
    if (yaReflejado) return;
    final cajaCuentas = Hive.box('bancos'); // Renombrado de accBox, accounts
    if (tipo == 'Ingreso' || tipo == 'Gasto') {
      final llaveCuenta = _encontrarLlaveCuentaPorNombre(widget.datosMovimiento['account']); // Renombrado de accKey, txData, _findAccountKeyByName
      if (llaveCuenta == null) return;
      final cuenta = cajaCuentas.get(llaveCuenta); // Renombrado de acc
      final nuevoBalance = cuenta['balance'] + (tipo == 'Ingreso' ? monto : -monto);
      cajaCuentas.put(llaveCuenta, {...cuenta, 'balance': nuevoBalance}); // Renombrado de acc
    } else if (tipo == 'Transferencia') {
      final llaveOrigen = _encontrarLlaveCuentaPorNombre(widget.datosMovimiento['from']); // Renombrado de fromKey, txData, _findAccountKeyByName
      final llaveDestino = _encontrarLlaveCuentaPorNombre(widget.datosMovimiento['to']); // Renombrado de toKey, txData, _findAccountKeyByName
      if (llaveOrigen == null || llaveDestino == null) return;
      final cuentaOrigen = cajaCuentas.get(llaveOrigen); // Renombrado de fromAcc
      final cuentaDestino = cajaCuentas.get(llaveDestino); // Renombrado de toAcc
      cajaCuentas.put(llaveOrigen, {...cuentaOrigen, 'balance': cuentaOrigen['balance'] - monto}); // Renombrado de fromAcc
      cajaCuentas.put(llaveDestino, {...cuentaDestino, 'balance': cuentaDestino['balance'] + monto}); // Renombrado de toAcc
    }
  }

  void _actualizarMovimiento() { // Renombrado de _updateTransaction
    if (monto <= 0) return;
    _revertirMovimientoOriginal(); // Renombrado de _revertOriginalTransaction
    _aplicarNuevoMovimiento(); // Renombrado de _applyNewTransaction
    Hive.box('movimientos').put(widget.llaveMovimiento, { // Renombrado de transactions, txKey
      ...widget.datosMovimiento, 'amount': monto, 'description': descripcion, // Renombrado de txData
      'date': fechaSeleccionada.toIso8601String(), 'reflejado': yaReflejado,
    });
    Navigator.pop(context);
  }

  int? _encontrarLlaveCuentaPorNombre(String nombre) { // Renombrado de _findAccountKeyByName, name
    final cajaBancos = Hive.box('bancos'); // Renombrado de accountsBox
    for (var key in cajaBancos.keys) {
      if (cajaBancos.get(key)['name'] == nombre) return key; // Renombrado de name
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Movimiento')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Chip(label: Text('Tipo: $tipo', style: const TextStyle(fontWeight: FontWeight.bold))), // Renombrado de type
            const SizedBox(height: 16),
            TextField(
              controller: _controladorMonto, keyboardType: TextInputType.number, // Renombrado de _amountController
              decoration: const InputDecoration(labelText: 'Monto'),
              onChanged: (val) => monto = double.tryParse(val) ?? 0, // Renombrado de amount
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controladorDescripcion, decoration: const InputDecoration(labelText: 'Descripción'), // Renombrado de _descController
              onChanged: (val) => descripcion = val.trim(), // Renombrado de description
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Fecha del movimiento'),
              subtitle: Text(DateFormat('EEEE, d MMM y', 'es').format(fechaSeleccionada)),
              trailing: const Icon(Icons.calendar_today_outlined),
              onTap: () async {
                final seleccionada = await showDatePicker( // Renombrado de picked
                  context: context, initialDate: fechaSeleccionada,
                  firstDate: DateTime(DateTime.now().year - 5), lastDate: DateTime.now(),
                  locale: const Locale('es'),
                );
                if (seleccionada != null) setState(() => fechaSeleccionada = seleccionada); // Renombrado de picked
              },
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('No afectó saldo'),
              subtitle: const Text('El saldo no fue modificado por esta transacción.'),
              value: yaReflejado,
              onChanged: (val) => setState(() => yaReflejado = val),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _actualizarMovimiento, // Renombrado de _updateTransaction
              child: const Text('Actualizar Movimiento'),
            ),
          ],
        ),
      ),
    );
  }
}

class PantallaHistorialMovimientos extends StatefulWidget { // Renombrado de TransactionHistoryScreen
  const PantallaHistorialMovimientos({super.key});
  @override
  EstadoPantallaHistorialMovimientos createState() => EstadoPantallaHistorialMovimientos(); // Renombrado de TransactionHistoryScreenState
}

class EstadoPantallaHistorialMovimientos extends State<PantallaHistorialMovimientos> { // Renombrado de TransactionHistoryScreenState
  final cajaMovimientos = Hive.box('movimientos'); // Renombrado de transactionsBox
  DateTime? mesSeleccionado; // Renombrado de selectedMonth

  @override
  void initState() {
    super.initState();
    mesSeleccionado = DateTime(DateTime.now().year, DateTime.now().month); // Renombrado de selectedMonth
  }

  // Método para ir al mes anterior
  void _irMesAnterior() {
    setState(() {
      mesSeleccionado = DateTime(mesSeleccionado!.year, mesSeleccionado!.month - 1, 1);
    });
  }

  // Método para ir al mes siguiente
  void _irMesSiguiente() {
    setState(() {
      mesSeleccionado = DateTime(mesSeleccionado!.year, mesSeleccionado!.month + 1, 1);
    });
  }

  Map<String, double> calcularResumenMensual(DateTime mes) {
    double ingresos = 0, gastos = 0, transferencias = 0;
    for (var mov in cajaMovimientos.values) { // Renombrado de transactionsBox, tx
      final fecha = DateTime.parse(mov['date']);
      if (fecha.month == mes.month && fecha.year == mes.year) {
        final monto = mov['amount'] as double;
        if (mov['type'] == 'Ingreso') ingresos += monto;
        if (mov['type'] == 'Gasto') gastos += monto;
        if (mov['type'] == 'Transferencia') transferencias += monto;
      }
    }
    // Calculate balance
    double balance = ingresos - gastos;
    return {'ingresos': ingresos, 'gastos': gastos, 'movimientos': ingresos + gastos + (transferencias * 2), 'balance': balance};
  }

  Future<void> exportarMovimientosAExcel(DateTime mes) async {
    final excel = Excel.createExcel();
    final hoja = excel['Movimientos_${DateFormat('MM_yyyy').format(mes)}']; // Renombrado de sheet
    hoja.appendRow(const ['Fecha', 'Tipo', 'Cuenta Origen', 'Cuenta Destino', 'Monto', 'Descripción']);
    for (var mov in cajaMovimientos.values) { // Renombrado de transactionsBox, tx
      final fechaMov = DateTime.parse(mov['date']);
      if (fechaMov.year == mes.year && fechaMov.month == mes.month) {
        hoja.appendRow([
          DateFormat('yyyy-MM-dd HH:mm').format(fechaMov), mov['type'], mov['account'] ?? mov['from'] ?? '',
          mov['to'] ?? '', mov['amount'], mov['description'] ?? '',
        ]);
      }
    }
    try {
      final dir = await obtenerRutaDescarga(); // Renombrado de getDownloadPath
      if (dir == null) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No se pudo encontrar la carpeta de descargas.')));
        return;
      }
      final rutaArchivo = '$dir/movimientos_${DateFormat('MMMM_yyyy', 'es').format(mes)}.xlsx'; // Renombrado de filePath
      final bytesArchivo = excel.save(); // Renombrado de fileBytes
      if (bytesArchivo != null) {
        File(rutaArchivo)
          ..createSync(recursive: true)
          ..writeAsBytesSync(bytesArchivo);
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Archivo guardado en: $rutaArchivo')));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al exportar: $e')));
    }
  }

  Future<String?> obtenerRutaDescarga() async { // Renombrado de getDownloadPath
    Directory? directorio; // Renombrado de directory
    try {
      if (Platform.isIOS) {
        directorio = await getApplicationDocumentsDirectory();
      } else {
        directorio = Directory('/storage/emulated/0/Download');
        if (!await directorio.exists()) directorio = await getExternalStorageDirectory();
      }
    } catch (err) {
      debugPrint("No se pudo obtener la ruta de la carpeta de descargas");
    }
    return directorio?.path;
  }

  void _eliminarMovimiento(dynamic llave, Map mov) { // Renombrado de _deleteTransaction, key, tx
    final cajaBancos = Hive.box('bancos'); // Renombrado de accountsBox
    final reflejado = mov['reflejado'] == true;
    final tipo = mov['type'];
    final monto = mov['amount'];

    int? encontrarLlave(String? n) { // Renombrado de findKey, name
      try {
        return cajaBancos.keys.firstWhere((k) => cajaBancos.get(k)['name'] == n, orElse: () => -1);
      } catch (e) {
        return null;
      }
    }

    if (!reflejado) {
      if (tipo == 'Ingreso' || tipo == 'Gasto') {
        final llaveCuenta = encontrarLlave(mov['account']); // Renombrado de accKey
        if (llaveCuenta != null && llaveCuenta != -1) {
          final cuenta = cajaBancos.get(llaveCuenta); // Renombrado de acc
          final nuevoBalance = cuenta['balance'] + (tipo == 'Ingreso' ? -monto : monto);
          cajaBancos.put(llaveCuenta, {...cuenta, 'balance': nuevoBalance});
        }
      } else if (tipo == 'Transferencia') {
        final llaveOrigen = encontrarLlave(mov['from']); // Renombrado de fromKey
        final llaveDestino = encontrarLlave(mov['to']); // Renombrado de toKey
        if (llaveOrigen != null && llaveOrigen != -1 && llaveDestino != null && llaveDestino != -1) {
          final cuentaOrigen = cajaBancos.get(llaveOrigen); // Renombrado de fromAcc
          final cuentaDestino = cajaBancos.get(llaveDestino); // Renombrado de toAcc
          cajaBancos.put(llaveOrigen, {...cuentaOrigen, 'balance': cuentaOrigen['balance'] + monto});
          cajaBancos.put(llaveDestino, {...cuentaDestino, 'balance': cuentaDestino['balance'] - monto});
        }
      }
    }
    cajaMovimientos.delete(llave); // Renombrado de transactionsBox, key
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: _irMesAnterior,
            ),
            Expanded(
              child: Text(
                mesSeleccionado != null ? DateFormat.yMMMM('es').format(mesSeleccionado!) : 'Historial',
                textAlign: TextAlign.center,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: _irMesSiguiente,
            ),
          ],
        ),
        actions: [
          if (mesSeleccionado != null) // Renombrado de selectedMonth
            IconButton(
              icon: const Icon(Icons.download_for_offline_outlined),
              tooltip: 'Exportar a Excel',
              onPressed: () => exportarMovimientosAExcel(mesSeleccionado!), // Renombrado de selectedMonth
            ),
          IconButton(
            icon: const Icon(Icons.date_range_outlined),
            tooltip: 'Filtrar por mes',
            onPressed: () async {
              final ahora = DateTime.now();
              final seleccionada = await showDatePicker( // Renombrado de picked
                context: context, initialDate: mesSeleccionado ?? ahora, firstDate: DateTime(ahora.year - 5), // Renombrado de selectedMonth
                lastDate: ahora, locale: const Locale('es'), initialEntryMode: DatePickerEntryMode.calendarOnly,
              );
              if (seleccionada != null) setState(() => mesSeleccionado = DateTime(seleccionada.year, seleccionada.month)); // Renombrado de selectedMonth, picked
            },
          ),
          if (mesSeleccionado != null) // Renombrado de selectedMonth
            IconButton(icon: const Icon(Icons.clear), onPressed: () => setState(() => mesSeleccionado = null)), // Renombrado de selectedMonth
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: cajaMovimientos.listenable(), // Renombrado de transactionsBox
        builder: (context, Box box, _) {
          final todasLasLlaves = box.keys.toList(); // Renombrado de allKeys
          final pares = List.generate(box.length, (i) => MapEntry(todasLasLlaves[i], box.get(todasLasLlaves[i]))); // Renombrado de pairs, allKeys
          pares.sort((a, b) => DateTime.parse(b.value['date']).compareTo(DateTime.parse(a.value['date'])));
          final paresFiltrados = mesSeleccionado == null ? pares : pares.where((e) { // Renombrado de filteredPairs, selectedMonth
            final fechaMov = DateTime.parse(e.value['date']); // Renombrado de txDate
            return fechaMov.year == mesSeleccionado!.year && fechaMov.month == mesSeleccionado!.month; // Renombrado de selectedMonth
          }).toList();

          if (paresFiltrados.isEmpty) {
            return const Center(child: Text('No hay movimientos en este periodo.'));
          }

          return ListView(
            padding: const EdgeInsets.all(8),
            children: [
              if (mesSeleccionado != null) _construirTarjetaResumenMensualHistorial(calcularResumenMensual(mesSeleccionado!)), // Renombrado de selectedMonth, _buildMonthlySummaryCard
              ...paresFiltrados.map((entrada) => _construirTileMovimiento(entrada.key, entrada.value)), // Renombrado de filteredPairs, _buildTransactionTile, entry
            ],
          );
        },
      ),
    );
  }

  Widget _construirTarjetaResumenMensualHistorial(Map<String, double> resumen) { // Renombrado de _buildMonthlySummaryCard
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Resumen del Mes', style: Theme.of(context).textTheme.titleLarge),
            const Divider(height: 24),
            _construirFilaResumenHistorial('Ingresos', resumen['ingresos']!, Colors.green.shade600), // Renombrado de _buildSummaryRow
            _construirFilaResumenHistorial('Gastos', resumen['gastos']!, TemaApp._colorError), // Renombrado de _buildSummaryRow, AppTheme._errorColor
            _construirFilaResumenHistorial('Balance del Mes', resumen['balance']!, resumen['balance']! >= 0 ? Colors.green.shade600 : TemaApp._colorError), // New row for balance
            _construirFilaResumenHistorial('Total Movimientos', resumen['movimientos']!, Theme.of(context).colorScheme.primary), // Renombrado de _buildSummaryRow
          ],
        ),
      ),
    );
  }

  Widget _construirFilaResumenHistorial(String titulo, double monto, Color color) { // Renombrado de _buildSummaryRow
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(titulo, style: const TextStyle(fontSize: 16)),
          Text(
            '\$${formatoMoneda.format(monto)}', // Renombrado de formatCurrency
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _construirTileMovimiento(dynamic llave, Map mov) { // Renombrado de _buildTransactionTile, key, tx
    final fecha = DateTime.parse(mov['date']);
    final fechaFormateada = DateFormat('dd MMM, HH:mm', 'es').format(fecha); // Renombrado de formattedDate
    IconData icono; // Renombrado de icon
    Color color;

    switch (mov['type']) {
      case 'Ingreso':
        icono = Icons.arrow_downward_rounded;
        color = Colors.green.shade600;
        break;
      case 'Gasto':
        icono = Icons.arrow_upward_rounded;
        color = TemaApp._colorError; // Renombrado de AppTheme._colorError
        break;
      case 'Transferencia':
        icono = Icons.swap_horiz_rounded;
        color = Colors.blue.shade600;
        break;
      default:
        icono = Icons.receipt_long_outlined;
        color = Theme.of(context).textTheme.bodySmall!.color!;
    }

    String titulo = mov['type'] == 'Transferencia'
        ? '${mov['from']} → ${mov['to']}'
        : (mov['description']?.isNotEmpty == true ? mov['description'] : mov['account']); // Renombrado de title

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color.withAlpha(26), child: Icon(icono, color: color)), // ~10% opacity // Renombrado de icon
        title: Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)), // Renombrado de title
        subtitle: Text(fechaFormateada), // Renombrado de formattedDate
        trailing: Text(
          '${mov['type'] == 'Ingreso' ? '+' : '-'}\$${formatoMoneda.format(mov['amount'])}', // Renombrado de formatCurrency
          style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        onTap: () => _mostrarDetallesMovimiento(llave, mov, color, icono), // Renombrado de _showTransactionDetails, key, tx, icon
      ),
    );
  }

  void _mostrarDetallesMovimiento(dynamic llave, Map mov, Color color, IconData icono) { // Renombrado de _showTransactionDetails, key, tx, icon
    final fecha = DateTime.parse(mov['date']);
    final fechaFormateada = DateFormat('EEEE, d MMM y, HH:mm', 'es').format(fecha); // Renombrado de formattedDate

    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  CircleAvatar(backgroundColor: color.withAlpha(26), child: Icon(icono, color: color)), // ~10% opacity // Renombrado de icon
                  const SizedBox(width: 16),
                  Expanded(child: Text(mov['type'], style: Theme.of(context).textTheme.headlineSmall)),
                  Text('\$${formatoMoneda.format(mov['amount'])}', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: color)), // Renombrado de formatCurrency
                ]),
                const Divider(height: 32),
                if (mov['description'] != null && mov['description'].isNotEmpty)
                  _filaDetalle('Descripción:', mov['description']), // Renombrado de _detailRow
                if (mov['type'] == 'Ingreso' || mov['type'] == 'Gasto')
                  _filaDetalle('Cuenta:', mov['account']), // Renombrado de _detailRow
                if (mov['type'] == 'Transferencia') ...[
                  _filaDetalle('Desde:', mov['from']), // Renombrado de _detailRow
                  _filaDetalle('Hacia:', mov['to']), // Renombrado de _detailRow
                ],
                _filaDetalle('Fecha:', fechaFormateada), // Renombrado de _detailRow, formattedDate
                if (mov['reflejado'] == true)
                  _filaDetalle('Estado:', 'No afectó el saldo de la cuenta.', icono: Icons.push_pin_outlined), // Renombrado de _detailRow
                const SizedBox(height: 24),
                Row(
                  children: [
                    OutlinedButton.icon(
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Eliminar'),
                      style: OutlinedButton.styleFrom(foregroundColor: TemaApp._colorError, side: const BorderSide(color: TemaApp._colorError)), // Renombrado de AppTheme._colorError
                      onPressed: () {
                        Navigator.pop(context);
                        _eliminarMovimiento(llave, mov); // Renombrado de _deleteTransaction, key, tx
                      },
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('Editar'),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(
                          builder: (_) => PantallaEditarMovimiento(llaveMovimiento: llave, datosMovimiento: mov), // Renombrado de EditTransactionScreen, txKey, txData
                        )).then((_) => setState(() {}));
                      },
                    )
                  ],
                )
              ],
            ),
          );
        }
    );
  }

  Widget _filaDetalle(String etiqueta, String valor, {IconData? icono}) { // Renombrado de _detailRow, label, value, icon
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icono ?? Icons.label_important_outline, size: 18, color: Theme.of(context).colorScheme.primary), // Renombrado de icon
          const SizedBox(width: 8),
          Text('$etiqueta ', style: const TextStyle(fontWeight: FontWeight.bold)), // Renombrado de label
          Expanded(child: Text(valor)), // Renombrado de value
        ],
      ),
    );
  }
}

//==============================================================================
// 🔄 PANTALLA DE DÉBITOS AUTOMÁTICOS (DebitosScreen)
//==============================================================================

class PantallaDebitos extends StatefulWidget { // Renombrado de DebitosScreen
  const PantallaDebitos({super.key});

  @override
  EstadoPantallaDebitos createState() => EstadoPantallaDebitos(); // Made public by removing underscore
}

class EstadoPantallaDebitos extends State<PantallaDebitos> { // Made public by removing underscore
  final cajaDebitos = Hive.box('debitos');
  final cajaBancos = Hive.box('bancos'); // Renombrado de accountsBox

  void _mostrarDialogoDebito({int? llave, Map? debito}) { // Renombrado de _showDebitoDialog, key
    final controladorNombre = TextEditingController(text: debito?['nombre'] ?? ''); // Renombrado de nombreController
    final controladorMonto = TextEditingController(text: debito?['monto']?.toString() ?? ''); // Renombrado de montoController
    int diaSeleccionado = debito?['dia'] ?? 1; // Renombrado de selectedDia
    int? idCuentaSeleccionada = debito?['cuentaId']; // Renombrado de selectedCuentaId

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(llave == null ? 'Nuevo Débito Automático' : 'Editar Débito'), // Renombrado de key
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter establecerEstado) { // Renombrado de setState
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  TextField(controller: controladorNombre, decoration: const InputDecoration(labelText: 'Nombre (Ej: Netflix, Arriendo)')), // Renombrado de nombreController
                  const SizedBox(height: 16),
                  TextField(controller: controladorMonto, decoration: const InputDecoration(labelText: 'Monto', prefixText: '\$ '), keyboardType: TextInputType.number), // Renombrado de montoController
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    value: diaSeleccionado, // Renombrado de selectedDia
                    decoration: const InputDecoration(labelText: 'Día del cobro'),
                    items: List.generate(28, (i) => i + 1).map((d) => DropdownMenuItem(value: d, child: Text('Día $d de cada mes'))).toList(),
                    onChanged: (val) => establecerEstado(() => diaSeleccionado = val!), // Renombrado de setState, selectedDia
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    value: idCuentaSeleccionada, // Renombrado de selectedCuentaId
                    hint: const Text('Seleccionar cuenta a debitar'),
                    decoration: const InputDecoration(labelText: 'Cuenta de Origen'),
                    isExpanded: true,
                    items: cajaBancos.keys.map((key) { // Renombrado de accountsBox
                      return DropdownMenuItem<int>(value: key, child: Text(cajaBancos.get(key)['name'])); // Renombrado de accountsBox
                    }).toList(),
                    onChanged: (val) => establecerEstado(() => idCuentaSeleccionada = val!), // Renombrado de setState, selectedCuentaId
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          TextButton(child: const Text('Cancelar'), onPressed: () => Navigator.pop(context)),
          ElevatedButton(
            child: const Text('Guardar'),
            onPressed: () {
              final nombre = controladorNombre.text.trim(); // Renombrado de nombreController
              final monto = double.tryParse(controladorMonto.text) ?? 0; // Renombrado de montoController
              if (nombre.isNotEmpty && monto > 0 && idCuentaSeleccionada != null) { // Renombrado de selectedCuentaId
                final datos = { // Renombrado de data
                  'nombre': nombre, 'monto': monto, 'dia': diaSeleccionado, // Renombrado de selectedDia
                  'cuentaId': idCuentaSeleccionada, 'ultimaEjecucion': debito?['ultimaEjecucion'], // Renombrado de selectedCuentaId
                };
                datos['proximaFecha'] = debito?['proximaFecha'];
                if (llave == null) { // Renombrado de key
                  cajaDebitos.add(datos); // Renombrado de data
                } else {
                  cajaDebitos.put(llave, datos); // Renombrado de key, data
                }
                Navigator.pop(context);
                setState(() {});
              }
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Débitos Automáticos')),
      body: ValueListenableBuilder(
        valueListenable: cajaDebitos.listenable(), // Renombrado de debitosBox
        builder: (context, Box box, _) {
          final debitos = box.toMap();
          if (debitos.isEmpty) {
            return const Center(child: Text('No has configurado débitos automáticos.'));
          }
          return ListView(
            padding: const EdgeInsets.all(8),
            children: debitos.entries.map((entrada) { // Renombrado de entry
              final debito = entrada.value;
              final cuenta = cajaBancos.get(debito['cuentaId']); // Renombrado de accountsBox
              final proximaFecha = debito['proximaFecha'] != null
                  ? DateFormat('dd/MM/yyyy').format(DateTime.parse(debito['proximaFecha']))
                  : 'Pendiente';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.event_repeat_outlined)),
                  title: Text(debito['nombre'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      'Día ${debito['dia']} de cada mes\n'
                          'Desde: ${cuenta?['name'] ?? 'N/A'}\n'
                          'Próximo cobro: $proximaFecha'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('\$${formatoMoneda.format(debito['monto'])}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), // Renombrado de formatCurrency
                      PopupMenuButton<String>(
                        onSelected: (valor) { // Renombrado de value
                          if (valor == 'Editar') {
                            _mostrarDialogoDebito(llave: entrada.key, debito: debito); // Renombrado de _showDebitoDialog, key
                          } else if (valor == 'Eliminar') {
                            cajaDebitos.delete(entrada.key); // Renombrado de debitosBox, key
                            setState(() {});
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(value: 'Editar', child: Text('Editar')),
                          const PopupMenuItem(value: 'Eliminar', child: Text('Eliminar')),
                        ],
                        icon: const Icon(Icons.more_vert),
                      )
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _mostrarDialogoDebito(), // Renombrado de _showDebitoDialog
        label: const Text('Nuevo Débito'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

//==============================================================================
// 📝 PANTALLA DE NOTAS (NotesScreen)
//==============================================================================

class PantallaNotas extends StatefulWidget { // Renombrado de NotesScreen
  const PantallaNotas({super.key});

  @override
  EstadoPantallaNotas createState() => EstadoPantallaNotas(); // Renombrado de NotesScreenState
}

class EstadoPantallaNotas extends State<PantallaNotas> { // Renombrado de NotesScreenState
  final cajaNotas = Hive.box('notas'); // Renombrado de notesBox
  final TextEditingController _controlador = TextEditingController(); // Renombrado de _controller

  void _mostrarDialogoNota({int? llave, String? textoExistente}) { // Renombrado de _showNoteDialog, key, existingText
    _controlador.text = textoExistente ?? ''; // Renombrado de _controller, existingText
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(llave == null ? 'Nueva Nota' : 'Editar Nota'), // Renombrado de key
        content: TextField(
          controller: _controlador, // Renombrado de _controller
          autofocus: true,
          maxLines: 8,
          decoration: const InputDecoration(
              hintText: 'Escribe tus ideas, recordatorios, etc.',
              border: OutlineInputBorder()
          ),
        ),
        actions: [
          TextButton(child: const Text('Cancelar'), onPressed: () => Navigator.pop(context)),
          ElevatedButton(
            child: const Text('Guardar'),
            onPressed: () {
              final texto = _controlador.text.trim(); // Renombrado de text, _controller
              if (texto.isNotEmpty) {
                if (llave == null) { // Renombrado de key
                  cajaNotas.add(texto); // Renombrado de notesBox, text
                } else {
                  cajaNotas.put(llave, texto); // Renombrado de notesBox, key, text
                }
              }
              Navigator.pop(context);
              setState(() {});
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notas Rápidas')),
      body: ValueListenableBuilder(
        valueListenable: cajaNotas.listenable(), // Renombrado de notesBox
        builder: (context, Box box, _) {
          final notas = box.toMap().entries.toList(); // Renombrado de notes
          if (notas.isEmpty) {
            return const Center(child: Text('No hay notas guardadas.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: notas.length,
            itemBuilder: (context, indice) { // Renombrado de index
              final entrada = notas[indice]; // Renombrado de entry
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: ListTile(
                  title: Text(entrada.value, maxLines: 5, overflow: TextOverflow.ellipsis), // Renombrado de entry
                  onTap: () => _mostrarDialogoNota(llave: entrada.key, textoExistente: entrada.value), // Renombrado de _showNoteDialog, key, existingText, entry
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: TemaApp._colorError), // Renombrado de AppTheme._colorError
                    onPressed: () {
                      cajaNotas.delete(entrada.key); // Renombrado de notesBox, key
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Nueva Nota',
        child: const Icon(Icons.add),
        onPressed: () => _mostrarDialogoNota(), // Renombrado de _showNoteDialog
      ),
    );
  }
}

//==============================================================================
// � PANTALLA DE RECORDATORIOS (RemindersScreen)
//==============================================================================

class PantallaRecordatorios extends StatefulWidget {
  const PantallaRecordatorios({super.key});

  @override
  EstadoPantallaRecordatorios createState() => EstadoPantallaRecordatorios();
}

class EstadoPantallaRecordatorios extends State<PantallaRecordatorios> {
  final cajaRecordatorios = Hive.box('recordatorios');
  final TextEditingController _controladorNombre = TextEditingController();
  final TextEditingController _controladorValor = TextEditingController();
  final TextEditingController _controladorNotas = TextEditingController(); // Nuevo controlador para notas

  String _tipoFrecuencia = 'Una vez'; // Valor predeterminado
  DateTime _fechaSeleccionada = DateTime.now();
  int? _diaSeleccionado; // Para mensual
  int? _mesSeleccionado; // Para anual


  @override
  void dispose() {
    _controladorNombre.dispose();
    _controladorValor.dispose();
    _controladorNotas.dispose(); // Disponer también del controlador de notas
    super.dispose();
  }

  void _mostrarDialogoRecordatorio({int? llave, Map? recordatorioExistente}) {
    _controladorNombre.text = recordatorioExistente?['nombre'] ?? '';
    _controladorValor.text = recordatorioExistente?['valor']?.toString() ?? '';
    _controladorNotas.text = recordatorioExistente?['notas'] ?? ''; // Cargar notas existentes

    _tipoFrecuencia = recordatorioExistente?['tipoFrecuencia'] ?? 'Una vez';
    if (recordatorioExistente != null) {
      if (_tipoFrecuencia == 'Una vez' && recordatorioExistente['fecha'] != null) {
        _fechaSeleccionada = DateTime.parse(recordatorioExistente['fecha']);
      } else if (_tipoFrecuencia == 'Mensual' && recordatorioExistente['dia'] != null) {
        _diaSeleccionado = recordatorioExistente['dia'] as int;
        _fechaSeleccionada = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          _diaSeleccionado ?? 1
        );
      } else if (_tipoFrecuencia == 'Anual' && recordatorioExistente['dia'] != null && recordatorioExistente['mes'] != null) {
        _diaSeleccionado = recordatorioExistente['dia'] as int;
        _mesSeleccionado = recordatorioExistente['mes'] as int;
        _fechaSeleccionada = DateTime(
          DateTime.now().year,
          _mesSeleccionado ?? 1,
          _diaSeleccionado ?? 1
        );
      } else {
        _fechaSeleccionada = DateTime.now();
      }
    } else {
      _fechaSeleccionada = DateTime.now();
    }


    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(llave == null ? 'Nuevo Recordatorio' : 'Editar Recordatorio'),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter establecerEstadoDialogo) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _controladorNombre,
                    decoration: const InputDecoration(labelText: 'Nombre del Recordatorio'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _controladorValor,
                    decoration: const InputDecoration(labelText: 'Valor (opcional)', prefixText: '\$ '),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  // Campo de notas/observaciones
                  TextField(
                    controller: _controladorNotas,
                    decoration: const InputDecoration(labelText: 'Notas / Observaciones (opcional)'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  // Dropdown de frecuencia
                  DropdownButtonFormField<String>(
                    value: _tipoFrecuencia,
                    decoration: const InputDecoration(labelText: 'Frecuencia'),
                    items: ['Una vez', 'Mensual', 'Anual'].map((tipo) => DropdownMenuItem(value: tipo, child: Text(tipo))).toList(),
                    onChanged: (val) {
                      establecerEstadoDialogo(() {
                        _tipoFrecuencia = val!;
                        // Reiniciar valores de fecha/día/mes al cambiar frecuencia
                        _fechaSeleccionada = DateTime.now();
                        _diaSeleccionado = null;
                        _mesSeleccionado = null;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  // Campos de fecha condicionales
                  if (_tipoFrecuencia == 'Una vez')
                    ListTile(
                      title: const Text('Fecha'),
                      subtitle: Text(DateFormat('EEEE, d MMM y', 'es').format(_fechaSeleccionada)),
                      trailing: const Icon(Icons.calendar_today_outlined),
                      onTap: () async {
                        final fechaElegida = await showDatePicker(
                          context: context,
                          initialDate: _fechaSeleccionada,
                          firstDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
                          lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                          locale: const Locale('es'),
                        );
                        if (fechaElegida != null) {
                          establecerEstadoDialogo(() {
                            _fechaSeleccionada = fechaElegida;
                          });
                        }
                      },
                    ),
                  if (_tipoFrecuencia == 'Mensual')
                    DropdownButtonFormField<int>(
                      value: _diaSeleccionado,
                      decoration: const InputDecoration(labelText: 'Día del mes'),
                      items: List.generate(28, (i) => i + 1).map((d) => DropdownMenuItem(value: d, child: Text('Día $d'))).toList(),
                      onChanged: (val) => establecerEstadoDialogo(() => _diaSeleccionado = val!),
                      validator: (val) => val == null ? 'Selecciona un día' : null,
                    ),
                  if (_tipoFrecuencia == 'Anual') ...[
                    DropdownButtonFormField<int>(
                      value: _mesSeleccionado,
                      decoration: const InputDecoration(labelText: 'Mes'),
                      items: List.generate(12, (i) => i + 1).map((m) => DropdownMenuItem(value: m, child: Text(DateFormat.MMMM('es').format(DateTime(2023, m))))).toList(),
                      onChanged: (val) => establecerEstadoDialogo(() => _mesSeleccionado = val!),
                      validator: (val) => val == null ? 'Selecciona un mes' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: _diaSeleccionado,
                      decoration: const InputDecoration(labelText: 'Día del mes'),
                      items: List.generate(31, (i) => i + 1).map((d) => DropdownMenuItem(value: d, child: Text('Día $d'))).toList(),
                      onChanged: (val) => establecerEstadoDialogo(() => _diaSeleccionado = val!),
                      validator: (val) => val == null ? 'Selecciona un día' : null,
                    ),
                  ],
                ],
              ),
            );
          },
        ),
        actions: [
          TextButton(child: const Text('Cancelar'), onPressed: () => Navigator.pop(context)),
          ElevatedButton(
            child: const Text('Guardar'),
            onPressed: () {
              final nombre = _controladorNombre.text.trim();
              final valor = double.tryParse(_controladorValor.text);
              final notas = _controladorNotas.text.trim();

              if (nombre.isNotEmpty) {
                final datos = {
                  'nombre': nombre,
                  'valor': valor,
                  'notas': notas, // Guardar notas
                  'tipoFrecuencia': _tipoFrecuencia,
                };

                if (_tipoFrecuencia == 'Una vez') {
                  datos['fecha'] = _fechaSeleccionada.toIso8601String();
                } else if (_tipoFrecuencia == 'Mensual') {
                  if (_diaSeleccionado == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Por favor, selecciona un día para el recordatorio mensual.')),
                    );
                    return;
                  }
                  datos['dia'] = _diaSeleccionado;
                } else if (_tipoFrecuencia == 'Anual') {
                  if (_diaSeleccionado == null || _mesSeleccionado == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Por favor, selecciona un día y un mes para el recordatorio anual.')),
                    );
                    return;
                  }
                  datos['dia'] = _diaSeleccionado;
                  datos['mes'] = _mesSeleccionado;
                }

                if (llave == null) {
                  cajaRecordatorios.add(datos);
                } else {
                  cajaRecordatorios.put(llave, datos);
                }
                Navigator.pop(context);
                setState(() {}); // Actualiza la lista en la pantalla
              }
            },
          )
        ],
      ),
    );
  }

  void _eliminarRecordatorio(dynamic llave) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Eliminar recordatorio?'),
        content: const Text('Esta acción no se puede deshacer.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: TemaApp._colorError),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmado == true) {
      cajaRecordatorios.delete(llave);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recordatorios')),
      body: ValueListenableBuilder(
        valueListenable: cajaRecordatorios.listenable(),
        builder: (context, Box box, _) {
          final recordatoriosConFechaProxima = box.toMap().entries.map((entrada) {
            final recordatorio = entrada.value;
            final proximaFecha = _calcularProximaFechaRecordatorio(recordatorio);
            return MapEntry(entrada.key, {'data': recordatorio, 'proximaFecha': proximaFecha});
          }).where((entrada) {
            // Filtrar recordatorios que tienen una próxima fecha válida
            return entrada.value['proximaFecha'] != null;
          }).toList();

          // Ordenar por la próxima fecha de ocurrencia
          recordatoriosConFechaProxima.sort((a, b) =>
              (a.value['proximaFecha'] as DateTime).compareTo(b.value['proximaFecha'] as DateTime));

          if (recordatoriosConFechaProxima.isEmpty) {
            return const Center(child: Text('No hay recordatorios guardados.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: recordatoriosConFechaProxima.length,
            itemBuilder: (context, indice) {
              final entrada = recordatoriosConFechaProxima[indice];
              final recordatorio = entrada.value['data'];
              final proximaFecha = entrada.value['proximaFecha'] as DateTime;
              final diasRestantes = proximaFecha.difference(DateTime.now()).inDays;
              final tieneValor = recordatorio['valor'] != null && recordatorio['valor'] > 0;
              final tieneNotas = recordatorio['notas'] != null && recordatorio['notas'].isNotEmpty;

              Color cardColor;
              Color iconColor;
              TextStyle textStyle = TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color);
              TextDecoration? textDecoration;

              if (diasRestantes < 0) { // Vencido
                cardColor = Colors.grey.shade200;
                iconColor = Colors.grey.shade600;
                textDecoration = TextDecoration.lineThrough;
                textStyle = TextStyle(color: Colors.grey.shade600, decoration: textDecoration);
              } else if (diasRestantes <= 7) { // 7 días o menos
                cardColor = Color.fromRGBO(
                  (TemaApp._colorAdvertencia.r * 255.0).round() & 0xff,
                  (TemaApp._colorAdvertencia.g * 255.0).round() & 0xff,
                  (TemaApp._colorAdvertencia.b * 255.0).round() & 0xff,
                  0.1,
                );
                iconColor = TemaApp._colorAdvertencia;
              } else if (diasRestantes <= 15) { // 8 a 15 días
                cardColor = Colors.amber.shade100;
                iconColor = Colors.amber.shade700;
              } else if (diasRestantes <= 30) { // 16 a 30 días
                cardColor = Colors.lightBlue.shade100;
                iconColor = Colors.lightBlue.shade700;
              } else { // Más de 30 días
                cardColor = Theme.of(context).cardColor;
                iconColor = Theme.of(context).colorScheme.primary;
              }

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                color: cardColor,
                child: ListTile(
                  leading: Icon(Icons.alarm_on_outlined, color: iconColor),
                  title: Text(
                    recordatorio['nombre'],
                    style: textStyle.copyWith(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${DateFormat('dd MMM y', 'es').format(proximaFecha)} '
                            '${tieneValor ? ' - \$${formatoMoneda.format(recordatorio['valor'])}' : ''}',
                        style: textStyle,
                      ),
                      Text(
                        diasRestantes >= 0
                            ? 'Faltan $diasRestantes días'
                            : 'Vencido hace ${diasRestantes.abs()} días',
                        style: textStyle.copyWith(fontSize: 12, fontStyle: FontStyle.italic),
                      ),
                      if (tieneNotas)
                        Text(
                          'Notas: ${recordatorio['notas']}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textStyle.copyWith(fontSize: 12),
                        ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () => _mostrarDialogoRecordatorio(llave: entrada.key, recordatorioExistente: recordatorio),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: TemaApp._colorError),
                        onPressed: () => _eliminarRecordatorio(entrada.key),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _mostrarDialogoRecordatorio(),
        label: const Text('Nuevo Recordatorio'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

//==============================================================================
// 📊 PANTALLA DE PRESUPUESTO Y METAS (BudgetScreen)
//==============================================================================
class PantallaPresupuesto extends StatefulWidget { // Renombrado de BudgetScreen
  const PantallaPresupuesto({super.key});

  @override
  EstadoPantallaPresupuesto createState() => EstadoPantallaPresupuesto(); // Renombrado de BudgetScreenState
}

class EstadoPantallaPresupuesto extends State<PantallaPresupuesto> { // Renombrado de BudgetScreenState
  final Box cajaAjustes = Hive.box('ajustes'); // Renombrado de settingsBox
  final Box cajaMetas = Hive.box('metas'); // Renombrado de goalsBox

  final controladorIngreso = TextEditingController(); // Renombrado de ingresoController
  final controladorGasto = TextEditingController(); // Renombrado de gastoController
  final controladorAhorro = TextEditingController(); // Renombrado de ahorroController
  final controladorInversion = TextEditingController(); // Renombrado de inversionController
  final controladorMeta = TextEditingController(); // Renombrado de metaController
  final controladorPrecio = TextEditingController(); // Renombrado de precioController
  final controladorMeses = TextEditingController(); // Renombrado de mesesController

  double ingresoPronosticado = 0;
  double porcentajeGasto = 0, porcentajeAhorro = 0, porcentajeInversion = 0;
  String categoriaSeleccionada = 'Gasto';

  @override
  void initState() {
    super.initState();
    _cargarAjustes(); // Renombrado de _loadSettings
  }

  void _cargarAjustes() { // Renombrado de _loadSettings
    ingresoPronosticado = cajaAjustes.get('ingreso', defaultValue: 0.0); // Renombrado de settingsBox
    porcentajeGasto = cajaAjustes.get('gasto', defaultValue: 50.0); // Renombrado de settingsBox
    porcentajeAhorro = cajaAjustes.get('ahorro', defaultValue: 25.0); // Renombrado de settingsBox
    porcentajeInversion = cajaAjustes.get('inversion', defaultValue: 25.0); // Renombrado de settingsBox

    controladorIngreso.text = ingresoPronosticado.toStringAsFixed(0); // Renombrado de ingresoController
    controladorGasto.text = porcentajeGasto.toStringAsFixed(0); // Renombrado de gastoController
    controladorAhorro.text = porcentajeAhorro.toStringAsFixed(0); // Renombrado de ahorroController
    controladorInversion.text = porcentajeInversion.toStringAsFixed(0); // Renombrado de inversionController
  }

  void _guardarAjustes() { // Renombrado de _saveSettings
    cajaAjustes.put('ingreso', double.tryParse(controladorIngreso.text) ?? 0.0); // Renombrado de settingsBox, ingresoController
    cajaAjustes.put('gasto', double.tryParse(controladorGasto.text) ?? 0.0); // Renombrado de settingsBox, gastoController
    cajaAjustes.put('ahorro', double.tryParse(controladorAhorro.text) ?? 0.0); // Renombrado de settingsBox, ahorroController
    cajaAjustes.put('inversion', double.tryParse(controladorInversion.text) ?? 0.0); // Renombrado de settingsBox, inversionController
    setState(() => _cargarAjustes()); // Renombrado de _loadSettings
  }

  Future<void> _agregarMeta() async { // Renombrado de _addGoal
    final nombre = controladorMeta.text.trim(); // Renombrado de metaController
    final precio = double.tryParse(controladorPrecio.text) ?? 0; // Renombrado de precioController
    final meses = int.tryParse(controladorMeses.text) ?? 1; // Renombrado de mesesController

    if (nombre.isNotEmpty && precio > 0 && meses > 0) {
      final nuevaLlave = await cajaMetas.add({ // Renombrado de goalsBox
        'nombre': nombre, 'precio': precio, 'meses': meses,
        'categoria': categoriaSeleccionada,
      });
      final ordenActual = List<int>.from(cajaAjustes.get('ordenMetas', defaultValue: [])); // Renombrado de settingsBox
      ordenActual.add(nuevaLlave);
      cajaAjustes.put('ordenMetas', ordenActual); // Renombrado de settingsBox
      controladorMeta.clear(); // Renombrado de metaController
      controladorPrecio.clear(); // Renombrado de precioController
      controladorMeses.clear(); // Renombrado de mesesController
      setState(() {});
    }
  }

  void _editarMeta(int llave, Map meta) { // Renombrado de _editGoal, key
    final controladorNombre = TextEditingController(text: meta['nombre']); // Renombrado de nombreController
    final controladorPrecio = TextEditingController(text: meta['precio'].toStringAsFixed(0)); // Renombrado de precioController
    final controladorMeses = TextEditingController(text: meta['meses'].toString()); // Renombrado de mesesController
    String nuevaCategoria = meta['categoria']; // Renombrado de nuevaCategoria

    showDialog(context: context, builder: (_) => StatefulBuilder(
      builder: (context, establecerEstadoDialogo) => AlertDialog( // Renombrado de setDialogState
        title: const Text('Editar Meta'),
        content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: controladorNombre, decoration: const InputDecoration(labelText: 'Nombre')), // Renombrado de nombreController
          const SizedBox(height: 16),
          TextField(controller: controladorPrecio, decoration: const InputDecoration(labelText: 'Valor total'), keyboardType: TextInputType.number), // Renombrado de precioController
          const SizedBox(height: 16),
          TextField(controller: controladorMeses, decoration: const InputDecoration(labelText: 'Meses'), keyboardType: TextInputType.number), // Renombrado de mesesController
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: nuevaCategoria, decoration: const InputDecoration(labelText: 'Categoría'), // Renombrado de nuevaCategoria
            items: ['Gasto', 'Ahorro', 'Inversion'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
            onChanged: (val) => establecerEstadoDialogo(() => nuevaCategoria = val!), // Renombrado de setDialogState, nuevaCategoria
          ),
        ])),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              cajaMetas.delete(llave); // Renombrado de goalsBox, key
              final orden = List<int>.from(cajaAjustes.get('ordenMetas', defaultValue: [])); // Renombrado de settingsBox
              orden.remove(llave); // Renombrado de key
              cajaAjustes.put('ordenMetas', orden); // Renombrado de settingsBox
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('Eliminar', style: TextStyle(color: TemaApp._colorError)), // Renombrado de AppTheme._colorError
          ),
          ElevatedButton(
            child: const Text('Guardar'),
            onPressed: () {
              cajaMetas.put(llave, { // Renombrado de goalsBox, key
                'nombre': controladorNombre.text.trim(), // Renombrado de nombreController
                'precio': double.tryParse(controladorPrecio.text) ?? meta['precio'], // Renombrado de precioController
                'meses': int.tryParse(controladorMeses.text) ?? meta['meses'], // Renombrado de mesesController
                'categoria': nuevaCategoria, // Renombrado de nuevaCategoria
              });
              Navigator.pop(context);
              setState(() {});
            },
          ),
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Presupuesto y Metas')),
      body: ValueListenableBuilder(
          valueListenable: cajaMetas.listenable(), // Renombrado de goalsBox
          builder: (context, Box box, _) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _construirTarjetaConfiguracion(), // Renombrado de _buildConfigCard
                const SizedBox(height: 24),
                _construirTarjetaPresupuestoCalculado(), // Renombrado de _buildCalculatedBudgetCard
                const SizedBox(height: 24),
                _construirTarjetaAgregarMeta(), // Renombrado de _buildAddGoalCard
                const SizedBox(height: 24),
                _construirListaMetas(), // Renombrado de _buildGoalsList
              ],
            );
          }),
    );
  }

  Widget _construirTarjetaConfiguracion() { // Renombrado de _buildConfigCard
    double totalAsignado = porcentajeGasto + porcentajeAhorro + porcentajeInversion;
    Color colorResumen = totalAsignado == 100 ? Colors.green : (totalAsignado < 100 ? TemaApp._colorAdvertencia : TemaApp._colorError); // Renombrado de AppTheme._warningColor, AppTheme._errorColor

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Configuración Mensual', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextField(controller: controladorIngreso, decoration: const InputDecoration(labelText: 'Ingreso Mensual Pronosticado'), keyboardType: TextInputType.number, onEditingComplete: _guardarAjustes), // Renombrado de ingresoController, _saveSettings
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: TextField(controller: controladorGasto, decoration: const InputDecoration(labelText: 'Gasto %'), keyboardType: TextInputType.number, onEditingComplete: _guardarAjustes)), // Renombrado de gastoController, _saveSettings
              const SizedBox(width: 8),
              Expanded(child: TextField(controller: controladorAhorro, decoration: const InputDecoration(labelText: 'Ahorro %'), keyboardType: TextInputType.number, onEditingComplete: _guardarAjustes)), // Renombrado de ahorroController, _saveSettings
              const SizedBox(width: 8),
              Expanded(child: TextField(controller: controladorInversion, decoration: const InputDecoration(labelText: 'Inversión %'), keyboardType: TextInputType.number, onEditingComplete: _guardarAjustes)), // Renombrado de inversionController, _saveSettings
            ]),
            const SizedBox(height: 16),
            Chip(
              label: Text('${totalAsignado.toStringAsFixed(0)}% Asignado', style: const TextStyle(fontWeight: FontWeight.bold)),
              backgroundColor: colorResumen.withAlpha(51), // ~20% opacity
              side: BorderSide(color: colorResumen),
            ),
          ],
        ),
      ),
    );
  }

  Widget _construirTarjetaPresupuestoCalculado() { // Renombrado de _buildCalculatedBudgetCard
    double montoGasto = ingresoPronosticado * porcentajeGasto / 100;
    double montoAhorro = ingresoPronosticado * porcentajeAhorro / 100;
    double montoInversion = ingresoPronosticado * porcentajeInversion / 100;
    double totalMensual(String tipo) => cajaMetas.values.where((m) => m['categoria'] == tipo).fold(0.0, (s, m) => s + (m['precio'] / m['meses'])); // Renombrado de goalsBox

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Presupuesto Disponible', style: Theme.of(context).textTheme.titleLarge),
            const Divider(height: 24),
            _filaPresupuesto('Gastos', montoGasto, totalMensual('Gasto')), // Renombrado de _budgetRow
            _filaPresupuesto('Ahorros', montoAhorro, totalMensual('Ahorro')), // Renombrado de _budgetRow
            _filaPresupuesto('Inversiones', montoInversion, totalMensual('Inversion')), // Renombrado de _budgetRow
          ],
        ),
      ),
    );
  }

  Widget _filaPresupuesto(String titulo, double presupuestoTotal, double comprometido) { // Renombrado de _budgetRow
    double disponible = presupuestoTotal - comprometido;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('\$${formatoMoneda.format(disponible)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), // Renombrado de formatCurrency
          ]),
          const SizedBox(height: 4),
          Text('Total: \$${formatoMoneda.format(presupuestoTotal)} | Comprometido: \$${formatoMoneda.format(comprometido)}', style: Theme.of(context).textTheme.bodySmall), // Renombrado de formatCurrency
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: presupuestoTotal > 0 ? comprometido / presupuestoTotal : 0,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _construirTarjetaAgregarMeta() { // Renombrado de _buildAddGoalCard
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Agregar Meta o Gasto Fijo', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextField(controller: controladorMeta, decoration: const InputDecoration(labelText: 'Nombre de la meta')), // Renombrado de metaController
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: TextField(controller: controladorPrecio, decoration: const InputDecoration(labelText: 'Valor total', prefixText: '\$'), keyboardType: TextInputType.number)), // Renombrado de precioController
              const SizedBox(width: 8),
              Expanded(child: TextField(controller: controladorMeses, decoration: const InputDecoration(labelText: 'Meses'), keyboardType: TextInputType.number)), // Renombrado de mesesController
            ]),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: categoriaSeleccionada,
              decoration: const InputDecoration(labelText: 'Categoría'),
              items: ['Gasto', 'Ahorro', 'Inversion'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (val) => setState(() => categoriaSeleccionada = val!),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.add_task_outlined),
              label: const Text('Agregar Meta'),
              onPressed: _agregarMeta, // Renombrado de _addGoal
            ),
          ],
        ),
      ),
    );
  }

  Widget _construirListaMetas() { // Renombrado de _buildGoalsList
    final ajustes = Hive.box('ajustes'); // Renombrado de settings
    final orden = List<int>.from(ajustes.get('ordenMetas', defaultValue: cajaMetas.keys.cast<int>().toList())); // Renombrado de settings, goalsBox
    final metasFiltradas = orden.where((k) => cajaMetas.containsKey(k)).toList(); // Renombrado de goalsBox

    if (metasFiltradas.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Metas Actuales', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          onReorder: (indiceAntiguo, nuevoIndice) { // Renombrado de oldIndex, newIndex
            if (nuevoIndice > indiceAntiguo) nuevoIndice--; // Renombrado de oldIndex, newIndex
            final llaveMovida = metasFiltradas.removeAt(indiceAntiguo); // Renombrado de movedKey, oldIndex
            metasFiltradas.insert(nuevoIndice, llaveMovida); // Renombrado de newIndex, movedKey
            ajustes.put('ordenMetas', metasFiltradas); // Renombrado de settings
            setState(() {});
          },
          children: metasFiltradas.map((llave) { // Renombrado de key
            final meta = cajaMetas.get(llave); // Renombrado de goalsBox, key
            final mensual = meta['precio'] / meta['meses'];
            String formatoAniosMeses(int meses) {
              final anios = meses ~/ 12; final resto = meses % 12;
              if (anios > 0 && resto > 0) return '$anios a, $resto m';
              if (anios > 0) return '$anios año(s)';
              return '$resto mes(es)';
            }

            return Card(
              key: ValueKey(llave), // Renombrado de key
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: ListTile(
                title: Text('${meta['nombre']} (${meta['categoria']})'),
                subtitle: Text('Total: \$${formatoMoneda.format(meta['precio'])} en ${formatoAniosMeses(meta['meses'])}'), // Renombrado de formatCurrency
                trailing: Text('\$${formatoMoneda.format(mensual)}/mes', style: const TextStyle(fontWeight: FontWeight.bold)), // Renombrado de formatCurrency
                onTap: () => _editarMeta(llave, meta), // Renombrado de _editGoal, key
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

//==============================================================================
// 🛂 PANTALLAS DE CONTROL UVT / DIAN
//==============================================================================
class PantallaControlUVT extends StatefulWidget { // Renombrado de ControlUVTScreen
  const PantallaControlUVT({super.key});

  @override
  EstadoPantallaControlUVT createState() => EstadoPantallaControlUVT();
}

class EstadoPantallaControlUVT extends State<PantallaControlUVT> {
  final cajaAjustes = Hive.box('ajustes'); // Renombrado de settingsBox
  final cajaBancos = Hive.box('bancos'); // Renombrado de accountsBox
  late Set<int> cuentasSeleccionadas;

  @override
  void initState() {
    super.initState();
    final seleccionadas = cajaAjustes.get('cuentasUVT', defaultValue: <int>[]); // Renombrado de settingsBox
    cuentasSeleccionadas = Set<int>.from(seleccionadas);
  }

  void guardarSeleccion() {
    cajaAjustes.put('cuentasUVT', cuentasSeleccionadas.toList()); // Renombrado de settingsBox
  }

  @override
  Widget build(BuildContext context) {
    final cuentas = cajaBancos.toMap().cast<int, dynamic>(); // Renombrado de accountsBox
    return Scaffold(
      appBar: AppBar(title: const Text('Control UVT / DIAN')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Selecciona las cuentas a incluir en el cálculo de topes. Las cuentas con "bolsillo" en el nombre se excluyen por defecto.', style: Theme.of(context).textTheme.bodyLarge),
          ),
          Expanded(
            child: ListView(
              children: cuentas.entries.map((entrada) { // Renombrado de entry
                final id = entrada.key;
                final nombre = entrada.value['name'];
                final esBolsillo = nombre.toLowerCase().contains('bolsillo');
                return CheckboxListTile(
                  title: Text(nombre),
                  subtitle: esBolsillo ? const Text('(Excluida automáticamente)') : null,
                  value: esBolsillo ? false : cuentasSeleccionadas.contains(id),
                  onChanged: esBolsillo ? null : (val) {
                    setState(() {
                      if (val == true) {
                        cuentasSeleccionadas.add(id);
                      } else {
                        cuentasSeleccionadas.remove(id);
                      }
                      guardarSeleccion();
                    });
                  },
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.arrow_forward_ios_rounded),
              label: const Text('Ver Resumen de Topes'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const PantallaResumenUVT())); // Renombrado de UVTResumenScreen
              },
            ),
          )
        ],
      ),
    );
  }
}

class PantallaResumenUVT extends StatefulWidget { // Renombrado de UVTResumenScreen
  const PantallaResumenUVT({super.key});
  @override
  EstadoPantallaResumenUVT createState() => EstadoPantallaResumenUVT(); // Renombrado de UVTResumenScreenState
}

class EstadoPantallaResumenUVT extends State<PantallaResumenUVT> { // Renombrado de UVTResumenScreenState
  // Función auxiliar para manejar la opacidad de los colores
  // Método auxiliar para manejar la opacidad de los colores
  // Nota: withOpacity() está marcado como obsoleto en algunas versiones de Flutter,
  // pero es el método estándar recomendado en versiones recientes
  Color conAlpha(Color color, double opacidad) { // Renombrado de withAlpha, opacity
    return color.withAlpha((opacidad * 255).round());
  }
  final cajaAjustes = Hive.box('ajustes'); // Renombrado de settingsBox
  final cajaBancos = Hive.box('bancos'); // Renombrado de accountsBox
  final cajaMovimientos = Hive.box('movimientos'); // Renombrado de txBox

  final Map<String, int> topesUVT = {'ingresos': 1400, 'patrimonio': 4500, 'movimientos': 1400, 'consumos': 1400, 'compras': 1400};
  final controladorValorUVT = TextEditingController(); // Renombrado de valorUVTController
  Map<String, TextEditingController> controladoresIniciales = {}; // Renombrado de inicialControllers
  late int anioSeleccionado;
  late NumberFormat formatoPesos;

  @override
  void initState() {
    super.initState();
    anioSeleccionado = DateTime.now().year;
    formatoPesos = NumberFormat.decimalPattern('es_CO');
    controladorValorUVT.text = cajaAjustes.get('uvtValor', defaultValue: 47065).toString(); // Renombrado de valorUVTController, settingsBox
    final valoresIniciales = Map<String, double>.from(cajaAjustes.get('uvtValoresIniciales', defaultValue: {})); // Renombrado de settingsBox
    for (var clave in topesUVT.keys) {
      controladoresIniciales[clave] = TextEditingController(text: (valoresIniciales[clave] ?? 0).toStringAsFixed(0)); // Renombrado de inicialControllers
    }
  }

  double get valorUVT => double.tryParse(controladorValorUVT.text) ?? 47065; // Renombrado de valorUVTController

  void guardarValores() {
    final mapa = {for (var c in controladoresIniciales.keys) c: double.tryParse(controladoresIniciales[c]!.text) ?? 0}; // Renombrado de inicialControllers
    cajaAjustes.put('uvtValoresIniciales', mapa); // Renombrado de settingsBox
    cajaAjustes.put('uvtValor', valorUVT); // Renombrado de settingsBox
    setState(() {});
  }

  // Calcula el monto actual de una categoría
  double calcularMonto(String categoria) {
    final seleccionadas = Set<int>.from(cajaAjustes.get('cuentasUVT', defaultValue: [])); // Renombrado de settingsBox
    double total = 0;
    int? buscar(String? n) => n == null ? null : cajaBancos.keys.cast<int>().firstWhere((k) => cajaBancos.get(k)['name'] == n, orElse: () => -1); // Renombrado de accountsBox

    if (categoria == 'patrimonio') {
      total = seleccionadas.fold(0.0, (sum, key) => sum + (cajaBancos.get(key)?['balance'] ?? 0)); // Renombrado de accountsBox
      total += List<Map>.from(cajaAjustes.get('bienesUVT', defaultValue: [])).fold(0.0, (s, b) => s + b['valor']); // Renombrado de settingsBox
    } else {
      for (var mov in cajaMovimientos.values) { // Renombrado de txBox, tx
        if (DateTime.parse(mov['date']).year == anioSeleccionado) {
          final tipo = mov['type'];
          if (categoria == 'ingresos' && tipo == 'Ingreso' && seleccionadas.contains(buscar(mov['account']))) {
            total += mov['amount'];
          } else if ((categoria == 'compras' || categoria == 'consumos') && tipo == 'Gasto' && seleccionadas.contains(buscar(mov['account']))) {
            total += mov['amount'];
          } else if (categoria == 'movimientos') {
            if ((tipo == 'Ingreso' || tipo == 'Gasto') && seleccionadas.contains(buscar(mov['account']))) {
              total += mov['amount'];
            } else if (tipo == 'Transferencia' && (seleccionadas.contains(buscar(mov['from'])) || seleccionadas.contains(buscar(mov['to'])))) {
              total += mov['amount'] * 2;
            }
          }
        }
      }
    }
    return total + (double.tryParse(controladoresIniciales[categoria]?.text ?? '0') ?? 0); // Renombrado de inicialControllers
  }

  // Calcula la proyección anual basada en el gasto actual
  Map<String, dynamic> calcularProyeccionAnual(String categoria, double montoActual, double topeUVT) {
    final ahora = DateTime.now(); // Renombrado de now
    final inicioAnio = DateTime(anioSeleccionado, 1, 1);
    final finAnio = DateTime(anioSeleccionado, 12, 31);

    // Días transcurridos y totales del año
    final diasTranscurridos = ahora.difference(inicioAnio).inDays + 1;
    final diasTotales = finAnio.difference(inicioAnio).inDays + 1;

    // Proyección lineal basada en el gasto actual
    final factorProyeccion = diasTotales / diasTranscurridos;
    final proyeccionAnual = montoActual * factorProyeccion;

    // Porcentaje del año transcurrido
    final porcentajeTranscurrido = (diasTranscurridos / diasTotales) * 100;

    // Tendencias
    final tendencia = proyeccionAnual / (topeUVT * valorUVT);
    String mensajeTendencia;
    Color colorTendencia;

    if (tendencia < 0.8) {
      mensajeTendencia = 'Bajo control';
      colorTendencia = Colors.green.shade600;
    } else if (tendencia < 1.0) {
      mensajeTendencia = 'Cerca del límite';
      colorTendencia = Colors.orange;
    } else {
      mensajeTendencia = 'Sobre el límite';
      colorTendencia = Colors.red.shade700;
    }

    return {
      'proyeccionAnual': proyeccionAnual,
      'porcentajeTranscurrido': porcentajeTranscurrido,
      'diasTranscurridos': diasTranscurridos,
      'diasTotales': diasTotales,
      'tendencia': tendencia,
      'mensajeTendencia': mensajeTendencia,
      'colorTendencia': colorTendencia,
      'sobrepasa': proyeccionAnual > (topeUVT * valorUVT),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resumen Topes UVT')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _construirTarjetaConfiguracionUVT(), // Renombrado de _buildConfigCard
          const SizedBox(height: 16),
          ...topesUVT.entries.map((entrada) => _construirTarjetaCategoria(entrada.key, entrada.value)), // Renombrado de entry, _buildCategoryCard
        ],
      ),
    );
  }

  Widget _construirTarjetaConfiguracionUVT() { // Renombrado de _buildConfigCard
    final fechaDeclaracion = cajaAjustes.get('fechaDeclaracionUVT'); // Renombrado de fechaDec, settingsBox
    final fechaFormateada = fechaDeclaracion != null ? DateFormat('d MMMM y', 'es').format(DateTime.parse(fechaDeclaracion)) : 'No definida';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Row(children: [
            Expanded(child: DropdownButtonFormField<int>(
              value: anioSeleccionado,
              decoration: const InputDecoration(labelText: 'Año Fiscal'),
              onChanged: (nuevo) => setState(() => anioSeleccionado = nuevo!),
              items: List.generate(5, (i) {
                final anio = DateTime.now().year - 2 + i;
                return DropdownMenuItem(value: anio, child: Text(anio.toString()));
              }),
            )),
            const SizedBox(width: 16),
            Expanded(child: TextField(
              controller: controladorValorUVT, keyboardType: TextInputType.number, // Renombrado de valorUVTController
              decoration: const InputDecoration(labelText: 'Valor UVT'),
              onChanged: (_) => guardarValores(),
            )),
          ]),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Fecha límite de declaración'),
            subtitle: Text(fechaFormateada, style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: const Icon(Icons.calendar_month_outlined),
            onTap: () async {
              final seleccionada = await showDatePicker( // Renombrado de picked
                context: context, initialDate: DateTime.now(),
                firstDate: DateTime(DateTime.now().year - 1), lastDate: DateTime(DateTime.now().year + 2),
                locale: const Locale('es'),
              );
              if (seleccionada != null) {
                cajaAjustes.put('fechaDeclaracionUVT', seleccionada.toIso8601String()); // Renombrado de settingsBox, picked
                setState(() {});
              }
            },
          ),
        ]),
      ),
    );
  }

  Widget _construirTarjetaCategoria(String categoria, int topeUVT) { // Renombrado de _buildCategoryCard
    final topePesos = topeUVT * valorUVT;
    final monto = calcularMonto(categoria);
    final porcentaje = monto / topePesos;
    final color = porcentaje >= 1 ? TemaApp._colorError : (porcentaje >= 0.8 ? TemaApp._colorAdvertencia : Colors.green.shade600); // Renombrado de AppTheme._errorColor, AppTheme._warningColor

    // Calcular proyección anual
    final proyeccion = calcularProyeccionAnual(categoria, monto, topeUVT.toDouble());
    final proyeccionAnual = proyeccion['proyeccionAnual'] as double;
    final porcentajeProyeccion = proyeccionAnual / topePesos;
    final colorProyeccion = proyeccion['colorTendencia'] as Color;
    final mensajeTendencia = proyeccion['mensajeTendencia'] as String;
    final porcentajeTranscurrido = proyeccion['porcentajeTranscurrido'] as double;
    final diasTranscurridos = proyeccion['diasTranscurridos'] as int;
    final diasTotales = proyeccion['diasTotales'] as int;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título y estado actual
            Row(
              children: [
                Expanded(
                  child: Text(
                    categoria.toUpperCase(),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: conAlpha(color, 0.1), // Renombrado de withAlpha
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: conAlpha(color, 0.3)), // Renombrado de withAlpha
                  ),
                  child: Text(
                    '${(porcentaje * 100).toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text('Límite: $topeUVT UVT (\$${formatoPesos.format(topePesos)})'),
            const SizedBox(height: 8),

            // Barra de progreso actual
            LinearProgressIndicator(
              value: porcentaje.clamp(0.0, 1.0),
              color: color,
              backgroundColor: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(4),
              minHeight: 8,
            ),
            const SizedBox(height: 12),

            // Resumen actual
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Actual:', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
                    Text('\$${formatoPesos.format(monto)}',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: color)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Días: $diasTranscurridos/$diasTotales',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
                    Text('${porcentajeTranscurrido.toStringAsFixed(1)}% del año',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
                  ],
                ),
              ],
            ),

            // Sección de proyección
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: conAlpha(colorProyeccion, 0.05), // Renombrado de withAlpha
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: conAlpha(colorProyeccion, 0.2)), // Renombrado de withAlpha
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.trending_up, color: colorProyeccion, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'PROYECCIÓN ANUAL',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: colorProyeccion,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '\$${formatoPesos.format(proyeccionAnual)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colorProyeccion,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                        color: conAlpha(colorProyeccion, 0.1), // Renombrado de withAlpha
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          mensajeTendencia,
                          style: TextStyle(
                            color: colorProyeccion,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: porcentajeProyeccion.clamp(0.0, 1.5),
                    color: colorProyeccion,
                    backgroundColor: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4),
                    minHeight: 6,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${(porcentajeProyeccion * 100).toStringAsFixed(1)}% del límite proyectado',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            // Campo para valor manual
            const SizedBox(height: 16),
            TextField(
              controller: controladoresIniciales[categoria], // Renombrado de inicialControllers
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Sumar valor inicial manual',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (_) => guardarValores(),
            ),

            // Botón de gestión de bienes (solo para patrimonio)
            if (categoria == 'patrimonio')
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    icon: const Icon(Icons.inventory_2_outlined, size: 18),
                    label: const Text('Gestionar bienes'),
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: conAlpha(Theme.of(context).primaryColor, 0.3)), // Renombrado de withAlpha
                      ),
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PantallaBienesUVT()), // Renombrado de BienesUVTScreen
                    ).then((_) => setState(() {})),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class PantallaBienesUVT extends StatefulWidget { // Renombrado de BienesUVTScreen
  const PantallaBienesUVT({super.key});

  @override
  EstadoPantallaBienesUVT createState() => EstadoPantallaBienesUVT(); // Renombrado de BienesUVTScreenState
}

class EstadoPantallaBienesUVT extends State<PantallaBienesUVT> { // Renombrado de BienesUVTScreenState
  final cajaAjustes = Hive.box('ajustes'); // Renombrado de settingsBox

  List<Map<String, dynamic>> _obtenerBienes() { // Renombrado de _getBienes
    return List<Map>.from(cajaAjustes.get('bienesUVT', defaultValue: [])).map((b) => Map<String, dynamic>.from(b)).toList(); // Renombrado de settingsBox
  }

  void _guardarBienes(List<Map<String, dynamic>> lista) { // Renombrado de _saveBienes
    cajaAjustes.put('bienesUVT', lista); // Renombrado de settingsBox
    setState(() {});
  }

  void _mostrarDialogo({int? indice}) { // Renombrado de _showDialog, index
    final bienes = _obtenerBienes(); // Renombrado de _getBienes
    final esNuevo = indice == null; // Renombrado de isNuevo
    final controladorNombre = TextEditingController(text: esNuevo ? '' : bienes[indice]['nombre']); // Renombrado de nombreCtrl, index
    final controladorValor = TextEditingController(text: esNuevo ? '' : bienes[indice]['valor'].toString()); // Renombrado de valorCtrl, index

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(esNuevo ? 'Nuevo Bien Patrimonial' : 'Editar Bien'), // Renombrado de isNuevo
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: controladorNombre, decoration: const InputDecoration(labelText: 'Nombre del bien (Carro, Lote, etc)')), // Renombrado de nombreCtrl
            const SizedBox(height: 16),
            TextField(controller: controladorValor, decoration: const InputDecoration(labelText: 'Valor estimado', prefixText: '\$'), keyboardType: TextInputType.number), // Renombrado de valorCtrl
          ],
        ),
        actions: [
          if (!esNuevo) // Renombrado de isNuevo
            TextButton(
              onPressed: () { bienes.removeAt(indice); _guardarBienes(bienes); Navigator.pop(context); }, // Renombrado de index, _saveBienes
              child: const Text('Eliminar', style: TextStyle(color: TemaApp._colorError)), // Renombrado de AppTheme._colorError
            ),
          TextButton(child: const Text('Cancelar'), onPressed: () => Navigator.pop(context)),
          ElevatedButton(
            child: const Text('Guardar'),
            onPressed: () {
              final nombre = controladorNombre.text.trim(); // Renombrado de nombreCtrl
              final valor = double.tryParse(controladorValor.text) ?? 0; // Renombrado de valorCtrl
              if (nombre.isNotEmpty && valor > 0) {
                if (esNuevo) { // Renombrado de isNuevo
                  bienes.add({'nombre': nombre, 'valor': valor});
                } else {
                  bienes[indice] = {'nombre': nombre, 'valor': valor}; // Renombrado de index
                }
                _guardarBienes(bienes); // Renombrado de _saveBienes
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bienes = _obtenerBienes(); // Renombrado de _getBienes
    return Scaffold(
      appBar: AppBar(title: const Text('Bienes Patrimoniales')),
      body: bienes.isEmpty
          ? const Center(child: Text('No has registrado bienes.'))
          : ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: bienes.length,
        itemBuilder: (_, i) {
          final bien = bienes[i];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.inventory_2_outlined)),
              title: Text(bien['nombre']),
              subtitle: Text('\$${NumberFormat.decimalPattern('es_CO').format(bien['valor'])}'),
              onTap: () => _mostrarDialogo(indice: i), // Renombrado de _showDialog, index
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _mostrarDialogo(), // Renombrado de _showDialog
        label: const Text('Agregar Bien'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

//==============================================================================
// 💾 PANTALLA DE COPIA DE SEGURIDAD (BackupScreen)
//==============================================================================

class PantallaCopiaSeguridad extends StatefulWidget { // Renombrado de BackupScreen
  const PantallaCopiaSeguridad({super.key});

  @override
  State<PantallaCopiaSeguridad> createState() => _EstadoPantallaCopiaSeguridad(); // Renombrado de _BackupScreenState
}

class _EstadoPantallaCopiaSeguridad extends State<PantallaCopiaSeguridad> { // Renombrado de _BackupScreenState
  bool _estaCargando = false; // Renombrado de _isLoading
  final List<String> _nombresCajas = [ // Renombrado de _boxNames
    'debitos', 'bancos', 'movimientos', 'notas', 'ajustes', 'metas', // Renombrado de accounts, transactions, notes, settings, goals
    'cuentasUVT', 'uvtValoresIniciales', 'bienesUVT', 'fechaDeclaracionUVT', 'categorias', 'uvt', 'recordatorios' // Agregada la nueva caja
  ];

  Future<bool> _manejarPermisoAlmacenamiento() async { // Renombrado de _handleStoragePermission
    if (await Permission.manageExternalStorage.isGranted) return true;
    final resultado = await Permission.manageExternalStorage.request(); // Renombrado de result
    if (resultado.isGranted) return true;

    if (mounted) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Permiso Requerido'),
          content: const Text('La app necesita permiso de almacenamiento para leer o guardar respaldos. Ve a los ajustes para concederlo.'),
          actions: [
            TextButton(child: const Text('Cancelar'), onPressed: () => Navigator.pop(context)),
            ElevatedButton(
              onPressed: () { openAppSettings(); Navigator.pop(context); },
              child: const Text('Abrir Ajustes'),
            ),
          ],
        ),
      );
    }
    return false;
  }

  Future<void> _exportarDatos() async { // Renombrado de _exportData
    if (!await _manejarPermisoAlmacenamiento()) { // Renombrado de _handleStoragePermission
      _mostrarSnackbar('No se concedió el permiso de almacenamiento.', esError: true); // Renombrado de _showSnackbar, isError
      return;
    }
    setState(() => _estaCargando = true); // Renombrado de _isLoading

    try {
      final Map<String, dynamic> todosLosDatos = {}; // Renombrado de allData
      for (final nombreCaja in _nombresCajas) { // Renombrado de boxName, _boxNames
        if (!Hive.isBoxOpen(nombreCaja)) await Hive.openBox(nombreCaja); // Renombrado de boxName
        final caja = Hive.box(nombreCaja); // Renombrado de box, boxName
        todosLosDatos[nombreCaja] = caja.toMap().map((key, value) => MapEntry(key.toString(), value)); // Renombrado de boxName, box
      }
      final cadenaJson = jsonEncode(todosLosDatos); // Renombrado de jsonString, allData

      Directory? directorioDescargas; // Renombrado de downloadsDir
      if (Platform.isAndroid) {
        directorioDescargas = Directory('/storage/emulated/0/Download');
        if(!await directorioDescargas.exists()) directorioDescargas = await getExternalStorageDirectory();
      } else {
        directorioDescargas = await getApplicationDocumentsDirectory();
      }

      if (directorioDescargas == null) throw Exception("No se pudo obtener el directorio");

      final fechaFormateada = DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now()); // Renombrado de formattedDate
      final rutaArchivo = '${directorioDescargas.path}/finanzas_respaldo_$fechaFormateada.json'; // Renombrado de filePath, downloadsDir, formattedDate

      final archivo = File(rutaArchivo); // Renombrado de file, filePath
      await archivo.writeAsString(cadenaJson); // Renombrado de file, jsonString
      _mostrarSnackbar('¡Exportación exitosa! Archivo guardado en: $rutaArchivo', esError: false); // Renombrado de _showSnackbar, filePath, isError

    } catch (e) {
      _mostrarSnackbar('Ocurrió un error durante la exportación: $e'); // Renombrado de _showSnackbar
    } finally {
      if (mounted) setState(() => _estaCargando = false); // Renombrado de _isLoading
    }
  }

  Future<void> _importarDatos() async { // Renombrado de _importData
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ ¡Atención!'),
        content: const Text('Vas a reemplazar TODOS los datos actuales con los del respaldo. Esta acción no se puede deshacer. ¿Estás seguro?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: TemaApp._colorError), // Renombrado de AppTheme._colorError
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sí, importar'),
          ),
        ],
      ),
    );

    if (confirmado != true) return;
    if (!await _manejarPermisoAlmacenamiento()) { // Renombrado de _handleStoragePermission
      _mostrarSnackbar('No se concedió el permiso para leer archivos.', esError: true); // Renombrado de _showSnackbar, isError
      return;
    }

    final resultado = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['json']); // Renombrado de result
    if (resultado == null || resultado.files.single.path == null) {
      _mostrarSnackbar('No se seleccionó ningún archivo.', esError: true); // Renombrado de _showSnackbar, isError
      return;
    }
    setState(() => _estaCargando = true); // Renombrado de _isLoading

    try {
      final archivo = File(resultado.files.single.path!); // Renombrado de file, result
      final cadenaJson = await archivo.readAsString(); // Renombrado de jsonString, file
      final Map<String, dynamic> todosLosDatos = jsonDecode(cadenaJson); // Renombrado de allData, jsonString

      for (final nombreCaja in _nombresCajas) { // Renombrado de boxName, _boxNames
        if (todosLosDatos.containsKey(nombreCaja)) {
          if (!Hive.isBoxOpen(nombreCaja)) await Hive.openBox(nombreCaja); // Renombrado de boxName
          final caja = Hive.box(nombreCaja); // Renombrado de box, boxName
          await caja.clear(); // Renombrado de box
          final datosDesdeRespaldo = todosLosDatos[nombreCaja] as Map<String, dynamic>; // Renombrado de dataFromBackup, boxName
          final mapaFinal = datosDesdeRespaldo.map((key, value) => MapEntry(int.tryParse(key) ?? key, value)); // Renombrado de finalMap
          await caja.putAll(mapaFinal); // Renombrado de box, finalMap
        }
      }
      _mostrarSnackbar('¡Importación completada con éxito!', esError: false); // Renombrado de _showSnackbar, isError
      if (mounted) Navigator.of(context).pop();

    } catch (e) {
      _mostrarSnackbar('Error al importar: El archivo podría estar dañado o no ser compatible. ($e)'); // Renombrado de _showSnackbar
    } finally {
      if (mounted) setState(() => _estaCargando = false); // Renombrado de _isLoading
    }
  }

  void _mostrarSnackbar(String mensaje, {bool esError = false}) { // Renombrado de _showSnackbar, message, isError
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(mensaje), // Renombrado de message
      backgroundColor: esError ? TemaApp._colorError : Colors.green.shade600, // Renombrado de isError, AppTheme._colorError
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Copia de Seguridad')),
      body: _estaCargando // Renombrado de _isLoading
          ? const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [CircularProgressIndicator(), SizedBox(height: 16), Text('Procesando...')]))
          : ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _construirTarjetaAccion( // Renombrado de _buildActionCard
            titulo: 'Exportar Datos', // Renombrado de title
            descripcion: 'Guarda todos tus datos en un archivo de respaldo (.json). Transfiere este archivo a un lugar seguro como tu email, Google Drive o tu computador.', // Renombrado de description
            etiquetaBoton: 'Exportar Datos', // Renombrado de buttonLabel
            icono: Icons.cloud_upload_outlined, // Renombrado de icon
            alPresionar: _exportarDatos, // Renombrado de onPressed, _exportData
            colorBoton: Theme.of(context).colorScheme.primary, // Renombrado de buttonColor
          ),
          const SizedBox(height: 24),
          _construirTarjetaAccion( // Renombrado de _buildActionCard
            titulo: 'Importar Datos', // Renombrado de title
            descripcion: 'Restaura tus datos desde un archivo de respaldo. ADVERTENCIA: Esta acción borrará permanentemente todos los datos actuales de la aplicación.', // Renombrado de description
            etiquetaBoton: 'Importar Datos', // Renombrado de buttonLabel
            icono: Icons.cloud_download_outlined, // Renombrado de icon
            alPresionar: _importarDatos, // Renombrado de onPressed, _importData
            colorBoton: TemaApp._colorAdvertencia, // Renombrado de buttonColor, AppTheme._warningColor
          ),
          const SizedBox(height: 24),
          // Nuevo botón para otorgar permisos de almacenamiento
          _construirTarjetaAccion(
            titulo: 'Otorgar Permisos de Almacenamiento',
            descripcion: 'Asegúrate de que la aplicación tenga los permisos necesarios para acceder al almacenamiento y guardar/cargar tus copias de seguridad.',
            etiquetaBoton: 'Abrir Ajustes de Permisos',
            icono: Icons.settings_applications_outlined,
            alPresionar: () async {
              await _manejarPermisoAlmacenamiento();
              // Opcional: mostrar un snackbar después de que el usuario regrese de los ajustes
              if (await Permission.manageExternalStorage.isGranted) {
                _mostrarSnackbar('Permiso de almacenamiento concedido.', esError: false);
              } else {
                _mostrarSnackbar('Permiso de almacenamiento no concedido.', esError: true);
              }
            },
            colorBoton: Colors.blueGrey,
          ),
        ],
      ),
    );
  }

  Widget _construirTarjetaAccion({ // Renombrado de _buildActionCard
    required String titulo, required String descripcion, required String etiquetaBoton, // Renombrado de title, description, buttonLabel
    required IconData icono, required VoidCallback alPresionar, required Color colorBoton // Renombrado de icon, onPressed, buttonColor
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo, style: Theme.of(context).textTheme.headlineSmall), // Renombrado de title
            const SizedBox(height: 12),
            Text(descripcion, style: Theme.of(context).textTheme.bodyLarge), // Renombrado de description
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: Icon(icono), // Renombrado de icon
              label: Text(etiquetaBoton), // Renombrado de buttonLabel
              style: ElevatedButton.styleFrom(backgroundColor: colorBoton), // Renombrado de buttonColor
              onPressed: alPresionar, // Renombrado de onPressed
            ),
          ],
        ),
      ),
    );
  }
}

//==============================================================================
// 🐞 PANTALLA DE DEPURACIÓN DE HIVE (HiveDebugScreen)
//==============================================================================

class PantallaDepuracionHive extends StatefulWidget { // Renombrado de HiveDebugScreen
  const PantallaDepuracionHive({super.key});

  @override
  EstadoPantallaDepuracionHive createState() => EstadoPantallaDepuracionHive(); // Renombrado de HiveDebugScreenState
}

class EstadoPantallaDepuracionHive extends State<PantallaDepuracionHive> { // Renombrado de HiveDebugScreenState
  String? cajaSeleccionada; // Renombrado de selectedBox
  Map<dynamic, dynamic> contenidoCaja = {}; // Renombrado de boxContent
  final List<String> cajas = [
    'bancos', 'movimientos', 'ajustes', 'notas', 'metas', 'debitos', // Renombrado de accounts, transactions, notes, settings, goals
    'cuentasUVT', 'uvtValoresIniciales', 'bienesUVT', 'fechaDeclaracionUVT', 'categorias', 'uvt', 'recordatorios' // Agregada la nueva caja
  ];

  void _cargarContenido() { // Renombrado de _loadContent
    if (cajaSeleccionada != null && Hive.isBoxOpen(cajaSeleccionada!)) { // Renombrado de selectedBox
      final caja = Hive.box(cajaSeleccionada!); // Renombrado de box, selectedBox
      setState(() => contenidoCaja = caja.toMap()); // Renombrado de boxContent, box
    } else {
      setState(() => contenidoCaja = {}); // Renombrado de boxContent
    }
  }

  void _eliminarEntrada(dynamic llave) async { // Renombrado de _deleteEntry, key
    await Hive.box(cajaSeleccionada!).delete(llave); // Renombrado de selectedBox, key
    _cargarContenido(); // Renombrado de _loadContent
  }

  void _limpiarCaja() async { // Renombrado de _clearBox
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Estás seguro?'),
        content: Text('Esto eliminará TODOS los datos de la caja "$cajaSeleccionada".'), // Renombrado de selectedBox
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: TemaApp._colorError), // Renombrado de AppTheme._colorError
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Confirmar Eliminación')),
        ],
      ),
    );
    if (confirmado == true) {
      await Hive.box(cajaSeleccionada!).clear(); // Renombrado de selectedBox
      _cargarContenido(); // Renombrado de _loadContent
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Depurar Base de Datos')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              hint: const Text('Selecciona una caja Hive'),
              value: cajaSeleccionada, // Renombrado de selectedBox
              isExpanded: true,
              items: cajas.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (valor) { // Renombrado de value
                setState(() => cajaSeleccionada = valor); // Renombrado de selectedBox
                _cargarContenido(); // Renombrado de _loadContent
              },
            ),
            const SizedBox(height: 16),
            if (cajaSeleccionada != null) // Renombrado de selectedBox
              Expanded(
                child: contenidoCaja.isEmpty // Renombrado de boxContent
                    ? const Center(child: Text('Caja vacía o no seleccionada.'))
                    : ListView(
                  children: contenidoCaja.entries.map((entrada) { // Renombrado de boxContent, entry
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        title: Text('Key: [${entrada.key}]', style: const TextStyle(fontWeight: FontWeight.bold)), // Renombrado de entry
                        subtitle: Text(jsonEncode(entrada.value)), // Show full content for debugging
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: TemaApp._colorError), // Renombrado de AppTheme._colorError
                          onPressed: () => _eliminarEntrada(entrada.key), // Renombrado de _deleteEntry, entry
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            if (cajaSeleccionada != null && contenidoCaja.isNotEmpty) // Renombrado de selectedBox, boxContent
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.delete_forever),
                  label: Text('Limpiar toda la caja "$cajaSeleccionada"'), // Renombrado de selectedBox
                  style: ElevatedButton.styleFrom(backgroundColor: TemaApp._colorError), // Renombrado de AppTheme._colorError
                  onPressed: _limpiarCaja, // Renombrado de _clearBox
                ),
              ),
          ],
        ),
      ),
    );
  }
}


//==============================================================================

Future<void> ejecutarDebitosAutomaticos() async {
  final cajaDebitos = Hive.box('debitos');
  final cajaBancos = Hive.box('bancos'); // Renombrado de accountsBox
  final cajaMovimientos = Hive.box('movimientos'); // Renombrado de txBox
  final hoy = DateTime.now(); // Renombrado de today

  for (var llave in cajaDebitos.keys) { // Renombrado de key
    final debito = cajaDebitos.get(llave);

    // Add null checks and default values
    if (debito == null) continue;

    final dia = debito['dia'] as int? ?? 1; // Default to 1st day of month if null
    final ultimaEjecucion = debito['ultimaEjecucion'] as String?;
    final ultima = ultimaEjecucion != null
        ? DateTime.tryParse(ultimaEjecucion) ?? DateTime(2000)
        : DateTime(2000);

    bool ejecutarHoy = hoy.day == dia && (ultima.year != hoy.year || ultima.month != hoy.month);

    if (ejecutarHoy) {
      final idCuenta = debito['cuentaId'] as int?;
      final monto = (debito['monto'] as num?)?.toDouble() ?? 0.0;

      if (idCuenta != null) {
        final cuenta = cajaBancos.get(idCuenta);
        final nombreDebito = debito['nombre'] as String? ?? 'Débito automático';

        if (cuenta != null) {
          final saldoActual = (cuenta['balance'] as num?)?.toDouble() ?? 0.0;
          final nuevoSaldo = saldoActual - monto;

          cajaBancos.put(idCuenta, {...cuenta, 'balance': nuevoSaldo});

          cajaMovimientos.add({
            'type': 'Débito automático',
            'amount': monto,
            'account': cuenta['name'] as String? ?? 'Cuenta sin nombre',
            'description': nombreDebito,
            'date': hoy.toIso8601String(),
          });
          debito['ultimaEjecucion'] = hoy.toIso8601String();
        }
      }
    }

    final proximaFecha = _calcularProximaFecha(hoy, dia);
    debito['proximaFecha'] = proximaFecha.toIso8601String();
    cajaDebitos.put(llave, debito); // Renombrado de key
  }
}

DateTime _calcularProximaFecha(DateTime ultimaEjecucion, int dia) {
  final ahora = DateTime.now(); // Renombrado de now
  int proximoAnio = ahora.year; // Renombrado de proximoAnio, now
  int proximoMes = ahora.month; // Renombrado de proximoMes, now

  if (ultimaEjecucion.year > 2000) {
    proximoAnio = ultimaEjecucion.year;
    proximoMes = ultimaEjecucion.month;
  }

  DateTime proximaFecha;
  try {
    proximaFecha = DateTime(proximoAnio, proximoMes, dia);
  } catch(e) {
    // Si el día no es válido para el mes (ej: 31 de Febrero), toma el último día.
    proximaFecha = DateTime(proximoAnio, proximoMes + 1, 0);
  }


  if (proximaFecha.isBefore(ahora)) { // Renombrado de now
    proximoMes++;
    if (proximoMes > 12) {
      proximoMes = 1;
      proximoAnio++;
    }
    try {
      proximaFecha = DateTime(proximoAnio, proximoMes, dia);
    } catch (e) {
      proximaFecha = DateTime(proximoAnio, proximoMes + 1, 0);
    }
  }
  return proximaFecha;
}

// Nueva función auxiliar para calcular la próxima fecha de un recordatorio
DateTime? _calcularProximaFechaRecordatorio(Map recordatorio) {
  try {
    final ahora = DateTime.now();
    final tipoFrecuencia = recordatorio['tipoFrecuencia'] as String? ?? 'Mensual';

    switch (tipoFrecuencia) {
      case 'Una vez':
        final fechaStr = recordatorio['fecha'] as String?;
        if (fechaStr == null || fechaStr.isEmpty) {
          return null;
        }
        return DateTime.tryParse(fechaStr);
      case 'Mensual':
        final dia = recordatorio['dia'] as int? ?? ahora.day;
        DateTime fechaIntento = DateTime(ahora.year, ahora.month, dia);
        if (fechaIntento.isBefore(ahora.subtract(const Duration(days: 1)))) {
          // Si el día de este mes ya pasó, intenta el próximo mes
          return DateTime(ahora.year, ahora.month + 1, dia);
        }
        return fechaIntento;
      case 'Anual':
        final dia = recordatorio['dia'] as int? ?? ahora.day;
        final mes = recordatorio['mes'] as int? ?? ahora.month;
        DateTime fechaIntento = DateTime(ahora.year, mes, dia);
        if (fechaIntento.isBefore(ahora.subtract(const Duration(days: 1)))) {
          // Si el día y mes de este año ya pasaron, intenta el próximo año
          return DateTime(ahora.year + 1, mes, dia);
        }
        return fechaIntento;
      default:
        return null; // En caso de tipo de frecuencia desconocido
    }
  } catch (e) {
    debugPrint('Error al calcular próxima fecha de recordatorio: $e');
    return null;
  }
}