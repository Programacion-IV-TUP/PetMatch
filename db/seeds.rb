# db/seeds.rb
# English technical comments as requested for standard code style.

puts "🌱 Populating initial database records..."

# -----------------------------------------------------------------------------
# 1. CITIES (15 records)
# -----------------------------------------------------------------------------
puts "📍 Creating Cities..."

cities_data = [
  { name: "La Plata", state: "Buenos Aires" },
  { name: "Ciudad Autónoma de Buenos Aires", state: "CABA" },
  { name: "Rosario", state: "Santa Fe" },
  { name: "Córdoba", state: "Córdoba" },
  { name: "Mendoza", state: "Mendoza" },
  { name: "Mar del Plata", state: "Buenos Aires" },
  { name: "San Miguel de Tucumán", state: "Tucumán" },
  { name: "Salta", state: "Salta" },
  { name: "Santa Fe", state: "Santa Fe" },
  { name: "San Juan", state: "San Juan" },
  { name: "Neuquén", state: "Neuquén" },
  { name: "San Salvador de Jujuy", state: "Jujuy" },
  { name: "Resistencia", state: "Chaco" },
  { name: "Posadas", state: "Misiones" },
  { name: "Bahía Blanca", state: "Buenos Aires" }
]

cities = cities_data.map do |data|
  City.find_or_create_by!(name: data[:name], state: data[:state])
end

puts "  └─ #{City.count} cities available."

# -----------------------------------------------------------------------------
# 2. ADDRESSES (15 records using city_id FK)
# -----------------------------------------------------------------------------
puts "🏠 Creating Addresses..."

addresses_data = [
  { street: "Calle 50", number: "1234", city: cities[0] },
  { street: "Av. Corrientes", number: "1230", city: cities[1] },
  { street: "Av. Pellegrini", number: "1500", city: cities[2] },
  { street: "Av. Colón", number: "850", city: cities[3] },
  { street: "Av. San Martín", number: "400", city: cities[4] },
  { street: "Calle 7", number: "890", city: cities[0] },
  { street: "Av. Pedro Luro", number: "2300", city: cities[5] },
  { street: "Calle 25 de Mayo", number: "640", city: cities[6] },
  { street: "Av. Belgrano", number: "1120", city: cities[7] },
  { street: "Av. Urquiza", number: "3100", city: cities[8] },
  { street: "Calle Central", number: "450", city: cities[9] },
  { street: "Av. Argentina", number: "980", city: cities[10] },
  { street: "Calle Lavalle", number: "120", city: cities[11] },
  { street: "Av. 9 de Julio", number: "530", city: cities[12] },
  { street: "Av. Mitre", number: "210", city: cities[13] }
]

addresses = addresses_data.map do |data|
  Address.find_or_create_by!(street: data[:street], number: data[:number], city: data[:city])
end

puts "  └─ #{Address.count} addresses created."

# -----------------------------------------------------------------------------
# 3. BREEDS (15 records)
# -----------------------------------------------------------------------------
puts "🐾 Creating Breeds..."

breeds_data = [
  { name: "Mestizo Perro", species: "dog" },
  { name: "Labrador Retriever", species: "dog" },
  { name: "Golden Retriever", species: "dog" },
  { name: "Ovejero Alemán", species: "dog" },
  { name: "Caniche Toy", species: "dog" },
  { name: "Bulldog Francés", species: "dog" },
  { name: "Beagle", species: "dog" },
  { name: "Boxer", species: "dog" },
  { name: "Dachshund (Sartén)", species: "dog" },
  { name: "Mestizo Gato", species: "cat" },
  { name: "Siamés", species: "cat" },
  { name: "Persa", species: "cat" },
  { name: "Maine Coon", species: "cat" },
  { name: "Bengalí", species: "cat" },
  { name: "Sphynx", species: "cat" }
]

breeds = breeds_data.map do |data|
  Breed.find_or_create_by!(name: data[:name], species: data[:species])
