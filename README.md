# 💳 FinanzApp JRR

Una aplicación **completa de gestión financiera personal** desarrollada en Flutter que te permite llevar un control detallado de todas tus finanzas desde cualquier dispositivo.

## 📱 ¿Qué es FinanzApp JRR?

FinanzApp JRR es tu asistente financiero personal diseñado para ayudarte a:

- **Controlar tus finanzas** de manera sencilla y visual
- **Organizar cuentas bancarias** y tarjetas de crédito
- **Registrar ingresos y gastos** con categorización inteligente
- **Programar recordatorios** de pagos importantes
- **Establecer presupuestos** y metas de ahorro
- **Gestionar finanzas familiares** con tu pareja
- **Acceder desde cualquier lugar** gracias al despliegue web

## 🚀 Acceso Rápido

### 🌐 Versión Web (Recomendada)
**Disponible en:** [FinanzApp web](https://julianrr24.github.io/FinanzApp/)

*Accede desde cualquier navegador sin instalar nada*

### 📲 Versión Móvil
**Instalación local:**
Descarga el apk desde el aparatdo de Releases
**Descarga aqui:** [FinanzApp Apk](https://github.com/JulianRR24/FinanzApp/releases/download/1.4/app-release.apk)

---

## 👤 Tutorial de Usuario

### 🏠 Primeros Pasos

1. **Abre la aplicación** desde tu navegador o dispositivo móvil
2. **Explora el menú principal** con el botón flotante (+)
3. **Agrega tu primera cuenta** bancaria o tarjeta de crédito
4. **Registra tus primeros movimientos** (ingresos y gastos)

### 💼 Gestión de Cuentas

#### Agregar Cuentas
- **Cuentas Bancarias:** Registra tus cuentas de ahorro, corriente, etc.
- **Tarjetas de Crédito:** Añade tus tarjetas con límites y fechas de corte
- **Ordenación personalizada:** Reorganiza tus cuentas como prefieras

#### Visualización de Saldos
- **Dashboard principal:** Vé todos tus saldos en un solo lugar
- **Detalles por cuenta:** Accede a movimientos específicos
- **Cálculos automáticos:** Totales de débitos y créditos en tiempo real

### 📊 Control de Finanzas

#### Registrar Movimientos
- **Ingresos:** Salarios, devoluciones, transferencias recibidas
- **Gastos:** Categorizados automáticamente (Hogar, Transporte, Comida, etc.)
- **Transferencias:** Movimientos entre tus propias cuentas
- **Notas adjuntas:** Añade detalles importantes a cada movimiento

#### Categorización Inteligente
- **Tipos de gasto predefinidos:** Hogar, Transporte, Comida, Salud, Educación, etc.
- **Filtrado avanzado:** Busca por categoría, fecha, monto o descripción
- **Estadísticas visuales:** Gráficos de distribución de gastos

### 🏡 Finanzas del Hogar (Nueva Funcionalidad)

#### Gestión Familiar
- **Historial editable del hogar:** Modifica movimientos específicos del hogar
- **Importar datos de pareja:** Sube archivos JSON con movimientos de tu pareja
- **Sincronización inteligente:** Mantén datos actualizados
- **Control de saldos:** Registra ingresos y gastos familiares por mes

#### Operaciones del Hogar
- **Importación:** `Archivo → Importar historial de pareja`
- **Sincronización:** `Botón Sync → Actualizar con datos originales`
- **Exportación:** `Descargar → Exportar a JSON`
- **Edición:** Modifica movimientos directamente en la interfaz

### ⏰ Recordatorios y Pagos

#### Gestión de Recordatorios
- **Pagos recurrentes:** Configura pagos mensuales, quincenales, etc.
- **Alertas automáticas:** Notificaciones antes de fechas importantes
- **Seguimiento:** Marca pagos como completados o pendientes
- **Categorización:** Organiza recordatorios por tipo (servicios, préstamos, etc.)

### 📈 Presupuestos y Metas

#### Establecimiento de Presupuestos
- **Por categoría:** Define límites de gasto mensuales
- **Seguimiento en tiempo real:** Visualiza tu progreso vs. presupuesto
- **Alertas de exceso:** Notificaciones cuando superas límites

#### Metas de Ahorro
- **Objetivos financieros:** Define metas de ahorro específicas
- **Progreso visual:** Barra de avance hacia tus metas
- **Ahorro automático:** Configura transferencias periódicas

### 🔧 Herramientas Avanzadas

#### Depuración de Datos
- **Pantalla de depuración:** Acceso técnico a todas las cajas de datos
- **Inspección de Hive:** Revisa el contenido almacenado localmente
- **Exportación de datos:** Descarga toda tu información en formato JSON

#### Copias de Seguridad
- **Exportación completa:** Respalda todos tus datos
- **Importación segura:** Restaura desde copias de seguridad
- **Compatibilidad web:** Funciona en todos los navegadores modernos

---

## 🛠️ Características Técnicas

### Arquitectura Principal
- **Framework:** Flutter 3.32.5
- **Lenguaje:** Dart
- **Base de datos:** Hive (almacenamiento local)
- **Estado:** StatefulWidget con ValueListenableBuilder
- **Arquitectura:** MVC con separación de responsabilidades

### Plataformas Soportadas
- ✅ **Web (GitHub Pages)** - Despliegue automático
- ✅ **Android** - API 21+
- ✅ **iOS** - iOS 11.0+
- ✅ **Windows** - Escritorio
- ✅ **macOS** - Escritorio
- ✅ **Linux** - Escritorio

### Gestión de Datos
- **Almacenamiento local:** Hive boxes para datos persistentes
- **Sincronización:** Importación/exportación JSON
- **Respaldo automático:** Copias de seguridad manuales
- **Múltiples cajas:** Organización por tipo de dato

### Interfaz de Usuario
- **Material Design 3:** Diseño moderno y accesible
- **Temas claro/oscuro:** Personalización visual
- **Responsive:** Adaptación a todos los tamaños de pantalla
- **Navegación intuitiva:** Menú contextual y botones flotantes

---

## 📦 Instalación y Configuración

### Requisitos del Sistema
- **Flutter SDK** 3.32.5 o superior
- **Dart SDK** (incluido con Flutter)
- **Android Studio** o **VS Code** para desarrollo
- **Navegador moderno** para versión web

### Instalación Local
```bash
# Clonar repositorio
git clone https://github.com/JulianRR24/FinanzApp.git
cd FinanzApp

# Obtener dependencias
flutter pub get

# Ejecutar en modo desarrollo
flutter run

# Construir para producción
flutter build web    # Para web
flutter build apk    # Para Android
flutter build ios    # Para iOS
```

### Configuración de GitHub Pages
La aplicación se despliega automáticamente en GitHub Pages mediante GitHub Actions:

1. **Push a main branch** → Dispara el workflow
2. **Build web app** → Compila la versión web
3. **Deploy to Pages** → Publica en `https://julianrr24.github.io/FinanzApp/`

---

## 🏗️ Estructura del Proyecto

```bash
FinanzApp/
├── lib/
│   ├── main.dart              # Punto de entrada principal
│   ├── web_stub.dart          # Compatibilidad web
│   └── io_stub.dart           # Compatibilidad móvil
├── web/
│   └── index.html             # Configuración web
├── android/                   # Configuración Android
├── ios/                       # Configuración iOS
├── windows/                   # Configuración Windows
├── macos/                     # Configuración macOS
├── .github/
│   └── workflows/
│       └── deploy.yml         # GitHub Actions para despliegue
├── assets/                    # Recursos estáticos
├── pubspec.yaml              # Dependencias del proyecto
└── README.md                 # Este archivo
```

### Cajas de Datos (Hive Boxes)
- `bancos` - Cuentas bancarias y tarjetas
- `movimientos` - Transacciones financieras
- `finanzasHogar` - Datos familiares
- `historialHogarEditable` - Historial modificable del hogar
- `recordatorios` - Recordatorios de pago
- `metas` - Objetivos financieros
- `categorias` - Categorías personalizadas
- `ajustes` - Configuración de la app

---

## 🔄 Actualizaciones Recientes

### v2.0 - Finanzas del Hogar
- ✨ **Nuevo módulo:** Gestión financiera familiar
- 📥 **Importación de datos:** Sube movimientos de tu pareja
- 🔄 **Sincronización inteligente:** Mantén datos actualizados
- 📊 **Historial editable:** Modifica movimientos específicos
- 🌐 **Despliegue web:** Acceso desde cualquier dispositivo

### v1.5 - Mejoras de Usabilidad
- 🎨 **Interfaz renovada:** Material Design 3
- 📱 **Responsive design:** Mejor adaptación a pantallas
- 🔍 **Búsqueda mejorada:** Filtros avanzados
- 💾 **Copias de seguridad:** Exportación JSON mejorada

---

## 🤝 Contribución

¡Las contribuciones son bienvenidas! Si deseas mejorar el proyecto:

1. **Fork** el repositorio
2. **Crea una rama:** `git checkout -b feature/nueva-funcionalidad`
3. **Commit tus cambios:** `git commit -m 'Agregar nueva funcionalidad'`
4. **Push a la rama:** `git push origin feature/nueva-funcionalidad`
5. **Abre un Pull Request**

### Guía de Estilo
- **Clean Code:** Código legible y mantenible
- **SOLID Principles:** Responsabilidad única y abstracción
- **Sin comentarios:** Código autoexplicativo
- **Nombres descriptivos:** Variables y funciones claras

---

## 🆘 Soporte y Contacto

### Obtener Ayuda
- 📋 **Issues:** Reporta problemas o solicita funciones
- 📧 **Contacto directo:** [julianramirezreyes23@gmail.com](mailto:julianramirezreyes23@gmail.com)
- 📖 **Documentación:** Revisa este README y el código fuente

### Preguntas Frecuentes

**Q: ¿Mis datos están seguros?**
A: Sí, todos los datos se almacenan localmente en tu dispositivo usando Hive. No hay servidores externos.

**Q: ¿Puedo usar la app sin conexión?**
A: Sí, la aplicación funciona completamente offline. Solo necesitas conexión para el despliegue web inicial.

**Q: ¿Cómo transfiero mis datos a otro dispositivo?**
A: Usa la función de exportación JSON y luego importa en el nuevo dispositivo.

**Q: ¿La versión web tiene todas las funciones?**
A: Sí, la versión web es idéntica a la versión móvil, con soporte completo para todas las características.

---

## 🌟 Agradecimientos

- **Flutter team** - Por el increíble framework multiplataforma
- **Hive** - Por la base de datos ligera y rápida
- **Material Design** - Por las guías de diseño intuitivo
- **Comunidad Flutter** - Por el constante soporte y recursos

---

**¡Gracias por usar FinanzApp JRR!** 🎉

*Tu herramienta definitiva para el control financiero personal.*
