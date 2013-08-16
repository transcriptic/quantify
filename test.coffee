assert = require 'assert'
Quantity = require './quantify'

u = (v,u) -> new Quantity v, u
q = u 3, 'milliliter'
assert.equal q.to('microliter').toString(), '3000 microliter'
assert.equal q.times(new Quantity 1, 'liter').toString(), '0.003 liter^2'

nmol_per_ul = u(2, 'nanomole').per(u 2, 'microliter')
umol_per_nl = u(1, 'micromole').per(u 1, 'nanoliter')
assert.equal nmol_per_ul.to(umol_per_nl.units).toString(), '0.000001 micromole nanoliter^-1'

assert.equal u(1, 'liter').plus(u(4, 'milliliter')).toString(), '1.004 liter'
assert.equal u(4, 'milliliter').reciprocal().toString(), '0.25 milliliter^-1'
assert.equal u(1, Quantity.Unit [], 'milliliter').to(Quantity.Unit [], 'microliter').toString(), '0.001 microliter^-1'
assert.equal u(1, 'liter').per(u(4, 'milliliter')).toString(), '250'
assert.equal u(0.25, Quantity.Unit [], 'milliliter').times(u(1, 'liter')), '250'
assert.equal u(1, Quantity.Unit [], 'liter').times(u(1, 'milliliter')), '0.001'

console.log u(1, Quantity.Unit 'nanomole', 'milliliter').to(Quantity.Unit 'micromole', 'microliter')
