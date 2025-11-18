# Guía Completa de Despliegue - Supabase Edge Functions para FinanzApp

## 🎯 Objetivo
Resolver el problema de descarga de archivos JSON en iOS Safari usando Supabase Edge Functions.

## 📋 Estructura Creada

```
supabase/
├── functions/
│   ├── deno.json                    # Configuración global de imports
│   ├── export_backup/
│   │   ├── index.ts                 # Edge Function para copia de seguridad
│   │   ├── function.json            # Configuración sin JWT
│   │   └── deno.json                # Import específico (opcional)
│   └── export_hogar/
│       ├── index.ts                 # Edge Function para movimientos del hogar
│       ├── function.json            # Configuración sin JWT
│       └── deno.json                # Import específico (opcional)
└── deno.json                        # Configuración de proyecto Deno
```

## 🚀 Pasos de Despliegue

### 1. Configurar VS Code para Deno

```bash
# En VS Code, presiona:
Ctrl + Shift + P
→ Deno: Enable
```

### 2. Instalar Supabase CLI (si no lo tienes)

```bash
# Windows (PowerShell)
winget install supabase.cli

# O manualmente:
iwr -useb https://supabase.com/install/v1.ps1 | iex
```

### 3. Iniciar Sesión en Supabase

```bash
supabase login
```

### 4. Conectar con tu Proyecto

```bash
# Si ya tienes un proyecto
supabase link --project-ref your-project-ref

# O crear uno nuevo
supabase init
supabase start
```

### 5. Probar Localmente

```bash
# Iniciar servidor local de Edge Functions
supabase functions serve

# En otra terminal, probar las funciones
curl -X POST "http://localhost:54321/functions/v1/export_backup" \
  -H "Content-Type: application/json" \
  -d '{"test": "data"}'

curl -X POST "http://localhost:54321/functions/v1/export_hogar" \
  -H "Content-Type: application/json" \
  -d '{"movimientos": [], "mes": "noviembre_2024"}'
```

### 6. Desplegar las Funciones

```bash
# Desplegar ambas funciones
supabase functions deploy export_backup
supabase functions deploy export_hogar

# Verificar despliegue
supabase functions list
```

### 7. Obtener URLs de las Funciones

```bash
# Obtener URL del proyecto
supabase status

# Las URLs serán:
# https://your-project-ref.supabase.co/functions/v1/export_backup
# https://your-project-ref.supabase.co/functions/v1/export_hogar
```

## 🔧 Configurar Flutter

### 1. Agregar Dependencias

```yaml
# pubspec.yaml
dependencies:
  http: ^1.1.0
  universal_html: ^2.2.4
```

### 2. Configurar URLs en el Código

```dart
// lib/supabase_export.dart
class SupabaseExportService {
  static const String _supabaseUrl = 'https://your-project-ref.supabase.co';
  static const String _anonKey = 'your-anon-key';
}
```

### 3. Integrar en main.dart

Reemplazar las funciones existentes:

```dart
// En la función _exportarDatos()
// Reemplazar:
await descargarArchivoWeb(Uint8List.fromList(bytesJson), nombreArchivo);

// Por:
await SupabaseExportService.exportBackupComplete(todosLosDatos);

// En la función exportarMovimientosAJson()
// Reemplazar:
await descargarArchivoWeb(Uint8List.fromList(bytesJson), nombre);

// Por:
await SupabaseExportService.exportHomeFinanceMovements(lista, mes);
```

## 📱 Pruebas en Dispositivos

### iOS Safari/Chrome
1. Abrir la app en iOS
2. Intentar exportar copia de seguridad
3. Intentar exportar movimientos del hogar
4. Verificar que los archivos se descarguen correctamente

### Desktop (Chrome/Firefox/Safari)
1. Probar exportación en navegadores de escritorio
2. Verificar compatibilidad

### Android
1. La app debe usar la lógica móvil existente
2. No debería llamar a Edge Functions

## 🔍 Verificación y Debugging

### 1. Ver Logs de Edge Functions

```bash
# Logs en tiempo real
supabase functions logs export_backup --follow
supabase functions logs export_hogar --follow
```

### 2. Probar con Postman/Insomnia

```http
POST https://your-project-ref.supabase.co/functions/v1/export_backup
Content-Type: application/json
Authorization: Bearer your-anon-key
apikey: your-anon-key

{
  "debitos": {},
  "bancos": {},
  "movimientos": {},
  "notas": {},
  "ajustes": {},
  "metas": {},
  "metasHogar": {},
  "cuentasUVT": {},
  "uvtValoresIniciales": {},
  "bienesUVT": {},
  "fechaDeclaracionUVT": {},
  "categorias": {},
  "uvt": {},
  "recordatorios": {},
  "finanzasHogar": {},
  "historialHogarEditable": {}
}
```

```http
POST https://your-project-ref.supabase.co/functions/v1/export_hogar
Content-Type: application/json
Authorization: Bearer your-anon-key
apikey: your-anon-key

{
  "movimientos": [
    {
      "date": "2024-11-18T10:00:00.000Z",
      "amount": 100.0,
      "type": "Ingreso",
      "description": "Salario"
    }
  ],
  "mes": "noviembre_2024"
}
```

## 🚨 Solución de Problemas Comunes

### Error 401 Unauthorized
- Verificar que `_anonKey` sea correcto
- Asegurar que las funciones tengan `"verify_jwt": false`

### Error 404 Not Found
- Verificar que las funciones estén desplegadas
- Confirmar URLs correctas

### Error CORS
- Las funciones ya incluyen headers CORS
- Si persiste, verificar configuración de Supabase

### Descarga no funciona en iOS
- Verificar que se esté usando la Edge Function (no la descarga directa)
- Confirmar que `kIsWeb` sea true en Flutter Web

## 📊 Monitoreo

### 1. Dashboard de Supabase
- Ir a `https://supabase.com/dashboard`
- Seleccionar tu proyecto
- Ver sección "Edge Functions"

### 2. Métricas de Uso
```bash
supabase functions logs export_backup --limit=100
supabase functions logs export_hogar --limit=100
```

## 🔄 Actualizaciones Futuras

### Para agregar nuevas funciones de exportación:
1. Crear nueva carpeta en `supabase/functions/`
2. Copiar estructura de funciones existentes
3. Adaptar lógica según necesidad
4. Desplegar con `supabase functions deploy nombre_funcion`

### Para mejorar seguridad:
1. Activar `"verify_jwt": true` en function.json
2. Implementar validación de tokens en las funciones
3. Agregar rate limiting

## ✅ Checklist Final

- [ ] VS Code configurado para Deno
- [ ] Supabase CLI instalado y logueado
- [ ] Proyecto conectado correctamente
- [ ] Funciones probadas localmente
- [ ] Funciones desplegadas en producción
- [ ] URLs configuradas en Flutter
- [ ] Pruebas exitosas en iOS Safari
- [ ] Pruebas exitosas en desktop
- [ ] Logs funcionando correctamente
- [ ] Documentación actualizada

## 📞 Soporte

Si encuentras problemas:
1. Revisa los logs de las Edge Functions
2. Verifica la configuración de CORS
3. Confirma las URLs y claves de API
4. Prueba con Postman antes de integrar en Flutter
