import { Router } from 'express';
import { supabase } from '../index.js';

const router = Router();

// Get chemical data within a bounding box
router.get('/chemical', async (req, res) => {
  const { minLat, minLng, maxLat, maxLng } = req.query;
  
  const { data, error } = await supabase.rpc('get_chemical_data_in_bounds', {
    min_lat: minLat,
    min_lng: minLng,
    max_lat: maxLat,
    max_lng: maxLng
  });
  
  if (error) return res.status(500).json({ error });
  res.json(data);
});

// Get physical data within a bounding box
router.get('/physical', async (req, res) => {
  const { minLat, minLng, maxLat, maxLng } = req.query;
  
  const { data, error } = await supabase.rpc('get_physical_data_in_bounds', {
    min_lat: minLat,
    min_lng: minLng,
    max_lat: maxLat,
    max_lng: maxLng
  });
  
  if (error) return res.status(500).json({ error });
  res.json(data);
});

// Get hydraulic data within a bounding box
router.get('/hydraulic', async (req, res) => {
  const { minLat, minLng, maxLat, maxLng } = req.query;
  
  const { data, error } = await supabase.rpc('get_hydraulic_data_in_bounds', {
    min_lat: minLat,
    min_lng: minLng,
    max_lat: maxLat,
    max_lng: maxLng
  });
  
  if (error) return res.status(500).json({ error });
  res.json(data);
});

export { router };