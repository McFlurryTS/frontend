# McDonald's App - Rocket UI

## Descripción del Proyecto

RocketUI es una aplicación moderna desarrollada para McDonald's, diseñada para mejorar la experiencia del usuario mediante la implementación de estrategias de marketing innovadoras y funcionalidades interactivas.

## Características Principales

- **Sistema de Pedidos Inteligente**

  - Interfaz intuitiva para navegar por el menú
  - Carrito de compras con persistencia local
  - Cajita Feliz personalizable con diferentes tamaños
  - Sistema de recomendaciones basado en pedidos anteriores

- **Experiencia Gamificada**

  - Minijuegos interactivos usando Flame Engine
  - Sistema de recompensas y descuentos
  - Logros desbloqueables
  - Animaciones fluidas y atractivas

- **Localización y Mapas**

  - Búsqueda de restaurantes cercanos
  - Navegación integrada
  - Seguimiento de pedidos en tiempo real
  - Información detallada de sucursales

- **Sistema de Notificaciones**
  - Alertas de ofertas personalizadas
  - Recordatorios de pedidos favoritos
  - Notificaciones push con Firebase
  - Actualizaciones de estado de pedidos

## Tecnologías Utilizadas

### Frontend

- Flutter 3.7.2+
- Provider para gestión de estado
- Google Maps para geolocalización
- Firebase para notificaciones y análisis
- Hive para almacenamiento local
- Flame para juegos interactivos

### Dependencias Principales

- `provider: ^6.1.4` - Gestión de estado
- `firebase_core: ^3.13.0` - Integración con Firebase
- `firebase_messaging: ^15.2.5` - Notificaciones push
- `flutter_local_notifications: ^19.1.0` - Notificaciones locales
- `google_fonts: ^6.2.1` - Tipografía personalizada
- `hive: ^2.2.3` - Base de datos local
- `geolocator: ^10.1.0` - Servicios de ubicación
- `flame: ^1.27.0` - Motor de juegos 2D
- `cached_network_image: ^3.3.1` - Caché de imágenes
- `shared_preferences: ^2.5.3` - Almacenamiento de preferencias

## Estructura del Proyecto

### Assets

- `assets/images/` - Recursos gráficos principales
- `assets/icons/` - Iconografía de la aplicación
- `assets/sounds/` - Efectos de sonido y música
- `assets/fonts/` - Fuentes tipográficas

### Lib

- `lib/screens/` - Interfaces de usuario
- `lib/models/` - Modelos de datos
- `lib/providers/` - Gestores de estado
- `lib/services/` - Servicios y APIs
- `lib/widgets/` - Componentes reutilizables
- `lib/utils/` - Utilidades y helpers
- `lib/game/` - Lógica de juegos
- `lib/adapters/` - Adaptadores de datos

## Configuración del Proyecto

### Requisitos Previos

- Flutter SDK ^3.7.2
- Dart SDK ^3.0.0
- Android Studio / VS Code
- Git

### Pasos de Instalación

1. Clonar el repositorio:

   ```bash
   git clone https://github.com/McFlurryTS/frontend.git
   ```

2. Instalar dependencias:

   ```bash
   flutter pub get
   ```

3. Configurar variables de entorno:

   - Crear archivo `.env` en la raíz del proyecto
   - Añadir las claves necesarias según `.env.example`

4. Ejecutar la aplicación:
   ```bash
   flutter run
   ```

### Configuración de Firebase

1. Crear proyecto en Firebase Console
2. Descargar `google-services.json`
3. Colocar en `android/app/`
4. Habilitar servicios necesarios:
   - Cloud Messaging
   - Analytics
   - Cloud Firestore

## Control de Versiones

### Ramas Principales

- `main` - Producción
- `dev` - Desarrollo e integración
- `feature/*` - Nuevas funcionalidades
- `hotfix/*` - Correcciones urgentes

### Flujo de Trabajo

1. Crear rama desde `dev`
2. Desarrollar funcionalidad
3. Crear Pull Request
4. Code Review
5. Merge a `dev`
6. Deploy a staging
7. Merge a `main`

## Contribución

1. Fork del repositorio
2. Crear rama de feature:
   ```bash
   git checkout -b feature/nueva-funcionalidad
   ```
3. Commits significativos:
   ```bash
   git commit -m "feat: añade nueva funcionalidad"
   ```
4. Push a tu fork:
   ```bash
   git push origin feature/nueva-funcionalidad
   ```
5. Crear Pull Request

## Licencia

Este proyecto es privado y propietario. Todos los derechos reservados.
