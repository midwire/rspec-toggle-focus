{CompositeDisposable} = require 'atom'

module.exports = RspecToggleFocus =
  subscriptions: null

  activate: (state) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'rspec-toggle-focus:toggle': => @toggle()

  deactivate: ->
    @subscriptions.dispose()

  serialize: ->
    rspecToggleFocusViewState: @rspecToggleFocusView.serialize()

  toggle: ->
    if editor = atom.workspace.getActiveTextEditor()
      cursors = editor.getCursors()
      for cursor in cursors
        row = cursor.getBufferRow()
        line = editor.lineTextForBufferRow(row)
        focus_regex = /.*((?:it|describe|context)\s+(?:\"[^\"]+\"|\'[^\']+\'))(\,\s+focus\:\s*true)(.+do)/i

        # focus:true is found, remove it
        if focus_match = focus_regex.exec(line)
          line_without_focus = focus_match[1] + focus_match[3]
          editor.moveToFirstCharacterOfLine()
          editor.selectToEndOfLine()
          editor.insertText(line_without_focus)

        # focus:true is NOT found, add it
        else
          unfocus_regex = /.*((?:it|describe|context)\s+(?:\"[^\"]+\"|\'[^\']+\'))(.+do)/i

          if unfocus_match = unfocus_regex.exec(line)
            line_with_focus = unfocus_match[1] + ', focus: true' + unfocus_match[2]
            editor.moveToFirstCharacterOfLine()
            editor.selectToEndOfLine()
            editor.insertText(line_with_focus)
