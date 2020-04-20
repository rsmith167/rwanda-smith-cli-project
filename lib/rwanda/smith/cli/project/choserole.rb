
require_relative './userprofile.rb'
#require_relative './startapp.rb'
require_relative './WebsiteScraper.rb'

class ChoseRole
    
    @@first_choice = ""
    
    def self.start(role_or_aff)
        role_or_aff = role_or_aff
        if role_or_aff == "R"
           @@first_choice = "role"
        elsif role_or_aff == "A"
            @@first_choice = "affiliation"
        end
        role_or_aff_list = {}
        x = []
        x = WebsiteScraper.role_or_aff_list(@@first_choice)
        puts "The #{@@first_choice}s are #{x}"
        x.each_with_index {|v,i| 
            role_or_aff_list[i] = v
            puts "Press #{i + 1} for #{v}"
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
            self.choosebasedon(role_or_aff_list[uichoseroles.to_i - 1])
        end
    end
    def self.choosebasedon(role_or_aff)
        role_or_aff = role_or_aff
        list = []
        list = WebsiteScraper.list_heroes_by(role_or_aff)
        puts "#{list}"
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
            list_select = {}
            list.each_with_index {|v,i|
                list_select[i] = v
                puts "Press #{i + 1} to select #{v}"}
                uiselecthero = 0
                uiselecthero = gets.to_i
                puts "#{WebsiteScraper.all_heroes[list_select[uiselecthero-1]]["description"]}"
                puts "S - Save this hero to your list    B - Back to previous screen"
                uiafterselect = ""
                uiafterselect = gets.chomp
                uiafterselect.upcase!
                if uiafterselect == "S"
                    self.save_hero(list_select[uiselecthero-1])
                elsif uiafterselect == "B"
                   self.choosebasedon(role_or_aff)
                end  
        elsif uichoserole.to_i == 2 
            narrow_hero(list, role_or_aff)
        else 
            self.choosebasedon(role_or_aff)
        end
    end
    def self.save_hero(choice)
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
    def self.narrow_hero(hero_list, role_or_aff)
        hero_narrow = []
        hero_narrow = WebsiteScraper.narrow_heroes_by(hero_list, role_or_aff)        
        puts "These are all the \'#{role_or_aff}\' heroes"
        puts " roles" if WebsiteScraper.role_or_aff_list("affiliation").include?(role_or_aff)
        puts " affiliations" if WebsiteScraper.role_or_aff_list("role").include?(role_or_aff)
        puts "Press the select corresponding number for your choice of"
        puts " roles" if WebsiteScraper.role_or_aff_list("affiliation").include?(role_or_aff)
        puts " affiliations" if WebsiteScraper.role_or_aff_list("role").include?(role_or_aff)
        hero_narrow.each_with_index {|v,i| puts "#{i+1}. #{v}"}
        narrowchoice = []
        uinarrow = 0
        uinarrow = gets.to_i
        narrowchoice = hero_narrow[uinarrow-1]
        narrowchoicearray = []
        WebsiteScraper.all_hero_names.each {
            |hero_name|
            if hero_list.include?(hero_name) &&  (WebsiteScraper.all_heroes[hero_name]["affiliation"] == narrowchoice)
            narrowchoicearray << hero_name
            elsif hero_list.include?(hero_name) &&  (WebsiteScraper.all_heroes[hero_name]["role"] == narrowchoice)
            narrowchoicearray << hero_name
            end
        }
        puts "These are the #{role_or_aff} heroes with #{narrowchoice}"
        list_select = {}
        narrowchoicearray.each_with_index {|v,i|
            list_select[i] = v
            puts "Press #{i + 1} to select #{v}"}
            uiselecthero = 0
            uiselecthero = gets.to_i
            puts "#{WebsiteScraper.all_heroes[list_select[uiselecthero-1]]["description"]}"
            puts "S - Save this hero to your list    B - Back to previous screen"
            uiafterselect = ""
            uiafterselect = gets.chomp
            uiafterselect.upcase!
            if uiafterselect == "S"
                self.save_hero(list_select[uiselecthero-1])
            elsif uiafterselect == "B"
               self.choosebasedon(role_or_aff)
            end  
    end
end