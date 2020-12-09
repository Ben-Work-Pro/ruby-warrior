#ajout d'une fonction pour savoir si il reste des objectifs à accomplir dans la salle
#si il reste des objectifs le guerrier va maintenant pouvoir les recherchers grace à la fonction "listen"

class Player

  DIRECTIONS = [:forward, :backward, :right, :left]
  MAX_HEALTH = 20
  GOOD_HEALTH = 15

  #Fonction pour faire marcher le guerrier
  def walk(direction)
    @warrior.walk!(direction)
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

  #Fontion décidant quelle action le guerrier va effectuer pendant son tour 
  def play_turn(warrior)
    @warrior = warrior
    @stairs_direction = @warrior.direction_of_stairs
    @enemy_nb = count_object(:enemy?)
    @capture_nb = count_object(:captive?)
    @low_health = is_health_low()
    
    if is_room_finish() == false
      if (@enemy_nb == 0)
        if (@low_health == true)
          heal()
        elsif (@capture_nb > 0)
          save(object_direction(:captive?))
        else
          walk(@warrior.direction_of(@warrior.listen[0]))
        end
      elsif (@enemy_nb == 1)
        attack(object_direction(:enemy?))
      elsif (@enemy_nb >= 2)
        capture(object_direction(:enemy?))
      end
    else
      walk(@stairs_direction)
    end
  end
end
  