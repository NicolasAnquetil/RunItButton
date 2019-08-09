"
pc := ProgressCircle new color: Color blue.
pc extent: 500@500.
pc percentage: 0.3.
pc position: pc topRight.
pc openInWorld.

mes := MorphEventSubscription new
	recipient: CORAEventRecipient new;
	selector: #hello.

meh := MorphicEventHandler new 
	addSubscription: mes toEvent: #click.

pc eventHandler: meh.


"
Class {
	#name : #RunButton,
	#superclass : #CircleMorph,
	#instVars : [
		'scripts',
		'current'
	],
	#classInstVars : [
		'instance'
	],
	#category : #RunItButton
}

{ #category : #accessing }
RunButton class >> instance [
	^ instance
]

{ #category : #example }
RunButton class >> run [
	<example>
	instance ifNotNil: [ instance delete ].
	^ (instance := self new) openInWorld.
]

{ #category : #example }
RunButton class >> script: aBlock [
	instance ifNil: [ ^ nil ].
	instance script: aBlock
]

{ #category : #'morphic integration' }
RunButton >> balloonText [
	^ scripts 
		ifEmpty: [ self noScriptMessage ]
		ifNotEmpty: [ self script asString]
]

{ #category : #'morphic integration' }
RunButton >> click: anEvent [
	(self formerPosition = anEvent position)
		ifFalse: [ ^ self ].
	anEvent whichButton = 4 "left/primary button"
		ifTrue: [^ self runCurrentScript ].
    anEvent whichButton = 2 "right button"
		ifTrue: [ self scriptMenu ].

]

{ #category : #running }
RunButton >> doScript: anInteger [
	current := anInteger.
	self runCurrentScript
]

{ #category : #'morphic integration' }
RunButton >> handlesMouseDown: anEvent [ 
    ^ true
]

{ #category : #running }
RunButton >> inform: aString [
	UIManager default inform: aString
]

{ #category : #initialization }
RunButton >> initialize [
	super initialize. 
	self initializeScripts.
	self
		extent: 75 @ 75;
		color: Color green
]

{ #category : #initialization }
RunButton >> initializeScripts [
	current := 0.
	scripts := OrderedCollection new.
]

{ #category : #'morphic integration' }
RunButton >> mouseDown: anEvent [
	self formerPosition: anEvent position.
	anEvent hand
		waitForClicksOrDrag: self
		event: anEvent
]

{ #category : #'morphic integration' }
RunButton >> mouseMove: anEvent [
	anEvent hand grabMorph: self
]

{ #category : #accessing }
RunButton >> noScriptMessage [
			^ 'Set a script to run with:', String cr , '`' , self class name asString , ' script: [...]'''
]

{ #category : #running }
RunButton >> resetScripts [
	scripts := OrderedCollection new
]

{ #category : #running }
RunButton >> runCurrentScript [
	| result |
	[ result := self script value ]
	on: Exception
	do: [ :ex |
		^ self inform: ex description
	].
	 self inform: result asString
]

{ #category : #accessing }
RunButton >> script [
	^ scripts 
		ifEmpty: [ Warning signal: self noScriptMessage ]
		ifNotEmpty: [ scripts at: current]
]

{ #category : #accessing }
RunButton >> script: aBlock [
	scripts add: aBlock.
	current := current+1
]

{ #category : #'morphic integration' }
RunButton >> scriptMenu [
	| menu i |
	menu := MenuMorph new.
	menu defaultTarget: self.
	"menu add: 'Add script' selector: #getNewScript."
	menu add: 'Clear scripts' selector: #initializeScripts.
	menu add: 'Delete' selector: #delete.
	menu addLine.
	i := 1.
	scripts do: [ :sc |
		menu add: sc asString selector: #doScript: argument: i.
		i := i + 1
	].
	menu invokeModal.

]