end

puts "  └─ #{Breed.count} breeds created."

# -----------------------------------------------------------------------------
# 4. SHELTERS (15 records using address_id FK)
# -----------------------------------------------------------------------------
puts "🏢 Creating Shelters..."

shelters_data = [
  { name: "Refugio Mascotas La Plata", phone: "2211234567", email: "contacto@refugiolaplata.org", address: addresses[0] },
  { name: "Refugio Mascotas Buenos Aires", phone: "1112345678", email: "contacto@refugiobaires.org", address: addresses[1] },
  { name: "Protectora Rosario", phone: "3415551234", email: "info@protectorarosario.org", address: addresses[2] },
  { name: "Hogar Canino Córdoba", phone: "3514449876", email: "adopciones@hogarcordoba.org", address: addresses[3] },
  { name: "Refugio del Sol Mendoza", phone: "2618882233", email: "contacto@refugiosol.org", address: addresses[4] },
  { name: "Asociación Huellas La Plata", phone: "2219998877", email: "huellas@laplata.org", address: addresses[5] },
  { name: "Refugio Costa Atlántica", phone: "2234445566", email: "costa@refugios.org", address: addresses[6] },
  { name: "Protectora Tucumán", phone: "3812223344", email: "tucuman@adopciones.org", address: addresses[7] },
  { name: "Hogar Salteño", phone: "3871112233", email: "salta@petmatch.org", address: addresses[8] },
  { name: "Refugio Santa Fe Sanito", phone: "3425556677", email: "santafe@mascotas.org", address: addresses[9] },
  { name: "Protectora San Juan", phone: "2643334455", email: "sanjuan@protectora.org", address: addresses[10] },
  { name: "Refugio del Comahue", phone: "2996667788", email: "neuquen@refugio.org", address: addresses[11] },
  { name: "Asociación Animalista Jujuy", phone: "3884441122", email: "jujuy@animales.org", address: addresses[12] },
  { name: "Hogar Chaqueño", phone: "3628889900", email: "chaco@mascotas.org", address: addresses[13] },
  { name: "Refugio Misiones Verde", phone: "3764443322", email: "misiones@proteccion.org", address: addresses[14] }
]

shelters = shelters_data.map do |data|
  Shelter.find_or_create_by!(name: data[:name]) do |s|
    s.phone = data[:phone]
    s.email = data[:email]
    s.address = data[:address]
    s.active = true
  end
end

puts "  └─ #{Shelter.count} shelters created."

# -----------------------------------------------------------------------------
# 5. USERS (15 records: address_id is NOT NULL in schema)
# -----------------------------------------------------------------------------
puts "👤 Creating Users..."

