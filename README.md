# 🐾 PetMatch API & Back-Office

Plataforma integral para la gestión y adopción responsable de mascotas. Desarrollada sobre **Ruby on Rails 8** con SQLite3 (desarrollo) y PostgreSQL (producción), interfaz administrativa responsiva en Hotwire (Turbo + Stimulus) y Tailwind CSS, optimización y almacenamiento multimedia con Cloudinary, suite de pruebas automatizadas en RSpec y una API RESTful desacoplada con autenticación basada en JWT para clientes móviles o web.

---

## 📋 Tabla de Contenidos

- [Características Principales](#-características-principales)
- [Requisitos Previos](#-requisitos-previos)
- [Instalación y Ejecución](#-instalación-y-ejecución)
- [Preparación de la Base de Datos](#-preparación-de-la-base-de-datos)
- [Acceso al Back-Office y Credenciales](#-acceso-al-back-office-y-credenciales)
- [Almacenamiento y Optimización Multimedia](#-almacenamiento-y-optimización-multimedia)
- [Pruebas y Calidad de Código](#-pruebas-y-calidad-de-código)
- [API RESTful (v1)](#-api-restful-v1)
- [Despliegue en Producción (Render & PostgreSQL)](#-despliegue-en-producción-render--postgresql)
- [Modelo de Datos](#-modelo-de-datos)
- [Estructura del Proyecto](#-estructura-del-proyecto)

---

## 🚀 Características Principales

- **Back-Office Administrativo Responsivo**: Panel de control con interfaz moderna en Tailwind CSS y Hotwire (Turbo + Stimulus) para la administración de mascotas, refugios, registros médicos, usuarios y solicitudes de adopción. Incluye navegación lateral colapsable para dispositivos móviles (`sidebar_controller`) y visualización adaptativa (tarjetas en móvil y tablas en desktop).
- **Previsualización de Archivos en Tiempo Real**: Controlador Stimulus (`file_preview_controller`) que permite previsualizar instantáneamente imágenes de mascotas y avatares de usuarios antes de enviar los formularios.
- **Almacenamiento y Optimización Multimedia en la Nube**: Configuración multi-entorno con Active Storage (disco local para desarrollo y **Cloudinary** para producción). Procesamiento dinámico de variantes: redimensionamiento inteligente, detección facial/gravedad (`gravity: :face`), optimización automática de formato y calidad (`format: :auto`, `quality: :auto` para WebP/AVIF) y carga diferida (`loading: "lazy"`).
- **Roles y Permisos**:
  - `admin`: Superadministrador con control total del sistema.
  - `shelter_manager`: Gestor enfocado en las mascotas y solicitudes de su refugio asignado.
  - `adopter`: Usuario final que consulta mascotas y envía solicitudes vía API.
- **API RESTful Segura**: Endpoints versionados (`/api/v1`) con autenticación mediante JSON Web Tokens (JWT).
- **Ciclo de Adopción Automatizado**: Cambios automáticos de estado en las mascotas al aprobar o cancelar solicitudes de adopción.
- **Internacionalización (i18n)**: Soporte de idiomas configurable por sesión web, selector de idioma visual en el panel y en la pantalla de inicio de sesión (`/session/new`), y cabecera `Accept-Language` en la API.
- **Calidad de Código y Pruebas Automatizadas**: Suite completa de pruebas con **RSpec Rails**, análisis estático de vulnerabilidades (`brakeman`, `bundler-audit`, `importmap audit`) y linter de estilo con RuboCop (`rubocop-rails-omakase`).
- **Listo para Producción en la Nube**: Configuración lista para despliegue en **Render** (`render.yaml`) utilizando base de datos **PostgreSQL** (Neon) y compilación automatizada (`render-build.sh`).

---

## 🛠 Requisitos Previos

Asegúrate de contar con las siguientes herramientas instaladas en tu entorno:

- **Ruby**: versión 3.x o superior (verificado con Ruby 3.3+ / 4.0)
- **Ruby on Rails**: 8.1.3+
- **Bundler**: `gem install bundler`
- **SQLite3**: versión 3.8 o superior (para desarrollo local)
- **PostgreSQL**: versión 14+ (opcional para desarrollo local, requerido para producción)
- **Git**

---

## 💻 Instalación y Ejecución

### 1. Clonar el repositorio

```bash
git clone <URL_DEL_REPOSITORIO>
cd PetMatch
```

### 2. Instalar dependencias

```bash
bundle install
```

### 3. Ejecutar la aplicación

El proyecto utiliza **Tailwind CSS**, por lo que requiere compilar los assets en modo desarrollo. Existen dos formas de iniciar el entorno:

#### Opción A: Usando `bin/dev` (Recomendado)
Inicia el servidor web Puma y el proceso de compilación continua de Tailwind CSS en paralelo:

```bash
./bin/dev
```
*(En Windows PowerShell o CMD, si no tienes un entorno Unix/Bash, utiliza la Opción B).*

#### Opción B: En terminales separadas

- **Terminal 1** (Servidor Rails):
  ```bash
  bin/rails server
  ```
- **Terminal 2** (Compilador de Tailwind CSS):
  ```bash
  bin/rails tailwindcss:watch
  ```

La aplicación web estará disponible en: **`http://localhost:3000`**

> **Nota sobre correos electrónicos**: En entorno de desarrollo se incluye la gema `letter_opener`. Cuando el sistema envía correos (notificaciones de adopción, bienvenida, etc.), estos se abren automáticamente en pestañas de tu navegador sin necesidad de configurar un servidor SMTP.

---

## 🗄 Preparación de la Base de Datos

El proyecto utiliza **SQLite3** como motor de base de datos. Los archivos de datos se almacenan en el directorio `storage/`.

### Inicialización rápida (Creación, Migraciones y Carga de Semillas)

Para preparar todo el entorno desde cero en un único comando:

```bash
bin/rails db:setup
```

Si la base de datos ya existía y deseas restablecerla por completo:

```bash
bin/rails db:reset
```

### Pasos individuales (si prefieres ejecutarlos manualmente)

1. **Crear la base de datos**:
   ```bash
   bin/rails db:create
   ```

2. **Ejecutar migraciones**:
   ```bash
   bin/rails db:migrate
   ```

3. **Cargar datos iniciales (Seeds)**:
   ```bash
   bin/rails db:seed
   ```

### ¿Qué datos iniciales se cargan con `db:seed`?
- **Ciudades**: La Plata, CABA, Rosario, Córdoba, Mendoza.
- **Razas**: Mestizo, Labrador, Golden Retriever, Ovejero Alemán, Siamés, Común Europeo, etc.
- **Refugios**: "Refugio Mascotas La Plata" y "Refugio Mascotas Buenos Aires" con direcciones asociadas.
- **Usuarios de prueba**: Cuentas con contraseñas preconfiguradas para cada rol.
- **Mascotas**: Perros y gatos con diferentes estados, tamaños y registros médicos (vacunas, chequeos, desparasitaciones).
- **Solicitudes de adopción**: Solicitudes de ejemplo vinculadas para probar el flujo de revisión.

---

## 🔐 Acceso al Back-Office y Credenciales

El back-office está ubicado en la ruta raíz del sistema y en el namespace `/admin`. El acceso requiere autenticación previa mediante sesión web.

### URL de Inicio de Sesión
Navega en tu navegador a:
👉 **`http://localhost:3000/session/new`** (o directamente a `http://localhost:3000/admin`)

### Credenciales de Prueba Disponibles

| Rol | Correo Electrónico | Contraseña | Alcance de Permisos |

| **Super Administrador (Admin)** | `admin@petmatch.com` | `password123` | Control total: Usuarios, Refugios, Mascotas, Registros Médicos, Razas, Ciudades y Solicitudes. |
| **Gestor de Refugio (La Plata)** | `manager@refugiolaplata.org` | `password123` | Gestión limitada al "Refugio Mascotas La Plata": sus mascotas, historial médico y solicitudes. |
| **Gestor de Refugio (Bs As)** | `manager@refugiobuenosaires.org` | `password123` | Gestión limitada al "Refugio Mascotas Buenos Aires". |
| **Adoptante (Usuario App)** | `adoptante@ejemplo.com` | `password123` | Usuario final para pruebas de API de adoptantes. No tiene acceso al panel `/admin`. |

---

## 🖼 Almacenamiento y Optimización Multimedia

PetMatch utiliza **Active Storage** configurado para operar de forma eficiente y desacoplada según el entorno de ejecución:

- **Desarrollo y Testing**: Almacenamiento local en disco (`storage/` y `tmp/storage`).
- **Producción**: Almacenamiento y CDN global en la nube mediante **Cloudinary** (`service: Cloudinary`).

### Características de Optimización de Imágenes
- **Variantes Dinámicas en Tiempo Real**: Procesamiento automático para avatares, logos y fotos de mascotas (`resize_to_limit`, `resize_to_fill`).
- **Recorte Inteligente (`Gravity`)**:
  - Detección facial (`gravity: :face`) en avatares de usuarios para asegurar que los rostros siempre queden perfectamente encuadrados.
  - Centrado automático (`gravity: :auto`) en las fotos y miniaturas de mascotas.
- **Formato y Calidad Adaptativos**: Se aplican directivas `format: :auto` y `quality: :auto`, permitiendo que Cloudinary entregue formatos modernos y livianos (WebP o AVIF) según la compatibilidad del navegador.
- **Carga Diferida (`Lazy Loading`)**: Todas las imágenes en galerías, tablas y tarjetas utilizan `loading: "lazy"` para optimizar la velocidad de carga inicial de las vistas.
- **Previsualización Interactiva en Frontend**: Mediante el controlador Stimulus `file_preview_controller.js`, los usuarios y administradores pueden previsualizar instantáneamente sus imágenes en el navegador antes de enviarlas al servidor.

---

## 🧪 Pruebas y Calidad de Código

El proyecto cuenta con una suite completa de pruebas automatizadas y herramientas de análisis estático de código y seguridad.

### 1. Ejecución de Pruebas con RSpec
La suite de pruebas está construida con **RSpec Rails** (`spec/`), abarcando pruebas unitarias de modelos, validaciones, callbacks de negocio, peticiones a la API RESTful (`requests`) y correos transaccionales (`mailers`).

Para preparar el entorno y ejecutar las pruebas:

```bash
# 1. Compilar Tailwind CSS (necesario para vistas y pruebas de sistema)
bin/rails tailwindcss:build

# 2. Preparar la base de datos de pruebas
bin/rails db:test:prepare

# 3. Ejecutar toda la suite de RSpec
bundle exec rspec
```

También es posible ejecutar archivos o carpetas específicas:
```bash
# Pruebas de modelos
bundle exec rspec spec/models/pet_spec.rb

# Pruebas de integración de la API
bundle exec rspec spec/requests/api/v1/pets_spec.rb

# Pruebas de mailers
bundle exec rspec spec/mailers/
```

### 2. Linters y Auditorías de Seguridad
Se incluyen scripts ejecutables en `bin/` para garantizar la robustez, el estilo de código y la ausencia de vulnerabilidades:

- **Linter de código (RuboCop Omakase + RSpec)**:
  ```bash
  bin/rubocop
  ```
- **Auditoría de vulnerabilidades en código Rails (Brakeman)**:
  ```bash
  bin/brakeman --no-pager
  ```
- **Auditoría de dependencias Ruby (Bundler Audit)**:
  ```bash
  bin/bundler-audit
  ```
- **Auditoría de dependencias JavaScript (Importmap Audit)**:
  ```bash
  bin/importmap audit
  ```

### 3. Integración Continua (CI en GitHub Actions)
El repositorio cuenta con un pipeline automatizado en `.github/workflows/ci.yml` que se ejecuta en cada Pull Request y push a la rama `master`:
- **`scan_ruby`**: Análisis estático de seguridad con Brakeman y Bundler Audit.
- **`scan_js`**: Auditoría de seguridad en paquetes JS con Importmap Audit.
- **`lint`**: Verificación de estilo y buenas prácticas con RuboCop.
- **`test` / `system-test`**: Preparación de base de datos, compilación de assets y ejecución completa de los tests de RSpec.

---

## 🌐 API RESTful (v1)

- **Prefijo base**: `/api/v1`
- **Formato**: `JSON`
- **Autenticación**: Mediante cabecera HTTP con esquema Bearer Token:
  ```http
  Authorization: Bearer <TU_JWT_TOKEN>
  ```
- **Idioma / Localización (opcional)**: Enviar la cabecera `Accept-Language: es` o `Accept-Language: en`.

---

### Resumen de Endpoints

#### 1. Autenticación y Perfil (`/api/v1`)

| Método | Endpoint | Requiere Auth | Descripción |
| :--- | :--- | :---: | :--- |
| `POST` | `/api/v1/signup` | No | Registro de nuevo adoptante junto con su dirección. Retorna token JWT. |
| `POST` | `/api/v1/login` | No | Inicio de sesión con credenciales (`email_address`, `password`). Retorna token JWT. |
| `DELETE` | `/api/v1/logout` | Sí | Cierre de sesión. |
| `GET` | `/api/v1/profile` | Sí | Obtiene los datos del perfil y dirección del usuario autenticado. |
| `PUT / PATCH` | `/api/v1/profile` | Sí | Actualiza datos del perfil o dirección del usuario autenticado. |
| `DELETE` | `/api/v1/profile` | Sí | Desactiva la cuenta del usuario (Soft Delete). |

#### 2. Mascotas (`/api/v1/pets`)

| Método | Endpoint | Requiere Auth | Descripción |
| :--- | :--- | :---: | :--- |
| `GET` | `/api/v1/pets` | No* | Lista mascotas disponibles para adopción (`status: available`). Soporta filtros por query string. Si se envía token de autenticación, incluye el atributo `is_favorite: true/false`. |
| `GET` | `/api/v1/pets/:id` | No | Detalle completo de una mascota: fotos, raza, refugio de origen y registros médicos. |

**Filtros disponibles para `GET /api/v1/pets`**:
- `?species=dog` o `?species=cat`
- `?breed_id=1`
- `?gender=male` o `?gender=female`
- `?size=small`, `?size=medium` o `?size=large`
- `?shelter_id=1`
- `?city_id=1`

#### 3. Solicitudes de Adopción (`/api/v1/adoption_applications`)

| Método | Endpoint | Requiere Auth | Descripción |
| :--- | :--- | :---: | :--- |
| `GET` | `/api/v1/adoption_applications` | Sí | Lista todas las solicitudes de adopción del usuario autenticado. |
| `POST` | `/api/v1/adoption_applications` | Sí | Crea una nueva solicitud para una mascota disponible (`pet_id`, `housing_type`, `has_another_pet`, `notes`). |
| `PUT / PATCH` | `/api/v1/adoption_applications/:id` | Sí | Modifica una solicitud existente (únicamente si su estado es `pending`). |
| `DELETE` | `/api/v1/adoption_applications/:id` | Sí | Cancela una solicitud (`status: cancelled`). |

#### 4. Favoritos (`/api/v1/favorites`)

| Método | Endpoint | Requiere Auth | Descripción |
| :--- | :--- | :---: | :--- |
| `GET` | `/api/v1/favorites` | Sí | Lista de mascotas marcadas como favoritas por el usuario autenticado. |
| `POST` | `/api/v1/favorites` | Sí | Agrega una mascota a favoritos (`pet_id`). |
| `DELETE` | `/api/v1/favorites/:id` | Sí | Elimina una mascota de favoritos (acepta ID de favorito o ID de mascota). |

#### 5. Refugios (`/api/v1/shelters`)

| Método | Endpoint | Requiere Auth | Descripción |
| :--- | :--- | :---: | :--- |
| `GET` | `/api/v1/shelters` | No | Listado general de refugios activos. |
| `GET` | `/api/v1/shelters/:id` | No | Detalle del refugio incluyendo dirección completa y medios de contacto. |

#### 6. Endpoints Maestros / Auxiliares

| Método | Endpoint | Requiere Auth | Descripción |
| :--- | :--- | :---: | :--- |
| `GET` | `/api/v1/enums` | No | Devuelve todos los valores posibles de los `enums` del sistema (géneros, tamaños, estados de adopción, roles, especies). |
| `GET` | `/api/v1/breeds` | No | Catálogo de razas registradas agrupadas por especie. |
| `GET` | `/api/v1/cities` | No | Listado de ciudades disponibles en el sistema. |

---

### Ejemplos de Peticiones API

#### Iniciar Sesión (`POST /api/v1/login`)
```bash
curl -X POST http://localhost:3000/api/v1/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "adoptante@ejemplo.com",
    "password": "password123"
  }'
```
*Respuesta:*
```json
{
  "status": 200,
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
      "id": 3,
      "first_name": "María",
      "email": "adoptante@ejemplo.com",
      "role": "adopter"
    }
  }
}
```

#### Listar Mascotas Disponibles (`GET /api/v1/pets`)
```bash
curl -X GET "http://localhost:3000/api/v1/pets?species=dog&size=medium" \
  -H "Authorization: Bearer <TOKEN_JWT>"
```

#### Enviar Solicitud de Adopción (`POST /api/v1/adoption_applications`)
```bash
curl -X POST http://localhost:3000/api/v1/adoption_applications \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <TOKEN_JWT>" \
  -d '{
    "adoption_application": {
      "pet_id": 1,
      "housing_type": "Casa con patio",
      "has_another_pet": true,
      "notes": "Tenemos experiencia previa con perros grandes."
    }
  }'
```

---

## 🚀 Despliegue en Producción (Render & PostgreSQL)

El repositorio está preconfigurado para un despliegue ágil en **Render** (o servicios cloud equivalentes) utilizando **PostgreSQL** (como [Neon](https://neon.tech/) o Render Postgres) y almacenamiento en **Cloudinary**.

### Archivos de Configuración Incluidos
- **`render.yaml`**: Blueprint de infraestructura como código (IaC) para Render:
  - Define el servicio web (`petmatch-web`) en entorno Ruby con Puma.
  - Concurrencia optimizada mediante `WEB_CONCURRENCY=2`.
  - Servido directo de assets compilados (`RAILS_SERVE_STATIC_FILES=true`).
- **`bin/render-build.sh`**: Script de construcción y preparación automatizado:
  ```bash
  bundle install
  bin/rails assets:precompile
  bin/rails assets:clean
  bin/rails db:migrate
  bin/rails db:seed
  ```

### Variables de Entorno Requeridas
Para el correcto funcionamiento en producción, define las siguientes variables de entorno en el panel de tu proveedor:

| Variable | Descripción | Ejemplo / Formato |
| :--- | :--- | :--- |
| `DATABASE_URL` | Cadena de conexión a PostgreSQL | `postgresql://user:password@ep-host.neon.tech/petmatch_db?sslmode=require` |
| `RAILS_MASTER_KEY` | Clave maestra para desencriptar credenciales | Valor en `config/master.key` |
| `CLOUDINARY_URL` | URL de conexión al servicio de Cloudinary | `cloudinary://API_KEY:API_SECRET@CLOUD_NAME` |
| `RAILS_SERVE_STATIC_FILES` | Permite que Rails sirva assets compilados | `true` |
| `WEB_CONCURRENCY` | Cantidad de workers en paralelo para Puma | `2` |

---

## 📊 Modelo de Datos

A continuación se detalla la estructura relacional y los propósitos de cada entidad en la base de datos:

```mermaid
erDiagram
    CITY ||--o{ ADDRESS : "contiene"
    ADDRESS ||--o{ SHELTER : "ubica a"
    ADDRESS ||--o{ USER : "residencia de"
    SHELTER ||--o{ USER : "emplea (managers)"
    SHELTER ||--o{ PET : "alberga"
    BREED ||--o{ PET : "clasifica"
    PET ||--o{ MEDICAL_RECORD : "posee"
    PET ||--o{ ADOPTION_APPLICATION : "recibe"
    USER ||--o{ ADOPTION_APPLICATION : "postula"
    PET ||--o{ FAVORITE : "marcada en"
    USER ||--o{ FAVORITE : "guarda"
    USER ||--o{ SESSION : "inicia"

    USER {
        int id PK
        string first_name
        string last_name
        string email_address UK
        string password_digest
        string phone
        string role "admin | shelter_manager | adopter"
        boolean active
        int address_id FK
        int shelter_id FK "nullable"
    }

    PET {
        int id PK
        string name
        int age_months
        string gender "male | female"
        string size "small | medium | large"
        float weight
        text description
        string status "available | in_process | adopted"
        boolean active
        int shelter_id FK
        int breed_id FK
    }

    SHELTER {
        int id PK
        string name
        string email
        string phone
        string website
        text description
        boolean active
        int address_id FK
    }

    ADOPTION_APPLICATION {
        int id PK
        int pet_id FK
        int user_id FK
        string status "pending | under_review | approved | rejected | cancelled"
        string housing_type
        boolean has_another_pet
        text notes
    }

    MEDICAL_RECORD {
        int id PK
        int pet_id FK
        string record_type "vaccine | deworming | surgery | checkup | treatment"
        string title
        date performed_at
        date next_due_date
        text notes
    }

    BREED {
        int id PK
        string name UK
        string species "dog | cat | other"
    }

    CITY {
        int id PK
        string name
        string state
    }

    ADDRESS {
        int id PK
        string street
        string number
        int floor
        string apartment
        string zip_code
        int city_id FK
    }

    FAVORITE {
        int id PK
        int user_id FK
        int pet_id FK
    }

    SESSION {
        int id PK
        int user_id FK
        string ip_address
        string user_agent
    }
```

### Descripción de Entidades Principales

1. **`User`**: Cuentas del sistema con contraseñas cifradas vía `has_secure_password` (`bcrypt`). Soporta tres roles (`admin`, `shelter_manager`, `adopter`), avatar adjunto por Active Storage y borrado lógico (`active: false`).
2. **`Pet`**: Animales ingresados al sistema. Administra atributos biológicos (edad en meses, sexo, tamaño, peso), galería de fotos, soft-delete y estados de adopción (`available`, `in_process`, `adopted`).
3. **`Shelter`**: Refugios u organizaciones de rescate. Contiene datos de contacto, logo, galería de fotos y se vincula con los gestores (`shelter_manager`) y mascotas correspondientes.
4. **`AdoptionApplication`**: Postulaciones de adopción efectuadas por usuarios. Posee un callback automático: cuando una solicitud es marcada como **`approved`**, el estado de la mascota pasa a `adopted` y el resto de las solicitudes pendientes para esa misma mascota pasan a `rejected`.
5. **`MedicalRecord`**: Historial clínico y sanitario de cada animal (vacunación, cirugías, desparasitación, revisiones).
6. **`Breed` & `City` / `Address`**: Tablas maestras normalizadas para razas categorizadas por especie y domicilios normalizados vinculados a ciudades y provincias.
7. **`Favorite`**: Relación muchos a muchos entre usuarios y mascotas favoritas.
8. **`Session`**: Registro de sesiones web activas en base de datos para la autenticación en el panel administrativo.

---

## 📂 Estructura del Proyecto

```text
PetMatch/
├── .github/
│   └── workflows/ci.yml       # Pipeline de integración continua (CI en GitHub Actions)
├── app/
│   ├── controllers/
│   │   ├── admin/             # Controladores del Back-Office (Web)
│   │   ├── api/v1/            # Controladores de la API RESTful (JSON)
│   │   └── concerns/          # Módulos compartidos (Authentication)
│   ├── javascript/
│   │   └── controllers/       # Controladores Stimulus (vista previa de imágenes, sidebar responsivo)
│   ├── mailers/               # Correos electrónicos transaccionales
│   ├── models/                # Modelos de dominio y reglas de negocio
│   ├── services/
│   │   └── json_web_token.rb  # Servicio de codificación y decodificación JWT
│   └── views/
│       ├── admin/             # Vistas HTML/Tailwind para el Back-Office
│       └── layouts/           # Plantillas generales y de administración
├── bin/
│   ├── dev                    # Script de arranque en desarrollo (Puma + Tailwind)
│   ├── render-build.sh        # Script de build, migraciones y seeds para Render
│   ├── brakeman               # Auditoría estática de seguridad Rails
│   ├── bundler-audit          # Auditoría de vulnerabilidades en dependencias
│   ├── rubocop                # Linter de código Ruby
│   └── rails                  # CLI de Ruby on Rails
├── config/
│   ├── database.yml           # Configuración de base de datos (SQLite3 / PostgreSQL)
│   ├── routes.rb              # Definición de rutas Web y API
│   └── storage.yml            # Servicios de almacenamiento (Disco local / Cloudinary)
├── db/
│   ├── migrate/               # Migraciones de base de datos
│   ├── schema.rb              # Esquema de la base de datos
│   └── seeds.rb               # Datos iniciales para pruebas y desarrollo
├── spec/                      # Suite de pruebas automatizadas en RSpec
│   ├── models/                # Pruebas unitarias de modelos
│   ├── requests/              # Pruebas de integración para endpoints de la API
│   └── mailers/               # Pruebas de correos transaccionales
├── storage/                   # Base de datos SQLite3 y archivos locales
└── render.yaml                # Blueprint de infraestructura para despliegue en Render
```
