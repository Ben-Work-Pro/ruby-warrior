#Ajout d'une fonction pour avancer

class Player
  
  #Fonction pour faire marcher le guerrier
  def walk()
    @warrior.walk!
  end

  #Fontion décidant quelle action le guerrier va effectuer pendant son tour
  def play_turn(warrior)
    @warrior = warrior
    
    walk()
  end
end