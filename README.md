# RunItButton
A small button to quickly execute a smalltalk expression. Its goals are to be lean, non-intrusive and quick to use.
It is intended to ease the execution of one repetitive task.

The button is big enough to be easily clicked yet it takes relatively little screen space (compared to a full window). It can be placed anywhere by just dragging it.

To tell it what expression to evaluate:

```[ Transcript show: 'I am running!']``` (not very interesting)

or:

```[ Smalltalk snapshot: true andQuit: false ]``` (saves the image)

or:

```[ MyTestClass run: #aTestMethod ]``` (runs a test case)

Each time you click on the button, the expression is evaluated.
That's all.

You can have several expressions and choose the one to run from a menu.

StartIt with: ```RunButton run```.

Add new expression with: ```RunButton script: <block-without-argument]```.
