#ajout d'une fonction attaquer
#ajout d'une fonction se soigner
#Début de l'algorithme permettant au guerrier de prendre des décisions

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
  
  #Fonction pour faire attaquer le guerrier
  def attack(direction)
    @warrior.attack!(direction)
  end
  
  #Fonction permettant de compter le nombre d'ennemies autour du guerrier
  def count_enemies()
    _enemy_nb = 0
    for i in 0..3
      if @warrior.feel(DIRECTIONS[i]).enemy?
        _enemy_nb += 1
      end
    end
    return _enemy_nb
  end
  
  #Fonction permettant au guerrier de savoir dans quel direction se trouve ses ennemies
  def enemy_direction()
    for i in 0..3
      if @warrior.feel(DIRECTIONS[i]).enemy?
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

  #Fontion décidant quelle action le guerrier va effectuer pendant son tour 
  def play_turn(warrior)
    @warrior = warrior
    @stairs_direction = @warrior.direction_of_stairs
    @enemy_nb = count_enemies()
    @low_health = is_health_low()
    
    if (@enemy_nb == 0)
      if (@low_health == true)
        heal()
      else
        walk(@stairs_direction)
      end
    elsif (@enemy_nb >= 1)
      attack(enemy_direction())
    end
  end
end
  