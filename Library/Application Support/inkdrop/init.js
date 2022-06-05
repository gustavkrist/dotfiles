inkdrop.onEditorLoad((editor) => {
  const app = require('@electron/remote').app
  const modulePath = app.getAppPath() + '/node_modules/'
  require(modulePath + "codemirror/addon/display/rulers")
  const { cm } = editor

  function showRelativeLines(cm) {
    const lineNum = cm.getCursor().line + 1;
    if (cm.state.curLineNum === lineNum) {
      return;
    }
    cm.state.curLineNum = lineNum;
    cm.setOption('lineNumberFormatter', l =>
      l === lineNum ? lineNum : Math.abs(lineNum - l));
  }
  cm.on('cursorActivity', showRelativeLines)
  cm.setOption('cursorBlinkRate', 0);
  cm.setOption('cursorScrollMargin', 170);
  cm.setOption('rulers', [{color: "#3B4252", column: 80, lineStyle: "solid"}])
  inkdrop.commands.add(document.body, {
    'user:vim-visual-cut': ()=> {
      const inputField = cm.getInputField();
      inkdrop.commands.dispatch(inputField, "vim:delete")
    }
  })
})
