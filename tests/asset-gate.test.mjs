import { test } from 'node:test';
import assert from 'node:assert/strict';
import { mkdtemp, mkdir, writeFile, rm, symlink } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { createHash } from 'node:crypto';

const mod = await import('../tools/asset-gate.mjs').catch(() => ({}));
const digest = value => createHash('sha256').update(value).digest('hex');
async function fixture(t) {
  const root = await mkdtemp(join(tmpdir(), 'ob-asset-test-'));
  t.after(() => rm(root, { recursive: true, force: true }));
  await mkdir(join(root, 'src'));
  await writeFile(join(root, 'src/unit.luau'), 'return {}');
  return { root, files: ['src/unit.luau'], manifest: { schemaVersion: 1, entries: [{
    path: 'src/unit.luau', sha256: digest('return {}'), creator: 'frootz jhklphy',
    origin: 'newly-authored', license: 'owner-controlled', status: 'approved-for-build',
    evidence: ['Original source authored in this project under owner-approved plan.'],
    permittedUses: ['roblox-bundle'],
  }] } };
}

test('validator exists: prevents silently skipping approval enforcement', () => {
  assert.equal(typeof mod.validateBundle, 'function');
});
test('approved original content with a matching hash passes', async t => {
  assert.equal(typeof mod.validateBundle, 'function');
  await mod.validateBundle(await fixture(t));
});
for (const [name, mutate, reason] of [
  ['unknown file', f => f.files.push('src/foreign.glb'), /unapproved/],
  ['changed hash', f => f.manifest.entries[0].sha256 = '0'.repeat(64), /hash/],
  ['missing evidence', f => f.manifest.entries[0].evidence = [], /evidence/],
  ['unapproved status', f => f.manifest.entries[0].status = 'pending', /status/],
  ['missing permission', f => f.manifest.entries[0].permittedUses = [], /permitted/],
  ['duplicate approval', f => f.manifest.entries.push({...f.manifest.entries[0]}), /duplicate/],
  ['duplicate input', f => f.files.push('src/unit.luau'), /duplicate/],
  ['absolute input', f => f.files[0] = '/src/unit.luau', /path/],
  ['traversal input', f => f.files[0] = '../unit.luau', /path/],
  ['alternate Windows stream', f => f.files[0] = 'src/unit.luau:evil', /path/],
  ['Windows separators', f => f.files[0] = 'src\\unit.luau', /path/],
  ['blank author', f => f.manifest.entries[0].creator = '', /creator/],
]) {
  test(`rejects ${name}`, async t => {
    assert.equal(typeof mod.validateBundle, 'function');
    const f = await fixture(t); mutate(f);
    await assert.rejects(mod.validateBundle(f), reason);
  });
}
for (const license of ['CC-BY-3.0', 'CC-BY-SA-4.0', 'AGPL-3.0', 'unknown']) {
  test(`rejects unreviewed ${license} despite an approval label`, async t => {
    assert.equal(typeof mod.validateBundle, 'function');
    const f = await fixture(t); f.manifest.entries[0].license = license;
    await assert.rejects(mod.validateBundle(f), /license/);
  });
}
test('rejects symlink files instead of reading their targets', async t => {
  assert.equal(typeof mod.validateBundle, 'function');
  const f = await fixture(t);
  try { await symlink(join(f.root, 'src/unit.luau'), join(f.root, 'src/link.luau')); }
  catch (error) {
    if (process.platform === 'win32' && error.code === 'EPERM') {
      t.skip('Windows host denies file-symlink creation; directory-junction rejection still runs.');
      return;
    }
    throw error;
  }
  f.files[0] = 'src/link.luau'; f.manifest.entries[0].path = 'src/link.luau';
  await assert.rejects(mod.validateBundle(f), /symlink/);
});
test('rejects symlink directory ancestors', async t => {
  assert.equal(typeof mod.validateBundle, 'function');
  const f = await fixture(t);
  await symlink(join(f.root, 'src'), join(f.root, 'alias'), 'junction');
  f.files[0] = 'alias/unit.luau'; f.manifest.entries[0].path = 'alias/unit.luau';
  await assert.rejects(mod.validateBundle(f), /symlink/);
});
test('collector includes every source, so omitted approvals fail validation', async t => {
  assert.equal(typeof mod.collectSources, 'function');
  const f = await fixture(t);
  await writeFile(join(f.root, 'src/foreign.luau'), 'return "foreign"');
  await writeFile(join(f.root, 'default.project.json'), '{}');
  assert.deepEqual(await mod.collectSources(f.root), ['default.project.json', 'src/foreign.luau', 'src/unit.luau']);
  await assert.rejects(mod.validateBundle({...f, files: await mod.collectSources(f.root)}), /unapproved/);
});
test('collector rejects unrecognized shipped assets rather than ignoring them', async t => {
  assert.equal(typeof mod.collectSources, 'function');
  const f = await fixture(t);
  await writeFile(join(f.root, 'src/foreign.glb'), 'foreign');
  await assert.rejects(mod.collectSources(f.root), /Unexpected/);
});
test('collector refuses linked source directories', async t => {
  assert.equal(typeof mod.collectSources, 'function');
  const f = await fixture(t);
  await symlink(join(f.root, 'src'), join(f.root, 'src/linked'), 'junction');
  await assert.rejects(mod.collectSources(f.root), /symlink/);
});
