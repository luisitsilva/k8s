// join-api.js

import express from 'express';
import fs from 'fs';
import dotenv from 'dotenv';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3010;

const joinCommand = fs.readFileSync('./kubeadm-join.txt', 'utf8').trim();

app.get('/join', (req, res) => {
  res.json({ join: joinCommand });
});

app.listen(PORT, () => {
  console.log(`🚀 Kube Join API listening at http://localhost:${PORT}`);
});


