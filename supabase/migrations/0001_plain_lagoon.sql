/*
  # Initialize Spatial Database Schema

  1. Extensions
    - Enable PostGIS extension for spatial data handling
    - Enable PostGIS topology for advanced spatial operations

  2. New Tables
    - regions (top-level administrative divisions)
    - provinces (subdivisions of regions)
    - departments (subdivisions of provinces)
    - communes (subdivisions of departments)
    - cities (urban areas)
    - villages (rural settlements)
    - chemical_data (chemical composition measurements)
    - physical_data (physical properties measurements)
    - hydraulic_data (water-related measurements)

  3. Security
    - Enable RLS on all tables
    - Add policies for data access
*/

-- Enable PostGIS extensions
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS postgis_topology;

-- Create administrative boundaries tables
CREATE TABLE IF NOT EXISTS regions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  code text UNIQUE NOT NULL,
  geometry geometry(MultiPolygon, 4326) NOT NULL,
  properties jsonb DEFAULT '{}'::jsonb,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS provinces (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  region_id uuid REFERENCES regions(id),
  name text NOT NULL,
  code text UNIQUE NOT NULL,
  geometry geometry(MultiPolygon, 4326) NOT NULL,
  properties jsonb DEFAULT '{}'::jsonb,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS departments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  province_id uuid REFERENCES provinces(id),
  name text NOT NULL,
  code text UNIQUE NOT NULL,
  geometry geometry(MultiPolygon, 4326) NOT NULL,
  properties jsonb DEFAULT '{}'::jsonb,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS communes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  department_id uuid REFERENCES departments(id),
  name text NOT NULL,
  code text UNIQUE NOT NULL,
  geometry geometry(MultiPolygon, 4326) NOT NULL,
  properties jsonb DEFAULT '{}'::jsonb,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS cities (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  commune_id uuid REFERENCES communes(id),
  name text NOT NULL,
  population integer,
  geometry geometry(Point, 4326) NOT NULL,
  properties jsonb DEFAULT '{}'::jsonb,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS villages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  commune_id uuid REFERENCES communes(id),
  name text NOT NULL,
  population integer,
  geometry geometry(Point, 4326) NOT NULL,
  properties jsonb DEFAULT '{}'::jsonb,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create measurement data tables
CREATE TABLE IF NOT EXISTS chemical_data (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  location geometry(Point, 4326) NOT NULL,
  sample_date timestamptz NOT NULL,
  ph numeric,
  conductivity numeric,
  dissolved_oxygen numeric,
  temperature numeric,
  minerals jsonb,
  heavy_metals jsonb,
  organic_compounds jsonb,
  properties jsonb DEFAULT '{}'::jsonb,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS physical_data (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  location geometry(Point, 4326) NOT NULL,
  sample_date timestamptz NOT NULL,
  soil_type text,
  soil_texture text,
  density numeric,
  porosity numeric,
  permeability numeric,
  properties jsonb DEFAULT '{}'::jsonb,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS hydraulic_data (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  location geometry(Point, 4326) NOT NULL,
  sample_date timestamptz NOT NULL,
  flow_rate numeric,
  pressure numeric,
  water_level numeric,
  aquifer_depth numeric,
  conductivity numeric,
  properties jsonb DEFAULT '{}'::jsonb,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create spatial indexes
CREATE INDEX IF NOT EXISTS regions_geometry_idx ON regions USING GIST (geometry);
CREATE INDEX IF NOT EXISTS provinces_geometry_idx ON provinces USING GIST (geometry);
CREATE INDEX IF NOT EXISTS departments_geometry_idx ON departments USING GIST (geometry);
CREATE INDEX IF NOT EXISTS communes_geometry_idx ON communes USING GIST (geometry);
CREATE INDEX IF NOT EXISTS cities_geometry_idx ON cities USING GIST (geometry);
CREATE INDEX IF NOT EXISTS villages_geometry_idx ON villages USING GIST (geometry);
CREATE INDEX IF NOT EXISTS chemical_data_location_idx ON chemical_data USING GIST (location);
CREATE INDEX IF NOT EXISTS physical_data_location_idx ON physical_data USING GIST (location);
CREATE INDEX IF NOT EXISTS hydraulic_data_location_idx ON hydraulic_data USING GIST (location);

-- Enable Row Level Security
ALTER TABLE regions ENABLE ROW LEVEL SECURITY;
ALTER TABLE provinces ENABLE ROW LEVEL SECURITY;
ALTER TABLE departments ENABLE ROW LEVEL SECURITY;
ALTER TABLE communes ENABLE ROW LEVEL SECURITY;
ALTER TABLE cities ENABLE ROW LEVEL SECURITY;
ALTER TABLE villages ENABLE ROW LEVEL SECURITY;
ALTER TABLE chemical_data ENABLE ROW LEVEL SECURITY;
ALTER TABLE physical_data ENABLE ROW LEVEL SECURITY;
ALTER TABLE hydraulic_data ENABLE ROW LEVEL SECURITY;

-- Create RLS Policies
CREATE POLICY "Enable read access for authenticated users" ON regions
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "Enable read access for authenticated users" ON provinces
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "Enable read access for authenticated users" ON departments
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "Enable read access for authenticated users" ON communes
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "Enable read access for authenticated users" ON cities
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "Enable read access for authenticated users" ON villages
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "Enable read access for authenticated users" ON chemical_data
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "Enable read access for authenticated users" ON physical_data
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "Enable read access for authenticated users" ON hydraulic_data
  FOR SELECT TO authenticated USING (true);