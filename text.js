#!/usr/bin/env phantomjs
var args = require('system').args;
if (args.length != 2) {
  console.log('usage: ./text.js <url>');
  phantom.exit(1);
}

var webPage = require('webpage');
var page = webPage.create();

page.open(args[1], function (status) {
  if (status !== 'success') {
    phantom.exit(1);
  }
  console.log('#!/usr/bin/env fontforge\nOpen($1);SelectAll();');
  var seen = new Uint8Array(1 << 20);
  for (var i = 0, s = page.plainText; i < s.length; ++i) {
    var c = s.charCodeAt(i);
    if (0xd800 <= c && c <= 0xdbff) {
      c = ((c - 0xd800) << 10) + (s.charCodeAt(++i) - 0xdc00);
    }
    if (!seen[c]) {
      seen[c] = 1;
    }
  }
  for (var i = 0, codes = []; i < seen.length; ++i) {
    if (seen[i]) {
      codes.push('0u' + i);
    }
  }
  var maxArgs = 24;
  for (var i = 0; i < codes.length; i += maxArgs) {
    console.log('SelectFewerSingletons(' + codes.slice(i, i + maxArgs) + ');');
  }
  console.log('DetachAndRemoveGlyphs();Save($2);');
  phantom.exit();
});
