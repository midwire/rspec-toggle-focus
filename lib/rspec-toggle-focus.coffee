RspecToggleFocusView = require './rspec-toggle-focus-view'
{CompositeDisposable} = require 'atom'

module.exports = RspecToggleFocus =
  rspecToggleFocusView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @rspecToggleFocusView = new RspecToggleFocusView(state.rspecToggleFocusViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @rspecToggleFocusView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'rspec-toggle-focus:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @rspecToggleFocusView.destroy()

  serialize: ->
    rspecToggleFocusViewState: @rspecToggleFocusView.serialize()

  toggle: ->
    console.log 'RspecToggleFocus was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
