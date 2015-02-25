# everything old is new again!

cutting edge web technologies:
why the 1960s still matter

---
# systems "theory" according to Systemantics

1. A simple system, designed from scratch, sometimes works.

---
# systems "theory" according to Systemantics

2. Some complex systems actually work.

---
# systems "theory" according to Systemantics

3. A complex system that works is invariably found to have
evolved from a simple system that works.

---
# systems "theory" according to Systemantics

4. A complex system designed from scratch never works and cannot
be patched up to make it work. You have to start over, beginning
with a working simple system.

---
# unix

a simple system, designed from scratch at Bell Labs in the 1960s
that worked

---
# why unix survived

"worse is better", ranking of priorities according to its critics:

1. simplicity
2. correctness
3. consistency
4. completeness can be sacrificed in favor of any other quality

---
# why the web survived

"worse is better" applied to the web:

1. simplicity - `<script>alert('hello')</script>`
2. correctness - untyped, `eval()`, very forgiving markup
3. consistency - `<input />` vs `<b>wow</b>` (and so much more)
4. completeness - first version of html didn't even have `<img>`

---
# evolution

Never, ever, break backwards compatability.

Never rewrite a complex system from scratch.

http://c2.com/cgi/wiki?SecondSystemEffect

---
# unix philosophy

```
This is the Unix philosophy: Write programs that do one thing and
do it well. Write programs to work together. Write programs to
handle text streams, because that is a universal interface.

    -- Douglas McIlroy
```

---
# unix philosophy

```
"We should have some ways of connecting programs like garden
hose--screw in another segment when it becomes necessary to
massage data in another way. This is the way of IO also."

    -- Douglas McIlroy
```

---
# demo: the unix shell

---
# why streams

* chunk by chunk - save memory
* immediate results - act before the entire file arrives
* hook together simple interchangeable processing units

---
# node.js streams

streams are a handy interface available in node.js

---
# some built-in streams

* process.stdin - read from the keyboard
* process.stdout - write to the terminal

---
# echo input to output

``` js
process.stdin.pipe(process.stdout)
```

---
# print a file to stdout

``` js
var fs = require('fs');


fs.createReadStream('wow.txt')
    .pipe(process.stdout)
;
```

---
# print a gzipped file to stdout

``` js
var fs = require('fs');
var zlib = require('zlib');

fs.createReadStream('wow.txt')
    .pipe(zlib.createGzip())
    .pipe(process.stdout)
;
```

---
# chaining

just like the shell

---
# gzip a file and save the output to another file

``` js
var fs = require('fs');
var zlib = require('zlib');

fs.createReadStream('wow.txt')
    .pipe(zlib.createGzip())
    .pipe(fs.createWriteStream('wow.gz'))
;
```

---
# kinds of streams

* readable - produces data
* writable - consumes data
* transform - consumes data to produce data
* duplex - consumes data separately from producing data

---
# kinds of streams

* readable - `readable.pipe(A)`
* writable - `A.pipe(writable)`
* transform - `A.pipe(transform).pipe(B)`
* duplex - `A.pipe(duplex).pipe(A)`

---
# readable stream methods

* `a.pipe(b)` - pipe `a` into `b`, returning `b`
* `.read()` - read some data (but you probably want `.pipe()` instead)

---
# writable stream methods

* `.write(buf)` - write some data
* `.end()` - close the stream
* `.end(buf)` - write some data and close the stream

---
# transform and duplex streams

readable methods and writable methods

---
# through2

Create transform streams with the `through2 module:

``` js
var through = require('through2')
var tr = through(write, end);
process.stdin.pipe(tr).pipe(process.stdout);

// ...
```

---
# through2

``` js
var through = require('through2')
var tr = through(write, end);
process.stdin.pipe(tr).pipe(process.stdout);

function write (buf, enc, next) {
    var str = buf.toString('utf8');
    this.push(str.toUpperCase());
}
function end () {
    this.push('!!!');
    this.push(null);
}
```

---
# concat-stream

writable stream to buffer up input and call a callback when the
stream ends

``` js
var concat = require('concat-stream');
process.stdin.pipe(concat(function (body) {
    console.log(body.length);
}));
```

---
# split

line-buffering

``` js
var split = require('split');
var sp = split();
sp.pipe(through(function (buf, enc, next) {
    console.log('line=', + buf);
}));
sp.end('abc\ndef\nghi\n');
```

---
# http

`req` is a readable stream
`res` is a writable stream

``` js
var http = require('http');
var server = http.createServer(function (req, res) {
    res.end('hello!');
}));
server.listen(5000);
```

---
# demo: web servers

---
# demo: http form post

---
# duplex streams

You can write to and read from a duplex stream, but the input
doesn't directly drive the output.

Telltale sign of a duplex stream:

``` js
a.pipe(b).pipe(a)
```

---
# demo: tcp server

---
# object streams

streams normally only deal with strings and buffers

However, with `{ objectMode: true }` or `through.obj()`, you can
use arbitrary objects.

---
# demo: parsing really big files

given an `alameda.json.gz` geojson file,
we can use streams to parse the entire file without
tempfiles and without loading the whole thing into memory

---

``` js
var zlib = require('zlib');
var parse = require('JSONStream').parse;
var stdout = require('stdout')();

process.stdin
    .pipe(zlib.createGunzip())
    .pipe(parse(['features',true,'geometry','coordinates']))
    .pipe(stdout)
;
```

---
# web application tooling

stdin, stdout!

---
# demo: npm scripts

---
# case: dnode

https://github.com/dominictarr/rpc-stream#rant

```
REMOTE_SSH_STREAM
    .pipe(DECRYPT_STREAM)
    .pipe(GUNZIP_STREAM)
    .pipe(RPC)
    .pipe(GZIP_STREAM)
    .pipe(ENCYPT_STREAM)
    .pipe(REMOTE_SSH_STREAM)
```

---
# case: browserify

started out life as an express middleware(!)

now fully command-line stdin/stdout driven

---
# wide audience

The more general the interfaces,
the more people can use your software.

---
# writing software for ecosystems

Prefer atomic abstractions that perform very specialized tasks.

Instead of making a "utility library for dates", release
individual abstractions for:

* date formatting (like strftime),
* converting a human-readable string into a date object
* parsing human-readable durations (parse-duration)

---
# if your project scope is too broad

* it's not obvious what belongs
* everything is versioned in one big lump
* neglect and bitrot

---
# demo: webgl

---
# demo: web audio

---

THE END

