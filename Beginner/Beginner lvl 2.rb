#Ajout de condition pour detecter la nature de la case devant le guerrier
#Ajout d'une fonction pour attaquer

class Player
  
  #Fonction pour faire marcher le guerrier
  def walk()
    @warrior.walk!
  end
  
  #Fonction pour faire attaquer le guerrier
  def attack()
    @warrior.attack!
  end
  
  #Fontion décidant quelle action le guerrier va effectuer pendant son tour
  def play_turn(warrior)
    @warrior = warrior
    @feel = warrior.feel
    
    if @feel.enemy?
      attack()
    else
      walk()
    end
  end
end