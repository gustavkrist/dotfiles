inkdrop.onEditorLoad((editor) => {
  const { cm } = editor

  function showRelativeLines(cm) {
    const lineNum = cm.getCursor().line + 1;
    if (cm.state.curLineNum === lineNum) {
      return;
    }
    cm.state.curLineNum = lineNum;
    cm.setOption('lineNumberFormatter', l =>
      l === lineNum ? lineNum : Math.abs(lineNum - l));
    cm.setOption('cursorBlinkRate', 0);
  }
  cm.on('cursorActivity', showRelativeLines)
  // inkdrop.commands.add(document.body, {
  //   'user:vim-visual-cut': ()=> {
  //     const inputField = cm.getInputField();
  //     inkdrop.commands.dispatch(inputField, "vim:delete")
  //   }
  // })
})
