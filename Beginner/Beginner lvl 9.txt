#Même code que pour le niveau 8

class Player
  
  LOW_HEALTH = 10

  #Constructeur de la classe
  def initialize
    @health = 20
  end
  
  #Fonction pour faire marcher le guerrier
  def walk()
    @warrior.walk!
  end
  
  #Fonction pour faire tourner le guerrier
  def pivot()
    @warrior.pivot!
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
  def save()
    @warrior.rescue!
  end
  
  #Fonction pour faire attaquer le guerrier
  def attack()
    @warrior.attack!
  end
  
  #Fonction pour faire tirer une fleche au guerrier
  def shoot()
    @warrior.shoot!
  end
  
  #Fonction permettant de stocker la vie du guerrier dans une variable à la fin de son tour
  def update_health()
    @health = @warrior.health
  end
  
  #Fontion permettant de regarder sur les 3 cases devant le guerrier et determiné si il fait face à un enemie
  def look_for_enemy()
    @look = @warrior.look
    
    for i in 0..2
      if (@look[i].captive?)
        return false
      elsif (@look[i].enemy?)
        return true
      end
    end
    return false
  end
  
  #Fonction comparant la vie que la guerrier avait à son dernier tour et au tour actuel
  def is_position_safe()
    if @warrior.health < @health
      return false
    end
    return true
  end
  
  #Fonction permettant de savoir si les points de vie du guerrier sont bas
  def is_health_point_low()
    if @warrior.health <= LOW_HEALTH
      return true
    end
    return false
  end
  
  #Fontion décidant quelle action le guerrier va effectuer pendant son tour 
  def play_turn(warrior)
    @warrior = warrior
    @feel = warrior.feel
    
    if @feel.wall?
      pivot()
    elsif @feel.empty?
      if look_for_enemy()
        if !is_health_point_low() && !is_position_safe()
          walk()
        elsif is_position_safe()
          shoot()
        else
          retreat()
        end
      else
        if (is_health_point_low() && is_position_safe())
          heal()
        else
          walk()
        end
      end
    elsif @feel.enemy?
      attack()
    elsif @feel.captive?
      save()
    end
    update_health()
  end
end