import { test } from 'node:test';
import assert from 'node:assert/strict';
import { spawnSync } from 'node:child_process';
import { readdirSync } from 'node:fs';
import { join } from 'node:path';
const suffix = process.platform === 'win32' ? '.exe' : '';
const interpreter = join('.tools','luau',`luau${suffix}`);
const compiler = join('.tools','luau',`luau-compile${suffix}`);
for (const file of ['tests/geometry.spec.luau','tests/camera.spec.luau']) {
  test(`real Luau executes ${file}`, () => {
    const result = spawnSync(interpreter,[file],{encoding:'utf8'});
    assert.ifError(result.error);
    assert.equal(result.status,0,result.stdout+result.stderr);
    assert.match(result.stdout,/PASS/);
  });
}
test('all shipped and verification Luau modules compile', () => {
  function files(dir) {
    return readdirSync(dir,{withFileTypes:true}).flatMap(entry => {
      const path = join(dir,entry.name);
      return entry.isDirectory() ? files(path) : path.endsWith('.luau') ? [path] : [];
    });
  }
  const result = spawnSync(compiler,['--null',...files('src'),...files('tests')],{encoding:'utf8'});
  assert.ifError(result.error);
  assert.equal(result.status,0,result.stdout+result.stderr);
});
