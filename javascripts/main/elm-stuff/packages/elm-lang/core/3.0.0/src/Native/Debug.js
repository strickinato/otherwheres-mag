Elm.Native.Debug={},Elm.Native.Debug.make=function(e){function t(e,t){var u=e+": "+i(t),a=a||{};return a.stdout?a.stdout.write(u):console.log(u),t}function u(e){throw new Error(e)}function a(t,u){return e.debug?e.debug.trace(t,u):u}function r(t,u){return e.debug&&e.debug.watch(t,u),u}function n(t,u,a){return e.debug&&e.debug.watch(t,u(a)),a}if(e.Native=e.Native||{},e.Native.Debug=e.Native.Debug||{},e.Native.Debug.values)return e.Native.Debug.values;var i=Elm.Native.Utils.make(e).toString;return e.Native.Debug.values={crash:u,tracePath:F2(a),log:F2(t),watch:F2(r),watchSummary:F3(n)}};