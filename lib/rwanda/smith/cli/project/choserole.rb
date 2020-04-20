require_relative './choseaffiliation.rb'
require_relative './userprofile.rb'
require_relative './WebsiteScraper.rb'

class ChoseRole
    def self.start(role_or_aff)
        if role_or_aff == "R"
           @@first_choice == "role"
        elsif role_or_aff == "A"
            @@first_choice == "affiliation"
        end
        role_or_aff_list = {}
        puts "The #{first_choice}s are #{WebsiteScraper.role_or_aff_list(first_choice)}"
        WebsiteScraper.role_or_aff_list(first_choice).each_with_index {
            role_or_aff_list[i] = v
            |v,i| puts "Press #{i + 1} for #{v}"
        }
        uichoseroles = ""
        uichoseroles = gets.chomp
        uichoseroles.upcase!
        if uichoseroles == "M"
            StartApp.mainmenu
        elsif uichoseroles == "H"
            StartApp.helpmenu
        elsif ("A".."Z").include?(uichoseroles)
            puts "This is not a valid option"
            self.StartApp(@@first_choice)
        elsif @@first_choice == "role" || "affiliation"
            choosebasedon(role_or_aff_list[uichoserole.to_i - 1])
        end
    end
    def choosebasedon(role_or_aff)
        role_or_aff = role_or_aff
        list = []
        list = WebsiteScraper.list_heroes_by(role_or_aff)
        list
        puts "1 - Select one of these heroes 2 - Narrow down by affiliation" if WebsiteScraper.role_or_aff_list("role").include?(role_or_aff)
        puts "1 - Select one of these heroes 2 - Narrow down by role" if WebsiteScraper.role_or_aff_list("affiliation").include?(role_or_aff)
        uichoserole = ""
        uichoserole = gets.chomp
        uichoserole.upcase!
        if uichoserole == "M"
            StartApp.mainmenu
        elsif uichoserole == "H"
            StartApp.helpmenu
        elsif ("A".."Z").include?(uichoserole)
            puts "This is not a valid option"
            self.choosebasedon(role_or_aff)
        elsif uichoserole.to_i == 1
            select_hero(list, role_or_aff)
        elsif uichoserole.to_i == 2 
            narrow_hero(list, role_or_aff)
        end
    end
    def select_hero(list,role_or_aff)
        hero_index = {}
        hero_by_role_or_aff.each_with_index {|hero_name, index|
        hero_index[index] = hero_name
        puts "Press #{index+1} to read more about #{hero_name}"}
        uiselecthero = 0
        uiselecthero = gets.to_i
        puts "#{WebsiteScraper.all_heroes[hero_index[uiselecthero-1]]["description"]}"
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