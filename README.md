# Rocket UI

## Nombre del Proyecto

El proyecto se llama oficialmente **Rocket**.

## Descripción del Proyecto

RocketUI es una aplicación inspirada en la app de McDonald's, diseñada para mejorar la experiencia del usuario mediante la implementación de estrategias de marketing innovadoras. Las principales características incluyen:

- **Juegos interactivos**: Los usuarios pueden participar en juegos para ganar recompensas y descuentos.
- **Recomendaciones personalizadas**: El menú se adapta a las preferencias del usuario basándose en su historial de pedidos.
- **Notificaciones inteligentes**: Se envían notificaciones personalizadas para promociones, recordatorios y ofertas especiales.
- **Formulario con IA**: Un formulario inteligente que utiliza inteligencia artificial para recopilar y analizar datos del usuario, optimizando las estrategias de marketing.

## Estructura del Proyecto

### Assets

Contiene materiales y elementos utilizados en el proyecto, organizados en subcarpetas:

- `assets/images`: Imágenes utilizadas en la aplicación.
- `assets/fonts`: Fuentes utilizadas en la aplicación.
- `assets/sounds`: Archivos de audio utilizados en la aplicación.
- `assets/files`: Otros archivos utilizados en la aplicación.

### Lib

La carpeta principal que contiene la lógica de la aplicación y los componentes de la interfaz de usuario:

- `lib/screens`: Pantallas de la aplicación configuradas en las rutas de navegación.
- `lib/data` o `lib/models`: Clases para la gestión de datos, como modelos de usuario o pedidos.
- `lib/utils`: Clases de utilidades, como cálculos de fechas, conversión de datos y constantes comunes.
- `lib/widgets`: Widgets reutilizables para la interfaz de usuario, como botones personalizados o tarjetas.
- `lib/services`: Clases que gestionan la comunicación con servicios externos, como Firestore o API HTTP.
- `lib/main.dart`: El punto de entrada de la aplicación (contiene la función `main`).

### Configuración

Para configurar el proyecto, sigue estos pasos:

1. Clona el repositorio:

   ```bash
   git clone https://github.com/your-username/rocket-ui.git
   ```

2. Navega al directorio del proyecto:

   ```bash
   cd rocket-ui
   ```

3. Instala las dependencias:

   ```bash
   flutter pub get
   ```

4. Ejecuta la aplicación:

   ```bash
   flutter run
   ```

5. Para compilar la aplicación para producción:
   ```bash
   flutter build apk
   ```

### Funcionalidades Clave

1. **Juegos Interactivos**:

   - Implementados en `lib/screens/games`.
   - Incluyen mecánicas para recompensas y descuentos.

2. **Recomendaciones Personalizadas**:

   - Gestionadas en `lib/services/recommendation_service.dart`.
   - Basadas en el historial de pedidos almacenado en Firestore.

3. **Notificaciones Inteligentes**:

   - Configuradas en `lib/services/notification_service.dart`.
   - Utilizan Firebase Cloud Messaging para enviar notificaciones personalizadas.

4. **Formulario con IA**:
   - Implementado en `lib/screens/form`.
   - Utiliza algoritmos de inteligencia artificial para analizar las respuestas de los usuarios y generar insights que mejoren las campañas de marketing.

## Ramas

| Rama             | Propósito                           |
| ---------------- | ----------------------------------- |
| `main`           | Producción                          |
| `dev`            | Integración y pruebas               |
| `feature/*`      | Nuevas funcionalidades              |
| `bugfix/*`       | Corrección de errores               |
| `hotfix/*`       | Correcciones urgentes en `main`     |
| `experimental/*` | Prototipos o pruebas experimentales |

## Contribución

Si deseas contribuir al proyecto, sigue estos pasos:

1. Crea una rama basada en `dev`:

   ```bash
   git checkout -b feature/nueva-funcionalidad dev
   ```

2. Realiza tus cambios y haz un commit:

   ```bash
   git commit -m "Descripción de los cambios"
   ```

3. Sube tu rama al repositorio remoto:

   ```bash
   git push origin feature/nueva-funcionalidad
   ```

4. Abre un Pull Request hacia la rama `dev`.

## Licencia

RocketUI está bajo la licencia MIT. Consulta el archivo `LICENSE` para más detalles.
