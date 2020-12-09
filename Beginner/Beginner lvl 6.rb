#Modification de l'algorithme obligeant le guerrier à toucher un mur avant de terminer le niveau pour ainsi sauver tout les prisonniers

class Player
  
  MAX_HEALTH = 20
  LOW_HEALTH = 10
  
  #Constructeur de la classe
  def initialize
    @health = 20
    @wall = false
  end
  
  #Fonction pour faire marcher le guerrier
  def walk()
    @warrior.walk!
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
  
  #Fonction comparant la vie que la guerrier avait à son dernier tour et au tour actuel
  def is_position_safe()
    if @warrior.health < @health
      return false
    end
    return true
  end
  
  #Fonction permettant de savoir si les points de vie du guerrier sont bas
  def is_health_point_low()
    if @warrior.health <= LOW_HEALTH && @warrior.health != MAX_HEALTH
      return true
    end
    return false
  end
  
  #Fonction permettant de savoir si les points de vie du guerrier sont bas
  def is_health_point_good()
    if @warrior.health < MAX_HEALTH
      return false
    end
    return true
  end
  
  #Fonction permettant de stocker la vie du guerrier dans une variable à la fin de son tour
  def update_health()
    @health = @warrior.health
  end
  
  #Fontion décidant quelle action le guerrier va effectuer pendant son tour
  def play_turn(warrior)
    @warrior = warrior
    
    if !is_health_point_low() && !is_position_safe() && !warrior.feel.enemy?
      walk()
    elsif is_health_point_low() && !is_position_safe()
      retreat()
    elsif !is_health_point_good() && is_position_safe()
      heal()
    else
      if warrior.feel.enemy?
        attack()
      elsif warrior.feel.captive?
        save()
      elsif warrior.feel(:backward).captive?
        @warrior.rescue!:backward
      elsif warrior.feel(:backward).wall? && @wall == false
        @wall = true
        walk()
      elsif warrior.feel(:backward).empty? && @wall == false
        @warrior.walk!:backward
      else
        walk()
      end
    end
    update_health()
  end
end