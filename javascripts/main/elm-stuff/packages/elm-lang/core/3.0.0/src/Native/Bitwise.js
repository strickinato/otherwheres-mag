Elm.Native.Bitwise={},Elm.Native.Bitwise.make=function(t){function i(t,i){return t&i}function e(t,i){return t|i}function n(t,i){return t^i}function r(t){return~t}function u(t,i){return t<<i}function a(t,i){return t>>i}function s(t,i){return t>>>i}return t.Native=t.Native||{},t.Native.Bitwise=t.Native.Bitwise||{},t.Native.Bitwise.values?t.Native.Bitwise.values:t.Native.Bitwise.values={and:F2(i),or:F2(e),xor:F2(n),complement:r,shiftLeft:F2(u),shiftRightArithmatic:F2(a),shiftRightLogical:F2(s)}};