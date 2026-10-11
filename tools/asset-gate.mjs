import { lstat, readFile, readdir, realpath } from 'node:fs/promises';
import { join, resolve, relative, sep } from 'node:path';
import { createHash } from 'node:crypto';

function safePath(path) {
  if (typeof path !== 'string' || !path || path.includes('\\') || path.includes(':') ||
      path.startsWith('/') || path.split('/').some(p => !p || p === '.' || p === '..')) {
    throw new Error(`Unsafe path: ${path}`);
  }
  return path;
}
const nonblank = value => typeof value === 'string' && value.trim().length > 0;

async function safeFile(root, path) {
  let cursor = root;
  for (const part of safePath(path).split('/')) {
    cursor = join(cursor, part);
    if ((await lstat(cursor)).isSymbolicLink()) throw new Error(`symlink rejected: ${path}`);
  }
  const actual = await realpath(cursor);
  const rel = relative(root, actual);
  if (rel.startsWith(`..${sep}`) || rel === '..' || resolve(root, rel) !== actual) {
    throw new Error(`Escaping path: ${path}`);
  }
  if (!(await lstat(actual)).isFile()) throw new Error(`Not a file: ${path}`);
  return actual;
}

/** Approval is an engineering gate, not a legal-clearance assertion. */
export async function validateBundle({ root, manifest, files }) {
  if (manifest?.schemaVersion !== 1 || !Array.isArray(manifest.entries) || !Array.isArray(files)) {
    throw new Error('Invalid approval manifest');
  }
  const base = await realpath(root);
  const approvals = new Map();
  for (const entry of manifest.entries) {
    const path = safePath(entry.path);
    const key = path.toLowerCase();
    if (approvals.has(key)) throw new Error(`duplicate approval: ${path}`);
    approvals.set(key, entry);
  }
  const seen = new Set();
  for (const path of files) {
    safePath(path);
    const key = path.toLowerCase();
    if (seen.has(key)) throw new Error(`duplicate input: ${path}`);
    seen.add(key);
    const entry = approvals.get(key);
    if (!entry || entry.path !== path) throw new Error(`unapproved file: ${path}`);
    if (entry.status !== 'approved-for-build') throw new Error(`Unapproved status: ${path}`);
    if (!nonblank(entry.creator)) throw new Error(`Missing creator: ${path}`);
    if (!Array.isArray(entry.evidence) || !entry.evidence.length || !entry.evidence.every(nonblank)) {
      throw new Error(`Missing evidence: ${path}`);
    }
    if (!Array.isArray(entry.permittedUses) || !entry.permittedUses.includes('roblox-bundle')) {
      throw new Error(`Missing permitted use: ${path}`);
    }
    // v1 deliberately has no bypass for a self-asserted third-party permission.
    if (!((entry.license === 'owner-controlled' && entry.origin === 'newly-authored') ||
          (entry.license === 'CC0-1.0' && entry.origin === 'source-reviewed'))) {
      throw new Error(`Unreviewed license or origin: ${path}`);
    }
    const bytes = await readFile(await safeFile(base, path));
    const hash = createHash('sha256').update(bytes).digest('hex');
    if (!/^[a-f0-9]{64}$/.test(entry.sha256) || hash !== entry.sha256) {
      throw new Error(`hash mismatch: ${path}`);
    }
  }
}

export async function collectSources(root) {
  const files = ['default.project.json'];
  async function walk(path) {
    const stat = await lstat(join(root, path));
    if (stat.isSymbolicLink()) throw new Error(`symlink rejected: ${path}`);
    if (stat.isDirectory()) {
      for (const name of (await readdir(join(root, path))).sort()) await walk(`${path}/${name}`);
    } else if (stat.isFile()) {
      if (!path.endsWith('.luau')) throw new Error(`Unexpected shipped file: ${path}`);
      files.push(path);
    } else throw new Error(`Unsupported source: ${path}`);
  }
  await walk('src');
  return files;
}