users_data = [
  # Admin users
  { email: "admin@petmatch.com", first_name: "Admin", last_name: "General", role: "admin", shelter: nil, address: addresses[0] },
  { email: "admin2@petmatch.com", first_name: "Sofía", last_name: "Rodríguez", role: "admin", shelter: nil, address: addresses[1] },

  # Shelter Managers
  { email: "manager@refugiolaplata.org", first_name: "Carlos", last_name: "Gómez", role: "shelter_manager", shelter: shelters[0], address: addresses[0] },
  { email: "manager@refugiobuenosaires.org", first_name: "Fernanda", last_name: "García", role: "shelter_manager", shelter: shelters[1], address: addresses[1] },
  { email: "manager@rosario.org", first_name: "Lucas", last_name: "Martínez", role: "shelter_manager", shelter: shelters[2], address: addresses[2] },
  { email: "manager@cordoba.org", first_name: "Valeria", last_name: "López", role: "shelter_manager", shelter: shelters[3], address: addresses[3] },
  { email: "manager@mendoza.org", first_name: "Mateo", last_name: "Díaz", role: "shelter_manager", shelter: shelters[4], address: addresses[4] },

  # Adopters
  { email: "adoptante@ejemplo.com", first_name: "María", last_name: "Pérez", role: "adopter", shelter: nil, address: addresses[5] },
  { email: "juan.perez@ejemplo.com", first_name: "Juan", last_name: "Pérez", role: "adopter", shelter: nil, address: addresses[6] },
  { email: "lucia.romero@ejemplo.com", first_name: "Lucía", last_name: "Romero", role: "adopter", shelter: nil, address: addresses[7] },
  { email: "agustin.torres@ejemplo.com", first_name: "Agustín", last_name: "Torres", role: "adopter", shelter: nil, address: addresses[8] },
  { email: "camila.benitez@ejemplo.com", first_name: "Camila", last_name: "Benítez", role: "adopter", shelter: nil, address: addresses[9] },
  { email: "nicolas.acosta@ejemplo.com", first_name: "Nicolás", last_name: "Acosta", role: "adopter", shelter: nil, address: addresses[10] },
  { email: "florencia.flores@ejemplo.com", first_name: "Florencia", last_name: "Flores", role: "adopter", shelter: nil, address: addresses[11] },
  { email: "gonzalo.sosa@ejemplo.com", first_name: "Gonzalo", last_name: "Sosa", role: "adopter", shelter: nil, address: addresses[12] }
]

users = users_data.map do |data|
  user = User.find_or_initialize_by(email_address: data[:email])
  if user.new_record?
    user.first_name = data[:first_name]
    user.last_name = data[:last_name]
    user.password = "password123"
    user.password_confirmation = "password123"
    user.role = data[:role]
    user.shelter = data[:shelter]
    user.address = data[:address] # Mandatory due to null: false constraint on address_id
    user.active = true
    user.save!
  end
  user
end

puts "  └─ #{User.count} users verified/created."

# -----------------------------------------------------------------------------
# 6. PETS (15 records using shelter_id and breed_id FKs)
# -----------------------------------------------------------------------------
puts "🐶 Creating Pets..."

pets_data = [
  { name: "Firulais", age_months: 24, gender: "male", size: "medium", status: "available", breed: breeds[0], shelter: shelters[0] },
  { name: "Misha", age_months: 12, gender: "female", size: "small", status: "in_process", breed: breeds[10], shelter: shelters[0] },
  { name: "Rocco", age_months: 36, gender: "male", size: "large", status: "available", breed: breeds[1], shelter: shelters[1] },
  { name: "Luna", age_months: 18, gender: "female", size: "medium", status: "available", breed: breeds[2], shelter: shelters[1] },
  { name: "Thor", age_months: 48, gender: "male", size: "large", status: "adopted", breed: breeds[3], shelter: shelters[2] },
  { name: "Toby", age_months: 8, gender: "male", size: "small", status: "available", breed: breeds[4], shelter: shelters[2] },
  { name: "Lola", age_months: 14, gender: "female", size: "small", status: "in_process", breed: breeds[5], shelter: shelters[3] },
  { name: "Milo", age_months: 20, gender: "male", size: "medium", status: "available", breed: breeds[6], shelter: shelters[3] },
  { name: "Simba", age_months: 10, gender: "male", size: "small", status: "available", breed: breeds[9], shelter: shelters[4] },
  { name: "Cleo", age_months: 28, gender: "female", size: "small", status: "adopted", breed: breeds[11], shelter: shelters[4] },
  { name: "Bobi", age_months: 60, gender: "male", size: "medium", status: "available", breed: breeds[7], shelter: shelters[5] },
  { name: "Felix", age_months: 15, gender: "male", size: "medium", status: "available", breed: breeds[12], shelter: shelters[5] },
  { name: "Pina", age_months: 6, gender: "female", size: "small", status: "available", breed: breeds[13], shelter: shelters[6] },
  { name: "Max", age_months: 42, gender: "male", size: "large", status: "available", breed: breeds[8], shelter: shelters[6] },
  { name: "Nala", age_months: 22, gender: "female", size: "small", status: "available", breed: breeds[14], shelter: shelters[7] }
]

