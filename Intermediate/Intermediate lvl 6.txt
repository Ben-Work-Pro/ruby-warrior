#Modification de l'algorithme pour permettre au guerrier de désamorcer les bombes avant d'accomplir les autres objectifs

class Player

  DIRECTIONS = [:forward, :right, :left, :backward]
  MAX_HEALTH = 20
  GOOD_HEALTH = 15
  
  #Fonction pour faire marcher le guerrier
  def walk()
    if is_room_finish() == false
      if @warrior.feel(@warrior.direction_of(@warrior.listen[0])).stairs?
        @warrior.walk!(find_empty_case())
      elsif @bomb == true
        bomb_case = @warrior.listen
        bomb_case = bomb_case.select(&:ticking?).first
        if @warrior.feel(@warrior.direction_of(bomb_case)).enemy?
          @warrior.walk!(find_empty_case())
        else
          @warrior.walk!(@warrior.direction_of(bomb_case))
        end
      elsif @bomb == false
        @warrior.walk!(@warrior.direction_of(@warrior.listen[0]))
      end
    else
      @warrior.walk!(@stairs_direction)
    end
  end
  
  #Fonction pour faire reculer le guerrier
  def retreat()
    @warrior.walk!:backward
  end
  
  #Fonction pour soigner le guerrier
  def heal()
    @warrior.rest!
  end
  
  #Fonction pour sauver un prisonnier
  def save(direction)
    @warrior.rescue!(direction)
  end
  
  #Fonction pour faire attaquer le guerrier
  def attack(direction)
    @warrior.attack!(direction)
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
      if @warrior.feel(DIRECTIONS[i]).send(object)
        return DIRECTIONS[i]
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
        if (@low_health == true)
          heal()
        elsif (@capture_nb > 0)
          save(object_direction(:captive?))
        else
          walk()
        end
      elsif (@enemy_nb == 1)
        if (@low_health == true && @warrior.health <= 3)
          retreat()
        elsif @bomb == true
          walk()
        else
          attack(object_direction(:enemy?))
        end
      elsif (@enemy_nb >= 2)
        capture(object_direction(:enemy?))
      end
    else
      walk()
    end
  end
end