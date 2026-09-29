#!/usr/bin/env node
/**
 * Exports the Fire TV app's UI string table (src/i18n/strings.ts) and the
 * ALLERGEN_NAMES map to JSON resources bundled by the iOS app.
 *
 * Usage (from this repo root):
 *   TV_REPO=../fifirecipes-amazonfire node scripts/export-strings.cjs
 *
 * The TV repo's own copy of jiti does the TypeScript evaluation, so this
 * script stays dependency-free in this repo.
 */
const fs = require('fs');
const path = require('path');

const repoRoot = path.resolve(__dirname, '..');
const tvRepo = path.resolve(process.env.TV_REPO || '../fifirecipes-amazonfire');
const jiti = require(path.join(tvRepo, 'node_modules/jiti/lib/jiti.cjs'))(__filename);

const stringsPath = path.join(tvRepo, 'src/i18n/strings.ts');
const mod = jiti(stringsPath);
const { STRINGS, EN } = mod;

if (!STRINGS || !EN) throw new Error('STRINGS/EN exports not found in strings.ts');
if (Object.keys(STRINGS).length !== 24) {
  throw new Error(`expected 24 languages, got ${Object.keys(STRINGS).length}`);
}

// ALLERGEN_NAMES is module-private; strings.ts exposes allergenName().
// Rebuild the per-language map through the public function so the JSON
// carries the same fallback-resolved values.
const fsSrc = fs.readFileSync(stringsPath, 'utf8');
const am = fsSrc.match(/const ALLERGEN_NAMES[^=]*=\s*(\{[\s\S]*?\n\});/);
if (!am) throw new Error('ALLERGEN_NAMES literal not found');
const ALLERGEN_NAMES = new Function(`return (${am[1]})`)();

const outDir = path.join(repoRoot, 'FifiRecipes', 'Resources');
fs.mkdirSync(outDir, { recursive: true });
fs.writeFileSync(
  path.join(outDir, 'ui-strings.json'),
  JSON.stringify({ strings: STRINGS, allergens: ALLERGEN_NAMES }, null, 0) + '\n',
);
console.log(`wrote ui-strings.json: ${Object.keys(STRINGS).length} languages, ` +
  `${Object.keys(ALLERGEN_NAMES).length} allergen tables`);
