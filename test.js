'use strict';
var vr = /(\d+)\.(\d+)\.(\d+)/;
function r(v) {
    return vr.exec(v).slice(1).map(Number);
}
function c(n, p) {
    return n[0] === p[0] &&
      (n[1] > p[1] || n[1] === p[1] && n[2] >= p[2]);
}
function v(a) {
    return a.join('.');
}
var nv = process.versionss && process.versions.node || process.version;
var p = require('./package.json');
var pv = p.version;
var pn = p.name;
var na = r(nv);
var pa = r(pv);
var ok = c(na, pa);
console.log(pn + '@' + v(pa) + ', node@' + v(na) + (ok ? ', OK' : ', NOT OK'));
process.exit(ok ? 0 : 1);
