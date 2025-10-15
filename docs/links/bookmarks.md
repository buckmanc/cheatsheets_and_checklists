# Bookmarks

## Dev

### Regex
- [Old Regex Basics](https://web.archive.org/web/20130814132447/http://www.regular-expressions.info/reference.html)
- [Regex Lookarounds](https://miro.medium.com/v2/1*PRRHGdN32Mep-3KhLwvKzw.png)
- [Regex Tester](https://regex101.com/)

### Character Encoding
- [ASCII Converter](https://www.branah.com/ascii-converter)
- [ANSI Escape Sequences](https://stackoverflow.com/a/33206814)
- [URL Decode / Encode](https://urlencoder.org)

### Man
- [rsync](https://linux.die.net/man/1/rsync)
- [grep](https://linux.die.net/man/1/grep)

### Misc
- [Vim Cheat Sheet](https://vim.rtorr.com/)
- [SQL Server Data Types](https://web.archive.org/web/20161128134813/http://www.dummies.com/programming/sql/data-types-found-in-sql-server-2008)
- [SQL Data Types](https://www.w3schools.com/sql/sql_datatypes.asp)
- [Markdown Cheatsheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)
- [Nerd Font Cheatsheet](https://www.nerdfonts.com/cheat-sheet)
- [Windows Environment Variables](https://ss64.com/nt/syntax-variables.html)
- [ShellCheck](https://shellcheck.net)
- [Crontab.Guru](https://crontab.guru)
- [No Hello](https://nohello.net)
- [Passwordless SSH](https://linuxize.com/post/how-to-setup-passwordless-ssh-login/)
- [jq Cheat Sheet](https://gist.github.com/olih/f7437fb6962fb3ee9fe95bda8d2c8fa4)
- [bash filename parsing / extraction](https://stackoverflow.com/a/965069/1995812)
- [bash test operators cheat sheet](https://kapeli.com/cheat_sheets/Bash_Test_Operators.docset/Contents/Resources/Documents/index)
- [sqlite3 cheat sheet](https://sqlitetutorial.net/sqlite-commands)
- [dotnet ef commands](https://learn.microsoft.com/en-us/ef/core/cli/dotnet#using-the-tools)
- [JSON2CSharp (and XML, etc)](https://json2cscharp.com)
- [HTTP Status Codes](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status)

## Other
- [NowPlayi.ng](https://nowplayi.ng/playing.php)
- [Pokemon Go Raid Finder](https://9db.jp/pokego/data/62)
- [Pokemon Go Countdowns](https://p337.info/pokemongo/)
- [Market Holidays](https://www.nyse.com/markets/hours-calendars)
- [bookmarks for browser import](../html/bookmarks_export.html)

## Emergency Music
- [Dungeon Synth Archives](https://www.youtube.com/playlist?list=UULFhmm356a5qe1luUsoatAgjA)
- [LoFi Study Girl](https://youtube.com/watch?v=jfKfPfyJRdk)
- [LoFi Air Traffic Control](https://www.lofiatc.com/)
- [OC Remix Radio](https://rainwave.cc/ocremix/)
- [Bytebeat](https://dollchan.net/bytebeat/)
- ~~[Voices of the Ainur](https://www.podchaser.com/podcasts/voices-of-the-ainur-1487083/episodes/recent)~~

## Bookmarklets

- copy sanitized url - `javascript:void(navigator.clipboard.writeText(location.href.substring(0,location.href.search("(ref=|\\?)"))));`
- email - `javascript:void(window.open("mailto:example@example.com?subject="+encodeURIComponent(document.title)+"&body="+document.location.href));`
- wb - view `javascript:void(window.open('https://web.archive.org/web/*/'+location.href.replace(/\/$/, '')));`
- wb - save `javascript:void(window.open('https://web.archive.org/save/'+location.href));`
- x - img (need to test) `javascript: (function () { var images = document.getElementsByTagName('img');var l = images.length; for (var i = 0; i < l; i++) { images[0].parentNode.removeChild(images[0];} }());`
- puzzle from img - `javascript:post('https://www.jigsawexplorer.com/jigsaw-puzzle-result/',{'image-url':document.location.href,color:'charcoal','puzzle-nop':136});function post(a,b){const c=(e,f)=>Object.assign(document.createElement(e),f),d=c('form',{action:a,method:'post',hidden:true});for(const[e,f]of Object.entries(b))d.appendChild(c('input',{name:e,value:f}));document.body.appendChild(d),d.submit()}`
