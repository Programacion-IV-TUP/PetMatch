puts "🌱 Cargando datos iniciales en la base de datos..."

# -----------------------------------------------------------------------------
# 1. Ciudades (Unicidad por nombre scoped a provincia)
# -----------------------------------------------------------------------------
puts "📍 Creando ciudades..."

cities_data = [
  { name: "La Plata", state: "Buenos Aires" },
  { name: "Ciudad Autónoma de Buenos Aires", state: "CABA" },
  { name: "Rosario", state: "Santa Fe" },
  { name: "Córdoba", state: "Córdoba" },
  { name: "Mendoza", state: "Mendoza" }
]

cities_data.each do |data|
  City.find_or_create_by!(name: data[:name], state: data[:state])
end

puts "  └─ #{City.count} ciudades cargadas."

# -----------------------------------------------------------------------------
# 2. Razas (Lista maestra por especie)
# -----------------------------------------------------------------------------
puts "🐾 Creando razas..."

breeds_data = [
  { name: "Mestizo", species: "dog" },
  { name: "Labrador Retriever", species: "dog" },
  { name: "Golden Retriever", species: "dog" },
  { name: "Ovejero Alemán", species: "dog" },
  { name: "Mestizo / Común Europeo", species: "cat" },
  { name: "Siamés", species: "cat" }
]

breeds_data.each do |data|
  Breed.find_or_create_by!(name: data[:name], species: data[:species])
end

puts "  └─ #{Breed.count} razas cargadas."

# -----------------------------------------------------------------------------
# 3. Dirección y Refugio
# -----------------------------------------------------------------------------
puts "🏠 Creando dirección y refugio por defecto..."

la_plata = City.find_by!(name: "La Plata", state: "Buenos Aires")
caba = City.find_by!(name: "Ciudad Autónoma de Buenos Aires", state: "CABA")

# Crear primero la dirección obligatoria
address = Address.find_or_create_by!(street: "Calle 50", number: "1234") do |a|
  a.city = la_plata
end

address2 = Address.find_or_create_by!(street: "Av. Corrientes", number: "22") do |a|
  a.city = caba
end

# Crear el refugio vinculando la dirección creada
shelter = Shelter.find_or_create_by!(name: "Refugio Mascotas La Plata") do |s|
  s.phone = "2211234567"
  s.email = "contacto@refugiolaplata.org"
  s.address = address
end

shelter = Shelter.find_or_create_by!(name: "Refugio Mascotas Buenos Aires") do |s|
  s.phone = "1112345678"
  s.email = "contacto@refugiobaires.org"
  s.address = address
end

# -----------------------------------------------------------------------------
# 4. Usuarios Administradores y Adoptantes (con nombres y dirección)
# -----------------------------------------------------------------------------
puts "👤 Creando usuarios..."

# Global Admin / Super Admin
admin_user = User.find_or_initialize_by(email_address: "admin@petmatch.com")
if admin_user.new_record?
  admin_user.first_name = "Admin"
  admin_user.last_name = "General" # O last_name / segundo nombre según tu schema
  admin_user.password = "password123"
  admin_user.password_confirmation = "password123"
  admin_user.role = "admin"
  admin_user.address = address if admin_user.respond_to?(:address=)
  admin_user.save!
end

# Shelter Manager
manager_user = User.find_or_initialize_by(email_address: "manager@refugiolaplata.org")
if manager_user.new_record?
  manager_user.first_name = "Carlos"
  manager_user.last_name = "Gómez"
  manager_user.password = "password123"
  manager_user.password_confirmation = "password123"
  manager_user.role = "shelter_manager"
  manager_user.shelter = shelter
  manager_user.address = address if manager_user.respond_to?(:address=)
  manager_user.save!
end

manager_user = User.find_or_initialize_by(email_address: "manager@refugiobuenosaires.org")
if manager_user.new_record?
  manager_user.first_name = "Fernanda"
  manager_user.last_name = "García"
  manager_user.password = "password123"
  manager_user.password_confirmation = "password123"
  manager_user.role = "shelter_manager"
  manager_user.shelter = shelter
  manager_user.address = address2 if manager_user.respond_to?(:address=)
  manager_user.save!
end


# Usuario Adoptante
adopter_user = User.find_or_initialize_by(email_address: "adoptante@ejemplo.com")
if adopter_user.new_record?
  adopter_user.first_name = "María"
  adopter_user.last_name = "Pérez"
  adopter_user.password = "password123"
  adopter_user.password_confirmation = "password123"
  adopter_user.role = "adopter"
  adopter_user.address = address if adopter_user.respond_to?(:address=)
  adopter_user.save!
end

puts "  └─ #{User.count} usuarios creados/verificados."

# -----------------------------------------------------------------------------
# 5. Mascotas
# -----------------------------------------------------------------------------
puts "🐶 Creando mascotas de prueba..."

breed_dog = Breed.find_by!(name: "Mestizo", species: "dog")
breed_cat = Breed.find_by!(name: "Siamés", species: "cat")

pet1 = Pet.find_or_create_by!(name: "Firulais", shelter: shelter) do |p|
  p.age_months = 24
  p.gender = "male"   # Obligatorio por validación
  p.size = "medium"   # Obligatorio por validación
  p.status = "available"
  p.breed = breed_dog
end

pet2 = Pet.find_or_create_by!(name: "Misha", shelter: shelter) do |p|
  p.age_months = 12
  p.gender = "female" # Obligatorio por validación
  p.size = "small"    # Obligatorio por validación
  p.status = "in_process"
  p.breed = breed_cat
end

puts "  └─ #{Pet.count} mascotas registradas."

# -----------------------------------------------------------------------------
# 6. Registros Médicos
# -----------------------------------------------------------------------------
puts "🩺 Creando registros médicos..."

MedicalRecord.find_or_create_by!(title: "Vacuna Antirrábica", pet: pet1) do |m|
  m.record_type = "vaccine"
  m.performed_at = Date.current - 3.months
  m.notes = "Vacunación anual completada sin reacciones adversas."
end

MedicalRecord.find_or_create_by!(title: "Desparasitación general", pet: pet1) do |m|
  m.record_type = "deworming"
  m.performed_at = Date.current - 1.month
  m.notes = "Dosis de comprimido administrada según peso."
end

MedicalRecord.find_or_create_by!(title: "Chequeo inicial", pet: pet2) do |m|
  m.record_type = "checkup"
  m.performed_at = Date.current - 2.weeks
  m.notes = "Gato en excelente estado de salud general."
end

puts "  └─ #{MedicalRecord.count} registros médicos vinculados."

# -----------------------------------------------------------------------------
# 7. Solicitudes de Adopción
# -----------------------------------------------------------------------------
puts "📋 Creando solicitudes de adopción..."

AdoptionApplication.find_or_create_by!(pet: pet2, user: adopter_user) do |a|
  a.status = "under_review"
  a.housing_type = "House"
  a.has_another_pet = true # Se pasa true para cumplir con 'presence: true' si el modelo lo requiere
  a.notes = "Cuenta con espacio adecuado y disponibilidad horaria."
end

puts "  └─ #{AdoptionApplication.count} solicitudes registradas."

puts "✅ Carga de seeds finalizada exitosamente."
