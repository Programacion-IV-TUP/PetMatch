# 🐾 PetMatch API & Back-Office

Plataforma integral para la gestión y adopción responsable de mascotas. Desarrollada sobre **Ruby on Rails 8** con SQLite3, interfaz administrativa en Hotwire/TailwindCSS y una API RESTful desacoplada con autenticación basada en JWT para clientes móviles o web.

---

## 📋 Tabla de Contenidos

- [Características Principales](#-características-principales)
- [Requisitos Previos](#-requisitos-previos)
- [Instalación y Ejecución](#-instalación-y-ejecución)
- [Preparación de la Base de Datos](#-preparación-de-la-base-de-datos)
- [Acceso al Back-Office y Credenciales](#-acceso-al-back-office-y-credenciales)
- [API RESTful (v1)](#-api-restful-v1)
- [Modelo de Datos](#-modelo-de-datos)
- [Estructura del Proyecto](#-estructura-del-proyecto)

---

## 🚀 Características Principales

- **Back-Office Administrativo**: Panel de control con interfaz moderna en Tailwind CSS para la administración de mascotas, refugios, registros médicos, usuarios y solicitudes de adopción.
- **Roles y Permisos**:
  - `admin`: Superadministrador con control total del sistema.
  - `shelter_manager`: Gestor enfocado en las mascotas y solicitudes de su refugio asignado.
  - `adopter`: Usuario final que consulta mascotas y envía solicitudes vía API.
- **API RESTful Segura**: Endpoints versionados (`/api/v1`) con autenticación mediante JSON Web Tokens (JWT).
- **Gestión Multimedia**: Subida y procesamiento de fotos y avatares con Active Storage.
- **Ciclo de Adopción Automatizado**: Cambios automáticos de estado en las mascotas al aprobar o cancelar solicitudes de adopción.
- **Internacionalización (i18n)**: Soporte de idiomas configurable por sesión web y mediante cabecera `Accept-Language` en la API.

---

## 🛠 Requisitos Previos

Asegúrate de contar con las siguientes herramientas instaladas en tu entorno:

- **Ruby**: versión 3.x o superior (verificado con Ruby 3.3+ / 4.0)
- **Ruby on Rails**: 8.1.3+
- **Bundler**: `gem install bundler`
- **SQLite3**: versión 3.8 o superior
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
├── app/
│   ├── controllers/
│   │   ├── admin/             # Controladores del Back-Office (Web)
│   │   ├── api/v1/            # Controladores de la API RESTful (JSON)
│   │   └── concerns/          # Módulos compartidos (Authentication)
│   ├── mailers/               # Correos electrónicos transaccionales
│   ├── models/                # Modelos de dominio y reglas de negocio
│   ├── services/
│   │   └── json_web_token.rb  # Servicio de codificación y decodificación JWT
│   └── views/
│       ├── admin/             # Vistas HTML/Tailwind para el Back-Office
│       └── layouts/           # Plantillas generales y de administración
├── config/
│   ├── routes.rb              # Definición de rutas Web y API
│   └── database.yml           # Configuración de SQLite3
├── db/
│   ├── migrate/               # Migraciones de base de datos
│   ├── schema.rb              # Esquema de la base de datos
│   └── seeds.rb               # Datos iniciales para pruebas y desarrollo
├── storage/                   # Base de datos SQLite3 y archivos locales
└── bin/
    ├── dev                    # Script de arranque en desarrollo (Puma + Tailwind)
    └── rails                  # CLI de Ruby on Rails
```
