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

{ #category : #accessing }
RunButton >> balloonText [
	^ scripts 
		ifEmpty: [ self noScriptMessage ]
		ifNotEmpty: [ self script asString]
]

{ #category : #drawing }
RunButton >> click: anEvent [
	(self formerPosition = anEvent position)
		ifFalse: [ ^ self ].
	anEvent whichButton = 4 "left/primary button"
		ifTrue: [^ self runCurrentScript ].
    anEvent whichButton = 2 "right button"
		ifTrue: [ self scriptMenu ].

]

{ #category : #initialization }
RunButton >> defaultScript [
		^ [ UIManager default inform: self noScriptMessage ]
]

{ #category : #drawing }
RunButton >> doScript: anInteger [
	current := anInteger.
	self runCurrentScript
]

{ #category : #drawing }
RunButton >> handlesMouseDown: anEvent [ 
    ^ true
]

{ #category : #initialization }
RunButton >> initialize [
	super initialize. 
	current := 0.
	scripts := OrderedCollection new.
	self
		extent: 75 @ 75;
		color: Color green
]

{ #category : #drawing }
RunButton >> mouseDown: anEvent [
	self formerPosition: anEvent position.
	anEvent hand
		waitForClicksOrDrag: self
		event: anEvent
]

{ #category : #drawing }
RunButton >> mouseMove: anEvent [
	anEvent hand grabMorph: self
]

{ #category : #accessing }
RunButton >> noScriptMessage [
			^ 'Set a script to run with:', String cr , '`' , self class name asString , ' script: [...]'''
]

{ #category : #drawing }
RunButton >> runCurrentScript [
	self script value
]

{ #category : #accessing }
RunButton >> script [
	^ scripts 
		ifEmpty: [ self defaultScript ]
		ifNotEmpty: [ scripts at: current]
]

{ #category : #accessing }
RunButton >> script: aBlock [
	scripts add: aBlock.
	current := current+1
]

{ #category : #drawing }
RunButton >> scriptMenu [
	| menu i |
	menu := MenuMorph new.
	menu defaultTarget: self.
	"menu add: 'Add script' selector: #getNewScript."
	menu add: 'Delete' selector: #delete.
	menu addLine.
	i := 1.
	scripts do: [ :sc |
		menu add: sc asString selector: #doScript: argument: i.
		i := i + 1
	].
	menu invokeModal.

]
