# RunItButton
A small button to quickly execute a smalltalk expression.

Just tell it what expression to evaluate, for example:

```[ Transcript show: 'I am running!']```

or:

```[ Smalltalk snapshot: true andQuit: false ]```

and each time you click on it, it evaluates the expression.

You can have several expressions and choose the one to run from a menu.

StartIt with: ```RunButton run```.

Add new expression with: ```RunButton script: <block-without-argument]```.
