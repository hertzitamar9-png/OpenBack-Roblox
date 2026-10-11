import { test } from 'node:test';
import assert from 'node:assert/strict';
import { mkdtemp, mkdir, writeFile, readFile, rm, access } from 'node:fs/promises';
import { join, resolve } from 'node:path';
import { tmpdir } from 'node:os';
import { createHash } from 'node:crypto';
const mod = await import('../tools/build.mjs').catch(() => ({}));
const project = {
  name:'OpenBackRobloxFoundation', tree: {$className:'DataModel',
    ReplicatedStorage: {OpenBack:{$path:'src/shared'}},
    ServerScriptService: {OpenBack:{$path:'src/server'}},
    StarterPlayer: {StarterPlayerScripts:{OpenBack:{$path:'src/client'}}},
  },
};
async function fixture(t) {
  const root = await mkdtemp(join(tmpdir(),'ob-build-test-'));
  t.after(() => rm(root,{recursive:true,force:true}));
  for (const path of ['src/shared','src/server','src/client','assets']) await mkdir(join(root,path),{recursive:true});
  await writeFile(join(root,'default.project.json'),JSON.stringify(project));
  await writeFile(join(root,'src/shared/Example.luau'),'return 1');
  const entries = [];
  for (const path of ['default.project.json','src/shared/Example.luau']) entries.push({
    path,sha256:createHash('sha256').update(await readFile(join(root,path))).digest('hex'),
    creator:'frootz jhklphy',origin:'newly-authored',license:'owner-controlled',
    status:'approved-for-build',evidence:['Original fixture'],permittedUses:['roblox-bundle'],
  });
  await writeFile(join(root,'assets/approval.json'),JSON.stringify({schemaVersion:1,entries}));
  return root;
}
test('approved sources produce a real Roblox place with only mapped scripts', async t => {
  assert.equal(typeof mod.build,'function');
  const root = await fixture(t);
  const output = await mod.build({root,rojo:resolve('.tools/rojo',process.platform==='win32'?'rojo.exe':'rojo')});
  const xml = await readFile(output,'utf8');
  assert.match(xml,/<roblox /);
  assert.match(xml,/<Item class="ModuleScript"/);
  assert.match(xml,/return 1/);
  assert.doesNotMatch(xml,/VerificationOnly/);
});
test('unapproved source blocks export before any output is written', async t => {
  assert.equal(typeof mod.build,'function');
  const root = await fixture(t);
  await writeFile(join(root,'src/shared/Foreign.luau'),'return "unauthorized"');
  await assert.rejects(mod.build({root,rojo:'never-invoke-this-tool'}),/unapproved/);
  await assert.rejects(access(join(root,'.out/OpenBackFoundation.rbxlx')));
});
test('unapproved project routing cannot import external source trees', async t => {
  assert.equal(typeof mod.build,'function');
  const root = await fixture(t);
  const changed = structuredClone(project);
  changed.tree.ReplicatedStorage.OpenBack.$path = '../external';
  await writeFile(join(root,'default.project.json'),JSON.stringify(changed));
  await assert.rejects(mod.build({root,rojo:'never-invoke-this-tool'}),/project routing/);
  await assert.rejects(access(join(root,'.out/OpenBackFoundation.rbxlx')));
});
test('project instance injection fails even with an updated approval hash', async t => {
  assert.equal(typeof mod.build,'function');
  const root = await fixture(t);
  const changed = structuredClone(project);
  changed.tree.Workspace = {$className:'Workspace', Mesh:{$className:'MeshPart',$properties:{MeshId:'rbxassetid://1'}}};
  const text = JSON.stringify(changed);
  await writeFile(join(root,'default.project.json'),text);
  const approvals = JSON.parse(await readFile(join(root,'assets/approval.json'),'utf8'));
  approvals.entries[0].sha256 = createHash('sha256').update(text).digest('hex');
  await writeFile(join(root,'assets/approval.json'),JSON.stringify(approvals));
  await assert.rejects(mod.build({root,rojo:'never-invoke-this-tool'}),/project routing/);
});
