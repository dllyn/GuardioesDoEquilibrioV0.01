extends CharacterBody2D

const JUMP_SPEED : float = 200.0
const SPEED : float = 300.0
const JUMP_VELOCITY : float = -400.0
@onready var _animation_player = $AnimatedPlayer #Animação do Nino
@onready var isWall := $WallDetector as RayCast2D
var is_jumping : bool = true
var is_in_wall : bool = false

func _process(_delta: float) -> void: #Carregar sempre, usar função
	_set_animation() #Animações do player
	print(is_in_wall)
func _physics_process(delta: float) -> void: #Movimentação Base e virar player
# Add the gravity.

	if not is_on_floor():
		velocity += get_gravity() * delta
		is_jumping = false
		
			
# Mecanica jump.
	if Input.is_action_just_pressed("ui_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		is_jumping = true #Varificar se está pulando (para a Animação)
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction : float = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
#Mecanica Wall Jump

	#Se, a direção é para a parede, está colidindo na parede, NÃO está no chão e clicando no Shift:
	if direction >= 1 and isWall.is_colliding() and !is_on_floor() \
	and Input.is_action_pressed("ui_wall") : #
		#velocity = get_gravity() * delta #Para escorregar
		velocity.y = 0
		is_in_wall = true
		
		if Input.is_action_just_pressed("ui_jump"):
			velocity.y = JUMP_VELOCITY
			velocity.x = JUMP_SPEED
			isWall.scale.x = direction * -1 
			is_in_wall = false
			
	#Se não, a direção é para a parede, está colidindo na parede, NÃO está no chão e clicando no Shift:
	elif direction <= 1 and isWall.is_colliding() and !is_on_floor() \
	and Input.is_action_pressed("ui_wall") : #
		#velocity = get_gravity() * delta #Para escorregar
		velocity.y = 0
		is_in_wall = true
		
		if Input.is_action_just_pressed("ui_jump"):
			velocity.y = JUMP_VELOCITY
			velocity.x = -JUMP_SPEED
			isWall.scale.x = direction * -1
			is_in_wall = false
			
	if not isWall.is_colliding(): #Para controlar a variavel "is_in_wall"
		is_in_wall = false
	move_and_slide() #Detecta os movimentos básicos para o player
	
func _set_animation(): #Função da animação do Player e girar 
	var direction : float = Input.get_axis("ui_left", "ui_right") #Variavel da direção do player
	if direction:
			_animation_player.play("Run") #Para ativar animação corre
			_animation_player.flip_h = direction < 0 #Faz girar o player no eixo X
	if is_on_floor() and not Input.is_anything_pressed(): #Para a animação de "parado"
		_animation_player.play("Idle")
		is_jumping = false
#	se o player não tiver no chão e a outra animação acabar, então:	
	if not is_on_floor() and _animation_player.animation_finished: #Para a animação de cair
		_animation_player.play("Fall") #Movimento de cair
	if is_jumping == true:
		_animation_player.play("Jump")
		
#Wall Jump e Wall slide Player

	if direction != 0.0:
		isWall.scale.x = direction
	if isWall.is_colliding() and !is_on_floor() and Input.is_action_pressed("ui_wall"):
		_animation_player.play("WallSlide")
		
		
