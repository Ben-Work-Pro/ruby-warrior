#Modification de l'algorithme permettant au guerrier de se soigner même si toutes les bombes n'ont pas été désamorcé si la situation est critique
#Amélioration de la fonction de retraite

class Player

  DIRECTIONS = [:forward, :right, :left, :backward]
  MAX_HEALTH = 20
  GOOD_HEALTH = 12
  
  #Fonction pour faire marcher le guerrier
  def walk()
    if is_room_finish() == false
      if @warrior.feel(@warrior.direction_of(@warrior.listen[0])).stairs?
        @warrior.walk!(find_empty_case())
      elsif @bomb == true
        @warrior.walk!(@warrior.direction_of(get_bomb_pos()))
      elsif @bomb == false
        @warrior.walk!(@warrior.direction_of(@warrior.listen[0]))
      end
    else
      @warrior.walk!(@stairs_direction)
    end
  end
  
  #Fonction pour faire reculer le guerrier
  def retreat()
    @warrior.walk!(find_empty_case())
  end
  
  #Fonction pour soigner le guerrier
  def heal()
    @warrior.rest!
  end
  
  #Fonction pour sauver un prisonnier
  def save(direction)
    @warrior.rescue!(direction)
  end
  
  #Fonction pour attaquer un ennemi avec l'épée
  def sword_attack(direction)
    @warrior.attack!(direction)
  end
  
  #Fonction pour attaquer un ennemi avec la bombe
  def bomb_attack(direction)
    @warrior.detonate!(direction)
  end
  
  #Fonction pour emprisonner un ennemi
  def capture(direction)
    @warrior.bind!(direction)
  end
  
  #Fonction permettant de compter un type d'objet (ex: ennemie, captif, ect...) autour du guerrier
  def count_object(object)
    _enemy_nb = 0
    for i in 0..3
      if @warrior.feel(DIRECTIONS[i]).send(object)
        _enemy_nb += 1
      end
    end
    return _enemy_nb
  end
  
  #Fonction permettant au guerrier de savoir dans quel direction se trouve un type d'objet (ex: ennemie, captif, ect...)
  def object_direction(object)
    for i in 0..3
      if (@bomb == true)
        if @warrior.feel(DIRECTIONS[i]).send(object) && DIRECTIONS[i] != @warrior.direction_of(get_bomb_pos)
          return DIRECTIONS[i]
        end
      elsif (@bomb == false)
        if @warrior.feel(DIRECTIONS[i]).send(object) && DIRECTIONS[i]
          return DIRECTIONS[i]
        end
      end
    end
  end
  
  #Fonction permettant de savoir si la vie du guerrier est basse
  def is_health_low()
    if @warrior.health >= GOOD_HEALTH
      return false
    elsif @warrior.health < GOOD_HEALTH
      return true
    end
  end
  
  #Fonction permettant de savoir si il reste des objectifs à accomplir dans la salle
  def is_room_finish()
    if (@warrior.listen).length == 0
      return true
    else
      return false
    end
  end

  #Fonction permettant de trouver une case vide autour du guerrier
  def find_empty_case()
    for i in 0..3
      if @warrior.feel(DIRECTIONS[i]).empty? && !@warrior.feel(DIRECTIONS[i]).stairs?
        return DIRECTIONS[i]
      end
    end
  end
  
  #Fonction permettant de savoir si une bombe est active dans la salle
  def is_bomb_ticking()
    _listen_for_bomb = @warrior.listen
    if (_listen_for_bomb.any?(&:ticking?))
      return true
    else
      return false
    end
  end
  
  #Fonction permettant de determiner la position de la bomb dans la salle
  def get_bomb_pos()
    _bomb_case = @warrior.listen
    _bomb_case = _bomb_case.select(&:ticking?).first
    return _bomb_case
  end
  
  #Fonction permettant de determiner si un ennemie est sur le chemin de la bombe
  def enemy_in_the_way()
    if @warrior.feel(@warrior.direction_of(get_bomb_pos)).enemy?
      return true
    else
      return false
    end
  end
  
  #Fonction decidant de la meilleure arme à utiliser face à un ennemi
  def choose_attack_type()
    _look = @warrior.look
    if (_look.count(&:enemy?) == 1)
      sword_attack(@warrior.direction_of(get_bomb_pos()))
    else
      bomb_attack(@warrior.direction_of(get_bomb_pos()))
    end
  end
  
  #Fonction décidant de la stratégie lorsque le guerrier fait face à au moins un ennemie
  def choose_strategy_enemy()
    if (@bomb == true)
      if enemy_in_the_way()
        if (@enemy_nb == 1)
          choose_attack_type()
        else
          capture(object_direction(:enemy?))
        end
      else
        walk()
      end
    else
      if (@enemy_nb == 1)
        if (@low_health == true && @warrior.health <= 3)
          retreat()
        else
          sword_attack(object_direction(:enemy?))
        end
      elsif (@enemy_nb >= 2)
        capture(object_direction(:enemy?))
      end
    end
  end
    
  #Fonction décidant de la stratégie lorsque le guerrier est seul
  def choose_strategy_alone()
    if (@bomb == true)
      if (@low_health == true)
        heal()
      elsif (@capture_nb > 0 && @warrior.feel(@warrior.direction_of(get_bomb_pos)).captive?)
        save(@warrior.direction_of(get_bomb_pos))
      else
        walk()
      end
    else
      if (@low_health == true)
        heal()
      elsif (@capture_nb > 0)
        if (@warrior.feel(@warrior.direction_of(@warrior.listen[0])).captive? && @warrior.feel(@warrior.direction_of(@warrior.listen[0])).enemy?)
          attack(object_direction(:captive?))
        else
          save(object_direction(:captive?))
        end
      else
        walk()
      end
    end
  end
  
  #Fontion décidant quelle action le guerrier va effectuer pendant son tour 
  def play_turn(warrior)
    @warrior = warrior
    @stairs_direction = @warrior.direction_of_stairs
    @enemy_nb = count_object(:enemy?)
    @capture_nb = count_object(:captive?)
    @low_health = is_health_low()
    @bomb = is_bomb_ticking()
    
    if is_room_finish() == false
      if (@enemy_nb == 0)
        choose_strategy_alone()
      elsif (@enemy_nb >= 1)
        choose_strategy_enemy()
      end
    else
      walk()
    end
  end
end