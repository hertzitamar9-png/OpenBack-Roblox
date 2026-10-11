import { mkdir, readFile, realpath, lstat, rename, rm } from 'node:fs/promises';
import { join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { execFile } from 'node:child_process';
import { promisify, isDeepStrictEqual } from 'node:util';
import { randomUUID } from 'node:crypto';
import { collectSources, validateBundle } from './asset-gate.mjs';
const run = promisify(execFile);
const allowedProject = {
  name:'OpenBackRobloxFoundation', tree: {$className:'DataModel',
    ReplicatedStorage: {OpenBack:{$path:'src/shared'}},
    ServerScriptService: {OpenBack:{$path:'src/server'}},
    StarterPlayer: {StarterPlayerScripts:{OpenBack:{$path:'src/client'}}},
  },
};
export async function build({ root, rojo }) {
  root = await realpath(root);
  const project = JSON.parse(await readFile(join(root,'default.project.json'),'utf8'));
  if (!isDeepStrictEqual(project,allowedProject)) throw new Error('Unapproved project routing or instance properties');
  const manifest = JSON.parse(await readFile(join(root,'assets/approval.json'),'utf8'));
  const files = await collectSources(root);
  await validateBundle({root,manifest,files});
  const version = await run(rojo,['--version']);
  if (version.stdout.trim() !== 'Rojo 7.7.1') throw new Error('Expected pinned Rojo 7.7.1');
  const out = join(root,'.out');
  try { if ((await lstat(out)).isSymbolicLink()) throw new Error('symlink output directory rejected'); }
  catch (error) { if (error.code !== 'ENOENT') throw error; }
  await mkdir(out,{recursive:true});
  const temporary = join(out,`${randomUUID()}.rbxlx`);
  const destination = join(out,'OpenBackFoundation.rbxlx');
  try {
    await run(rojo,['build','default.project.json','--output',temporary],{cwd:root,windowsHide:true});
    await rename(temporary,destination);
    return destination;
  } finally { await rm(temporary,{force:true}); }
}
if (process.argv[1] && resolve(process.argv[1]) === fileURLToPath(import.meta.url)) {
  const root = fileURLToPath(new URL('../',import.meta.url));
  const rojo = join(root,'.tools','rojo',process.platform==='win32'?'rojo.exe':'rojo');
  try { console.log(await build({root,rojo})); }
  catch (error) { console.error(error.message); process.exitCode = 1; }
}
