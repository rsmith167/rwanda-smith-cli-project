require_relative './userprofile.rb'
require_relative './WebsiteScraper.rb'

class Navigate
    
    @@first_choice = ""
    
    def self.start(role_or_aff) #original, the user was able to choose between narrowing down heroes by role or afilliation. I change this since it I need to scrap all the data, which took up to a minute. I updated the code so that the user chooses just a role, then the websites are scraped based on that input.
        role_or_aff = role_or_aff
        if role_or_aff == "R"
           @@first_choice = "role"
        # elsif role_or_aff == "A"
        #     @@first_choice = "affiliation"
        end
        role_or_aff_list = {}
        x = []
        x = WebsiteScraper.role_or_aff_list(@@first_choice)
        puts "The #{@@first_choice}s are #{x}"
        if x.length != 0
            x.each_with_index {|v,i| 
                role_or_aff_list[i] = v
                puts "Press #{i + 1} for #{v}"
            }
        else
            puts "An erro occured; please restart the app."
        end
        uichoseroles = ""
        uichoseroles = gets.chomp
        uichoseroles.upcase!
        if uichoseroles == "M"
            StartApp.mainmenu
        elsif uichoseroles == "H"
            StartApp.helpmenu
        # elsif ("A".."Z").include?(uichoseroles)
        #     puts "This is not a valid option"
        #     self.start(@@first_choice)
        elsif @@first_choice == "role" #|| "affiliation"
            self.narrow_down_by_choice(role_or_aff_list[uichoseroles.to_i - 1])
        else
             puts "This is not a valid option"
             self.start(@@first_choice)
        end
    end
    def self.narrow_down_by_choice(role_choice)
        heroes_by_role = WebsiteScraper.list_heroes_by(role_choice)
        WebsiteScraper.scrape_further(role_choice)
        hero_list = {}
        heroes_by_role.each_with_index {|v,i|
            hero_list[i] = v
            puts "Press #{i + 1} for #{v}"
        }
        uichoseroles = ""
        uichoseroles = gets.chomp
        uichoseroles.upcase!
        if uichoseroles != ["a".."z"] || ["A".."Z"] || ""
            self.choose_based_on(hero_list[uichoseroles.to_i - 1], role_choice)
        else
             self.narrow_down_by_choice(role_choice)
        end
    end
    def self.choose_based_on(hero, role_choice)
        # role_or_aff = role_or_aff
        # list = []
        # list = WebsiteScraper.list_heroes_by(role_or_aff)
        # puts "#{list}"
        # puts "1 - Select one of these heroes 2 - Narrow down by affiliation" if WebsiteScraper.role_or_aff_list("role").include?(role_or_aff)
        # puts "1 - Select one of these heroes 2 - Narrow down by role" if WebsiteScraper.role_or_aff_list("affiliation").include?(role_or_aff)
        # uichoserole = ""
        # uichoserole = gets.chomp
        # uichoserole.upcase!
        # if uichoserole == "M"
        #     StartApp.mainmenu
        # elsif uichoserole == "H"
        #     StartApp.helpmenu
        # elsif ("A".."Z").include?(uichoserole)
        #     puts "This is not a valid option"
        #     self.choose_based_on(role_or_aff)
        # elsif uichoserole.to_i == 1
            # list_select = {}
            # list.each_with_index {|v,i|
            #     list_select[i] = v
            #     puts "Press #{i + 1} to select #{v}"}
            #     uiselecthero = 0
            #     uiselecthero = gets.to_i
                puts "#{WebsiteScraper.all_heroes[hero]["description"]}"
                puts "S - Save this hero to your list    B - Back to previous screen"
                uiafterselect = ""
                uiafterselect = gets.chomp
                uiafterselect.upcase!
                if uiafterselect == "S"
                    self.save_hero(hero)
                elsif uiafterselect == "B"
                   self.narrow_down_by_choice(role_choice)
                end
        #         end  
        # elsif uichoserole.to_i == 2 
        #     narrow_hero(list, role_or_aff)
        # else 
        #     self.choose_based_on(role_or_aff)
        # end
    end
    def self.save_hero(choice)
        #user = StartApp.current_user
        #y = UserProfiles.all_users.index(user)
        #current_profile = UserProfiles.all_users[y]
        #current_profile.save_a_hero(choice)
        StartApp.current_user.save_a_hero(choice)
        puts "M - Main Menu    V - View Your Heroes"
        uisavehero = ""
        uisavehero = gets.chomp
        uisavehero.upcase!
        if uisavehero == "M"
            StartApp.mainmenu
        elsif uisavehero == "V"
            StartApp.current_user.view_your_list
        else 
            puts "Not a valid choice."
            self.save_hero(choice)
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
               self.choose_based_on(role_or_aff)
            end  
    end
end