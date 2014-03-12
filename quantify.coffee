class Quantity
  conversions = {}
  prefixes =
    yocto: -24
    zepto: -21
    atto:  -18
    femto: -15
    pico:  -12
    nano:   -9
    micro:  -6
    milli:  -3
    centi:  -2
    deci:   -1
    '':      0
    deca:    1
    hecto:   2
    kilo:    3
    mega:    6
    giga:    9
    tera:   12
    peta:   15
    exa:    18
    zetta:  21
    yotta:  24
  exponents = {}; exponents[v] = k for k,v of prefixes
  units = '''
    liter gram meter mole second kelvin
    hertz newton pascal
    joule watt coulomb ampere volt ohm
    tesla henry candela lumen sievert
  '''.split(/\s+/).filter((x) -> x.length)
  for unit in units
    for prefix, exponent of prefixes
      conversions[prefix+unit] = { unit, exponent, power: 1 }

  deepcopy = (obj) -> JSON.parse JSON.stringify obj

  parse_unit = (u = 'unit') -> conversions[u] ? { unit: u, exponent: 0, power: 1 }

  show_unit = ({ unit, exponent }) ->
    exponents[exponent] + unit

  show_units = (units) ->
    ss = for unit, {power, exponent} of units when power isnt 0
      s = "#{show_unit {unit, exponent}}"
      s += "^#{power}" unless power is 1
      s
    if ss.length then ss.join ' '

  constructor: (@value, unit = 'unit') ->
    return new Quantity arguments... unless @ instanceof Quantity
    @units = {}
    if typeof unit is 'string'
      u = parse_unit unit
      @units[u.unit] = power: u.power, exponent: u.exponent
    else
      @units = unit

  to: (other_unit) ->
    units = {}
    if typeof other_unit is 'string'
      { unit, exponent, power } = parse_unit other_unit
      units[unit] = { exponent, power }
    else
      units = other_unit
    diff = 1
    for unit, {power, exponent} of @units
      throw Error('bad conversion') unless units[unit]
      { power: other_power, exponent: other_exponent } = units[unit]
      throw Error('bad conversion') unless units[unit].power is power
      diff *= Math.pow 10, (exponent - other_exponent) * power
    new Quantity @value*diff, units

  times: (other_q) ->
    units = deepcopy @units
    val = @value
    other_val = other_q.value
    for unit, {power, exponent} of other_q.units
      if units[unit]?
        if units[unit].exponent < exponent
          val *= Math.pow 10, (units[unit].exponent - exponent) * units[unit].power
        else if units[unit].exponent > exponent
          other_val *= Math.pow 10, (exponent - units[unit].exponent) * power
      x = (units[unit] ?= { power: 0, exponent: -Infinity })
      x.power += power
      x.exponent = Math.max exponent, x.exponent
      delete units[unit] if x.power is 0

    new Quantity val * other_val, units

  per: (other_q) ->
    @times other_q.reciprocal()
  @::divide = @::over = @::per

  plus: (other_q) ->
    units = deepcopy @units
    val = @value
    other_val = other_q.value
    for unit, {power, exponent} of other_q.units
      throw Error('bad conversion') unless units[unit] and units[unit].power is power
      if units[unit].exponent < exponent
        val *= Math.pow 10, units[unit].exponent - exponent
      else if units[unit].exponent > exponent
        other_val *= Math.pow 10, exponent - units[unit].exponent
      units[unit].exponent = Math.max units[unit].exponent, exponent
    new Quantity val + other_val, units

  minus: (other_q) ->
    @plus other_q.negate()

  reciprocal: ->
    units = deepcopy @units
    for _, v of units
      v.power = -v.power
    new Quantity 1/@value, units

  negate: ->
    units = deepcopy @units
    new Quantity -@value, units

  isSame: (other_q) ->
    other_q.value == @value and @unitsAre other_q.units

  unitsAre: (other_units) ->
    for unit, { power, exponent } of other_units
      return false unless (u = @units[unit]) and u.power is power and u.exponent is exponent
    true

  @Unit: (num, den) ->
    units = {}
    for u in (if Array.isArray num then num else [num])
      {unit, power, exponent} = parse_unit u
      units[unit] = { power, exponent }
    for u in (if Array.isArray den then den else [den])
      {unit, power, exponent} = parse_unit u
      units[unit] = { power: -power, exponent }
    units

  toString: ->
    [@value, show_units @units].filter((x) -> x?).join ' '

  toJSON: ->
    { value: @value, unit: @units }

if typeof window is 'undefined'
  module.exports = Quantity
else
  window.Quantity = Quantity
