RspecToggleFocus = require '../lib/rspec-toggle-focus'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "RspecToggleFocus", ->
  [workspaceElement, activationPromise] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    activationPromise = atom.packages.activatePackage('rspec-toggle-focus')

  describe "when the rspec-toggle-focus:toggle event is triggered", ->
    it "toggles :focus", ->
      # Before the activation event the view is not on the DOM, and no panel
      # has been created
      expect(workspaceElement.querySelector('.rspec-toggle-focus')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.commands.dispatch workspaceElement, 'rspec-toggle-focus:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(workspaceElement.querySelector('.rspec-toggle-focus')).toExist()

        rspecToggleFocusElement = workspaceElement.querySelector('.rspec-toggle-focus')
        expect(rspecToggleFocusElement).toExist()

        rspecToggleFocusPanel = atom.workspace.panelForItem(rspecToggleFocusElement)
        expect(rspecToggleFocusPanel.isVisible()).toBe true
        atom.commands.dispatch workspaceElement, 'rspec-toggle-focus:toggle'
        expect(rspecToggleFocusPanel.isVisible()).toBe false
