#!/usr/bin/env node
'use strict';

const { spawn, spawnSync } = require('node:child_process');
const { mkdirSync } = require('node:fs');

const serverBin = '/usr/local/lib/node_modules/happy-server-self-host/bin/happy-server.cjs';

const dataDir = process.env.DATA_DIR || '/data';
const pgliteDir = process.env.PGLITE_DIR || `${dataDir}/pglite`;

process.env.DATA_DIR = dataDir;
process.env.PGLITE_DIR = pgliteDir;
process.env.DB_PROVIDER = process.env.DB_PROVIDER || 'pglite';
process.env.HOST = process.env.HOST || '0.0.0.0';
process.env.PORT = process.env.PORT || '3005';

const args = process.argv.slice(2);
if (args.length === 0) {
  args.push('serve');
}

if (args[0] === 'happy-server') {
  args.shift();
}

if (args.length === 0) {
  args.push('serve');
}

function runHappyServer(commandArgs) {
  const result = spawnSync(process.execPath, [serverBin, ...commandArgs], {
    env: process.env,
    stdio: 'inherit',
  });

  if (result.error) {
    console.error(result.error.message);
    process.exit(1);
  }

  if (result.signal) {
    process.kill(process.pid, result.signal);
  }

  if (result.status !== 0) {
    process.exit(result.status ?? 1);
  }
}

if (args[0] !== 'serve') {
  runHappyServer(args);
  process.exit(0);
}

mkdirSync(dataDir, { recursive: true });
mkdirSync(pgliteDir, { recursive: true });
runHappyServer(['migrate']);

const child = spawn(process.execPath, [serverBin, 'serve'], {
  env: process.env,
  stdio: 'inherit',
});

for (const signal of ['SIGINT', 'SIGTERM']) {
  process.on(signal, () => {
    if (!child.killed) {
      child.kill(signal);
    }
  });
}

child.on('error', (error) => {
  console.error(error.message);
  process.exit(1);
});

child.on('exit', (code, signal) => {
  if (signal) {
    process.kill(process.pid, signal);
  }
  process.exit(code ?? 0);
});
