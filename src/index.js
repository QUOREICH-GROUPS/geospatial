import express from 'express';
import cors from 'cors';
import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';
import { router as adminRouter } from './routes/administrative.js';
import { router as measurementRouter } from './routes/measurements.js';

dotenv.config();

const app = express();
const port = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

// Initialize Supabase client
export const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_ANON_KEY
);

// Routes
app.use('/api/administrative', adminRouter);
app.use('/api/measurements', measurementRouter);

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});