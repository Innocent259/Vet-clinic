SELECT
    *
FROM
    animals
WHERE
    name LIKE '%mon';

SELECT
    name
FROM
    animals
WHERE
    date_of_birth BETWEEN '2016-01-01'
    AND '2019-12-31';

SELECT
    name
FROM
    animals
WHERE
    neutered = true
    AND escape_attempts < 3;

SELECT
    date_of_birth
FROM
    animals
WHERE
    name IN ('Agumon', 'Pikachu');

SELECT
    name,
    escape_attempts
FROM
    animals
WHERE
    weight_kg > 10.5;

SELECT
    *
FROM
    animals
WHERE
    neutered = true;

SELECT
    *
FROM
    animals
WHERE
    name <> 'Gabumon';

SELECT
    *
FROM
    animals
WHERE
    weight_kg BETWEEN 10.4
    AND 17.3;

-- DAY-2
-- Updating animals table species column to 'digimon' to animals name ending with 'mon'
UPDATE
    animals
SET
    species = 'digimon'
WHERE
    name LIKE '%mon';

-- Updating animals species column to pokemon where species is null
UPDATE
    animals
SET
    species = 'pokemon'
WHERE
    species IS NULL;

COMMIT;

DELETE FROM
    animals;

ROLLBACK;

-- Start the transaction
BEGIN;

-- Delete all animals born after Jan 1st, 2022
DELETE FROM
    animals
WHERE
    date_of_birth > '2022-01-01';

-- Create a savepoint
SAVEPOINT my_savepoint;

-- Update all animals' weight to be their weight multiplied by -1
UPDATE
    animals
SET
    weight_kg = weight_kg * -1;

-- Roll back to the savepoint
ROLLBACK TO my_savepoint;

-- Update all animals' weights that are negative to be their weight multiplied by -1
UPDATE
    animals
SET
    weight_kg = weight_kg * -1
WHERE
    weight_kg < 0;

-- Commit the transaction
COMMIT;

-- How many animals are there 
SELECT
    COUNT(*) AS total_animals
FROM
    animals;

-- How many animals have never tried to escape
SELECT
    COUNT(*) AS num_never_escaped
FROM
    animals
WHERE
    escape_attempts = 0;

-- What is the average weight of animals
SELECT
    AVG(weight_kg) AS average_weight
FROM
    animals;

-- Who escapes the most, neutered or not neutered animals
SELECT
    neutered,
    MAX(escape_attempts) AS max_escape_attempts
FROM
    animals
GROUP BY
    neutered;

-- What is the minimum and maximum weight of each type of anima
SELECT
    species,
    MIN(weight_kg) AS min_weight,
    MAX(weight_kg) AS max_weight
FROM
    animals
GROUP BY
    species;

-- What is the average number of escape attempts per animal type of those born between 1990 and 2000
SELECT
    species,
    AVG(escape_attempts) AS avg_escape_attempts
FROM
    animals
WHERE
    date_of_birth BETWEEN '1990-01-01'
    AND '2000-12-31'
GROUP BY
    species;

-- What animals belong to Melody Pond
SELECT
    a.name AS animal_name,
    s.name AS species_name
FROM
    animals a
    JOIN species s ON a.species_id = s.id
    JOIN owners o ON a.owner_id = o.id
WHERE
    o.full_name = 'Melody Pond';

--List of all animals that are pokemon (their type is Pokemon)
SELECT
    a.name AS animal_name,
    s.name AS species_name
FROM
    animals a
    JOIN species s ON a.species_id = s.id
WHERE
    s.name = 'Pokemon';

-- List all owners and their animals, including those that don't own any animal
SELECT
    o.full_name,
    a.name AS animal_name
FROM
    owners o
    LEFT JOIN animals a ON o.id = a.owner_id;

-- How many animals are there per species
SELECT
    s.name AS species_name,
    COUNT(a.id) AS num_animals
FROM
    species s
    LEFT JOIN animals a ON s.id = a.species_id
GROUP BY
    s.name;

-- List all Digimon owned by Jennifer Orwell.
SELECT
    a.name AS digimon_name
FROM
    animals a
    JOIN species s ON a.species_id = s.id
    JOIN owners o ON a.owner_id = o.id
WHERE
    s.name = 'Digimon'
    AND o.full_name = 'Jennifer Orwell';

-- List all animals owned by Dean Winchester that haven't tried to escape
SELECT
    a.name AS animal_name
