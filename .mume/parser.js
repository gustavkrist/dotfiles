module.exports = {
  onWillParseMarkdown: function(markdown) {
    return new Promise((resolve, reject) => {
      // function admonition(st) {
      //   pat = /^(?<tabs>\ *)\?\?\?(\+)?\ (\w+)\s(.*)\n((?:\k<tabs>\ {4}.*\n?)+)/gm
      //   st = st.replace(pat, function(whole, tabs, open, type, title, content) {
      //     content = content.replace(/^\s{4}/gm, "")
      //     rep = "<details class=\"admonition " + type + "\""
      //     if (open == "+") {
      //       rep += "open>"
      //     } else {
      //       rep += ">"
      //     }
      //     rep += "<summary class=\"admonition-title\">" + title + "</summary>\n\n"
      //     rep += content + "\n" + tabs + "</details>" + "\n\n"
      //     return rep
      //   })
      //   return st
      // }
      // newmarkdown = admonition(markdown)
      // while (newmarkdown != markdown) {
      //   markdown = newmarkdown
      //   newmarkdown = admonition(markdown)
      // }
      function format(markdown, callback) {
        var cp = require("child_process");
        if (process.platform == "darwin") {
          var conda = process.env.HOME + '/opt/anaconda3/bin/conda';
          var pyparser = process.env.HOME + '/.mume/pymdown.py'
        } else if (process.platform == "win32") {
          var conda = "C:\\ProgramData\\Anaconda3\\condabin\\conda.bat"
          var pyparser = process.env.userprofile + "\\.mume\\pymdown.py"
        }
        var child = cp.spawn(conda, ['run', '--no-capture-output', '-n', 'mkdocs', 'python', pyparser]);
        child.stdin.write(markdown);
        child.stdin.end();
        // return callback(markdown)
        // return callback(" ")
        var html = '';
        child.stdout.on('data', function(data) {
          html += data.toString();
          // require('fs').writeFile("Users/gustavkristensen/.local/share/mume/midput.html", html, function(err) { })
        });
        child.on('close', function(code) {
          return callback(html)
        })
      }
      format(markdown, function(result) { return resolve(result) })
    });
  },
  onDidParseMarkdown: function(html) {
    return new Promise((resolve, reject) => {
      // var fs = require("fs");
      // require("fs").writeFile("/Users/gustavkristensen/.local/share/mume/ondidparse.html", html, function(err) { })
      // path = process.env.HOME + "/.local/share/mume/output.html";
      // // html = fs.readFileSync(path).toString();
      function post_format(html, callback) {
        // return callback(html)
        var cp = require("child_process");
        if (process.platform == "darwin") {
          var python = "/usr/bin/python3"
          var postformat = process.env.HOME + '/.mume/postformat.py'
        } else if (process.platform == "win32") {
          var python = 'C:\\ProgramData\\Anaconda3\\python.exe'
          var postformat = process.env.userprofile + '\\.mume\\postformat.py'
        }
        var child = cp.spawn(python, [postformat]);
        child.stdin.write(html);
        child.stdin.end();
        // return callback(markdown)
        // return callback(" ")
        var html = '';
        child.stdout.on('data', function(data) {
          html += data.toString();
          // require('fs').writeFile("Users/gustavkristensen/.local/share/mume/midput.html", html, function(err) { })
        });
        child.on('close', function(code) {
          return callback(html)
        })
      }
      post_format(html, function(result) { return resolve(result) });
      // return resolve(html)
    });
  },
};
