extends Node2D

@onready var chain1 := $Chain1
@onready var chain2 := $Chain2
@onready var ball := $Ball

# Define the properties of the pendulum
var pivot_position = self.position
var pivot_offset = Vector2(0, 50) # Adjust this offset as needed
var chain_length = 48 # Adjust this length as needed
var ball_speed = 2 # Adjust this speed as needed

func _ready():
	# Initialize the chain sprites and ball position
	chain1.position = pivot_position + pivot_offset
	chain2.position = pivot_position + pivot_offset
	ball.position = chain1.position + Vector2(chain_length, 0)

func _process(delta):
	# Calculate the new position of the ball using trigonometry
	var angle = (ball.position - pivot_position).angle()
	var new_angle = angle + ball_speed * delta
	ball.position = pivot_position + Vector2(cos(new_angle), sin(new_angle)) * chain_length

	# Update the chain sprites to visually connect the ball and base
	chain1.rotation = new_angle 
	chain1.position = pivot_position + Vector2(cos(new_angle), sin(new_angle)) * 32
	chain2.position = pivot_position + Vector2(cos(new_angle), sin(new_angle)) * 16
	chain2.rotation = (pivot_position - ball.position).angle()
