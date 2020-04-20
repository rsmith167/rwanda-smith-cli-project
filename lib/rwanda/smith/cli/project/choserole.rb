require_relative './choseaffiliation.rb'
require_relative './userprofile.rb'
require_relative './WebsiteScraper.rb'
#require_relative './startapp.rb'

class ChoseRole
    def start
        @ws = WebsiteScraper
        puts "The roles are #{@ws.roles_list}"
        puts "Press    #{@ws.roles_list[0][0]} - #{@ws.roles_list[0]}    #{@ws.roles_list[1][0]} - #{@ws.roles_list[1]}    #{@ws.roles_list[2][0]} - #{@ws.roles_list[2]}   
        \n\t\tM - Main Menu    H - Help"
        uichoseroles = ""
        uichoseroles = gets.chomp
        uichoseroles.upcase!
        if uichoseroles  == "T"
            choosebasedonrole("Tank")  
        elsif uichoseroles  == "D"
            choosebasedonrole("Damage")  
        elsif uichoseroles  == "S"
            choosebasedonrole("Support")  
        elsif uichoseroles == "M"
            StartApp.mainmenu
        elsif uichoseroles  == "H"
            StartApp.helpmenu
        else
            puts "\nThis is not a valid option"
            start
        end
    end
    def choosebasedonrole(role)
        role = role
        heroes1 = []
         @ws.all_hero_names.each {|x| 
                    if @ws.all_heroes[x]["role"] == role
                    heroes1 << x
                    end}
        puts "The #{role} heroes are #{heroes1}"
        puts "1 - Select one of these heroes 2 - Narrow down by affiliation 3 - Main Menu"
        uichoserole = ""
        uichoserole = gets.to_i
        if uichoserole  == 1
            select_hero(heroes1, role)
        elsif uichoserole == 2 
            narrow_hero(heroes1, role)
        elsif uichoserole == 3
            StartApp.mainmenu
        else
            puts "Not a valid option"
            choosebasedonrole(role)
        end
    end
    def select_hero(hero_by_role,role)
        hero_index = {}
        hero_by_role.each_with_index {|hero_name, index|
        hero_index[index] = hero_name
        puts "Press #{index+1} to read more about #{hero_name}"}
        uiselecthero = 0
        uiselecthero = gets.to_i
        puts "#{@ws.all_heroes[hero_index[uiselecthero-1]]["description"]}"
        puts "S - Save this hero to your list    B - Back to previous screen"
        uiafterselect = ""
        uiafterselect = gets.chomp
        uiafterselect.upcase!
        if uiafterselect == "S"
            save_hero(hero_index[uiselecthero-1])
        elsif uiafterselect == "B"
            if role == "Tank"
                choosebasedonrole("Tank")  
            elsif role == "Damage"
                choosebasedonrole("Damage")  
            elsif role == "Support"
                choosebasedonrole("Support")  
            end                   
        end   
    end
    def save_hero(choice)
        choice = choice
        UserProfiles.all_users[0].save_a_hero(choice)
        puts "Go to Main Menu (press M)   Veiw you list of heroes (press V)"
        uisavehero = ""
        uisavehero = gets.chomp
        uisavehero.upcase!
        if uisavehero == "M"
            StartApp.mainmenu
        elsif uisavehero == "V"
            UserProfiles.all_users[0].view_your_list
        end        
    end
    def narrow_hero(hero_list, role)
        hero_affs = []
        WebsiteScraper.all_hero_names.each {
            |hero_name|
            if hero_list.include?(hero_name)
            hero_affs << WebsiteScraper.all_heroes[hero_name]["affiliation"]
            end
        }
        puts "These are all the #{role} heroes affiliations: #{hero_affs}"
        puts "Press the corresponding number for your choice of affiliation:"
        hero_affs.each_with_index {|v,i| puts "#{i+1}. #{v}"}
        uinarrow = 0
        uinarrow = gets.to_i
        narrowchoice = hero_affs[uinarrow-1]
        narrowchoicearray = []
        WebsiteScraper.all_hero_names.each {
            |hero_name|
            if hero_list.include?(hero_name) &&  (WebsiteScraper.all_heroes[hero_name]["affiliation"] == narrowchoice)
            narrowchoicearray << hero_name
            end
        }
        puts "These are the #{role} heroes with #{narrowchoice}"
        
    end
end