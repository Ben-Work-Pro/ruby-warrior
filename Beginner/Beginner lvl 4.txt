#Même code que pour le niveau 3

class Player
  
  MAX_HEALTH = 20
  LOW_HEALTH = 10

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
  
  #Fonction pour faire attaquer le guerrier
  def attack()
    @warrior.attack!
  end
  
  #Fontion décidant quelle action le guerrier va effectuer pendant son tour
  def play_turn(warrior)
    @warrior = warrior
    @feel = warrior.feel
    
    if @warrior.health <= LOW_HEALTH && @feel.enemy?
      retreat()
    elsif @warrior.health < MAX_HEALTH && @feel.empty?
      heal()
    else
      if @feel.enemy?
        attack()
      else
        walk()
      end
    end
  end
end