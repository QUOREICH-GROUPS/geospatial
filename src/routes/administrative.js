import { Router } from 'express';
import { supabase } from '../index.js';

const router = Router();

// Get all regions
router.get('/regions', async (req, res) => {
  const { data, error } = await supabase
    .from('regions')
    .select('*');
  
  if (error) return res.status(500).json({ error });
  res.json(data);
});

// Get region by ID with provinces
router.get('/regions/:id', async (req, res) => {
  const { id } = req.params;
  const { data, error } = await supabase
    .from('regions')
    .select(`
      *,
      provinces (*)
    `)
    .eq('id', id)
    .single();
  
  if (error) return res.status(500).json({ error });
  res.json(data);
});

// Get all provinces in a region
router.get('/regions/:id/provinces', async (req, res) => {
  const { id } = req.params;
  const { data, error } = await supabase
    .from('provinces')
    .select('*')
    .eq('region_id', id);
  
  if (error) return res.status(500).json({ error });
  res.json(data);
});

// Similar endpoints for departments, communes, cities, and villages
export { router };