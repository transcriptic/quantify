assert = require 'assert'
Quantity = require './quantify'

q = Quantity 3, 'milliliter'
assert.equal q.to('microliter').toString(), '3000 microliter'
assert.equal q.times(new Quantity 1, 'liter').toString(), '0.003 liter^2'

nm1 = Quantity(2, 'nanomole')
nm2 = nm1.per(Quantity 2, 'microliter')
nm3 = nm1.per(2, 'microliter')
assert.equal nm2.toString(), nm3.toString()

nmol_per_ul = Quantity(2, 'nanomole').per(Quantity 2, 'microliter')
nmol_per_ul1 = Quantity(2, 'nanomole').per(2, 'microliter')
assert.equal nmol_per_ul.toString(), nmol_per_ul1.toString()

umol_per_nl = Quantity(1, 'micromole').per(Quantity 1, 'nanoliter')
umol_per_nl1 = Quantity(1, 'micromole').per(1, 'nanoliter')
assert.equal umol_per_nl.toString(), umol_per_nl1.toString()

assert.equal nmol_per_ul.to(umol_per_nl.units).toString(), '0.000001 micromole nanoliter^-1'

assert.equal Quantity(1, 'liter').plus(Quantity(4, 'milliliter')).toString(), '1.004 liter'
assert.equal Quantity(1, 'liter').plus(4, 'milliliter').toString(), '1.004 liter'
assert.equal Quantity(4, 'milliliter').reciprocal().toString(), '0.25 milliliter^-1'
assert.equal Quantity(1, Quantity.Unit [], 'milliliter').to(Quantity.Unit [], 'microliter').toString(), '0.001 microliter^-1'
assert.equal Quantity(1, 'liter').per(Quantity(4, 'milliliter')).toString(), '250'
assert.equal Quantity(1, 'liter').per(4, 'milliliter').toString(), '250'
assert.equal Quantity(0.25, Quantity.Unit [], 'milliliter').times(Quantity(1, 'liter')), '250'
assert.equal Quantity(0.25, Quantity.Unit [], 'milliliter').times(1, 'liter'), '250'
assert.equal Quantity(1, Quantity.Unit [], 'liter').times(Quantity(1, 'milliliter')), '0.001'
assert.equal Quantity(1, Quantity.Unit [], 'liter').times(1, 'milliliter'), '0.001'

assert.equal(
  Quantity(1, 'nanomole').per(1, 'milliliter').to(Quantity.Unit('micromole', 'microliter')).toString(),
  '0.000001 micromole microliter^-1'
)

micromolesPerMicroliter = Quantity.Unit('micromole', 'microliter')
assert.equal(
  Quantity(1, 'nanomole').per(1, 'milliliter').to(micromolesPerMicroliter).toString(),
  '0.000001 micromole microliter^-1'
)

console.log Quantity(1, Quantity.Unit 'nanomole', 'milliliter').to(Quantity.Unit 'micromole', 'microliter')