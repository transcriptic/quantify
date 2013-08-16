## Quantify

Quantify is a utility library to help you deal with dimensioned quantities.

Quick, what's the multiplier to convert a value from nanomoles per milliliter
to micromoles per microliter? Not sure? I'll give you a minute.

&#8942;

&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &#8942;

&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &#8942;


```coffeescript
Quantity(1, 'nanomole').per(1, 'milliliter')
    .to(Quantity.Unit('micromole', 'microliter').toString()
# => 0.000001 micromole microliter^-1
```

## Usage

In general, a dimension (more strictly, a unit) is specified as such:

    {
      meter:  { power: a, exponent: x },
      second: { power: b, exponent: y },
      ...
    }

which represents the unit: (&times;10<sup>a</sup> meter)<sup>x</sup>
(&times;10<sup>b</sup> second)<sup>y</sup>. For example,
kiloliters/microsecond<sup>2</sup> would be represented as:

    { liter: { power: 1, exponent: 3 }, second: { power: -2, exponent: -6 } }
       

#### q = Quantity(value, unit)

Create a dimensioned value. `unit` can either be a unit structure as above, or
a shorthand string like 'milliliter'. Supported units are:

    liter gram meter mole second kelvin
    hertz newton pascal
    joule watt coulomb ampere volt ohm
    tesla henry candela lumen sievert

If you specify a string unit that isn't of the form `'{prefix}?{supported
unit}'`, Quantify will still accept the unit, and will assume that the exponent
is 0: i.e, that you did not include a prefix. Thus, the string "hipster" will
yield the expected result, but the string "kilohipster" will not be parsed as
`{ hipster: { power: 1, exponent: 3 } }`.

All Quantity values are immutable. Instance methods return a new Quantity.

#### q.to(unit)

Returns a new quantity with the same semantic value as `q`, but in units of
`unit`. `unit` can take string or structure form.

Throws an exception if `unit` doesn't match the dimensions of `q`. You can't
convert teslas to lumens. (For that matter, you also can't convert liters to
meters<sup>3</sup>.)

#### q.times(other_q)

Returns a new quantity which is the result of multiplying `q` by `other_q`.
Multiplies the value and the units, so <code>2 meter * 3 second == 6 meter
&middot; second</code>

If multiplying two values with the same dimensions but differing exponents, the
more positive exponent will be used. <code>1 milliliter * 1 liter == 0.001
liter^2</code>

#### q.per(other_q)
##### or: q.over(other_q), q.divide(other_q)

Returns the result of `q / other_q`. <code>18 meter / 2 second / 1 second == 9
meter second<sup>-2</sup></code>.

#### q.plus(other_q), q.minus(other_q)

Returns the result of `q ± other_q`. Throws an exception if the units don't
match. `1 meter + 1 second` doesn't make sense, yo. `1 liter + 1 milliliter` is
fine, though, and will return `1.001 liter`.

#### q.negate()

Returns `-q`.

#### q.reciprocal()

Returns `1/q`.

#### q.isSame(other_q)

Returns true if `q` is identical to `other_q`, in value, dimensions, and
exponents. `(1 milliliter).isSame(1000 microliter) is false`.

#### q.toString()

Returns a hopefully-sensible string representation of `q`.

## MIT licensed

Quantify is copyright (c) 2013 Transcriptic, Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