pets = pets_data.map do |data|
  Pet.find_or_create_by!(name: data[:name], shelter: data[:shelter]) do |p|
    p.age_months = data[:age_months]
    p.gender = data[:gender]
    p.size = data[:size]
    p.status = data[:status]
    p.breed = data[:breed]
    p.active = true
  end
end

puts "  └─ #{Pet.count} pets registered."

# -----------------------------------------------------------------------------
# 7. MEDICAL RECORDS (15 records using pet_id FK)
# -----------------------------------------------------------------------------
puts "🩺 Creating Medical Records..."

medical_records_data = [
  { title: "Vacuna Antirrábica", record_type: "vaccine", performed_at: 3.months.ago, notes: "Vacunación anual completada.", pet: pets[0] },
  { title: "Desparasitación General", record_type: "deworming", performed_at: 1.month.ago, notes: "Dosis según peso corporal.", pet: pets[0] },
  { title: "Chequeo Inicial", record_type: "checkup", performed_at: 2.weeks.ago, notes: "Excelente estado de salud general.", pet: pets[1] },
  { title: "Vacuna Triple Felina", record_type: "vaccine", performed_at: 2.months.ago, notes: "Refuerzo aplicado.", pet: pets[1] },
  { title: "Cirugía de Castración", record_type: "surgery", performed_at: 6.months.ago, notes: "Procedimiento de orquiectomía sin complicaciones.", pet: pets[2] },
  { title: "Vacuna Quíntuple", record_type: "vaccine", performed_at: 4.months.ago, notes: "Dosis anual al día.", pet: pets[2] },
  { title: "Limpieza Dental", record_type: "treatment", performed_at: 1.week.ago, notes: "Profilaxis ultrasónica realizada.", pet: pets[3] },
  { title: "Chequeo Traumatológico", record_type: "checkup", performed_at: 5.months.ago, notes: "Evolución favorable de pata trasera.", pet: pets[4] },
  { title: "Primer Esquema Vacunación", record_type: "vaccine", performed_at: 1.month.ago, notes: "Cachorro con vacuna puppy al día.", pet: pets[5] },
  { title: "Desparasitación Interna", record_type: "deworming", performed_at: 3.weeks.ago, notes: "Jarabe antiparasitario administrado.", pet: pets[6] },
  { title: "Control Dermatológico", record_type: "checkup", performed_at: 2.months.ago, notes: "Tratamiento para alergia cutánea.", pet: pets[7] },
  { title: "Castración Felina", record_type: "surgery", performed_at: 4.months.ago, notes: "Ovariohisterectomía exitosa.", pet: pets[9] },
  { title: "Chequeo de Oídos", record_type: "treatment", performed_at: 2.days.ago, notes: "Limpieza de conducta auditivo realizada.", pet: pets[10] },
  { title: "Vacuna Antirrábica", record_type: "vaccine", performed_at: 1.year.ago, notes: "Vacunación antirrábica reglamentaria.", pet: pets[11] },
  { title: "Análisis de Sangre", record_type: "checkup", performed_at: 3.days.ago, notes: "Hemograma completo dentro de rangos normales.", pet: pets[12] }
]

medical_records_data.each do |data|
  MedicalRecord.find_or_create_by!(title: data[:title], pet: data[:pet]) do |m|
    m.record_type = data[:record_type]
    m.performed_at = data[:performed_at]
    m.notes = data[:notes]
  end
end

puts "  └─ #{MedicalRecord.count} medical records created."

# -----------------------------------------------------------------------------
# 8. ADOPTION APPLICATIONS (15 records using pet_id and user_id FKs)
# -----------------------------------------------------------------------------
puts "📋 Creating Adoption Applications..."

adopters = users.select { |u| u.adopter? }