FROM
    animals a
    JOIN owners o ON a.owner_id = o.id
WHERE
    o.full_name = 'Dean Winchester'
    AND a.escape_attempts = 0;

-- Who owns the most animals
SELECT
    o.full_name,
    COUNT(a.id) AS num_animals_owned
FROM
    owners o
    LEFT JOIN animals a ON o.id = a.owner_id
GROUP BY
    o.full_name
ORDER BY
    num_animals_owned DESC
LIMIT
    1;

-- Who was the last animal seen by William Tatcher
SELECT
    a.name AS animal_name
FROM
    animals a
    JOIN visits v ON a.id = v.animal_id
    JOIN vets vt ON v.vet_id = vt.id
WHERE
    vt.name = 'William Tatcher'
ORDER BY
    v.visit_date DESC
LIMIT
    1;

-- How many different animals did Stephanie Mendez see
SELECT
    COUNT(DISTINCT v.animal_id) AS num_animals_seen
FROM
    visits v
    JOIN vets vt ON v.vet_id = vt.id
WHERE
    vt.name = 'Stephanie Mendez';

-- List all vets and their specialties, including vets with no specialties
SELECT
    v.name AS vet_name,
    s.name AS specialty_name
FROM
    vets v
    LEFT JOIN specializations sp ON v.id = sp.vet_id
    LEFT JOIN species s ON sp.species_id = s.id;

-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020
SELECT
    a.name AS animal_name
FROM
    animals a
    JOIN visits v ON a.id = v.animal_id
    JOIN vets vt ON v.vet_id = vt.id
WHERE
    vt.name = 'Stephanie Mendez'
    AND v.visit_date BETWEEN '2020-04-01'
    AND '2020-08-30';

-- What animal has the most visits to vets
SELECT
    a.name AS animal_name,
    COUNT(v.animal_id) AS num_visits
FROM
    animals a
    JOIN visits v ON a.id = v.animal_id
GROUP BY
    a.name
ORDER BY
    num_visits DESC
LIMIT
    1;

--Who was Maisy Smith's first visit
SELECT vets.name, MIN(visits.visit_date) AS first_visit_date
FROM vets
JOIN visits ON vets.id = visits.vet_id
JOIN animals ON visits.animal_id = animals.id
WHERE animals.name IN (
  SELECT name FROM animals WHERE id IN (
    SELECT animal_id FROM visits WHERE vet_id IN (
      SELECT id FROM vets WHERE name = 'Maisy Smith'
    )
  ) ORDER BY name LIMIT 1)
GROUP BY vets.id;

-- Details for most recent visit: animal information, vet information, and date of visit
SELECT
    a.name AS animal_name,
    v.visit_date,
    vt.name AS vet_name
FROM
    animals a
    JOIN visits v ON a.id = v.animal_id
    JOIN vets vt ON v.vet_id = vt.id
ORDER BY
    v.visit_date DESC
LIMIT
    1;

-- How many visits were with a vet that did not specialize in that animal's species
SELECT species.name AS specialty 
FROM species 
JOIN specializations ON species.id = specializations.species_id 
JOIN (
  SELECT animal_id FROM visits WHERE animal_id IN (
    SELECT id FROM animals WHERE name IN (
      SELECT name FROM animals WHERE id IN (
        SELECT animal_id FROM visits WHERE vet_id IN (
          SELECT id FROM vets WHERE name = 'Maisy Smith'
        )
      ) GROUP BY name ORDER BY COUNT(*) DESC LIMIT 1)
    ) GROUP BY animal_id ORDER BY COUNT(*) DESC LIMIT 1) AS most_visited_animal 
ON most_visited_animal.animal_id IN (SELECT animal_id FROM specializations);

-- What specialty should Maisy Smith consider getting? Look for the species she gets the most
SELECT
    s.name AS specialty_name,
    COUNT(*) AS num_visits
FROM
    visits v
    JOIN animals a ON v.animal_id = a.id
    JOIN vets vt ON v.vet_id = vt.id
    JOIN owners o ON a.owner_id = o.id
    JOIN specializations sp ON vt.id = sp.vet_id
    AND a.species_id = sp.species_id
    JOIN species s ON sp.species_id = s.id
WHERE
    o.full_name = 'Maisy Smith'
GROUP BY
    s.name
ORDER BY
    num_visits DESC
LIMIT
    1;