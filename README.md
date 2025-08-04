# 📱 Anime

Una aplicación móvil desarrollada en **Flutter**, diseñada para visualizar y gestionar tu progreso de series de anime utilizando los datos del sitio [AnimeFLV](https://www3.animeflv.net/).  
Esta app no tiene fines de lucro y fue creada como proyecto educativo.

---

## ✨ Características

- ⚙️ **Arquitectura limpia** con gestión de estado mediante `BLoC` y `HydratedBloc` para persistencia local.
- 🔄 **Actualización remota automática** a través de GitHub.
- 📁 **Almacenamiento local** de datos de usuario y progreso de anime.
- 📺 **Pantalla de inicio** con los últimos animes disponibles.
- 💾 **Gestor de animes guardados**, organizados por estado:
    - En progreso
    - Planeado
    - Completado
    - Favorito
    - En espera
    - Abandonado
- 🔍 **Pantalla de búsqueda** con filtros por:
    - Tipo: TV, OVA, Películas, Especiales
- 🧩 **Pantalla de géneros**: Vista en cuadrícula con todos los géneros disponibles, cada uno con su propia lista navegable.
- 📄 **Pantalla de detalles** del anime con información completa y lista de episodios.
- ▶️ **Pantalla de visualización** de episodios, donde puedes elegir entre distintos servidores.
- 🧑 **Pantalla de opciones** donde puedes personalizar tu avatar.

---

## 🧱 Estructura del Proyecto

El proyecto sigue una separación modular y escalable de carpetas:

```plaintext
lib/
├── data/          # Enums, interfaces, modelos
├── domain/        # Lógica de negocio
│   ├── bloc/      # Gestión de estado
│   └── repository/
├── presentation/  # UI
│   ├── pages/
│   ├── screens/
│   └── widgets/
└── utils/         # Herramientas y utilidades generales
```
---
## 🛠 Tecnologías utilizadas

- [Flutter](https://flutter.dev/)
- [BLoC](https://bloclibrary.dev/) & [HydratedBloc](https://pub.dev/packages/hydrated_bloc)
- [GitHub](https://github.com/) para actualizaciones remotas
- [AnimeFLV](https://www3.animeflv.net/) como fuente de datos (web scraping)
- Almacenamiento local offline

---
## 🚀 Instalación y ejecución

### Requisitos

- Tener Flutter instalado
- SDK configurado correctamente

### Comandos

```bash
git clone https://github.com/alexito8473/anime
cd anime
flutter pub get
flutter run
```

---

## 📦 Dependencias destacadas

- **[flutter_bloc](https://pub.dev/packages/flutter_bloc)** `^9.0.0` – Gestión de estado
- **[hydrated_bloc](https://pub.dev/packages/hydrated_bloc)** `^10.0.0` – Persistencia automática
- **[dio](https://pub.dev/packages/dio)** `^5.8.0+1` – Cliente HTTP avanzado
- **[cached_network_image](https://pub.dev/packages/cached_network_image)** `^3.4.1` – Cache de imágenes en red
- **[flutter_inappwebview](https://pub.dev/packages/flutter_inappwebview)** `^6.1.5` – Navegador embebido
- **[firebase_messaging](https://pub.dev/packages/firebase_messaging)** `^15.2.3` – Notificaciones push
- **[flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)** `^18.0.1` – Notificaciones locales
- **[video_player](https://pub.dev/packages/video_player)** `^2.9.3` – Reproducción de video

---
### 🔧 Otras utilidades

- Animaciones: [`animate_do`](https://pub.dev/packages/animate_do)
- Navegación con menú lateral: [`flutter_zoom_drawer`](https://pub.dev/packages/flutter_zoom_drawer)
- Manejo de permisos: [`permission_handler`](https://pub.dev/packages/permission_handler)
- Información del dispositivo: [`device_info_plus`](https://pub.dev/packages/device_info_plus)
- Carga eficiente de listas: [`loading_more_list`](https://pub.dev/packages/loading_more_list)

---

## 🧠 Aprendizajes

Este proyecto ha sido clave para aprender:

- Cómo implementar **web scraping** con [`beautiful_soup_dart`](https://pub.dev/packages/beautiful_soup_dart)
- Uso de `HydratedBloc` para mantener el estado incluso después de cerrar la app
- Organización limpia y escalable de carpetas siguiendo buenas prácticas de arquitectura en Flutter


---

## ⚠️ Aviso Legal

> Esta aplicación es **exclusivamente con fines educativos**.  
> No tiene ninguna afiliación oficial con AnimeFLV ni se utiliza con propósitos comerciales.  
> Todo el contenido mostrado pertenece a sus respectivos autores.

---

## 👤 Autor

**Alejandro Aguilar Alba**  
🔗 [GitHub: alexito8473](https://github.com/alexito8473)