CREATE TABLE animals (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    date_of_birth DATE,
    escape_attempts INTEGER,
    neutered BOOLEAN,
    weight_kg DECIMAL(10, 2)
);

-- Adding new column to animals table
ALTER TABLE
    animals
ADD
    COLUMN species VARCHAR(255) -- Query multiple tables
    CREATE TABLE owners (
        id SERIAL PRIMARY KEY,
        full_name VARCHAR(255),
        age INTEGER
    );

CREATE TABLE species (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255)
);

-- Modify animals table 
-- Remove the species column
ALTER TABLE
    animals DROP COLUMN species;

-- Add the species_id column as a foreign key referencing species table
ALTER TABLE
    animals
ADD
    COLUMN species_id INTEGER REFERENCES species(id);

-- Add the owner_id column as a foreign key referencing owners table
ALTER TABLE
    animals
ADD
    COLUMN owner_id INTEGER REFERENCES owners(id);

-- Create a table named "vets"
CREATE TABLE vets (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    age INTEGER,
    date_of_graduation DATE
);

-- Create the "specializations" Join Table
CREATE TABLE specializations (
    vet_id INTEGER REFERENCES vets(id),
    species_id INTEGER REFERENCES species(id),
    PRIMARY KEY (vet_id, species_id)
);

-- Create the "visits" Join Table
CREATE TABLE visits (
    animal_id INTEGER REFERENCES animals(id),
    vet_id INTEGER REFERENCES vets(id),
    visit_date DATE,
    PRIMARY KEY (animal_id, vet_id, visit_date)
);