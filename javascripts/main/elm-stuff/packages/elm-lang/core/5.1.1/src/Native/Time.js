var _elm_lang$core$Native_Time=function(){function e(e,n){return _elm_lang$core$Native_Scheduler.nativeBinding(function(r){var a=setInterval(function(){_elm_lang$core$Native_Scheduler.rawSpawn(n)},e);return function(){clearInterval(a)}})}var n=_elm_lang$core$Native_Scheduler.nativeBinding(function(e){e(_elm_lang$core$Native_Scheduler.succeed(Date.now()))});return{now:n,setInterval_:F2(e)}}();