applications_data = [
  { pet: pets[0], user: adopters[0], status: "pending", housing_type: "House", has_another_pet: true, notes: "Casa con jardín cerrado." },
  { pet: pets[1], user: adopters[0], status: "under_review", housing_type: "Apartment", has_another_pet: false, notes: "Departamento amplio con protección en ventanas." },
  { pet: pets[1], user: adopters[1], status: "pending", housing_type: "Apartment", has_another_pet: true, notes: "Tiene un gato de 3 años socializado." },
  { pet: pets[2], user: adopters[2], status: "approved", housing_type: "House", has_another_pet: true, notes: "Familia con experiencia en perros grandes." },
  { pet: pets[3], user: adopters[3], status: "pending", housing_type: "House", has_another_pet: false, notes: "Disponibilidad de tiempo para paseos." },
  { pet: pets[4], user: adopters[4], status: "approved", housing_type: "House", has_another_pet: true, notes: "Adopción concretada anteriormente." },
  { pet: pets[5], user: adopters[5], status: "under_review", housing_type: "Apartment", has_another_pet: false, notes: "Trabaja desde casa." },
  { pet: pets[6], user: adopters[6], status: "pending", housing_type: "House", has_another_pet: false, notes: "Patio amplio totalmente cerrado." },
  { pet: pets[7], user: adopters[7], status: "rejected", housing_type: "Apartment", has_another_pet: true, notes: "No se permite mascotas en el reglamento del edificio." },
  { pet: pets[8], user: adopters[0], status: "pending", housing_type: "House", has_another_pet: true, notes: "Buscando compañero para perro actual." },
  { pet: pets[9], user: adopters[1], status: "approved", housing_type: "Apartment", has_another_pet: false, notes: "Redes de seguridad instaladas." },
  { pet: pets[10], user: adopters[2], status: "pending", housing_type: "House", has_another_pet: true, notes: "Familia compuesta por 4 integrantes." },
  { pet: pets[11], user: adopters[3], status: "under_review", housing_type: "House", has_another_pet: false, notes: "Interés en felino adulto." },
  { pet: pets[12], user: adopters[4], status: "pending", housing_type: "Apartment", has_another_pet: false, notes: "Primer adopción responsable." },
  { pet: pets[13], user: adopters[5], status: "pending", housing_type: "House", has_another_pet: true, notes: "Terreno amplio cercado." }
]

applications_data.each do |data|
  AdoptionApplication.find_or_create_by!(pet: data[:pet], user: data[:user]) do |a|
    a.status = data[:status]
    a.housing_type = data[:housing_type]
    a.has_another_pet = data[:has_another_pet]
    a.notes = data[:notes]
  end
end

puts "  └─ #{AdoptionApplication.count} adoption applications created."

# -----------------------------------------------------------------------------
# 9. FAVORITES (15 records using pet_id and user_id FKs)
# -----------------------------------------------------------------------------
puts "⭐ Creating Favorites..."

favorites_data = [
  { pet: pets[0], user: adopters[0] },
  { pet: pets[1], user: adopters[0] },
  { pet: pets[2], user: adopters[0] },
  { pet: pets[3], user: adopters[1] },
  { pet: pets[5], user: adopters[1] },
  { pet: pets[6], user: adopters[2] },
  { pet: pets[7], user: adopters[2] },
  { pet: pets[8], user: adopters[3] },
  { pet: pets[10], user: adopters[3] },
  { pet: pets[11], user: adopters[4] },
  { pet: pets[12], user: adopters[4] },
  { pet: pets[13], user: adopters[5] },
  { pet: pets[14], user: adopters[5] },
  { pet: pets[0], user: adopters[6] },
  { pet: pets[3], user: adopters[7] }
]

favorites_data.each do |data|
  Favorite.find_or_create_by!(pet: data[:pet], user: data[:user])
end

puts "  └─ #{Favorite.count} favorites linked."

puts "✅ Database successfully seeded with full production-like relationships!"
